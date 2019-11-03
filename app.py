#!flask/bin/python


import time
import data_processing
import os
from flask import Flask
from flask import request
from flask import abort
from flask import redirect
from flask import url_for
from flask import make_response
from flask import send_from_directory
from flask import jsonify
from werkzeug.utils import secure_filename
from werkzeug.urls import URL


app = Flask(__name__)

ret = {
    "date": 0,
    "name": "None"
}

error = {
    'error': 'Not a food'
}

@app.route('/', methods=['GET'])
def home():
    return "Custom API for handling OCR and backend"

@app.route('/foods', methods=['GET'])
def get_tmp():
    return jsonify({'ret': ret})

@app.route('/foods/<string:foodName>', methods=['GET'])
def get_date(foodName):
    rets = data_processing.getExpiration(foodName)
    #return str(rets)
    #dates = {rets[0]: rets[1]}
    if(rets=="ERROR"):
        return error
    return jsonify(rets)

UPLOAD_FOLDER = './files'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
ALLOWED_EXTENSIONS = ["jpg", "png"]

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS

@app.route('/image', methods=['POST'])
def upload_file():
    imagefile = request.files['image']
    filename = secure_filename(imagefile.filename)
    print("\nReceived image File name : " + imagefile.filename)
    imagefile.save(filename)
    return callResult(callProcess(filename))

@app.errorhandler(400)
def not_complete(error):
    return make_response(jsonify({'error' : 'request not complete'}), 400)

@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)


import requests
import json
from dotenv import load_dotenv
import os

# load your environment containing the api key
BASEDIR = os.path.abspath(os.path.dirname(__file__))
load_dotenv(os.path.join(BASEDIR, '.env'))
API_KEY = "9oaHqjGT77E29HoyQCOdCxicG3z75nIGQKbhv7ysX2tflOGU4oioACKUdDzEh81J"

def callProcess(filename):

    endpoint = "https://api.tabscanner.com/api/2/process"
    receipt_image = filename
    payload = {"documentType": "receipt"}
    files = {}
    with open(receipt_image, encoding="utf8", errors='ignore') as f:
        files['file'] = f.read()
    headers = {'apikey': API_KEY}

    response = requests.post(
        endpoint,
        files=files,
        data=payload,
        headers=headers)

    result = json.loads(response.text)

    return result

def callResult(token):

    url = "https://api.tabscanner.com/api/result/{0}"
    endpoint = url.format(token)

    headers = {'apikey':API_KEY}

    response = requests.get(endpoint,headers=headers)
    result = json.loads(response.text)

    return result




if __name__ == '__main__':
    app.run(debug=True)