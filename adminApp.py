from flask import Flask, render_template, request, jsonify
from modules.adminDetails import *

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('adminPage.html')

@app.route('/', methods=['POST'])
def admin_register():
    try:
        # Get form data from AJAX request
        admin_name = request.form['admin-name']
        admin_gmail = request.form['admin-email']
        admin_status = request.form['admin-status']
        
        # Generate tempPassword and hash it
        plain_password = generate_password()
        hashed_password = hash_password(plain_password)
        if not hashed_password:
            print("Failed to hash the password.")
            return jsonify({"success": False, "error": "Password hashing failed."})

        # Database connection
        connection = connect_to_database()
        if not connection:
            print("Failed to connect to the database.")
            return jsonify({"success": False, "error": "Failed to connect to the database."})

        # Verify and assign admin
        admin_id = verify_and_assign_admin(connection, admin_name, admin_gmail, admin_status, hashed_password)
        if admin_id == "Admin already exists":
            return jsonify({"success": False, "error": "Admin already exists"})
        elif admin_id:
            try:
                # Attempt to send the email
                email_error = send_email(admin_gmail, admin_id, admin_status, plain_password)
                if email_error:
                    print(f"Email sending failed: {email_error}")
                    return jsonify({"success": False, "error": email_error})  # Return the email error message
            except Exception as email_exception:
                print(f"Error in send_email: {email_exception}")
                return jsonify({"success": False, "error": "Failed to send confirmation email."})
            
            # Return success message
            return jsonify({
                "success": True,
                "message": f"Registration successful for {admin_name}"
            })
        else:
            print("Admin registration failed.")
            return jsonify({"success": False, "error": "Admin registration failed."})

    except KeyError as key_error:
        # Handle missing form data keys
        print(f"KeyError: {key_error}")
        return jsonify({"success": False, "error": f"Missing key: {key_error}"})
    except Exception as e:
        # Catch any other unexpected error
        print(f"Unexpected error: {e}")
        return jsonify({"success": False, "error": "An unexpected error occurred. Please try again."})


if __name__ == '__main__':
    app.run(debug=True)