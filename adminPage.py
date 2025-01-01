from flask import Flask, render_template
import socket

hostname = socket.gethostname()
ip_address = socket.gethostbyname(hostname)

adminOperations = Flask(__name__)

@adminOperations.route('/')
def home():
    return render_template('html/loginpage.html')

if __name__ == '__main__':
    adminOperations.run(host= ip_address, port=4000, debug=True)
