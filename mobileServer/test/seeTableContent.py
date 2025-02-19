import mysql.connector
import sys
import os

# Add the project root directory to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import config

def main():
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            password=config.passwd,
            database="tempDB"
        )
        
        cursor = conn.cursor()

        cursor.execute("SHOW TABLES")
        tables = cursor.fetchall()

        if not tables:
            print("No tables found in the database.")
        else:
            print("\nAvailable Tables:")
            for table in tables:
                print(f"- {table[0]}")

            for table in tables:
                table_name = table[0]
                print(f"\nContents of Table: {table_name}")
                cursor.execute(f"SELECT * FROM {table_name}")
                rows = cursor.fetchall()

                column_names = [i[0] for i in cursor.description]
                print(column_names)

                for row in rows:
                    print(row)

    except mysql.connector.Error as err:
        print(f"Error: {err}")
    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()
            print("\nConnection closed.")

if __name__ == "__main__":
    main()
