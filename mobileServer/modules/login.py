import mysql.connector
import sys
import os
import bcrypt
import base64
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

def getFromDB(student_id):
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            passwd=config.passwd,
            database="iCardSISDB"
        )
        cursor = conn.cursor(dictionary=True)

        cursor.execute("SELECT * FROM studentInfo WHERE studentId = %s", (student_id,))
        student_data = cursor.fetchone()

        if not student_data:
            return {"error": "Student not found"}

        cursor.execute("SELECT phoneNo FROM loginInfo WHERE studentId = %s", (student_id,))
        login_data = cursor.fetchone()

        def safe_str(value):
            return str(value) if value is not None else ""

        photo_base64 = base64.b64encode(student_data["photo"]).decode('utf-8') if student_data["photo"] else ""

        result = {
            "name": safe_str(f"{student_data['firstName']} {student_data['middleName']} {student_data['lastName']}".strip()),
            "dob": safe_str(student_data["DOB"]),
            "bg": safe_str(student_data["bloodGroup"]),
            "photo": photo_base64,
            "YOE": safe_str(student_data["YOE"]),
            "SEX": safe_str(student_data["sex"]),
            "course": safe_str(student_data["Course"]),
            "balance": safe_str(student_data["Balance"]),
            "phoneNo": safe_str(login_data["phoneNo"]) if login_data else ""
        }
        return result

    except mysql.connector.Error as err:
        return {"error": str(err)}

    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()

def verifyStudentPin(studentId, pin):
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            passwd=config.passwd,
            database="iCardSISDB"
        )
        cursor = conn.cursor(dictionary=True)

        query = "SELECT pin FROM loginInfo WHERE studentId = %s"
        cursor.execute(query, (studentId,))
        result = cursor.fetchone()

        cursor.close()
        conn.close()

        if result:
            if result["pin"] == pin:
                return True, "Successful"
            else:
                return False, "Invalid PIN"
        else:
            return False, "Student ID not found"

    except mysql.connector.Error as err:
        return False, f"Database error: {err}"