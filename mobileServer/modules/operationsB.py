import mysql.connector
import datetime
import base64
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
        
        cursor.execute("SELECT gmail, pin, password FROM tempData WHERE phone_number = %s", (phoneNo,))
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
        audit_input(studentId,"Student Registered for iCardSIS")
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
        cursor.execute("DELETE FROM tempData WHERE phone_number = %s", (phoneNo,))
        
        # Delete data from otpVerification table
        cursor.execute("DELETE FROM otpVerification WHERE phone_number = %s", (phoneNo,))

        conn.commit()
        print(f"Records deleted for phone number: {phoneNo}")

    except mysql.connector.Error as err:
        print(f"Error: {err}")

    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()

def audit_input(student_id, message):
    try:
        audit_conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="auditDB"
        )

        audit_cursor = audit_conn.cursor()
        table_name = f"Student-{student_id}"

        audit_cursor.execute(f"""
            INSERT INTO `{table_name}` (action)
            VALUES (%s)
        """, (message,))

        audit_conn.commit()
        print("INSERTED")
        return True

    except mysql.connector.Error as e:
        print(f"Error: {e}")
        return False

    finally:
        if audit_cursor:
            audit_cursor.close()
        if audit_conn:
            audit_conn.close()

def subscriptionPayment(stdId, amount, route):
    amounto = float(amount)
    
    conn = mysql.connector.connect(
        host="localhost",
        user=config.user,
        password=config.passwd,
        database="iCardSISDB"
    )
    
    cursor = conn.cursor()

    today = datetime.date.today()
    deadline = today + datetime.timedelta(days=30)
    daysRemaining = 30
    status = "ACTIVE"
    
    fetch_balance_query = "SELECT balance FROM studentInfo WHERE studentId = %s"
    update_balance_query = "UPDATE studentInfo SET balance = balance - %s WHERE studentId = %s AND balance >= %s"
    check_student_query = "SELECT COUNT(*) FROM transport WHERE studentId = %s"
    update_transport_query = """
        UPDATE transport 
        SET route = %s, status = %s, deadline = %s, daysRemaining = %s 
        WHERE studentId = %s
    """
    insert_transport_query = """
        INSERT INTO transport (studentId, route, status, deadline, daysRemaining)
        VALUES (%s, %s, %s, %s, %s)
    """
    
    try:
        cursor.execute(fetch_balance_query, (stdId,))
        result = cursor.fetchone()

        if result is None:
            print("Student ID not found.")
            return False

        current_balance = result[0]

        if current_balance < amounto:
            print("Insufficient balance.")
            return False

        cursor.execute(update_balance_query, (amounto, stdId, amounto))
        
        cursor.execute(check_student_query, (stdId,))
        exists = cursor.fetchone()[0]
        
        if exists:
            cursor.execute(update_transport_query, (route, status, deadline, daysRemaining, stdId))
        else:
            cursor.execute(insert_transport_query, (stdId, route, status, deadline, daysRemaining))

        conn.commit()
        audit_input(stdId, f"Bus subscription has been bought for {amounto}. Balance deducted.")

        return True

    except mysql.connector.Error as err:
        print(f"Error: {err}")
        conn.rollback()
        return False
    finally:
        cursor.close()
        conn.close()
    
def getStatus(studentId):
    result = None
    
    conn = mysql.connector.connect(
        host="localhost",
        user=config.user,
        password=config.passwd,
        database="iCardSISDB"
    )

    cursor = conn.cursor()
    query = "SELECT status FROM transport WHERE studentId = %s"
    cursor.execute(query, (studentId,))
    
    result = cursor.fetchone()

    cursor.close()
    conn.close()

    return result is not None and result[0] == "ACTIVE"
    
def getDataForTransportCard(studentId):
    conn = mysql.connector.connect(
        host="localhost",
        user=config.user,
        password=config.passwd,
        database="iCardSISDB"
    )
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT firstName, middleName, lastName, photo 
        FROM studentInfo 
        WHERE studentId = %s
    """, (studentId,))
    student = cursor.fetchone()

    if not student:
        return {"success": False, "message": "Student not found", "data": None}

    full_name = " ".join(filter(None, [student["firstName"], student["middleName"], student["lastName"]]))

    cursor.execute("""
        SELECT status, daysRemaining, deadline, route
        FROM transport 
        WHERE studentId = %s
    """, (studentId,))
    subscription = cursor.fetchone()

    cursor.close()
    conn.close()

    if not subscription:
        return {"success": False, "message": "Transport subscription not found", "data": None}
    
    photo_base64 = base64.b64encode(student["photo"]).decode('utf-8') if student["photo"] else ""

    return {
        "success": True,
        "message": "Data retrieved successfully",
        "data": {
            "id": studentId,
            "name": full_name,
            "subscription_status": subscription["status"],
            "photo": photo_base64,
            "daysRemaining": subscription["daysRemaining"],
            "deadline": subscription["deadline"],
            "route": subscription["route"]
        }
    }