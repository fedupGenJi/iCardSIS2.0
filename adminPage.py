from flask import Flask, render_template, request, jsonify
import socket
from modules.loginOperation import *

hostname = socket.gethostname()
ip_address = socket.gethostbyname(hostname)

adminOperations = Flask(__name__)

@adminOperations.route('/')
def home():
    return render_template('html/loginpage.html')

@adminOperations.route('/login',methods=['POST'])
def login():
    gmail = request.form.get('gmail')
    password = request.form.get('password')

    message = login_check(gmail, password)
    response = {"message": ""}

    if message == "success":
        response["message"] = "Login success!"
    elif message == "wrong pw":
        response["message"] = "Incorrect password!"
    elif message == "no email":
        response["message"] = "Email couldn't be found!!"
    else:
        response["message"] = "ERROR!"

    return jsonify(response)

if __name__ == '__main__':
    adminOperations.run(host= ip_address, port=4000, debug=True)