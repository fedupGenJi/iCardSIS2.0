import mysql.connector
import smtplib
import bcrypt
import random
import string
from cryptography.fernet import Fernet
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import base64
from modules.reconfigDetail import encode

#mysql-database connection
def connect_to_database():
    try:
        connection = mysql.connector.connect(
            host = "localhost",
            user = "GenJi",
            passwd = "okg00gle>",
            database="iCardSISDB"
        )
        return connection
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return None

#password-generator
def generate_password(length=12):
    characters = string.ascii_letters + string.digits + string.punctuation
    return ''.join(random.choice(characters) for _ in range(length))

#password-encrypter
def hash_password(plain_password):
    try:
        salt = bcrypt.gensalt()
        hashed = bcrypt.hashpw(plain_password.encode(), salt)
        return hashed
    except Exception as e:
        print(f"Error hashing password: {e}")
        return None

#sends-generated unique id
def generate_id(conn,stre):
    tempId = stre + " " + str(random.randint(1000, 9999))
    if (check_id_exists(conn,tempId) == False) :return tempId
    else: generate_id(conn)

#checks if the newly-generated id pre-exists
def check_id_exists(connection, generated_id):
    new_cursor = connection.cursor()
    new_cursor.execute("SELECT COUNT(*) FROM adminLogin WHERE adminId=%s", (generated_id,))
    result = new_cursor.fetchone()
    new_cursor.close()  #closes the new-cursor
    return result[0] > 0

#mysql-inserts the data
def verify_and_assign_admin(connection, admin_name, admin_gmail, admin_status, hashed_password):
    try:
        cursor = connection.cursor(dictionary=True)
        
        #does admin exists
        query = "SELECT * FROM adminLogin WHERE Gmail=%s"
        cursor.execute(query, (admin_gmail,))
        admin = cursor.fetchone()
        
        if admin:
            print("Admin already exists.")  #if gmail for admin exists
            return "Admin already exists"
        
        #unique adminId
        admin_id = generate_id(connection,admin_status)

        insert_query = """
        INSERT INTO adminLogin (adminId, Gmail, password, userName, status)
        VALUES (%s, %s, %s, %s, %s)
        """
        cursor.execute(insert_query, (admin_id, admin_gmail, hashed_password, admin_name, admin_status))
        connection.commit()
        print(f"New adminId {admin_id} generated and stored for admin: {admin_name}.")
        return admin_id
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return None

#sending-email
def send_email(admin_gmail, admin_id, admin_status, plain_password):
    sender_email = "scode904@gmail.com"  
    sender_password = "jfydvoxtjuemjxsy"
    receiver_email = admin_gmail

    ciphertext_base64 = encode(receiver_email)

    link = "http://192.168.1.74:6900/registrationConfig?email="+ciphertext_base64
    subject = "Admin Registration Confirmation"
    body = f"""
    Dear Admin,
    
    Your Admin ID: {admin_id}
    Status: {admin_status}
    Temporary Password: {plain_password}

    Please click the following link to change your password and configure your registration:
    *the link can only be used once*
    {link}

    Best regards,
    iCardSIS Team
    """

    message = MIMEMultipart()
    message["From"] = sender_email
    message["To"] = receiver_email
    message["Subject"] = subject
    message.attach(MIMEText(body, "plain"))

    try:
        with smtplib.SMTP('smtp.gmail.com', 587) as server:
            server.starttls()
            server.login(sender_email, sender_password)
            server.sendmail(sender_email, receiver_email, message.as_string())
            print(f"Email successfully sent to {receiver_email}")
    except Exception as e:
        print(f"Error sending email: {e}")
