import sys
import os

# Add the project root directory to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import config

# Check if the file exists
if os.path.exists("key.key"):
    os.remove("key.key")
    print("key.key file has been deleted.")


import mysql.connector

connection = mysql.connector.connect(
    host = "localhost",
    user = config.user,
    passwd = config.passwd 
)

cursor = connection.cursor()

try:
    cursor.execute("DROP DATABASE IF EXISTS iCardSISDB")
    print("Database 'iCardSISDB' deleted successfully.")
except mysql.connector.Error as err:
    print(f"Error: {err}")

cursor.close()
connection.close()