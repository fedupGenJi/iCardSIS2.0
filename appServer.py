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
    phoneNo = data.get('phone')
    #print("Received Data:", data)
    resultx = checkData(data)

    if not resultx["success"]:
        #print(resultx["message"])
        return jsonify({"success": False, "message": resultx["message"]}), 400 

    #print(resultx["message"])
    try:
        otp = sendSMS(data)
        if otp:
            otpStore(otp,phoneNo)
            print(f"OTP sent successfully: {otp}")
            return jsonify({"success": True, "message": "OTP SENT"}), 200
        else:
            print("Failed to send OTP")
            return jsonify({"success": False, "message": "Could not send OTP"}), 400
    except Exception as e:
        print(f"Unexpected error occurred: {e}")
        return jsonify({"success": False, "message": "Sever Error"}), 400
    
@appServer.route('/register/otp', methods=['POST'])
def otpVerify():
    otpData = request.get_json()
    result = otpVerify(otpData)

    if result['status'] == 'success':
        return jsonify({"message": result['message']}), 200
    else:
        error_message = result['message']

        if 'expired' in error_message.lower():
            return jsonify({"error": "OTP_EXPIRED"}), 400
        elif 'invalid' in error_message.lower():
            return jsonify({"error": "OTP_MISMATCH"}), 400
        elif 'not found' in error_message.lower():
            return jsonify({"error": "OTP_NOT_RECEIVED"}), 400
        else:
            return jsonify({"error": "UNEXPECTED_ERROR", "message": error_message}), 500

if __name__ == '__main__':
    appServer.run(host=ip_address, port=1000, debug=False)