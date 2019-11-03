#!flask/bin/python
from flask import Flask
from flask import jsonify
from flask import abort
from flask import make_response
from flask import request
from flask import url_for
from numpy.core import unicode
import data_processing

app = Flask(__name__)

ret = [
            {
                "date": 180.0,
                "name": "Cheese"
            }
        ]

@app.route('/', methods=['GET'])
def get_tmp():
    return jsonify({'ret': ret})

@app.route('/<string:foodName>', methods=['GET'])
def get_date(foodName):
    rets = data_processing.getExpiration(foodName)
    dates = [{'name': rets[0], 'date': rets[1]}]
    return jsonify({'ret': dates})

@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)

if __name__ == '__main__':
    app.run(debug=True)