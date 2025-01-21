import mysql.connector
from mysql.connector import Error
import os
import sys
import base64
# Add the project root directory to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import config

def audit_input(student_id, message):
    try:
        audit_conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="auditDB"
        )

        audit_cursor = audit_conn.cursor()
        table_name = f"Student-{student_id}"

        audit_cursor.execute(f"""
            INSERT INTO `{table_name}` (action)
            VALUES (%s)
        """, (message,))

        audit_conn.commit()
        print("INSERTED")
        return True

    except mysql.connector.Error as e:
        print(f"Error: {e}")
        return False

    finally:
        if audit_cursor:
            audit_cursor.close()
        if audit_conn:
            audit_conn.close()


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