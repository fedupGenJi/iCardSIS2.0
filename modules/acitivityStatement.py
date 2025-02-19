import mysql.connector
from mysql.connector import Error
from datetime import datetime
from modules.operationsB import audit_input

def determineTitle(action):
    if "login" in action.lower():
        return "Login Activity"
    elif "library" in action.lower():
        return "Library Activity"
    elif "registered" in action.lower():
        return "Registeration"
    elif "book" in action.lower():
        return "Library Lend/Return"
    else:
        return "General Activity"
    
def determineTitleforStatement(action):
    if "paid" in action.lower():
        return "Fines"
    elif "balance" in action.lower():
        return "Khalti"
    elif "sent" in action.lower():
        return "Friends"
    elif "received" in action.lower():
        return "Friends"
    else:
        return "General Activity"

def activityStudent(student_id, config):
    audit_conn = mysql.connector.connect(
        host="localhost",
        user=config.user,
        password=config.passwd,
        database="auditDB"
    )
    
    cursor = audit_conn.cursor(dictionary=True)
    
    table_name = f"Student-{student_id}"
    
    create_table_query = f"""
    CREATE TABLE IF NOT EXISTS `{table_name}` (
        id INT AUTO_INCREMENT PRIMARY KEY,
        action VARCHAR(255) NOT NULL,
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
    """
    cursor.execute(create_table_query)

    cursor.execute(f"SELECT action, timestamp FROM `{table_name}`")
    records = cursor.fetchall()
    
    student_activities = []
    
    for record in records:
        action = record['action']
        timestamp = record['timestamp'].strftime("%Y-%m-%d")
        
        if "balance" in action.lower():
            continue
        if "received" in action.lower():
            continue
        if "sent" in action.lower():
            continue
        if "paid" in action.lower():
            continue
        
        title = determineTitle(action)
        
        student_activities.append({
            "title": title,
            "description": action,
            "date": timestamp
        })
    
    cursor.close()
    audit_conn.close()

    return student_activities

def statementStudent(student_id, config):
    audit_conn = mysql.connector.connect(
        host="localhost",
        user=config.user,
        password=config.passwd,
        database="auditDB"
    )
    
    cursor = audit_conn.cursor(dictionary=True)
    
    table_name = f"Student-{student_id}"
    
    create_table_query = f"""
    CREATE TABLE IF NOT EXISTS `{table_name}` (
        id INT AUTO_INCREMENT PRIMARY KEY,
        action VARCHAR(255) NOT NULL,
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
    """
    cursor.execute(create_table_query)

    cursor.execute(f"SELECT action, timestamp FROM `{table_name}`")
    records = cursor.fetchall()

    student_activities = []
    
    keywords = ["balance", "received", "sent", "paid"]
    
    for record in records:
        action = record['action']
        date = record['timestamp'].strftime("%Y-%m-%d")
        
        if not any(keyword in action.lower() for keyword in keywords):
            continue
        
        title = determineTitleforStatement(action)
        
        student_activities.append({
            "title": title,
            "description": action,
            "date": date,
        })
    
    cursor.close()
    audit_conn.close()

    return student_activities

def payingFine(stdId, amount, config):
    try:

        amounta = float(amount)

        library_conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            passwd=config.passwd,
            database="LibraryDB"
        )
        conn = mysql.connector.connect(
            host="localhost",
            user=config.user,
            passwd=config.passwd,
            database="iCardSISDB"
        )
        
        library_cursor = library_conn.cursor()
        student_cursor = conn.cursor()
        
        library_update_query = """
        UPDATE FineTable
        SET fineAmount = fineAmount - %s
        WHERE studentId = %s
        """
        library_cursor.execute(library_update_query, (amounta, stdId))
        
        student_update_query = """
        UPDATE studentInfo
        SET balance = balance - %s
        WHERE studentId = %s
        """
        student_cursor.execute(student_update_query, (amount, stdId))
        
        if library_cursor.rowcount > 0 and student_cursor.rowcount > 0:
            library_conn.commit()
            conn.commit()
            audit_input(stdId,f"Fine paid of Rs. {amounta}")
            return True
        else:
            library_conn.rollback()
            conn.rollback()
            return False
    
    except Error as e:
        print("Error:", e)
        return False
    
    finally:
        if library_cursor:
            library_cursor.close()
        if student_cursor:
            student_cursor.close()
        if library_conn:
            library_conn.close()
        if conn:
            conn.close()