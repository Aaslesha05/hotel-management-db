from flask import Flask, render_template, request, redirect, url_for
import mysql.connector
from datetime import datetime

app = Flask(__name__)

# MySQL database connection
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root123",
    database="Hotel_management"
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
    guest_name = request.args.get('guest_name', '').lower()
    room_type = request.args.get('room_type', '').lower()

    base_query = """
        SELECT g.Guest_ID, g.Guest_Name, g.Phone, g.Email, g.Address, g.Aadhar_No, g.Registration_Date,
               r.Room_Number, rt.Type_Name
        FROM Guest g
        LEFT JOIN Booking b ON g.Guest_ID = b.Guest_ID
        LEFT JOIN Room r ON b.Room_ID = r.Room_ID
        LEFT JOIN RoomType rt ON r.Type_ID = rt.Type_ID
    """

    filters = []
    params = []

    if guest_name:
        filters.append("LOWER(g.Guest_Name) LIKE %s")
        params.append(f"%{guest_name}%")
    if room_type:
        filters.append("LOWER(rt.Type_Name) LIKE %s")
        params.append(f"%{room_type}%")

    if filters:
        base_query += " WHERE " + " AND ".join(filters)

    cursor.execute(base_query, params)
    guests = cursor.fetchall()
    column_names = ["Guest_ID", "Guest_Name", "Phone", "Email", "Address", "Aadhar_No", "Registration_Date", "Room_Number", "Room_Type"]

    return render_template('dashboard.html', guests=guests, columns=column_names)

@app.route('/add-guest', methods=['GET', 'POST'])
def add_guest():
    if request.method == 'POST':
        guest_name = request.form['guest_name']
        phone = request.form['phone']
        email = request.form['email']
        address = request.form['address']
        aadhar_no = request.form['aadhar_no']
        registration_date = request.form['registration_date']

        # Query to insert guest without ID (auto increment)
        query = """INSERT INTO Guest 
            (Guest_Name, Phone, Email, Address, Aadhar_No, Registration_Date) 
            VALUES (%s, %s, %s, %s, %s, %s)"""
        
        cursor.execute(query, (guest_name, phone, email, address, aadhar_no, registration_date))
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

        query = """UPDATE Guest SET 
            Guest_Name=%s, Phone=%s, Email=%s, Address=%s, Aadhar_No=%s, Registration_Date=%s 
            WHERE Guest_ID=%s"""
        cursor.execute(query, (guest_name, phone, email, address, aadhar_no, registration_date, id))
        db.commit()

        return redirect(url_for('dashboard'))

    query = "SELECT * FROM Guest WHERE Guest_ID = %s"
    cursor.execute(query, (id,))
    guest = cursor.fetchone()

    return render_template('edit_guest.html', guest=guest)

@app.route('/delete-guest/<int:guest_id>', methods=['POST'])
def delete_guest(guest_id):
    query = "DELETE FROM Guest WHERE Guest_ID = %s"
    cursor.execute(query, (guest_id,))
    db.commit()
    return redirect('/dashboard')

if __name__ == '__main__':
    app.run(debug=True)
