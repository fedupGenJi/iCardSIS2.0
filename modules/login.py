import mysql.connector
import sys
import os
import bcrypt
# Add the project root directory to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import config

def loginUser(data):
    phone = data.get("phone")
    password = data.get("password")

    try:
        conn = mysql.connector.connect(
             host = "localhost",
            user = config.user,
            passwd = config.passwd,
            database="iCardSISDB"
        )
        cursor = conn.cursor()

        cursor.execute("SELECT password, studentId FROM loginInfo WHERE phoneNo = %s", (phone,))
        user_data = cursor.fetchone()

        if user_data is None:
            return {"success": False, "message": "Phone number not registered", "id":None}

        stored_password = user_data[0]
        studentId = user_data[1]
        
        if bcrypt.checkpw(password.encode('utf-8'), stored_password.encode('utf-8')):
            return {"success": True, "message": "Login successful", "id":studentId}
        else:
            return {"success": False, "message": "Incorrect password", "id":None}

    except mysql.connector.Error as err:
        return {"success": False, "message": f"Database error: {err}", "id":None}

    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()
