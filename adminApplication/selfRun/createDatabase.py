import os
import sys
from cryptography.fernet import Fernet
import mysql.connector

# Add the project root directory to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import config

# Generate and save the key once
if not os.path.exists("key.key"):
    with open("key.key", "wb") as key_file:
        key_file.write(Fernet.generate_key())
    print("key.key file has been created.")
else:
    print("key.key file already exists.")

# Connect to MySQL
connection = mysql.connector.connect(
    host="localhost",
    user=config.user,
    passwd=config.passwd
)
if not connection:
    print("Failed to connect to the database.")

cursor = connection.cursor()

# Check if the database exists
cursor.execute("SHOW DATABASES")
databases = cursor.fetchall()
# Printing the databases retrieved
# print("Databases:", databases)
databases = [db[0].lower() for db in databases]

if "icardsisdb" in databases:
    print("Database already exists.")
    cursor.execute("USE icardsisdb")

    # Check if tables exist
    cursor.execute("SHOW TABLES")
    tables = cursor.fetchall()

    # Normalize table names to lowercase for comparison
    existing_tables = {table[0].lower() for table in tables}
    required_tables = {"studentinfo", "logininfo", "adminlogin", "transport"}  # All lowercase

    missing_tables = required_tables - existing_tables

    if not missing_tables:
        print("All tables already exist.")
    else:
        print(f"Creating missing tables: {', '.join(missing_tables)}")

        if "studentinfo" in missing_tables:
            cursor.execute("""
            CREATE TABLE studentInfo (
                studentId INT PRIMARY KEY,
                Gmail VARCHAR(255) UNIQUE NOT NULL,
                DOB VARCHAR(20),
                firstName VARCHAR(100),
                middleName VARCHAR(100),
                lastName VARCHAR(100),
                bloodGroup VARCHAR(10),
                photo MEDIUMBLOB,
                YOE INT,
                sex VARCHAR(10),
                Course VARCHAR(100),
                Balance FLOAT DEFAULT 0
            )
            """)

        if "logininfo" in missing_tables:
            cursor.execute("""
            CREATE TABLE loginInfo (
                studentId INT,
                Gmail VARCHAR(255) UNIQUE NOT NULL,
                phoneNo VARCHAR(20) UNIQUE NOT NULL,
                password VARCHAR(255) NOT NULL,
                pin VARCHAR(10) NOT NULL,
                FOREIGN KEY (studentId) REFERENCES studentInfo(studentId) ON DELETE CASCADE ON UPDATE CASCADE
            ) 
            """)

        if "adminlogin" in missing_tables:
            cursor.execute("""
            CREATE TABLE adminLogin (
                adminId VARCHAR(255) PRIMARY KEY,
                Gmail VARCHAR(255) UNIQUE NOT NULL,
                password VARCHAR(255) NOT NULL,
                userName VARCHAR(100),
                status VARCHAR(50),
                photo LONGBLOB NULL
            )
            """)

        if "transport" in missing_tables:
            cursor.execute("""
            CREATE TABLE transport (
                studentId INT,
                status VARCHAR(50),
                route VARCHAR(255),
                deadline VARCHAR(20),
                daysRemaining INT,
                FOREIGN KEY (studentId) REFERENCES studentInfo(studentId) ON DELETE CASCADE ON UPDATE CASCADE
            )
            """)

        connection.commit()
        print("Missing tables created successfully.")
else:
    # Create the database and switch to it
    cursor.execute("CREATE DATABASE iCardSISDB")
    cursor.execute("USE iCardSISDB")
    print("Database created successfully.")

    # Create all tables
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS studentInfo (
        studentId INT PRIMARY KEY,
        Gmail VARCHAR(255) UNIQUE NOT NULL,
        DOB VARCHAR(20),
        firstName VARCHAR(100),
        middleName VARCHAR(100),
        lastName VARCHAR(100),
        bloodGroup VARCHAR(10),
        photo MEDIUMBLOB,
        YOE INT,
        sex VARCHAR(10),
        Course VARCHAR(100),
        Balance FLOAT DEFAULT 0
    )
    """)

    cursor.execute("""
    CREATE TABLE IF NOT EXISTS loginInfo (
        studentId INT,
        Gmail VARCHAR(255) UNIQUE NOT NULL,
        phoneNo VARCHAR(20) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        pin VARCHAR(10) NOT NULL,
        FOREIGN KEY (studentId) REFERENCES studentInfo(studentId) ON DELETE CASCADE ON UPDATE CASCADE
    )
    """)

    cursor.execute("""
    CREATE TABLE IF NOT EXISTS adminLogin (
        adminId VARCHAR(255) PRIMARY KEY,
        Gmail VARCHAR(255) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        userName VARCHAR(100),
        status VARCHAR(50),
        photo LONGBLOB NULL
    )
    """)

    cursor.execute("""
    CREATE TABLE IF NOT EXISTS transport (
        studentId INT,
        status VARCHAR(50),
        route VARCHAR(255),
        deadline VARCHAR(20),
        daysRemaining INT,
        FOREIGN KEY (studentId) REFERENCES studentInfo(studentId) ON DELETE CASCADE ON UPDATE CASCADE
    )
    """)

    connection.commit()
    print("Tables created successfully.")

cursor.close()
connection.close()