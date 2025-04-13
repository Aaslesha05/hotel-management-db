from flask import Flask, render_template, request, redirect, url_for
import mysql.connector

app = Flask(__name__)

# MySQL database connection
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root123",
    database="hotel_management"
)

cursor = db.cursor()

@app.route('/')
def home():
    return render_template('login.html')

@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    password = request.form['password']

    # Check credentials
    query = "SELECT * FROM users WHERE username = %s AND password = %s"
    cursor.execute(query, (username, password))
    result = cursor.fetchone()

    if result:
        # If login is successful, redirect to dashboard
        return redirect(url_for('dashboard'))
    else:
        return render_template('login.html', error="Invalid username or password")

@app.route('/dashboard')
def dashboard():
    # Fetch all guests from the guest table
    query = "SELECT * FROM guest"
    cursor.execute(query)
    guests = cursor.fetchall()
    column_names = [desc[0] for desc in cursor.description]  # Get column headers
    return render_template('dashboard.html', guests=guests, columns=column_names)

@app.route('/add-guest', methods=['GET', 'POST'])
def add_guest():
    if request.method == 'POST':
        name = request.form['name']
        phone = request.form['phone']
        email = request.form['email']
        room_no = request.form['room_no']

        query = "INSERT INTO guest (name, phone, email, room_no) VALUES (%s, %s, %s, %s)"
        cursor.execute(query, (name, phone, email, room_no))
        db.commit()

        return redirect(url_for('dashboard'))
    return render_template('add_guest.html')

@app.route('/edit-guest/<int:id>', methods=['GET', 'POST'])
def edit_guest(id):
    if request.method == 'POST':
        name = request.form['name']
        phone = request.form['phone']
        email = request.form['email']
        room_no = request.form['room_no']

        # ✅ Use correct column name instead of `id`
        query = "UPDATE guest SET name=%s, phone=%s, email=%s, room_no=%s WHERE guest_id=%s"
        cursor.execute(query, (name, phone, email, room_no, id))
        db.commit()

        return redirect(url_for('dashboard'))
    
    # ✅ Use correct column name instead of `id`
    query = "SELECT * FROM guest WHERE guest_id = %s"
    cursor.execute(query, (id,))
    guest = cursor.fetchone()

    return render_template('edit_guest.html', guest=guest)

if __name__ == '__main__':
    app.run(debug=True)
