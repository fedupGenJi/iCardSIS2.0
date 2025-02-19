from flask import Flask,request,jsonify,redirect,render_template_string
import requests
import json
import socket
import qrcode
import io
import base64
from modules.operationsA import *
from modules.operationsB import *
from modules.sparrowSMS import *
from modules.login import *
from modules.khaltiPayment import *
from modules.operationsC import *
from modules.acitivityStatement import *

hostname = socket.gethostname()
ip_address = socket.gethostbyname(hostname)
print(ip_address)

appServer = Flask(__name__)

KHALTI_URL = "https://dev.khalti.com/api/v2/epayment/initiate/"
NGROK_URL = config.ngrokurl

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
        amount = float(amount) / 100
        total_amount = float(total_amount) / 100
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

        #app_link = f"icardsis://payment?status={status}&transaction_id={transaction_id or ''}"

        html_content = f"""
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Processing Payment</title>
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
                </style>
            </head>
            <body>
                <div class="container">
                    <h2>Processing Payment</h2>
                    <p><strong>Transaction ID:</strong> {transaction_id}</p>
                    <p><strong>Purchase Order ID:</strong> {purchase_order_id}</p>
                    <p><strong>Purchase Order Name:</strong> {purchase_order_name}</p>
                    <p><strong>Amount:</strong> NPR {amount}</p>
                    <p><strong>Total Amount:</strong> NPR {total_amount}</p>
                    <p><strong>Status:</strong> {status}</p>

                    <p class="bold">Please wait, closing Khalti...</p>
                    <p class="bold">You will be redirected to the app in 5 seconds.</p>
                </div>
            </body>
            </html>
            """

        return render_template_string(html_content)

    except Exception as e:
        return jsonify({"error": "Error processing request", "message": str(e)}), 500
    
@appServer.route('/khalti/result', methods=['POST'])
def payment_result():
    data = request.get_json()
    pidx = data.get('pidx')
    
    result = doesItExist(pidx)
    if result:
        return jsonify({
            'status': True,
            'message': f'Payment for transaction {pidx} was successful.'
        })
    else:
        return jsonify({
            'status': False,
            'message': 'Invalid payment information.'
        })
    
@appServer.route('/generateQR', methods=['POST'])
def generateQRs():
    data = request.json.get("stdId", "")
    
    if not data:
        return jsonify({"error": "No student ID provided"}), 400

    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(data)
    qr.make(fit=True)

    img = qr.make_image(fill="black", back_color="white")

    buffered = io.BytesIO()
    img.save(buffered, format="PNG")
    img_base64 = base64.b64encode(buffered.getvalue()).decode("utf-8")

    return jsonify({"qr_code": img_base64})

@appServer.route('/userinfo/<stdId>', methods=['GET'])
def getUserInfo(stdId):
    try:
        studentId = int(stdId)
        result = getDataforSM(studentId)
        
        if result["result"]:
            return jsonify(result), 200
        else:
            return jsonify({"error": result.get("error", "Unknown error")}), 400
    except ValueError:
        return jsonify({"error": "Invalid student ID format"}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@appServer.route('/sendMoney', methods=['POST'])
def sendMoney():
    try:
        data = request.get_json()
        amount = data.get('amount')
        phone_number = data.get('phone_number')
        studentId = data.get('student_id')

        if not all([amount, phone_number, studentId]):
            return jsonify({'error': 'Missing amount, phone number, or student ID'}), 400

        success, message = sendMoneyx(studentId, amount, phone_number)

        if success:
            return jsonify({'message': message}), 200
        else:
            return jsonify({'error': message}), 400
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@appServer.route('/librarylog/<stdId>', methods=['GET'])
def get_user_books(stdId):
    try:
        student_id = int(stdId)
        result = getBooksforId(student_id)

        if result["result"]:
            books = result.get("books", [])
            return jsonify(books), 200
        else:
            return jsonify([]), 200

    except ValueError:
        return jsonify([]), 200

    except Exception as e:
        return jsonify([]), 200
    
@appServer.route('/verifyPin', methods=['POST'])
def verifyPin():
    data = request.get_json()
    studentId = data.get("student_id")
    studentId = int(studentId)
    pin = data.get("pin")
    
    if not studentId or not pin:
        return jsonify({"message": "Missing student_id or pin"}), 400
    
    result, message = verifyStudentPin(studentId, pin)

    if result:
        return jsonify({"message": message}), 200
    else:
        return jsonify({"message": message}), 401

@appServer.route('/activity', methods=['POST'])
def getActivity():
    try:
        data = request.get_json()
        std_id = data.get("stdId")
        std_id = int(std_id)

        if not std_id:
            return jsonify({"error": "Missing student ID"}), 400

        activities = activityStudent(std_id, config)

        return jsonify(activities), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@appServer.route('/statement', methods=['POST'])
def getStatement():
    try:
        data = request.get_json()
        std_id = data.get("stdId")
        std_id = int(std_id)

        if not std_id:
            return jsonify({"error": "Missing student ID"}), 400

        statements = statementStudent(std_id,config)

        return jsonify(statements), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@appServer.route('/library/fines', methods=['GET'])
def getFineData():
    std_id = request.args.get('stdId')
    stdId = int(std_id)
    
    if not std_id:
        return jsonify({"error": "Student ID is required"}), 400
    
    result, balance, fine = getAmounts(stdId)
    #print(balance,fine)
    
    if result:
        return jsonify({"balance": balance, "fine": fine})
    else:
        return jsonify({"balance": 0, "fine": 0})
    
@appServer.route('/library/payFine', methods=['POST'])
def payFine():
    try:
        data = request.get_json()
        amount = data.get("amount")
        student_id = data.get("student_id")

        if not all([amount, student_id]):
            return jsonify({"error": "Missing required fields"}), 400
        
        stdId = int(student_id)
        amount = int(amount)

        payment_success = payingFine(stdId, amount, config)

        if payment_success:
            return jsonify({"message": "Fine payment successful"}), 200
        else:
            return jsonify({"error": "Payment failed"}), 400

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@appServer.route('/buySubscription/pay', methods=['POST'])
def buy_subscription():
    try:
        data = request.get_json()
        
        required_fields = ['studentId', 'route', 'amount']
        if not all(field in data for field in required_fields):
            return jsonify({'error': 'Missing required fields'}), 400
        
        student_id = int(data['studentId'])
        route = data['route']
        amount = int(data['amount'])
        # print(student_id, amount, route)

        payment_success = subscriptionPayment(student_id, amount, route)
        
        if payment_success:
            return jsonify({'message': 'Payment successful', 'studentId': student_id, 'amount': amount}), 200
        else:
            return jsonify({'error': 'Payment failed'}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@appServer.route('/busSubscription/verifyStatus', methods=['GET'])
def verifyStatus():
    student_id = request.args.get('studentId')
    
    if not student_id:
        return jsonify({"error": "Missing studentId"}), 400
    
    stdId = int(student_id)
    result = getStatus(stdId)

    return jsonify(result)

@appServer.route('/busSubscription/getData', methods=['GET'])
def getSubscriptionData():
    student_id = request.args.get('studentId')

    if not student_id:
        return jsonify({"success": False, "message": "Missing studentId", "data": None}), 400

    try:
        stdId = int(student_id)
    except ValueError:
        return jsonify({"success": False, "message": "Invalid studentId", "data": None}), 400

    subscription_response = getDataForTransportCard(stdId)

    return jsonify(subscription_response["data"])

if __name__ == '__main__':
    appServer.run(host=ip_address, port=1000, debug=False)