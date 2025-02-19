import mysql.connector
import sys
import os

# Add the project root directory to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import config

def list_tables(cursor):
    """Fetch and display available tables."""
    cursor.execute("SHOW TABLES")
    tables = [table[0] for table in cursor.fetchall()]
    
    if not tables:
        print("\nNo tables found in the database.")
        return []
    
    print("\nAvailable tables:")
    for table in tables:
        print(f"- {table}")
    
    return tables

def delete_table(cursor, conn, table_name):
    """Delete a specific table after confirmation."""
    confirmation = input(f"Are you sure you want to delete {table_name}? (yes/no): ").strip().lower()
    if confirmation == "yes":
        cursor.execute(f"DROP TABLE {table_name}")
        conn.commit()
        print(f"Table {table_name} deleted successfully.")
    else:
        print("Deletion canceled.")

def delete_all_tables(cursor, conn, tables):
    """Delete all tables after confirmation."""
    confirmation = input("Are you sure you want to delete ALL tables? (yes/no): ").strip().lower()
    if confirmation == "yes":
        for table in tables:
            cursor.execute(f"DROP TABLE {table}")
        conn.commit()
        print("All tables deleted successfully.")
    else:
        print("Deletion of all tables canceled.")

def main():
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="tempDB"
        )
        cursor = conn.cursor()

        tables = list_tables(cursor)
        if not tables:
            return

        delete_options = {"1": "tempData", "2": "otpVerification", "3": "ALL TABLES"}

        print("\nChoose an option:")
        print("1. Delete tempData")
        print("2. Delete otpVerification")
        print("3. Delete ALL tables")

        choice = input("Enter 1, 2, or 3: ").strip()

        if choice in delete_options:
            if choice == "3":
                delete_all_tables(cursor, conn, tables)
            else:
                table_to_delete = delete_options[choice]
                if table_to_delete in tables:
                    delete_table(cursor, conn, table_to_delete)
                else:
                    print(f"Table {table_to_delete} not found.")
        else:
            print("Invalid choice. Please enter 1, 2, or 3.")

    except mysql.connector.Error as err:
        print(f"Error: {err}")

    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'conn' in locals() and conn.is_connected():
            conn.close()

if __name__ == "__main__":
    main()