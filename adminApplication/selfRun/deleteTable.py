import sys
import os
import mysql.connector

# Add the project root directory to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import config

# Establish connection to the MySQL database
connection = mysql.connector.connect(
    host="localhost",
    user=config.user,
    passwd=config.passwd
)

cursor = connection.cursor()

def get_foreign_key_dependencies(table_name):
    """
    Retrieve tables that have foreign key dependencies on the given table.
    """
    cursor.execute(
        f"""
        SELECT TABLE_NAME
        FROM information_schema.KEY_COLUMN_USAGE
        WHERE REFERENCED_TABLE_NAME = '{table_name}'
        AND TABLE_SCHEMA = 'iCardSISDB';
        """
    )
    return [row[0] for row in cursor.fetchall()]

try:
    cursor.execute("USE iCardSISDB")
    cursor.execute("SHOW TABLES")
    tables = cursor.fetchall()

    if not tables:
        print("No tables found in the database.")
    else:
        print("Available tables:")
        for idx, table in enumerate(tables, start=1):
            print(f"{idx}. {table[0]}")

        # Ask the user to select a table to delete
        try:
            table_index = int(input("Enter the number of the table you want to delete: "))

            if 1 <= table_index <= len(tables):
                table_name = tables[table_index - 1][0]

                # Confirm deletion
                confirmation = input(f"Are you sure you want to delete the table '{table_name}'? (yes/no): ").strip().lower()
                if confirmation == "yes":
                    # Get dependent tables
                    dependencies = get_foreign_key_dependencies(table_name)

                    # Confirm deletion of all dependent tables
                    for dependent_table in dependencies:
                        dep_confirmation = input(f"The table '{dependent_table}' depends on '{table_name}'. Do you want to delete it? (yes/no): ").strip().lower()
                        if dep_confirmation != "yes":
                            print("Deletion process aborted due to dependent table not being approved for deletion.")
                            raise Exception("Process aborted by user.")

                    # Delete dependent tables
                    for dependent_table in dependencies:
                        print(f"Deleting dependent table '{dependent_table}'...")
                        cursor.execute(f"DROP TABLE {dependent_table}")
                        print(f"Table '{dependent_table}' deleted successfully.")

                    # Delete the selected table
                    cursor.execute(f"DROP TABLE {table_name}")
                    print(f"Table '{table_name}' deleted successfully.")
                else:
                    print("Deletion canceled.")
            else:
                print("Invalid selection. Please try again.")
        except ValueError:
            print("Invalid input. Please enter a valid number.")
        except Exception as e:
            print(e)

except mysql.connector.Error as err:
    print(f"Error: {err}")

finally:
    cursor.close()
    connection.close()