import mysql.connector
from mysql.connector import Error
from modules.operationsB import audit_input
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

        audit_input(studentId,f"{amount} sent to {newStudentId}")
        audit_input(newStudentId,f"{amount} received from {studentId}")

        return True, "Money sent successfully"
        
    except Error as e:
        return False, str(e)
    
    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()

def getBooksforId(student_id):
    try:
        library_conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="LibraryDB"
        )
        cursor = library_conn.cursor(dictionary=True)

        query1 = """
            SELECT bookId, borrowedDate
            FROM borrowedBooks
            WHERE studentId = %s
        """
        cursor.execute(query1, (student_id,))
        borrowed_books = cursor.fetchall()

        if not borrowed_books:
            cursor.close()
            library_conn.close()
            return {"result": False}

        books = []
        
        query2 = """
            SELECT bookName FROM book WHERE bookId = %s
        """
        for book in borrowed_books:
            cursor.execute(query2, (book["bookId"],))
            book_name_result = cursor.fetchone()

            book["bookName"] = book_name_result["bookName"] if book_name_result else "Unknown"
            books.append(book)

        cursor.close()
        library_conn.close()

        return {"result": True, "books": books}

    except mysql.connector.Error as err:
        print(f"Database error: {err}")
        return {"result": False} 
    
    except Exception as e:
        print(f"Unexpected error: {e}")
        return {"result": False} 
    
def getAmounts(stdId):
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            passwd=config.passwd,
            database="iCardSISDB"
        )
        cursor = conn.cursor()
        cursor.execute("SELECT balance FROM studentInfo WHERE studentId = %s", (stdId,))
        balance_result = cursor.fetchone()
        conn.close()
        
        library_conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            passwd=config.passwd,
            database="LibraryDB"
        )
        library_cursor = library_conn.cursor()
        library_cursor.execute("SELECT fineAmount FROM FineTable WHERE studentId = %s", (stdId,))
        fine_result = library_cursor.fetchone()
        library_conn.close()

        balance = int(balance_result[0]) if balance_result else 0
        fine = fine_result[0] if fine_result else 0

        return True, balance, fine

    except mysql.connector.Error as err:
        print("Error:", err)
        return False, 0, 0
    
def getDataForReport(studentId):
    try:
        library_conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            passwd=config.passwd,
            database="LibraryDB"
        )
        cursor = library_conn.cursor(dictionary=True)

        query = """
            SELECT bookId, days_dued 
            FROM borrowedBooks 
            WHERE studentId = %s
        """
        cursor.execute(query, (studentId,))
        borrowed_books = cursor.fetchall()

        temp_conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            passwd=config.passwd,
            database="tempDB"
        )
        temp_cursor = temp_conn.cursor()
        temp_cursor.execute("""
            CREATE TABLE IF NOT EXISTS error_reports (
                id INT AUTO_INCREMENT PRIMARY KEY,
                studentId INT NOT NULL,
                bookId INT NOT NULL,
                daysDued INT NOT NULL,
                status VARCHAR(20) DEFAULT 'Pending',
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)
        
        temp_cursor.execute("SELECT bookId FROM error_reports WHERE studentId = %s", (studentId,))
        error_books = {row[0] for row in temp_cursor.fetchall()}

        filtered_books = [book for book in borrowed_books if book['bookId'] not in error_books]

        has_borrowed = len(filtered_books) > 0
        
        return {
            "has_borrowed": has_borrowed,
            "borrowed_books": filtered_books
        }
    
    except Error as err:
        print(f"Error: {err}")
        return {"has_borrowed": False, "borrowed_books": []}
    
    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'library_conn' in locals() and library_conn.is_connected():
            library_conn.close()
        if 'temp_cursor' in locals():
            temp_cursor.close()
        if 'temp_conn' in locals() and temp_conn.is_connected():
            temp_conn.close()

def reportStore(student_id, book_id, days_dued):
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="tempDB"
        )
        cursor = conn.cursor()

        cursor.execute("""
            CREATE TABLE IF NOT EXISTS error_reports (
                id INT AUTO_INCREMENT PRIMARY KEY,
                studentId INT NOT NULL,
                bookId INT NOT NULL,
                daysDued INT NOT NULL,
                status VARCHAR(20) DEFAULT 'Pending',
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)

        cursor.execute("""
            INSERT INTO error_reports (studentId, bookId, daysDued) 
            VALUES (%s, %s, %s)
        """, (student_id, book_id, days_dued))

        conn.commit()
        cursor.close()
        conn.close()

        audit_input(student_id, f"A report issued for book with id: {book_id}")

        return True, "Report submitted successfully!"
    except mysql.connector.Error as err:
        return False, str(err)