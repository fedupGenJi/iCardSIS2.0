import mysql.connector
from datetime import datetime,timedelta
import sys
import os

# Add the project root directory to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from modules.operationsB import audit_input
import config

configx = {
    'host': 'localhost',
    'user': config.user,         
    'password': config.passwd
}

def paymentRecord(phoneNo,pidx,amount):
    try:
        conn = mysql.connector.connect(**configx)
        cursor = conn.cursor()

        cursor.execute("CREATE DATABASE IF NOT EXISTS tempDB")
        cursor.execute("USE tempDB")

        cursor.execute("""
            CREATE TABLE IF NOT EXISTS paymentRecords (
                phone_number VARCHAR(15) PRIMARY KEY,
                amount DECIMAL(10,2) NOT NULL,
                pidx VARCHAR(50) NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        """)

        cursor.execute("""
            INSERT INTO paymentRecords (phone_number, amount, pidx)
            VALUES (%s, %s, %s)
            ON DUPLICATE KEY UPDATE amount = VALUES(amount), pidx = VALUES(pidx)
        """, (phoneNo, amount, pidx))

        conn.commit()
        print(f"Data for {phoneNo} updated successfully.")
        cursor.close()
        conn.close()
    except mysql.connector.Error as e:
        print(f"Database error: {e}")

def paymentVerified(pidx):
    try:
        conn_temp = mysql.connector.connect(**configx)
        cursor_temp = conn_temp.cursor()
        cursor_temp.execute("USE tempDB")

        cursor_temp.execute("SELECT phone_number, amount FROM paymentRecords WHERE pidx = %s", (pidx,))
        result = cursor_temp.fetchone()
        cursor_temp.close()
        conn_temp.close()

        if not result:
            print(f"No matching record found for Pidx: {pidx}")
            return

        phone_number, amount = result
        print(f"Processing payment for Phone: {phone_number}, Amount: {amount}")

        amount = float(amount)

        conn_main = mysql.connector.connect(
            host="localhost",
            user=config.user,
            passwd=config.passwd,
            database="iCardSISDB"
        )
        cursor_main = conn_main.cursor()

        cursor_main.execute("SELECT studentId FROM loginInfo WHERE phoneNo = %s", (phone_number,))
        student_result = cursor_main.fetchone()

        if not student_result:
            print(f"No studentId found for Phone: {phone_number}")
            cursor_main.close()
            conn_main.close()
            return

        studentId = student_result[0]
        print(f"Student ID: {studentId} found for Phone: {phone_number}")

        cursor_main.execute("UPDATE studentInfo SET balance = balance + %s WHERE studentId = %s", (amount, studentId))
        conn_main.commit()
        audit_input(studentId, f"Balance added of {amount}")
        print(f"Balance updated successfully for Student ID: {studentId}")

        cursor_main.close()
        conn_main.close()

    except mysql.connector.Error as e:
        print(f"Database error: {e}")

def removeFailedPayment(pidx):
    try:
        conn = mysql.connector.connect(**configx)
        cursor = conn.cursor()
        cursor.execute("USE tempDB")

        cursor.execute("SELECT phone_number FROM paymentRecords WHERE pidx = %s", (pidx,))
        result = cursor.fetchone()

        if result:
            phone_number = result[0]
            print(f"Removing data entry for phone number: {phone_number}")

            cursor.execute("DELETE FROM paymentRecords WHERE pidx = %s", (pidx,))
            conn.commit()
        else:
            print("No matching record found for deletion.")

        cursor.close()
        conn.close()
    except mysql.connector.Error as e:
        print(f"Database error: {e}")

def doesItExist(pidx):
    try:
        conn = mysql.connector.connect(**configx)
        cursor = conn.cursor()
        cursor.execute("USE tempDB")

        cursor.execute("SELECT phone_number FROM paymentRecords WHERE pidx = %s", (pidx,))
        result = cursor.fetchone()

        if result:
            return True
        else:
            return False

    except mysql.connector.Error as e:
        print(f"Database error: {e}")

    finally:
        if result == True:
            removeFailedPayment(pidx)
        cursor.close()
        conn.close()