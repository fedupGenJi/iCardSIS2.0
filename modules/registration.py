from modules.operationA import *
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
        sex = data["sex"]

        icards_cursor.execute("SELECT COUNT(*) FROM studentInfo WHERE Gmail = %s", (email,))
        email_exists = icards_cursor.fetchone()[0] > 0
        if email_exists:
            print(f"Error: Email {email} already exists.")
            return ("Email exists!")

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
        INSERT INTO studentInfo (studentId, Gmail, DOB, firstName, middleName, lastName, bloodGroup, YOE, sex, Course, Balance, photo)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (student_id, email, dob, first_name, middle_name, last_name, blood_group, yoe, sex, course, 0.0, photo_data))

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
            audit_input(student_id,"Student Registered at KU-Database!")
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

def fetch_login_from_db():
    connection = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="iCardSISDB"
        )
    cursor = connection.cursor(dictionary=True)
    
    cursor.execute("SELECT * FROM loginInfo")
    
    students = cursor.fetchall()
    
    cursor.close()
    connection.close()
    
    return students

def delStdDB(stdId):
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="iCardSISDB"
        )
        library_conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="LibraryDB"
        )
        audit_conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="auditDB"
        )

        if connection.is_connected() and library_conn.is_connected() and audit_conn.is_connected():
            connection.start_transaction()
            library_conn.start_transaction()
            audit_conn.start_transaction()

            cursor = connection.cursor()
            delete_query = "DELETE FROM studentInfo WHERE studentId = %s"
            cursor.execute(delete_query, (stdId,))
            if cursor.rowcount == 0:
                raise Exception("Student ID not found in studentInfo")

            library_cursor = library_conn.cursor()
            delete_library_query = "DELETE FROM fineTable WHERE studentId = %s"
            library_cursor.execute(delete_library_query, (stdId,))
            if library_cursor.rowcount == 0:
                raise Exception("Student ID not found in fineTable")

            audit_cursor = audit_conn.cursor()
            table_name = f"Student-{stdId}"
            drop_table_query = f"DROP TABLE IF EXISTS `{table_name}`"
            audit_cursor.execute(drop_table_query)

            connection.commit()
            library_conn.commit()
            audit_conn.commit()
            print("Deleted")
            return True

    except Error as e:
        print("Error:", e)
        if connection.is_connected():
            connection.rollback()
        if library_conn.is_connected():
            library_conn.rollback()
        if audit_conn.is_connected():
            audit_conn.rollback()
        return False

    except Exception as ex:
        print("Exception:", ex)
        if connection.is_connected():
            connection.rollback()
        if library_conn.is_connected():
            library_conn.rollback()
        if audit_conn.is_connected():
            audit_conn.rollback()
        return False

    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()
        if library_conn.is_connected():
            library_cursor.close()
            library_conn.close()
        if audit_conn.is_connected():
            audit_cursor.close()
            audit_conn.close()

def delLoginDB(stdId):
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="iCardSISDB"
        )

        if connection.is_connected():
            connection.start_transaction()

            cursor = connection.cursor()
            delete_query = "DELETE FROM loginInfo WHERE studentId = %s"
            cursor.execute(delete_query, (stdId,))
            if cursor.rowcount == 0:
                raise Exception("Student ID not found in studentInfo")

            connection.commit()
            print("Deleted")
            return True

    except Error as e:
        print("Error:", e)
        if connection.is_connected():
            connection.rollback()
        return False

    except Exception as ex:
        print("Exception:", ex)
        if connection.is_connected():
            connection.rollback()
        return False

    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()