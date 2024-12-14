from flask import Flask, render_template, request, jsonify
from modules.adminDetails import *
from modules.reconfigDetail import *

hostname = socket.gethostname()
ip_address = socket.gethostbyname(hostname)

adminApp = Flask(__name__)

Allowed_IPs = [ip_address]

@adminApp.route('/')
def home():
    client_ip = request.remote_addr
    if client_ip in Allowed_IPs:
        return render_template('adminPage.html')
    else:
        return render_template('error.html',error_message = "You don't have permission to access this page."), 403

@adminApp.route('/', methods=['POST'])
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
                "message": f"Registration successful for \n {admin_name}"
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
    finally:
        connection.close()

@adminApp.route('/registrationConfig')
def regconfig():
    ciphertext = request.args.get('email')
    cursor = None
    connection = None  # Initialize connection to None to avoid UnboundLocalError

    if not ciphertext:
        return render_template("error.html", error_message="Ciphertext missing in email parameter."), 400

    try:
        try:
            decoded_email = decode(ciphertext)
        except Exception as e:
            return render_template("error.html", error_message=f"Failed to decode ciphertext: {e}"), 400

        if not decoded_email.endswith("@gmail.com"):
            return render_template("error.html", error_message="Invalid email domain. Only Gmail addresses are allowed."), 400

        # Attempt to connect to the database
        connection = connect_to_database()
        if not connection:
            return render_template("error.html", error_message="Failed to connect to the database."), 500

        # Create a cursor
        cursor = connection.cursor()

        # Check if the Gmail exists in the database
        check_email_query = "SELECT Gmail FROM adminLogin WHERE Gmail = %s"
        cursor.execute(check_email_query, (decoded_email,))
        email_exists = cursor.fetchone()

        if not email_exists:
            return render_template("error.html", error_message="Email does not exist in the database."), 404

        # Check if a photo exists for the decoded email
        query = "SELECT photo FROM adminLogin WHERE Gmail = %s"
        cursor.execute(query, (decoded_email,))
        result = cursor.fetchone()

        if result and result[0]:
            return render_template("error.html",error_message="Already registered."),200
        else:
            return render_template('page.html')

    except Exception as e:
        return render_template("error.html", error_message=f"An error occurred: {str(e)}"), 500

    finally:
        if cursor:  # Check if cursor was initialized
            cursor.close()
        if connection:  # Check if connection was initialized
            connection.close()

@adminApp.route('/registrationConfig', methods=['POST'])
def updateData():
    # Get the ciphertext from the query parameter
    ciphertexts = request.args.get('email')
    if not ciphertexts:
        print("Missing email parameter in request.")
        return jsonify({"success": False, "error": "Ciphertext missing in email parameter."})

    try:
        # Decode the ciphertext (replace this with your actual decoding method)
        decoded_email = decode(ciphertexts)
    except Exception as e:
        print(f"Decoding error: {e}")
        return jsonify({"success": False, "error": "Failed to decode email parameter."})

    connection = connect_to_database()
    if not connection:
        print("Failed to connect to the database.")
        return jsonify({"success": False, "error": "Failed to connect to the database."})

    try:
        # Get form data
        password = request.form.get('confirmPassword')
        photoId = request.files['photo'].read()

        # Hash the password
        hashed_password = hash_password(password)
        if not hashed_password:
            print("Failed to hash the password.")
            return jsonify({"success": False, "error": "Password hashing failed."})

        # Update the database with the new data
        registrationConfig = updatingDatabase(connection, decoded_email, hashed_password, photoId)
        if registrationConfig['status'] == "error":
            print("Could not upload.")
            return jsonify({"success": False, "error": "Could not upload."})
        else:
            return jsonify({"success": True, "message": "Upload successful."})

    except KeyError as e:
        print(f"Missing form field or file: {e}")
        return jsonify({"success": False, "error": f"Missing field: {str(e)}"})

    except Exception as e:
        print(f"Unexpected error: {e}")
        return jsonify({"success": False, "error": "An unexpected error occurred. Please try again."})

    finally:
        connection.close()

@adminApp.errorhandler(404)
def page_not_found(e):
    return render_template("error.html", error_message="Page not found"), 404

@adminApp.errorhandler(500)
def internal_server_error(e):
    return render_template("error.html", error_message="Internal server error"), 500

if __name__ == '__main__':
    adminApp.run(host=ip_address, port=6900, debug=False)