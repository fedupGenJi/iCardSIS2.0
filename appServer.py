from flask import Flask,request,jsonify,redirect,render_template_string
import requests
import json
import socket
from modules.operationsA import *
from modules.operationsB import *
from modules.sparrowSMS import *
from modules.login import *
from modules.khaltiPayment import *

hostname = socket.gethostname()
ip_address = socket.gethostbyname(hostname)
print(ip_address)

appServer = Flask(__name__)

KHALTI_URL = "https://dev.khalti.com/api/v2/epayment/initiate/"
NGROK_URL = "https://ef0c-27-34-73-168.ngrok-free.app"

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
            # print(otp)
            dataStore(data)
            #print(f"OTP sent successfully: {otp}")
            return jsonify({"success": True, "message": "OTP SENT"}), 200
        else:
            #print("Failed to send OTP")
            return jsonify({"success": False, "message": "Could not send OTP"}), 400
    except Exception as e:
        print(f"Unexpected error occurred: {e}")
        return jsonify({"success": False, "message": "Sever Error"}), 400
    
@appServer.route('/register/otp', methods=['POST'])
def otpVerify():
    otpData = request.get_json()
    result = otpVerification(otpData)

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
            print(error_message)
            return jsonify({"error": "UNEXPECTED_ERROR", "message": error_message}), 500
        
@appServer.route('/register/otp/valid', methods=['POST'])
def insert():
    data = request.get_json()
    phoneNo = data.get("phoneNumber")

    if not phoneNo:
        return jsonify({"status": "failure", "message": "phoneNo is required"}), 400

    result = registerData(phoneNo)

    if result == "success":
        return jsonify({"status": "success", "message": "Registration completed successfully"}), 200
    else:
        print(result)
        return jsonify({"status": "failure", "message": result}), 400
    
@appServer.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    if not data:
        return jsonify({"status": "failure", "message": "data not received", "stdId":None}), 400
    
    result = loginUser(data)
    #print(result)
    strId = str(result["id"])
    if result["success"]:
        return jsonify({"status": "success", "message": result["message"], "stdId":strId}), 200
    else:
        return jsonify({"status": "failure", "message": result["message"], "stdId":None}), 400

@appServer.route('/homepage', methods=['POST'])
def getData():
    data = request.get_json()
    user_id = int(data.get("id"))
    if not user_id:
        return jsonify({"error": "Missing user ID"}), 400
    
    student_data = getFromDB(user_id)
    if "error" in student_data:
        return jsonify(student_data), 400

    return jsonify(student_data), 200

@appServer.route('/khalti', methods=['POST'])
def process_payment():
    try:
        data = request.get_json()
        amount = data.get("amount")
        phone_number = data.get("phoneNumber")

        return_url = f"{NGROK_URL}/khalti/paymentSuccess"
        website_url = "https://GenJi.ngrok.io"

        payload = json.dumps({
            "return_url": return_url,
            "website_url": website_url,
            "amount": str(amount),
            "purchase_order_id": f"Order_{int(amount)}",
            "purchase_order_name": "Balance",
            "customer_info": {
                "name": "iCardSIS-User",
                "phone": phone_number
            }
        })

        headers = {
            'Authorization': config.khaltiKey,
            'Content-Type': 'application/json',
        }

        response = requests.post(KHALTI_URL, headers=headers, data=payload)
        #print(response.text)

        if response.status_code == 200:
            response_data = response.json()
            pidx = response_data.get("pidx")
            paymentRecord(phone_number,pidx,(amount/100))
            return jsonify(response.json())
        else:
            return jsonify({"error": "Failed to initiate payment", "details": response.text}), 400

    except Exception as e:
        #print(str(e))
        return jsonify({"error": "Internal Server Error", "message": str(e)}), 500

@appServer.route('/khalti/paymentSuccess', methods=['GET'])
def printMsg():
    try:
        pidx = request.args.get('pidx')
        transaction_id = request.args.get('transaction_id')
        amount = request.args.get('amount')
        total_amount = request.args.get('total_amount')
        mobile = request.args.get('mobile')
        status = request.args.get('status')
        purchase_order_id = request.args.get('purchase_order_id')
        purchase_order_name = request.args.get('purchase_order_name')

        if status.lower() == "completed":
            paymentVerified(pidx)
            status = "success"
        else:
            removeFailedPayment(pidx)
            status = "failed"

        app_link = f"icardsis://payment?status={status}&transaction_id={transaction_id or ''}"

        html_content = f"""
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Order Details</title>
                <style>
                    body {{
                        font-family: Arial, sans-serif;
                        text-align: center;
                        margin: 50px;
                    }}
                    .container {{
                        max-width: 500px;
                        margin: auto;
                        padding: 20px;
                        border: 1px solid #ddd;
                        border-radius: 10px;
                        box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.1);
                    }}
                    .bold {{
                        font-weight: bold;
                        font-size: 18px;
                        margin-top: 20px;
                    }}
                    .miracle-link {{
                        display: block;
                        margin-top: 10px;
                        font-size: 16px;
                        color: #007bff;
                        text-decoration: none;
                    }}
                </style>
            </head>
            <body>
                <div class="container">
                    <h2>Order Details</h2>
                    <p><strong>Transaction ID:</strong> {transaction_id}</p>
                    <p><strong>Purchase Order ID:</strong> {purchase_order_id}</p>
                    <p><strong>Purchase Order Name:</strong> {purchase_order_name}</p>
                    <p><strong>Amount:</strong> NPR {amount}</p>
                    <p><strong>Total Amount:</strong> NPR {total_amount}</p>
                    <p><strong>Status:</strong> {status}</p>

                    <p class="bold">Restart App! Redirection ain't working :P</p>
                    <a class="miracle-link" href="{app_link}">I believe in miracles</a>
                </div>
            </body>
            </html>
            """

        return render_template_string(html_content)

    except Exception as e:
        return jsonify({"error": "Error processing request", "message": str(e)}), 500

if __name__ == '__main__':
    appServer.run(host=ip_address, port=1000, debug=False)