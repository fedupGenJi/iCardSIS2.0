from flask import Blueprint, render_template, redirect, url_for, session, request, jsonify
from modules.loginOperation import get_admin_details  
from modules.registration import *
import json

admin = Blueprint('admin', __name__)

@admin.route('/admin/homepage')
def admin_homepage():
    if not session.get('logged_in'):  
        return redirect(url_for('home')) 
    
    id = session.get('email')
    admin_details = get_admin_details(id)
    return render_template('admin/homepage.html', **admin_details)

@admin.route('/admin/regPage')
def admin_regPage():
    if not session.get('logged_in'):  
        return redirect(url_for('home')) 
    
    id = session.get('email')
    admin_details = get_admin_details(id)
    return render_template('admin/regPageg.html', **admin_details)

@admin.route('/admin/regPage', methods=['POST'])
def reg():
    data = request.form['data']
    data = json.loads(data) 
    photo = request.files.get('photo')
    
    success = registration(data, photo)
    if (success==True):
        return {"status": "success", "message": "Student registered successfully"}
    elif (success == "Email exists!"):
        return {"status": "gmailFailure", "message": "Duplication of Email"}
    else:
        return {"status": "failure", "message": "Student registration failed"}
    
@admin.route('/admin/dataPage')
def dataPage():
    if not session.get('logged_in'):  
        return redirect(url_for('home')) 
    
    id = session.get('email')
    admin_details = get_admin_details(id)
    return render_template('admin/showData.html', **admin_details)

@admin.route('/api/students', methods=['GET'])
def studentData():
    try:
        students_data = fetch_students_from_db()
        return jsonify(students_data)

    except Exception as e:
        return jsonify({'error': str(e)}), 500
