from flask import Flask, render_template

app = Flask(__name__)

def get_admin_details():
    admin_details = {
        "admin_name": "John Doe",
        "admin_position": "Administrator",
        "admin_id": "KU-Admin 7788",
        "admin_photo_url": "/static/images/admin.png",
        "admin_email": "john.doe@example.com",
        "admin_status": "Admin-Operator"
    }
    return admin_details

@app.route('/')
def home():
    admin_details = get_admin_details()
    return render_template('home.html',**admin_details)

@app.route('/about')
def about():
    admin_details = get_admin_details()
    return render_template('about.html',**admin_details)

if __name__ == '__main__':
    app.run(debug=True)
