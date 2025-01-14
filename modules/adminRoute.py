from flask import Blueprint, render_template, redirect, url_for, session
from modules.loginOperation import get_admin_details  

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