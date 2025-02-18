import mysql.connector
from datetime import datetime

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
        
        title = determineTitle(action)
        
        student_activities.append({
            "title": title,
            "description": action,
            "date": timestamp
        })
    
    cursor.close()
    audit_conn.close()

    return student_activities