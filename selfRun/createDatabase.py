from cryptography.fernet import Fernet

# Generate and save the key once
with open("key.key", "wb") as key_file:
   key_file.write(Fernet.generate_key())
print("key.key file has created.")
   
import mysql.connector

connection = mysql.connector.connect(
    host = "localhost",
    user = "GenJi",
    passwd = "okg00gle>" 
)

cursor = connection.cursor()

cursor.execute("CREATE DATABASE IF NOT EXISTS iCardSISDB")
cursor.execute("USE iCardSISDB")

cursor.execute("""
CREATE TABLE IF NOT EXISTS studentInfo (
    studentId INT PRIMARY KEY,
    Gmail VARCHAR(255) UNIQUE NOT NULL,
    DOB VARCHAR(20),
    firstName VARCHAR(100),
    middleName VARCHAR(100),
    lastName VARCHAR(100),
    bloodGroup VARCHAR(10),
    photo BLOB,
    YOE INT,
    Course VARCHAR(100),
    Balance FLOAT
)
""")

cursor.execute("""
CREATE TABLE IF NOT EXISTS loginInfo (
    studentId INT,
    Gmail VARCHAR(255) UNIQUE NOT NULL,
    phoneNo VARCHAR(20) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    FOREIGN KEY (studentId) REFERENCES studentInfo(studentId)
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
    FOREIGN KEY (studentId) REFERENCES studentInfo(studentId)
)
""")

connection.commit()
cursor.close()
connection.close()

print("Database and tables created successfully.")