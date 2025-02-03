import mysql.connector
import sys
import os
import bcrypt
# Add the project root directory to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import config

def registerData(phoneNo):
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="tempDB"
        )
        cursor = conn.cursor(dictionary=True)
        
        cursor.execute("SELECT gmail, pin, password FROM tempData WHERE phoneNo = %s", (phoneNo,))
        result = cursor.fetchone()
        
        if not result:
            return "No data found for this phone number in tempData."

        gmail = result["gmail"]
        pin = result["pin"]
        plain_password = result["password"]

        hashed_password = bcrypt.hashpw(plain_password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')

        cursor.close()
        conn.close()

        conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="iCardSISDB"
        )
        cursor = conn.cursor(dictionary=True)

        cursor.execute("SELECT studentId FROM studentInfo WHERE gmail = %s", (gmail,))
        student_result = cursor.fetchone()

        if not student_result:
            return "No matching studentId found for this Gmail."

        studentId = student_result["studentId"]

        cursor.execute("""
            INSERT INTO loginInfo (studentId, Gmail, phoneNo, password, pin)
            VALUES (%s, %s, %s, %s, %s)
        """, (studentId, gmail, phoneNo, hashed_password, pin))

        conn.commit()
        clearTemp(phoneNo)
        return "success"

    except mysql.connector.Error as err:
        return f"Database error: {err}"

    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()

def clearTemp(phoneNo):
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="tempDB"
        )
        cursor = conn.cursor()

        # Delete data from tempData table
        cursor.execute("DELETE FROM tempData WHERE phone = %s", (phoneNo,))
        
        # Delete data from otpVerification table
        cursor.execute("DELETE FROM otpVerification WHERE phone = %s", (phoneNo,))

        conn.commit()
        print(f"Records deleted for phone number: {phoneNo}")

    except mysql.connector.Error as err:
        print(f"Error: {err}")

    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()