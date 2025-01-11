import sys
import os
import mysql.connector
import bcrypt
import string 
import random
import base64

# Add the project root directory to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import config

def secure_key():
    length = 12
    characters = string.ascii_letters + string.digits + string.punctuation
    return ''.join(random.choice(characters) for _ in range(length))

""""
#password-hashing
def hash_password(plain_password):
    try:
        salt = bcrypt.gensalt()
        hashed = bcrypt.hashpw(plain_password.encode(), salt)
        return hashed
    except Exception as e:
        print(f"Error hashing password: {e}")
        return None
"""
#mysql-database connection
def connect_to_database():
    try:
        connection = mysql.connector.connect(
            host = "localhost",
            user = config.user,
            passwd = config.passwd,
            database="iCardSISDB"
        )
        return connection
    
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return None
    
def login_check(gmail,password):
    connection = connect_to_database()

    if connection is None:
        return "Database connection failed.", None

    try:
        cursor = connection.cursor()

        query = "SELECT password FROM adminLogin WHERE Gmail = %s"
        cursor.execute(query, (gmail,))
        result = cursor.fetchone()

        if not result:
            return "no email", None

        stored_password = result[0] 
        if isinstance(stored_password, str):
            stored_password = stored_password.encode('utf-8')

#       hashedpw = hash_password(password)
#           if not hashedpw:
#           return "Failed to hash the password."

        if bcrypt.checkpw(password.encode('utf-8'),stored_password):
            query = "SELECT status FROM adminLogin WHERE Gmail = %s"
            cursor.execute(query, (gmail,))
            status_result = cursor.fetchone()
            user_status = status_result[0] if status_result else None
            return "success", user_status
        else:
            return "wrong pw", None

    except mysql.connector.Error as err:
        return f"An error occurred while accessing the database: {err}"

    finally:
        # Close the database connection
        if connection.is_connected():
            cursor.close()
            connection.close()

def get_admin_details(gmail):
    connection = connect_to_database()

    if connection is None:
        return "Database connection failed.", None
    
    try:
        cursor = connection.cursor(dictionary=True)
        query = "SELECT adminId, Gmail, userName, status, photo FROM adminLogin WHERE Gmail=%s;"
        cursor.execute(query, (gmail,))
        result = cursor.fetchone() 
        
        if result:
            admin_id = result['adminId']
            user_name = result['userName']
            status = result['status']
            photo = result['photo']
            gmail = result['Gmail']

            if status == "KU-Admin":
                post = "Administrator"
            else:
                post = "Librarian"

            if photo:
                photo = base64.b64encode(photo).decode('utf-8')
            else:
                photo = None
        else:
            raise ValueError("No admin found for the provided Gmail")

    finally:
        cursor.close()
        connection.close()

    admin_details = {
        "admin_name": user_name,
        "admin_position": post,
        "admin_id": admin_id,
        "admin_photo_url": f"data:image/jpeg;base64,{photo}" if photo else "/static/assests/icons/admin.png",
        "admin_email": gmail,
        "admin_status": status
    }
    
    return admin_details