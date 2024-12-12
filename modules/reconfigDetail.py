from cryptography.fernet import Fernet
import base64

key = Fernet.generate_key()

def decode(foc):
    ciphertext = base64.urlsafe_b64decode(foc)
    cipher = Fernet(key)
    decrypted_email = cipher.decrypt(ciphertext)
    return decrypted_email.decode('utf-8')

def encode(foc):
    cipher = Fernet(key)
    encoded_email = foc.encode('utf-8')
    ciphertext = cipher.encrypt(encoded_email)
    return base64.urlsafe_b64encode(ciphertext).decode('utf-8')