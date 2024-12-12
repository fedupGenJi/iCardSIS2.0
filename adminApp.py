from flask import Flask, render_template, request, jsonify
from modules.adminDetails import *
from modules.reconfigDetail import *

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('adminPage.html')

@app.route('/registrationConfig')
def regconfig():
    ciphertext = request.args.get('email')

    if not ciphertext:
        return jsonify({"error": "Ciphertext missing in email parameter."}), 400

    try:
        # Decode the ciphertext (assuming base64 encoding for simplicity)
        decoded_email = decode(ciphertext)
        if not decoded_email.endswith("@gmail.com"):
            return jsonify({"error": "Invalid email domain. Only Gmail addresses are allowed."}), 400

        connection = connect_to_database()
        if not connection:
            print("Failed to connect to the database.")
            return jsonify({"success": False, "error": "Failed to connect to the database."})
        cursor = connection.cursor(dictionary=True)

        # Check if a photo exists for the decoded email
        query = "SELECT photo FROM adminLogin WHERE Gmail = %s"
        cursor.execute(query, (decoded_email,))
        result = cursor.fetchone()

        if result and result.get('photo'):
            return jsonify({"message": "Already registered."}), 200
        else:
            return render_template('page.html')
    except Exception as e:
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500

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
    app.run(host='0.0.0.0', port=6900)