import sys
import os
import mysql.connector
from mysql.connector import Error

# Add the project root directory to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import config

def booksForDB(data):
    bookId = data.get('id')
    bookName = data.get('name')
    bookCount = int(data.get('count', 0))


    try:
        library_conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="LibraryDB"
        )
        cursor = library_conn.cursor()

        cursor.execute("SELECT bookName, noInStock FROM book WHERE bookID = %s", (bookId,))
        result = cursor.fetchone()

        if result:
            existingBookName, existingStock = result
            if existingBookName == bookName:
                newStock = existingStock + bookCount
                cursor.execute("UPDATE book SET noInStock = %s WHERE bookID = %s", (newStock, bookId))
                library_conn.commit()
                return True, f"{bookCount} added for pre-existing book."
            else:
                return False, "This ID exists previously but with a different name."
        else:
            cursor.execute("INSERT INTO book (bookID, bookName, noInStock) VALUES (%s, %s, %s)", 
                           (bookId, bookName, bookCount))
            library_conn.commit()
            return True, "New book added."

    except mysql.connector.Error as err:
        return False, f"Error: {err}"

    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'library_conn' in locals() and library_conn.is_connected():
            library_conn.close()

def removeBook(data):
    bookId = data.get('id')
    bookCount = int(data.get('count', 0))

    try:
        library_conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="LibraryDB"
        )
        cursor = library_conn.cursor()

        cursor.execute("SELECT noInStock FROM book WHERE bookID = %s", (bookId,))
        result = cursor.fetchone()

        if not result:
            return False, "No book available."

        available_count = result[0]

        if available_count < bookCount:
            return False, "Can't subtract that many books."

        new_count = available_count - bookCount
        cursor.execute("UPDATE book SET noInStock = %s WHERE bookID = %s", (new_count, bookId))
        library_conn.commit()

        return True, "Book(s) removed successfully."

    except mysql.connector.Error as err:
        return False, f"Database error: {err}"

    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'library_conn' in locals():
            library_conn.close()

def getBookShelves():
    try:
        library_conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="LibraryDB"
        )
        cursor = library_conn.cursor(dictionary=True)

        cursor.execute("SELECT bookID, bookName, noInStock FROM book")
        books = cursor.fetchall()

        book_list = [{'id': str(book['bookID']), 'name': book['bookName'], 'number': str(book['noInStock'])} for book in books]
        
        cursor.close()
        library_conn.close()

        return book_list

    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return []

def delBookId(book):
    bookId = int(book)
    try:
        library_conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="LibraryDB"
        )
        cursor = library_conn.cursor()

        delete_query = "DELETE FROM book WHERE bookId = %s"
        cursor.execute(delete_query, (bookId,))
        library_conn.commit()

        if cursor.rowcount > 0:
            return True 
        else:
            return False

    except Error as e:
        print(f"Database error: {e}")
        return None 

    finally:
        if library_conn.is_connected():
            cursor.close()
            library_conn.close()