from flask import Flask, render_template
import mysql.connector
import config
import base64

app = Flask(__name__)

def get_admin_details(gmail):
    connection = mysql.connector.connect(
            host = "localhost",
            user = config.user,
            passwd = config.passwd,
            database="iCardSISDB"
        )
    
    try:
        cursor = connection.cursor(dictionary=True)  
        query = "SELECT adminId, Gmail, userName, status, photo FROM adminLogin;" 

        cursor.execute(query)

        results = cursor.fetchall()

        for row in results:
            admin_id = row['adminId']
            gmail = row['Gmail']
            user_name = row['userName']
            status = row['status']
            photo = row['photo']

        if status == "KU-Admin":
            post = "Administrator"
        else:
            post = "Librarian"

        if photo:
                photo = base64.b64encode(photo).decode('utf-8')
    finally:
        cursor.close()
        connection.close()

    
    admin_details = {
        "admin_name": user_name,
        "admin_position": post,
        "admin_id": admin_id,
        "admin_photo_url": f"data:image/jpeg;base64,{photo}" if photo else "/static/images/admin.png",
        "admin_email": gmail,
        "admin_status": status
    }
    return admin_details

@app.route('/')
def home():
    id = "thakur.aakash569@gmail.com"
    admin_details = get_admin_details(id)
    return render_template('home.html',**admin_details)

@app.route('/about')
def about():
    id = "thakur.aakash569@gmail.com"
    admin_details = get_admin_details(id)
    return render_template('about.html',**admin_details)

if __name__ == '__main__':
    app.run(debug=True)