import mysql.connector
from mysql.connector import Error
import os
import sys
import base64
# Add the project root directory to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import config

def registration(data, photo):
    try:
        icards_conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="iCardSISDB"
        )
        icards_cursor = icards_conn.cursor()

        library_conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="LibraryDB"
        )
        library_cursor = library_conn.cursor()

        full_name = data["full_name"]
        name_parts = full_name.split()

        if len(name_parts) == 1:
            first_name = name_parts[0]
            middle_name = ""
            last_name = ""
        elif len(name_parts) == 2:
            first_name, last_name = name_parts
            middle_name = ""
        else:
            first_name = name_parts[0]
            last_name = name_parts[-1]
            middle_name = " ".join(name_parts[1:-1])


        yoe = int(data["year_of_enrollment"])
        email = data["email"]
        dob = data["date_of_birth"]
        blood_group = data["blood_group"]
        course = data["course"]

        icards_cursor.execute("SELECT COUNT(*) FROM studentInfo WHERE Gmail = %s", (email,))
        email_exists = icards_cursor.fetchone()[0] > 0
        if email_exists:
            print(f"Error: Email {email} already exists.")
            return False

        prefix = f"{yoe % 100}"  
        icards_cursor.execute(
            "SELECT MAX(studentId) FROM studentInfo WHERE studentId LIKE %s",
            (f"{prefix}%",)
        )
        max_id = icards_cursor.fetchone()[0]

        if max_id:
            student_id = max_id + 1
        else:
            student_id = int(f"{prefix}01")

        photo_data = None
        if photo:
            photo_data = photo.read()

        # Insert into studentInfo table
        icards_cursor.execute("""
        INSERT INTO studentInfo (studentId, Gmail, DOB, firstName, middleName, lastName, bloodGroup, YOE, Course, Balance, photo)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (student_id, email, dob, first_name, middle_name, last_name, blood_group, yoe, course, 0.0, photo_data))

        # Insert into FineTable
        library_cursor.execute("""
        INSERT INTO FineTable (studentID)
        VALUES (%s)
        """, (student_id,))

        icards_conn.commit()
        library_conn.commit()

        print(f"Student registered successfully with ID: {student_id}")

        # Create audit table
        if create_audit_table(student_id):
            return True
        else:
            return False

    except Error as e:
        print("Error:", e)
        return False

    finally:
        if icards_conn.is_connected():
            icards_cursor.close()
            icards_conn.close()
        if library_conn.is_connected():
            library_cursor.close()
            library_conn.close()

def create_audit_table(student_id):
    try:
        audit_conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd
        )
        audit_cursor = audit_conn.cursor()

        audit_cursor.execute("CREATE DATABASE IF NOT EXISTS auditDB")
        audit_cursor.execute("USE auditDB")

        table_name = f"Student-{student_id}"

        audit_cursor.execute(f"""
        CREATE TABLE IF NOT EXISTS `{table_name}` (
            id INT AUTO_INCREMENT PRIMARY KEY,
            action VARCHAR(255) NOT NULL,
            timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
        """)

        audit_conn.commit()
        print(f"Audit table '{table_name}' created successfully.")
        return True

    except Error as e:
        print("Error:", e)
        return False

    finally:
        if audit_conn.is_connected():
            audit_cursor.close()
            audit_conn.close()

def fetch_students_from_db():
    connection = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="iCardSISDB"
        )
    cursor = connection.cursor(dictionary=True)
    
    cursor.execute("SELECT * FROM studentInfo")
    
    students = cursor.fetchall()
    
    for student in students:
        student['name'] = f"{student['firstName']} {student['middleName']} {student['lastName']}"
        
        if student['photo']:
            student['photo'] = base64.b64encode(student['photo']).decode('utf-8')
    
    cursor.close()
    connection.close()
    
    return students