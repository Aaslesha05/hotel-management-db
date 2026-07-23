# 🏨 Hotel Management System

A **Hotel Management System** built using **MySQL** to efficiently manage hotel operations such as guest registration, room allocation, bookings, payments, staff management, and additional services. This project demonstrates database design concepts including normalization, relationships, constraints, stored procedures, triggers, and SQL queries.

---

## 📌 Features

- 👤 Guest Management
- 🛏️ Room and Room Type Management
- 📅 Room Booking System
- 💳 Payment Management
- 👨‍💼 Staff Management
- 🛎️ Additional Hotel Services
- 📊 SQL Queries for Reports
- ⚡ Database Triggers and Stored Procedures

---

## 🛠️ Technologies Used

- MySQL
- SQL
- MySQL Workbench

---

## 📂 Database Structure

The database consists of the following tables:

- **Guest**
  - Stores guest information.
- **RoomType**
  - Contains room categories and pricing.
- **Room**
  - Stores room details and availability.
- **Booking**
  - Manages room reservations.
- **Payment**
  - Records payment transactions.
- **Staff**
  - Stores employee information.
- **Service**
  - Lists hotel services offered.
- **GuestService**
  - Maps guests to the services they use.

---

## 🗂️ Entity Relationship

The database is designed using a normalized relational schema with:

- One-to-Many relationships
- Many-to-Many relationships (using junction tables)
- Primary Keys
- Foreign Keys
- Referential Integrity Constraints

---

## 🚀 How to Run

1. Clone this repository.

```bash
git clone https://github.com/your-username/hotel-management-system.git
```

2. Open **MySQL Workbench**.

3. Create a new database.

```sql
CREATE DATABASE hotel_management;
USE hotel_management;
```

4. Import or execute the SQL script.

5. Run the queries to insert sample data.

6. Execute the provided SQL queries, triggers, procedures, and reports.

---

## 📊 Sample Operations

- Add a new guest
- Add rooms
- Book a room
- Cancel booking
- Record payment
- Assign hotel services
- View room availability
- Generate booking reports
- View guest history

---

## 🔥 SQL Concepts Implemented

- DDL Commands
- DML Commands
- Joins
- Aggregate Functions
- GROUP BY
- HAVING
- ORDER BY
- Views
- Stored Procedures
- Triggers
- Indexes
- Constraints
- Transactions

---

## 📁 Project Structure

```
Hotel-Management-System/
│
├── Hotel_Management.sql
├── README.md
```

---

## 🎯 Learning Objectives

This project demonstrates:

- Relational Database Design
- Database Normalization
- SQL Programming
- Data Integrity
- Constraint Handling
- Trigger Implementation
- Stored Procedures
- Real-world Database Modeling

---

## 📄 License

This project is created for educational and academic purposes.

---

## 👩‍💻 Author

**Aaslesha**

B.Tech Computer Science Engineering

Dayananda Sagar University

---
⭐ If you found this project useful, consider giving it a star!
