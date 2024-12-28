from cryptography.fernet import Fernet
import base64
import mysql.connector

# Load the key for decryption
def load_key():
    with open("key.key", "rb") as key_file:
        return key_file.read()
    
# Load the consistent key
key = load_key()

def decode(foc):
    try:
        # Ensure input is in proper base64 format
        #print(f"Ciphertext received: {foc}")
        
        ciphertext = base64.urlsafe_b64decode(foc)
        #print(f"Decoded ciphertext: {ciphertext}")

        cipher = Fernet(key)
        decrypted_email = cipher.decrypt(ciphertext)
        return decrypted_email.decode('utf-8')

    except Exception as e:
        print(f"Error occurred during decryption: {e}")
        raise ValueError(f"Failed to decode ciphertext: {e}")
    

def encode(foc):
    cipher = Fernet(key)
    encoded_email = foc.encode('utf-8')
    ciphertext = cipher.encrypt(encoded_email)
    return base64.urlsafe_b64encode(ciphertext).decode('utf-8')

def updatingDatabase(connection, email, hashedPass, photo):
    try:
        cursor = connection.cursor()

        update_query = """
        UPDATE adminLogin
        SET password = %s, photo = %s
        WHERE Gmail = %s
        """
        cursor.execute(update_query, (hashedPass, photo, email))
        connection.commit()
        print("Database updated successfully.")
        return {"status": "success", "message": "Database updated successfully."}

    except mysql.connector.Error as e:
        print(f"Error updating database: {e}")
        connection.rollback()
        return {"status": "error", "message": str(e)}
    
    finally:
        cursor.close()

def get_employees_db(connection):
    cursor = None
    try:
        cursor = connection.cursor()
        query = "SELECT userName, adminId, Gmail, status, photo FROM adminLogin"
        cursor.execute(query)

        employees = [
            {
                "userName": row[0],
                "adminId": row[1],
                "Gmail": row[2],
                "status": row[3],
                "photo": row[4]
            }
            for row in cursor.fetchall()
        ]

        return employees
    except mysql.connector.Error as e:
        print(f"An error occurred: {e}")
        return []
    finally:
        if cursor:
            cursor.close()

def delete_employee_db(connection, admin_id):
    cursor = None
    try:
        cursor = connection.cursor()
        
        # Fetch Gmail of the admin to be deleted
        fetch_query = "SELECT Gmail FROM adminLogin WHERE adminId = %s"
        cursor.execute(fetch_query, (admin_id,))
        result = cursor.fetchone()
        
        if not result:
            print(f"No admin found with ID: {admin_id}")
            return False
        
        admin_gmail = result[0]
        
        from modules.adminDetails import send_removal_email
        # Send notification email
        send_removal_email(admin_gmail)
        
        # Delete the admin from the database
        delete_query = "DELETE FROM adminLogin WHERE adminId = %s"
        cursor.execute(delete_query, (admin_id,))
        connection.commit()
        
        return cursor.rowcount > 0 
    except Exception as e:
        print(f"An error occurred while deleting the employee: {e}")
        return False
    finally:
        if cursor:
            cursor.close()