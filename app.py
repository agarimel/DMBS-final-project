from flask import Flask, render_template, request, redirect, url_for
import psycopg2
from psycopg2 import sql

app = Flask(__name__)

# Replace these with your PostgreSQL database credentials
DB_HOST = 'localhost'
DB_PORT = '5433'
DB_NAME = 'thread_dbms'
DB_USER = 'sairo'
DB_PASSWORD = 'postgres'

# Connection to the PostgreSQL database
conn = psycopg2.connect(
    host=DB_HOST,
    port=DB_PORT,
    database=DB_NAME,
    user=DB_USER,
    password=DB_PASSWORD
)

@app.route('/')
def registration_page():
    return render_template('registration.html')

@app.route('/register', methods=['POST'])
def register_user():
    try:
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']

        # Insert user data into the "User" table
        with conn.cursor() as cursor:
            insert_user_query = sql.SQL("""
                INSERT INTO "User" (username, Email_ID, Password)
                VALUES (%s, %s, %s)
            """)
            cursor.execute(insert_user_query, (username, email, password))
            conn.commit()

        # Redirect the user to the account_info page after successful registration
        return redirect(url_for('account_info_page', username=username, email=email))

    except Exception as e:
        return f"Error: {str(e)}"

@app.route('/account_info/<username>/<email>', methods=['GET', 'POST'])
def account_info_page(username, email):
    if request.method == 'POST':
        try:
            bio = request.form['bio']
            full_name = request.form['full_name']
            date_of_birth = request.form['date_of_birth']
            gender = request.form['gender']

            with conn.cursor() as cursor:
                # Update additional information in the "User" table
                update_user_query = sql.SQL("""
                    UPDATE "User"
                    SET Bio = %s, Full_name = %s, Date_of_birth = %s, Gender = %s
                    WHERE username = %s AND Email_ID = %s
                """)
                cursor.execute(update_user_query, (bio, full_name, date_of_birth, gender, username, email))
                conn.commit()

            # Redirect the user to the success page after completing the account information
            return redirect(url_for('success_page'))

        except Exception as e:
            return f"Error: {str(e)}"
    else:
        return render_template('account_info.html', username=username, email=email)

@app.route('/login', methods=['GET', 'POST'])
def login_page():
    if request.method == 'POST':
        try:
            username = request.form['username']
            password = request.form['password']

            # Check if the username and password match in the "User" table
            with conn.cursor() as cursor:
                select_user_query = sql.SQL("""
                    SELECT * FROM "User"
                    WHERE username = %s AND Password = %s
                """)
                cursor.execute(select_user_query, (username, password))
                user = cursor.fetchone()

            if user:
                # Successful login, redirect to user dashboard
                return redirect(url_for('dashboard_page', username=username))
            else:
                # Incorrect username or password, redirect back to login page
                return redirect(url_for('login_page'))

        except Exception as e:
            return f"Error: {str(e)}"
    else:
        return render_template('login.html')
    
@app.route('/dashboard/<username>')
def dashboard_page(username):
    return render_template('dashboard.html', username=username)

@app.route('/user/<username>/dashboard')
def user_dashboard(username):
    # Render the user dashboard template
    return render_template('dashboard.html', username=username)

@app.route('/success')
def success_page():
    return render_template('success.html')

@app.route('/logout')
def logout():
    # Add any logout logic here if needed
    return redirect(url_for('login_page'))

if __name__ == '__main__':
    app.run(debug=True)
