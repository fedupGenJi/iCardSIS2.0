import os
from .. import config

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