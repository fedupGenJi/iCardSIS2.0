from flask import Flask, render_template, request, jsonify, session, redirect, url_for
import socket
from modules.loginOperation import *
from modules.adminRoute import admin
from modules.libRoute import library

hostname = socket.gethostname()
ip_address = socket.gethostbyname(hostname)

adminOperations = Flask(__name__)
adminOperations.secret_key = secure_key()

adminOperations.register_blueprint(admin)
adminOperations.register_blueprint(library)

@adminOperations.route('/')
def home():
    return render_template('loginpage.html')

@adminOperations.route('/login', methods=['POST'])
def login():
    gmail = request.form.get('gmail')
    password = request.form.get('password')

    message, status = login_check(gmail, password)
    response = {"status": "", "message": "", "new_url": None}

    if message == "success":

        session['logged_in'] = True
        session['user_role'] = status
        session['email'] = gmail

        if status == "KU-Admin":
            response = {
                "status" : "success",
                "message" : "Login Successful",
                "new_url" : "/admin/homepage",
            }
        elif status == "Librarian":
            response = {
                "status" : "success",
                "message" : "Login Successful",
                "new_url" : "/library/homepage",
            }
        else:
            response["status"] = "success"
            response["message"] = "Login successful, but user role is undefined!"

    elif message == "wrong pw":
        response["status"] = "error"
        response["message"] = "Incorrect password!"

    elif message == "no email":
        response["status"] = "error"
        response["message"] = "Email couldn't be found!"

    else:
        response["status"] = "error"
        response["message"] = "An unexpected error occurred!"

    return jsonify(response)

@adminOperations.route('/logout')
def logout():
    session.clear() 
    return redirect(url_for('home'))

if __name__ == '__main__':
    adminOperations.run(host= ip_address, port=4000, debug=False)