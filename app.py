# app.py
from flask import Flask, render_template, request, redirect, url_for
import mysql.connector
from datetime import datetime

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

    query = "SELECT * FROM users WHERE username = %s AND password = %s"
    cursor.execute(query, (username, password))
    result = cursor.fetchone()

    if result:
        return redirect(url_for('dashboard'))
    else:
        return render_template('login.html', error="Invalid username or password")

@app.route('/dashboard')
def dashboard():
    query = """
        SELECT g.Guest_ID, g.Guest_Name, g.Phone, g.Email, g.Address, g.Aadhar_No, g.Registration_Date,
               r.Room_Number, rt.Type_Name
        FROM Guest g
        LEFT JOIN Booking b ON g.Guest_ID = b.Guest_ID AND b.Booking_Status = 'Active'
        LEFT JOIN Room r ON b.Room_ID = r.Room_ID
        LEFT JOIN RoomType rt ON r.Room_Type_ID = rt.Room_Type_ID
    """
    cursor.execute(query)
    guests = cursor.fetchall()
    column_names = ["Guest_ID", "Guest_Name", "Phone", "Email", "Address", "Aadhar_No", "Registration_Date", "Room_Number", "Room_Type"]
    return render_template('dashboard.html', guests=guests, columns=column_names)

@app.route('/add-guest', methods=['GET', 'POST'])
def add_guest():
    if request.method == 'POST':
        guest_id = request.form['guest_id']
        guest_name = request.form['guest_name']
        phone = request.form['phone']
        email = request.form['email']
        address = request.form['address']
        aadhar_no = request.form['aadhar_no']
        registration_date = request.form['registration_date']

        query = """INSERT INTO guest 
            (Guest_ID, Guest_Name, Phone, Email, Address, Aadhar_No, Registration_Date) 
            VALUES (%s, %s, %s, %s, %s, %s, %s)"""
        cursor.execute(query, (guest_id, guest_name, phone, email, address, aadhar_no, registration_date))
        db.commit()

        return redirect(url_for('dashboard'))

    return render_template('add_guest.html')

@app.route('/edit-guest/<int:id>', methods=['GET', 'POST'])
def edit_guest(id):
    if request.method == 'POST':
        guest_name = request.form['guest_name']
        phone = request.form['phone']
        email = request.form['email']
        address = request.form['address']
        aadhar_no = request.form['aadhar_no']
        registration_date = request.form['registration_date']

        query = """UPDATE guest SET 
            Guest_Name=%s, Phone=%s, Email=%s, Address=%s, Aadhar_No=%s, Registration_Date=%s 
            WHERE Guest_ID=%s"""
        cursor.execute(query, (guest_name, phone, email, address, aadhar_no, registration_date, id))
        db.commit()

        return redirect(url_for('dashboard'))

    query = "SELECT * FROM guest WHERE Guest_ID = %s"
    cursor.execute(query, (id,))
    guest = cursor.fetchone()

    return render_template('edit_guest.html', guest=guest)

@app.route('/delete-guest/<int:guest_id>', methods=['POST'])
def delete_guest(guest_id):
    query = "DELETE FROM guest WHERE Guest_ID = %s"
    cursor.execute(query, (guest_id,))
    db.commit()
    return redirect('/dashboard')

if __name__ == '__main__':
    app.run(debug=True)
