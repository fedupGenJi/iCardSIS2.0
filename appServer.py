from flask import Flask,request,jsonify
import json
import socket
from modules.operationsA import *

hostname = socket.gethostname()
ip_address = socket.gethostbyname(hostname)
print(ip_address)

appServer = Flask(__name__)

@appServer.route('/register', methods=['POST'])
def reg():
    data = request.get_json()
    if not data:
        return jsonify({"message": "No data received"}), 400
    
    print("Received Data:", data)
    resultx = checkData(data)

    if (resultx["success"] == False):
        print(resultx["message"])
    
    if (resultx["success"] == True):
        print(resultx["message"])

    return jsonify({"message": "Registration successful"}), 200

if __name__ == '__main__':
    appServer.run(host=ip_address, port=1000, debug=False)