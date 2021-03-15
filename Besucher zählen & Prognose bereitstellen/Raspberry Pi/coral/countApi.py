#!flask/bin/python
from flask import Flask
import numpy as np


app = Flask(__name__)

@app.route('/', methods=['GET'])
def app_findBy():
    y = np.loadtxt('/home/pi/coral/tflite1/anzahl.txt')
    
    return str(y)

if __name__ == '__main__':
    app.run(host= '0.0.0.0' ,debug=False)

