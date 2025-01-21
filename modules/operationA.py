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
