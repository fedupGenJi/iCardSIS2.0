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