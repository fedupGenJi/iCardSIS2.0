from flask import Blueprint, render_template, redirect, url_for, session, request, jsonify
from modules.loginOperation import get_admin_details
from modules.libraryOperation import *

library = Blueprint('library', __name__)

@library.route('/library/homepage')
def lib_homepage():
    if not session.get('logged_in'):  
        return redirect(url_for('home')) 
    
    id = session.get('email')
    admin_details = get_admin_details(id)
    return render_template('library/homepagexx.html', **admin_details)

@library.route('/library/bookshelf')
def bookShelf():
    if not session.get('logged_in'):  
        return redirect(url_for('home')) 
    
    id = session.get('email')
    admin_details = get_admin_details(id)
    return render_template('library/bookShelf.html', **admin_details)

@library.route('/library/lendReturn')
def lendReturn():
    if not session.get('logged_in'):  
        return redirect(url_for('home')) 
    
    id = session.get('email')
    admin_details = get_admin_details(id)
    return render_template('library/lendReturn.html', **admin_details)

@library.route('/library/updateBookshelf')
def updateBS():
    if not session.get('logged_in'):  
        return redirect(url_for('home')) 
    
    id = session.get('email')
    admin_details = get_admin_details(id)
    return render_template('library/updateBookshelf.html', **admin_details)

@library.route('/library/errorReport')
def errorReport():
    if not session.get('logged_in'):  
        return redirect(url_for('home')) 
    
    id = session.get('email')
    admin_details = get_admin_details(id)
    return render_template('library/errorReport.html', **admin_details)

@library.route('/library/updateBookshelf/add', methods=['POST'])
def addingBooks():
    data = request.json

    if data:
        success, message = booksForDB(data)
        return jsonify({"success": success, "message": message}), (200 if success else 400)
    else:
        return jsonify({"error": "Invalid data"}), 400
    
@library.route('/library/updateBookshelf/delete', methods=['POST'])
def removingBooks():
    data = request.json

    if data:
        success, message = removeBook(data)
        return jsonify({"success": success, "message": message}), (200 if success else 400)
    else:
        return jsonify({"error": "Invalid data"}), 400