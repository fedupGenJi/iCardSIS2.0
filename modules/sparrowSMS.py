import http.client
import json
import sys
import os
import random

# Add the project root directory to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import config

def generateOtp():
    return str(random.randint(100000, 999999))

def sendSMS(data):
    try:
        otp = generateOtp()
        phoneNo = data.get('phone')

        if not phoneNo:
            raise ValueError("Phone number is required")

        message = f"Hey there, Welcome to ICardSIS<3 \n Your verification token is {otp}"

        conn = http.client.HTTPSConnection("api.sparrowsms.com")

        payload = json.dumps({
            "token": config.sparrowToken,
            "from": "Code Crafters",
            "to": phoneNo,
            "text": message
        })

        headers = {
            'Content-Type': 'application/json'
        }

        conn.request("POST", "/v2/sms/", body=payload, headers=headers)

        res = conn.getresponse()
        data = res.read()

        print(data.decode("utf-8"))
        return otp 

    except Exception as e:
        print(f"Error! Could not send message: {e}")
        return None
