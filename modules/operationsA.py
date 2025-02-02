import mysql.connector
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
