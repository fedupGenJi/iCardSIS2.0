import sys
import os

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import config
import mysql.connector

if os.path.exists("key.key"):
    os.remove("key.key")
    print("key.key file has been deleted.")

connection = mysql.connector.connect(
    host="localhost",
    user=config.user,
    passwd=config.passwd
)

cursor = connection.cursor()

def database_exists(cursor, db_name):
    cursor.execute("SHOW DATABASES")
    databases = [db[0] for db in cursor.fetchall()]
    return db_name in databases

databases_to_delete = ["iCardSISDB", "LibraryDB", "auditDB"]

for db in databases_to_delete:
    if database_exists(cursor, db):
        cursor.execute(f"DROP DATABASE {db}")
        print(f"The database '{db}' has been deleted.")
    else:
        print(f"The database '{db}' does not exist, so it was not deleted.")

cursor.close()
connection.close()