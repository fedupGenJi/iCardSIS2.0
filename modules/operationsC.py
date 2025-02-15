import mysql.connector
from mysql.connector import Error
import sys
import os
import bcrypt
# Add the project root directory to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import config

def getDataforSM(studentId):
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            passwd=config.passwd,
            database="iCardSISDB"
        )
        cursor = conn.cursor(dictionary=True)
        
        cursor.execute("SELECT phoneNo FROM loginInfo WHERE studentId = %s", (studentId,))
        phone_result = cursor.fetchone()
        
        cursor.execute("SELECT balance FROM studentInfo WHERE studentId = %s", (studentId,))
        balance_result = cursor.fetchone()
        
        if phone_result and balance_result:
            return {
                "result": True,
                "user_id": studentId,
                "balance": balance_result["balance"],
                "phone_number": phone_result["phoneNo"]
            }
        else:
            return {"result": False, "error": "Student ID not found in one or both tables."}
        
    except mysql.connector.Error as err:
        return {"result": False, "error": str(err)}
    
    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()

def sendMoneyx(studentId, amount, phoneNo):
    studentId = int(studentId)
    amount = float(amount)
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            passwd=config.passwd,
            database="iCardSISDB"
        )
        cursor = conn.cursor(dictionary=True)
        
        cursor.execute("SELECT balance FROM studentInfo WHERE studentId = %s", (studentId,))
        sender = cursor.fetchone()
        
        if not sender:
            return False, "Sender not found"
        
        if sender['balance'] < amount:
            return False, "Insufficient balance"
        
        cursor.execute("SELECT studentId FROM loginInfo WHERE phoneNo = %s", (phoneNo,))
        recipient = cursor.fetchone()
        
        if not recipient:
            return False, "Haven't joined iCardSIS"
        
        newStudentId = recipient['studentId']
        
        cursor.execute("UPDATE studentInfo SET balance = balance - %s WHERE studentId = %s", (amount, studentId))
        cursor.execute("UPDATE studentInfo SET balance = balance + %s WHERE studentId = %s", (amount, newStudentId))
        conn.commit()
        
        return True, "Money sent successfully"
        
    except Error as e:
        return False, str(e)
    
    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()