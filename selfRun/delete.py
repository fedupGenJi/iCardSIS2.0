import sys
import os

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import config
import mysql.connector

def database_exists(cursor, db_name):
    cursor.execute(f"SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '{db_name}'")
    return cursor.fetchone() is not None

def main():
    if os.path.exists("key.key"):
        os.remove("key.key")
        print("key.key file has been deleted.")

    try:
        connection = mysql.connector.connect(
            host="localhost",
            user=config.user,
            passwd=config.passwd
        )

        cursor = connection.cursor()

        databases_to_delete = ["iCardSISDB", "LibraryDB", "auditDB"]

        for db in databases_to_delete:
            if database_exists(cursor, db):
                cursor.execute(f"DROP DATABASE {db}")
                print(f"The database '{db}' has been deleted.")
            else:
                print(f"The database '{db}' does not exist, so it was not deleted.")

        print("Fresh Start!")

        cursor.close()
        connection.close()

    except mysql.connector.Error as err:
        print(f"Error: {err}")

if __name__ == "__main__":
    main()