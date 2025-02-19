import mysql.connector
from datetime import datetime,timedelta
import sys
import os

# Add the project root directory to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import config

def checkData(data):
    try:
        conn = mysql.connector.connect(
             host = "localhost",
            user = config.user,
            passwd = config.passwd,
            database="iCardSISDB"
        )
        cursor = conn.cursor()

        email = data.get('email')
        phone = data.get('phone')

        cursor.execute("SELECT * FROM studentInfo WHERE Gmail = %s", (email,))
        student = cursor.fetchone()

        if not student:
            return {"success": False, "message": "No email for student registered."}

        cursor.execute("SELECT * FROM loginInfo WHERE Gmail = %s OR phoneNo = %s", (email, phone))
        login = cursor.fetchone()

        if login:
            return {"success": False, "message": "Email/Phone registered previously."}

        return {"success": True, "message": "Ready for update in loginInfo."}

    except mysql.connector.Error as err:
        return {"success": False, "message": f"Database error: {err}"}

    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()

def otpStore(otp,phoneNo):
    configx = {
        'host': 'localhost',
        'user': config.user,         
        'password': config.passwd
    }

    try:
        conn = mysql.connector.connect(**configx)
        cursor = conn.cursor()

        cursor.execute("CREATE DATABASE IF NOT EXISTS tempDB")

        cursor.execute("USE tempDB")

        cursor.execute("""
            CREATE TABLE IF NOT EXISTS otpVerification (
                phone_number VARCHAR(15) PRIMARY KEY,
                otp_code VARCHAR(6) NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        """)

        cursor.execute("""
            INSERT INTO otpVerification (phone_number, otp_code, created_at)
            VALUES (%s, %s, NOW())
            ON DUPLICATE KEY UPDATE
                otp_code = VALUES(otp_code),
                created_at = NOW()
        """, (phoneNo, otp))

        conn.commit()
        print(f"OTP for {phoneNo} updated successfully.")

    except mysql.connector.Error as err:
        print(f"Error: {err}")

    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()

def dataStore(data):
    configx = {
        'host': 'localhost',
        'user': config.user,         
        'password': config.passwd
    }
    phoneNo = data.get('phone')
    password = data.get('password')
    gmail = data.get('email')
    pin = data.get('pin')
    #print(gmail)
    #print(f"Email length: {len(gmail)}")
    try:
        conn = mysql.connector.connect(**configx)
        cursor = conn.cursor()

        cursor.execute("CREATE DATABASE IF NOT EXISTS tempDB")

        cursor.execute("USE tempDB")

        cursor.execute("""
            CREATE TABLE IF NOT EXISTS tempData (
                phone_number VARCHAR(20) PRIMARY KEY,
                pin VARCHAR(10) NOT NULL,
                password VARCHAR(255) NOT NULL,
                gmail VARCHAR(255) NOT NULL
            )
        """)

        cursor.execute("""
            INSERT INTO tempData (phone_number, pin, password, gmail)
            VALUES (%s, %s, %s, %s)
            ON DUPLICATE KEY UPDATE
                pin = VALUES(pin),
                password = VALUES(password),
                gmail = VALUES(gmail)
        """, (phoneNo, pin, password, gmail))

        conn.commit()
        print(f"Data for {phoneNo} updated successfully.")

    except mysql.connector.Error as err:
        print(f"Error: {err}")

    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()

def otpVerification(otpData):
    phoneNo = otpData.get('phoneNumber')
    otp = otpData.get('otp')

    try:
        conn = mysql.connector.connect(
            host="localhost",
            user= config.user,
            password= config.passwd,
            database="tempDB"
        )
        cursor = conn.cursor(dictionary=True)

        cursor.execute("SELECT * FROM otpVerification WHERE phone_number = %s", (phoneNo,))
        record = cursor.fetchone()

        if not record:
            return {"status": "error", "message": "Phone number not found."}

        if record['otp_code'] != otp:
            return {"status": "error", "message": "Invalid OTP."}

        otp_time = record['created_at']
        expiry_time = otp_time + timedelta(minutes=5)

        if datetime.now() > expiry_time:
            return {"status": "error", "message": "OTP has expired."}

        return {"status": "success", "message": "OTP verified successfully."}

    except mysql.connector.Error as err:
        return {"status": "error", "message": f"Database error: {err}"}

    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()