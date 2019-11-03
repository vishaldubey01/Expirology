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

picsList=[]

###################
#  Download zone  #
###################

@app.route('/picture', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        file = request.files['file']
        return "hi"
        filename = str(time.time()).replace(".", "") + ".jpg"

        file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        return jsonify({'upload':True, 'name' : filename})

    return '''
    <!doctype html>
    <title>Upload new File</title>
    <h1>Upload new File</h1>
    <form action="" method=post enctype=multipart/form-data>
      <p><input type=file name=file>
         <input type=submit value=Upload>
    </form>
    '''
@app.route('/get/picture/<string:name>', methods=['GET'])
def send_pics(name):
    pics = open("./files/" + name)
    if pics:
        return send_from_directory(app.config['UPLOAD_FOLDER'], name)

    abort(404)


@app.errorhandler(400)
def not_complete(error):
    return make_response(jsonify({'error' : 'request not complete'}), 400)

@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)

if __name__ == '__main__':
    app.run(debug=True)