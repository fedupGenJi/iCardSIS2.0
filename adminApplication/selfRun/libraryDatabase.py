import mysql.connector
import sys
import os

# Add the project root directory to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import config

def create_database_and_tables():
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user= config.user,
            password= config.passwd
        )

        cursor = connection.cursor()

        cursor.execute("CREATE DATABASE IF NOT EXISTS LibraryDB")
        cursor.execute("USE LibraryDB")

        cursor.execute("""
            CREATE TABLE IF NOT EXISTS FineTable (
                studentID INT PRIMARY KEY,
                fineAmount INT DEFAULT 0
            )
        """)

        cursor.execute("""
            CREATE TABLE IF NOT EXISTS book (
                bookID INT PRIMARY KEY,
                bookName VARCHAR(255),
                noInStock INT
            )
        """)

        cursor.execute("""
            CREATE TABLE IF NOT EXISTS borrowedBooks (
                sequence INT AUTO_INCREMENT PRIMARY KEY,
                studentID INT,
                bookID INT,
                borrowedDate VARCHAR(255),
                deadline VARCHAR(255),
                days_dued INT,
                FOREIGN KEY (studentID) REFERENCES FineTable(studentID) ON DELETE CASCADE ON UPDATE CASCADE,
                FOREIGN KEY (bookID) REFERENCES book(bookID) ON DELETE CASCADE ON UPDATE CASCADE
            )
        """)

        cursor.execute("""
            CREATE TABLE IF NOT EXISTS maxBooks (
                studentID INT PRIMARY KEY,
                booksLended INT DEFAULT 0,
                FOREIGN KEY (studentID) REFERENCES FineTable(studentID) ON DELETE CASCADE ON UPDATE CASCADE
            )
        """)

        print("Database and tables created successfully!")
    
    except mysql.connector.Error as error:
        print(f"Error: {error}")
    
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

create_database_and_tables()