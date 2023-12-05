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

        return render_template('success.html')  # This line should redirect to the success page

    except Exception as e:
        return f"Error: {str(e)}"

@app.route('/login')
def login_page():
    return render_template('login.html')

@app.route('/login_user', methods=['POST'])
def login_user():
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
            return redirect(url_for('user_dashboard', username=username))
        else:
            # Incorrect username or password, redirect back to login page
            return redirect(url_for('login_page'))

    except Exception as e:
        return f"Error: {str(e)}"

@app.route('/user/<username>/dashboard')
def user_dashboard(username):
    return f"Welcome, {username}! This is your dashboard."

if __name__ == '__main__':
    app.run(debug=True)