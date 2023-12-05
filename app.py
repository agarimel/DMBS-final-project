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


def check_follow_status(follower_username, follower_email_id, followed_username, followed_email_id):
    # Check if there is a record in the 'follow' table indicating that
    # the follower is following the user with the given username and email
    with conn.cursor() as cursor:
        cursor.execute("""
            SELECT * FROM follow
            WHERE follower_username = %s AND follower_email_id = %s
                AND followed_username = %s AND followed_email_id = %s
        """, (follower_username, follower_email_id, followed_username, followed_email_id))
        return cursor.fetchone() is not None

def update_follow_status(follower_username, follower_email_id, followed_username, followed_email_id):
    # Check if the follow relationship already exists
    if not check_follow_status(follower_username, follower_email_id, followed_username, followed_email_id):
        # If not, insert a new record into the 'follow' table
        with conn.cursor() as cursor:
            try:
                cursor.execute("""
                    INSERT INTO follow (follower_username, follower_Email_ID, followed_username, followed_Email_ID)
                    VALUES (%s, %s, %s, %s)
                """, (follower_username, follower_email_id, followed_username, followed_email_id))
                conn.commit()
            except Exception as e:
                print(f"Error inserting into follow table: {e}")
                conn.rollback()



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
    # Fetch users and their follow status from the database
    with conn.cursor() as cursor:
        cursor.execute("SELECT username, Email_ID FROM \"User\"")
        users = cursor.fetchall()

    # Example: Fetch the follow status for a particular user (replace with your logic)
    follow_status = {}
    for user in users:
        follow_status[user] = check_follow_status(user[0], user[1], "current_user_username", "current_user_email")

    return render_template('dashboard.html', username=username, users=users, follow_status=follow_status)

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


@app.route('/follow', methods=['POST'])
def follow():
    try:
        # Get the form data
        follower_username = request.form['follower_username']
        followed_username = request.form['followed_username']

        # Retrieve email from the User table based on the username
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT Email_ID FROM "User"
                WHERE username = %s
            """, (follower_username,))
            follower_email = cursor.fetchone()[0]

            cursor.execute("""
                SELECT Email_ID FROM "User"
                WHERE username = %s
            """, (followed_username,))
            followed_email = cursor.fetchone()[0]

        # Add logic to update the follow status in the database (replace with your logic)
        update_follow_status(follower_username, follower_email, followed_username, followed_email)

        return redirect(url_for('dashboard_page', username=follower_username))

    except Exception as e:
        return f"Error: {str(e)}"



if __name__ == '__main__':
    app.run(debug=True)