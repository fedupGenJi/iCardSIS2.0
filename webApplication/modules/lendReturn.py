import mysql.connector
from mysql.connector import Error
from datetime import datetime, timedelta
from modules.operationA import audit_input
import os
import sys
# Add the project root directory to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import config

def lendBooktoStd(studentId, bookId, submittedDate):
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="LibraryDB"
        )
        cursor = conn.cursor(dictionary=True)

        cursor.execute("SELECT * FROM FineTable WHERE studentID = %s", (studentId,))
        student = cursor.fetchone()
        if not student:
            return {"status": False, "message": "Student not found"}

        cursor.execute("SELECT booksLended FROM maxBooks WHERE studentID = %s", (studentId,))
        max_books = cursor.fetchone()
        if max_books and max_books["booksLended"] >= 10:
            return {"status": False, "message": "Student has already lended maximum books"}

        cursor.execute("SELECT * FROM book WHERE bookID = %s", (bookId,))
        book = cursor.fetchone()
        if not book:
            return {"status": False, "message": "Book is not available in library"}

        if book["noInStock"] <= 0:
            return {"status": False, "message": "Book is out of stock"}

        borrowed_date = datetime.strptime(submittedDate, "%Y-%m-%d")
        deadline = borrowed_date + timedelta(days=30)

        cursor.execute("""
            INSERT INTO borrowedBooks (studentID, bookID, borrowedDate, deadline, days_dued) 
            VALUES (%s, %s, %s, %s, %s)
        """, (studentId, bookId, submittedDate, deadline.strftime("%Y-%m-%d"), 0))

        cursor.execute("""
             INSERT INTO maxBooks (studentID, booksLended) 
            VALUES (%s, 1) 
            ON DUPLICATE KEY UPDATE booksLended = booksLended + 1
        """, (studentId,))


        cursor.execute("UPDATE book SET noInStock = noInStock - 1 WHERE bookID = %s", (bookId,))

        conn.commit()
        audit_input(studentId,f"Book added with BookId:{bookId}")
        return {"status": True, "message": "Book successfully lended"}

    except mysql.connector.Error as err:
        return {"status": False, "message": f"Database error: {err}"}

    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()

def takeBookfromStd(studentId, bookId):
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="LibraryDB"
        )
        cursor = conn.cursor(dictionary=True)

        cursor.execute("SELECT * FROM FineTable WHERE studentID = %s", (studentId,))
        student = cursor.fetchone()
        if not student:
            return {"status": False, "message": "Student not found"}

        cursor.execute("SELECT * FROM borrowedBooks WHERE studentID = %s AND bookID = %s ORDER BY borrowedDate ASC", (studentId, bookId))
        borrowed_books = cursor.fetchall()
        if not borrowed_books:
            return {"status": False, "message": f"Student has not borrowed any books with ID: {bookId}"}

        oldest_book = borrowed_books[0]
        cursor.execute("DELETE FROM borrowedBooks WHERE studentID = %s AND bookID = %s AND borrowedDate = %s LIMIT 1", 
                    (studentId, bookId, oldest_book['borrowedDate']))
        conn.commit()

        cursor.execute("UPDATE maxBooks SET booksLended = booksLended - 1 WHERE studentID = %s", (studentId,))
        conn.commit()

        audit_input(studentId,f"Book removed with BookId:{bookId}")

        cursor.execute("SELECT * FROM book WHERE bookID = %s", (bookId,))
        book = cursor.fetchone()
        if book:
            cursor.execute("UPDATE book SET noInStock = noInStock + 1 WHERE bookID = %s", (bookId,))
            conn.commit()
            return {"status": True, "message": "Book returned by student"}
        else:
            return {"status": True, "message": "Book received but dumped"}

    except mysql.connector.Error as err:
        return {"status": False, "message": f"Database error: {err}"}

    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()

def fineCalculator():
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="LibraryDB"
        )
        cursor = conn.cursor()

        cursor.execute("SELECT sequence, studentID, deadline, days_dued FROM borrowedBooks")
        borrowed_books = cursor.fetchall()

        current_day = datetime.today().date()
        # current_day = datetime.strptime("2025-02-18", "%Y-%m-%d").date()

        for sequence, student_id, deadline, days_dued in borrowed_books:

            deadline_date = datetime.strptime(deadline, "%Y-%m-%d").date()

            days_expired = (current_day - deadline_date).days

            if days_expired > 0:
                new_days = days_expired - days_dued

                if new_days > 0:
                    fine_amount = new_days * 10

                    cursor.execute("""
                        INSERT INTO FineTable (studentID, fineAmount) 
                        VALUES (%s, %s) 
                        ON DUPLICATE KEY UPDATE fineAmount = fineAmount + VALUES(fineAmount)
                    """, (student_id, fine_amount))

                    cursor.execute("""
                        UPDATE borrowedBooks 
                        SET days_dued = days_dued + %s 
                        WHERE sequence = %s
                    """, (new_days, sequence))

        conn.commit()
        cursor.close()
        conn.close()

    except mysql.connector.Error as err:
        print("Error:", err)