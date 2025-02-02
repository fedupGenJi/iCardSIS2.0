import mysql.connector
import sys
import os

# Add the project root directory to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import config

def get_available_databases():
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd
        )
        cursor = connection.cursor()
        cursor.execute("SHOW DATABASES")
        databases = [db[0].lower() for db in cursor.fetchall()]  # Convert to lowercase
        
        available_dbs = [db for db in ["librarydb", "auditdb"] if db in databases]  # Check in lowercase
        
        if not available_dbs:
            print("Neither 'LibraryDB' nor 'auditDB' exists.")
            return []
        
        print("Available Databases:")
        for db in available_dbs:
            print(f"- {db}")
        
        return available_dbs
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return []
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

def delete_database(db_name):
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd
        )
        cursor = connection.cursor()
        cursor.execute(f"DROP DATABASE `{db_name}`")
        print(f"Database '{db_name}' deleted successfully.")
    except mysql.connector.Error as err:
        print(f"Error deleting {db_name}: {err}")
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

def main():
    available_dbs = get_available_databases()
    if not available_dbs:
        return

    print("\nOptions:")
    print("1. Delete 'LibraryDB'")
    print("2. Delete 'auditDB'")
    print("3. Delete both")
    print("4. Exit")
    
    choice = input("Enter your choice: ").strip()

    if choice == "1" and "librarydb" in available_dbs:
        delete_database("librarydb")
    elif choice == "2" and "auditdb" in available_dbs:
        delete_database("auditdb")
    elif choice == "3":
        for db in available_dbs:
            delete_database(db)
    elif choice == "4":
        print("Exiting without deleting anything.")
    else:
        print("Invalid choice or database not available.")

if __name__ == "__main__":
    main()
