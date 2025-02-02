from flask import Flask,request,jsonify
import json
import socket
from modules.operationsA import *
from modules.sparrowSMS import *

hostname = socket.gethostname()
ip_address = socket.gethostbyname(hostname)
print(ip_address)

appServer = Flask(__name__)

@appServer.route('/register', methods=['POST'])
def reg():
    data = request.get_json()
    if not data:
        return jsonify({"success": False, "message": "No data received"}), 400
    
    #print("Received Data:", data)
    resultx = checkData(data)

    if not resultx["success"]:
        #print(resultx["message"])
        return jsonify({"success": False, "message": resultx["message"]}), 400 

    #print(resultx["message"])
    try:
        otp = sendSMS(data)
        if otp:
            print(f"OTP sent successfully: {otp}")
            return jsonify({"success": True, "message": "OTP SENT"}), 200
        else:
            print("Failed to send OTP")
            return jsonify({"success": False, "message": "Could not send OTP"}), 400
    except Exception as e:
        print(f"Unexpected error occurred: {e}")
        return jsonify({"success": False, "message": "Sever Error"}), 400

if __name__ == '__main__':
    appServer.run(host=ip_address, port=1000, debug=False)