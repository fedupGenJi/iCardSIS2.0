from flask import Blueprint, render_template, redirect, url_for, session, request, jsonify
from modules.loginOperation import get_admin_details

library = Blueprint('library', __name__)

@library.route('/library/homepage')
def lib_homepage():
    if not session.get('logged_in'):  
        return redirect(url_for('home')) 
    
    id = session.get('email')
    admin_details = get_admin_details(id)
    return render_template('library/homepagexx.html', **admin_details)