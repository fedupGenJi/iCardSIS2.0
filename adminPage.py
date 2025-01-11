from flask import Flask, render_template, request, jsonify, session, redirect, url_for
import socket
from modules.loginOperation import *

hostname = socket.gethostname()
ip_address = socket.gethostbyname(hostname)

adminOperations = Flask(__name__)
adminOperations.secret_key = secure_key()

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

        if status == "KU-Admin":
            response = {
                "status" : "success",
                "message" : "Login Successful",
                "new_url" : "/admin/homepage",
            }
        elif status == "Librarian":
            response["status"] = "success"
            response["message"] = "Login Successful!!! But currently unavailable!"
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

@adminOperations.route('/admin/homepage')
def admin_homepage():
    id = "signifiespeace@gmail.com"
    admin_details = get_admin_details(id)
    if not session.get('logged_in'):  
        return redirect(url_for('home')) 
    return render_template('admin/homepage.html',**admin_details)

@adminOperations.route('/logout')
def logout():
    session.clear() 
    return redirect(url_for('home'))

if __name__ == '__main__':
    adminOperations.run(host= ip_address, port=4000, debug=True)