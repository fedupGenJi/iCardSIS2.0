from flask import Blueprint, render_template, redirect, url_for, session, request, jsonify
from modules.loginOperation import get_admin_details, passwordUpdate, pinUpdate
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

@admin.route('/admin/loginInfo')
def loginInfoPage():
    if not session.get('logged_in'):  
        return redirect(url_for('home')) 
    
    id = session.get('email')
    admin_details = get_admin_details(id)
    return render_template('admin/loginInfo.html', **admin_details)

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
    
@admin.route('/api/students', methods=['DELETE'])
def delStudent():
    data = request.get_json()
    student_id = data.get('student_id')
    if student_id:
        print(f"Received request to delete student ID: {student_id}")
    else:
        print("Student Id wasn't received!!!!")
        return jsonify({"error": "Student ID not provided."}), 400
    outcome = delStdDB(student_id)
    if (outcome == True ):
        return jsonify({"success":"Student removed with id:{student_id}"}),200
    else:
        return jsonify({"databaseError":"Database couldn't complete request"}),400
    
@admin.route('/api/students', methods=['PUT'])
def updateStudent():
    try:
        data = request.get_json()
        if not data:
            return jsonify({"error": "No data received"}), 404
        success = updateDatabase(data)
        if success:
            return jsonify({"message": "Student data updated successfully"}), 200
        else:
            return jsonify({"error": "Failed to update student data"}), 400

    except Exception as e:
        return jsonify({"error": f"Server error: {str(e)}"}), 500
    
@admin.route('/api/login', methods=['GET'])
def loginData():
    try:
        students_data = fetch_login_from_db()
        return jsonify(students_data)

    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@admin.route('/api/login', methods=['DELETE'])
def delLogin():
    data = request.get_json()
    student_id = data.get('student_id')
    if student_id:
        print(f"Received request to delete student ID: {student_id}")
    else:
        print("Student Id wasn't received!!!!")
        return jsonify({"error": "Student ID not provided."}), 400
    outcome = delLoginDB(student_id)
    if (outcome == True ):
        return jsonify({"success":"Student removed with id:{student_id}"}),200
    else:
        return jsonify({"databaseError":"Database couldn't complete request"}),400
    
@admin.route('/api/updatePassword', methods=['PUT'])
def updatePass():
    try:
        data = request.get_json()
        
        student_id = data.get('studentId')
        new_password = data.get('newPassword')

        if not student_id or not new_password:
            return jsonify({"message": "Missing studentId or newPassword"}), 400

        try:
            stdId = int(student_id)
        except ValueError:
            return jsonify({"message": "Invalid studentId format"}), 400

        result = passwordUpdate(stdId, new_password)

        if result == "success":
            return jsonify({"message": "Password updated successfully"}), 200
        elif result == "not_found":
            return jsonify({"message": "Student ID not found"}), 404
        else:
            return jsonify({"message": "Failed to update password"}), 500

    except Exception as e:
        return jsonify({"message": f"Server error: {str(e)}"}), 500

@admin.route('/api/updatePin', methods=['PUT'])
def updatePin():
    try:
        data = request.get_json()
        
        student_id = data.get('studentId')
        new_pin = data.get('newPin')

        if not student_id or not new_pin:
            return jsonify({"message": "Missing studentId or newPin"}), 400

        try:
            stdId = int(student_id)
        except ValueError:
            return jsonify({"message": "Invalid studentId format"}), 400

        result = pinUpdate(stdId, new_pin)

        if result == "success":
            return jsonify({"message": "Pin updated successfully"}), 200
        elif result == "not_found":
            return jsonify({"message": "Student ID not found"}), 404
        else:
            return jsonify({"message": "Failed to update pin"}), 500

    except Exception as e:
        return jsonify({"message": f"Server error: {str(e)}"}), 500