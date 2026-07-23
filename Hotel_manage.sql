-- Drop database if it already exists and create a new one
DROP DATABASE IF EXISTS Hotel_management;
CREATE DATABASE Hotel_management;
USE Hotel_management;

SELECT * FROM RoomType;
SELECT * FROM Room;
SELECT * FROM Guest;
SELECT * FROM Booking;
SELECT * FROM Payment;
SELECT * FROM Service;
SELECT * FROM Guest_Service;
SELECT * FROM Staff;
Select * from Room_staff;

SET SQL_SAFE_UPDATES = 0;


CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
);
INSERT INTO users (username, password) VALUES ('testuser', 'testpassword');
INSERT INTO users (username, password) VALUES ('Aishwarya', 'password1');
INSERT INTO users (username, password) VALUES ('Vibha', 'password2');
INSERT INTO users (username, password) VALUES ('Vismitha', 'password3');
INSERT INTO users (username, password) VALUES ('Aaslesha', 'password4');
select * from users;


-- RoomType Table
CREATE TABLE RoomType (
    Type_ID INT AUTO_INCREMENT PRIMARY KEY,
    Type_Name VARCHAR(50) NOT NULL,
    Description TEXT,
    Price_Per_Night DECIMAL(10, 2) NOT NULL
);

-- Room Table
CREATE TABLE Room (
    Room_ID INT AUTO_INCREMENT PRIMARY KEY,
    Room_Number VARCHAR(10) NOT NULL UNIQUE,
    Type_ID INT,
    Status ENUM('Available', 'Booked', 'Maintenance') DEFAULT 'Available',
    FOREIGN KEY (Type_ID) REFERENCES RoomType(Type_ID)
);

-- Guest Table
CREATE TABLE Guest (
    Guest_ID INT AUTO_INCREMENT PRIMARY KEY,
    Guest_Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Address TEXT,
    Aadhar_No VARCHAR(12) UNIQUE,
    Registration_Date DATE DEFAULT (CURRENT_DATE));

-- Booking Table
CREATE TABLE Booking (
    Booking_ID INT AUTO_INCREMENT PRIMARY KEY,
    Guest_ID INT,
    Room_ID INT,
    Check_In_Date DATE,
    Check_Out_Date DATE,
    FOREIGN KEY (Guest_ID) REFERENCES Guest(Guest_ID),
    FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID)
);

-- Payment Table
CREATE TABLE Payment (
    Payment_ID INT AUTO_INCREMENT PRIMARY KEY,
    Booking_ID INT,
    Amount DECIMAL(10, 2),
    Payment_Method ENUM('Cash', 'Card', 'Online'),
    Payment_Date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (Booking_ID) REFERENCES Booking(Booking_ID)
);

-- Service Table
CREATE TABLE Service (
    Service_ID INT AUTO_INCREMENT PRIMARY KEY,
    Service_Name VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL
);

-- staff table 
CREATE TABLE Staff (
    Staff_ID INT AUTO_INCREMENT PRIMARY KEY,
    Staff_Name VARCHAR(100) NOT NULL,
    Role ENUM('Receptionist', 'Housekeeping', 'Manager', 'Maintenance', 'Security') NOT NULL,
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Hire_Date DATE DEFAULT (CURRENT_DATE)
);

-- roo staff table 
CREATE TABLE Room_Staff (
    Room_ID INT,
    Staff_ID INT,
    FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID),
    FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID),
    PRIMARY KEY (Room_ID, Staff_ID)
);

-- Guest_Service Table
CREATE TABLE Guest_Service (
    Guest_ID INT,
    Service_ID INT,
    FOREIGN KEY (Guest_ID) REFERENCES Guest(Guest_ID),
    FOREIGN KEY (Service_ID) REFERENCES Service(Service_ID),
    PRIMARY KEY (Guest_ID, Service_ID)
);

show processlist;

-- Trigger 1: Check if room is booked before allowing service to be added
DELIMITER $$
CREATE TRIGGER before_add_guest_service
BEFORE INSERT ON Guest_Service
FOR EACH ROW
BEGIN
    DECLARE booking_exists INT;
    SELECT COUNT(*) INTO booking_exists
    FROM Booking
    WHERE Guest_ID = NEW.Guest_ID;

    IF booking_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Guest must have a booking to avail services';
    END IF;
END $$
DELIMITER ;

-- Trigger 2: Check if payment amount is correct
DELIMITER $$
CREATE TRIGGER validate_payment_amount
BEFORE INSERT ON Payment
FOR EACH ROW
BEGIN
    DECLARE room_price DECIMAL(10, 2);
    DECLARE checkin DATE;
    DECLARE checkout DATE;

    SELECT rt.Price_Per_Night, b.Check_In_Date, b.Check_Out_Date
    INTO room_price, checkin, checkout
    FROM Booking b
    JOIN Room r ON b.Room_ID = r.Room_ID
    JOIN RoomType rt ON r.Type_ID = rt.Type_ID
    WHERE b.Booking_ID = NEW.Booking_ID;

    IF DATEDIFF(checkout, checkin) * room_price != NEW.Amount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Incorrect payment amount for the stay duration';
    END IF;
END $$
DELIMITER ;

-- Insert Guests
INSERT INTO Guest (Guest_Name, Phone, Email, Address, Aadhar_No, Registration_Date) VALUES
('Aarav Mehta', '9876543210', 'aarav@gmail.com', 'Mumbai, India', '123456789012', '2025-04-01'),
('Riya Sen', '8765432109', 'riya@gmail.com', 'Kolkata, India', '234567890123', '2025-04-02'),
('Siddharth Verma', '7654321098', 'sid@gmail.com', 'Delhi, India', '345678901234', '2025-04-03'),
('Tanvi Joshi', '9154326780', 'tanvi.joshi@gmail.com', 'Delhi, India', '112233445566', '2025-04-11'),
('Vikram Patel', '9223456781', 'vikram.patel@gmail.com', 'Bangalore, India', '223344556677', '2025-04-12'),
('Harshita Reddy', '9304567892', 'harshita.reddy@gmail.com', 'Chennai, India', '334455667788', '2025-04-13'),
('Arjun Singh', '9375678903', 'arjun.singh@gmail.com', 'Pune, India', '445566778899', '2025-04-14'),
('Meera Deshmukh', '9446789014', 'meera.deshmukh@gmail.com', 'Mumbai, India', '556677889900', '2025-04-15'),
('Nikita Sharma', '9123456780', 'nikita.sharma@gmail.com', 'Jaipur, India', '456789012345', '2025-04-04'),
('Samantha Roy', '8234567890', 'samantha.roy@gmail.com', 'Bangalore, India', '567890123456', '2025-04-05'),
('Ankit Yadav', '7345678901', 'ankit.yadav@gmail.com', 'Chennai, India', '678901234567', '2025-04-06'),
('Priya Gupta', '8567890123', 'priya.gupta@gmail.com', 'Hyderabad, India', '789012345678', '2025-04-07'),
('Karan Shah', '9654321090', 'karan.shah@gmail.com', 'Pune, India', '890123456789', '2025-04-08'),
('Leela Patel', '9745632109', 'leela.patel@gmail.com', 'Ahmedabad, India', '901234567890', '2025-04-09'),
('Manoj Kumar', '9834567890', 'manoj.kumar@egmail.com', 'Lucknow, India', '102345678901', '2025-04-10');

-- insert room type
INSERT INTO RoomType (Type_Name, Description, Price_Per_Night) VALUES
('Single', 'Single occupancy with a twin-size bed', 1500.00),
('Double', 'Double occupancy with a queen-size bed', 2500.00),
('Deluxe', 'Spacious room with a king-size bed and amenities', 4000.00),
('Suite', 'Luxury suite with living space and premium services', 7000.00);

-- insert room
INSERT INTO Room (Room_Number, Type_ID, Status) VALUES
('101', 1, 'Booked'),
('102', 1, 'Booked'),
('201', 2, 'Booked'),
('202', 2, 'Booked'),
('301', 3, 'Booked'),
('302', 3, 'Booked'),
('401', 4, 'Booked'),
('402', 4, 'Available'),
('103', 1, 'Available'),
('203', 2, 'Available'),
('303', 3, 'Available'),
('403', 4, 'Maintenance'),
('104', 1, 'Available'),
('204', 2, 'Available'),
('304', 3, 'Available');

-- insert booking 
INSERT INTO Booking (Guest_ID, Room_ID, Check_In_Date, Check_Out_Date) VALUES
(1, 1, '2025-04-01', '2025-04-03'),
(2, 2, '2025-04-02', '2025-04-04'),
(3, 3, '2025-04-03', '2025-04-06'),
(4, 4, '2025-04-04', '2025-04-07'),
(5, 5, '2025-04-05', '2025-04-08'),
(6, 6, '2025-04-06', '2025-04-09'),
(7, 7, '2025-04-07', '2025-04-10'),
(8, 1, '2025-04-08', '2025-04-10'),
(9, 2, '2025-04-09', '2025-04-11'),
(10, 3, '2025-04-10', '2025-04-12'),
(11, 4, '2025-04-11', '2025-04-13'),
(12, 5, '2025-04-12', '2025-04-14'),
(13, 6, '2025-04-13', '2025-04-15'),
(14, 7, '2025-04-14', '2025-04-16'),
(15, 5, '2025-04-15', '2025-04-17');


-- insert payments
INSERT INTO Payment (Booking_ID, Amount, Payment_Method, Payment_Date) VALUES
(1, 3000.00, 'Card', '2025-04-01'),
(2, 3000.00, 'Online', '2025-04-02'),
(3, 7500.00, 'Card', '2025-04-03'),
(4, 7500.00, 'Cash', '2025-04-04'),
(5, 12000.00, 'Online', '2025-04-05'),
(6, 12000.00, 'Card', '2025-04-06'),
(7, 21000.00, 'Cash', '2025-04-07'),
(8, 3000.00, 'Card', '2025-04-08'),
(9, 3000.00, 'Cash', '2025-04-09'),
(10, 5000.00, 'Online', '2025-04-10'),
(11, 5000.00, 'Card', '2025-04-11'),
(12, 8000.00, 'Online', '2025-04-12'),
(13, 8000.00, 'Cash', '2025-04-13'),
(14, 14000.00, 'Card', '2025-04-14'),
(15, 8000.00, 'Card', '2025-04-15');

-- insert service 
INSERT INTO Service (Service_Name, Description, Price) VALUES
('Room Service', 'In-room food and drink delivery', 500.00),
('Laundry', 'Clothes washing and ironing', 300.00),
('Spa', 'Relaxing spa treatments and massage', 1500.00),
('Airport Pickup', 'Pick-up from the airport', 1000.00),
('Gym Access', 'Unlimited access to gym facilities', 200.00);

-- insert guest service
INSERT INTO Guest_Service (Guest_ID, Service_ID) VALUES
(1, 1),
(2, 2),
(3, 1),
(3, 3),
(4, 4),
(5, 1),
(6, 5),
(7, 3),
(8, 2),
(9, 1),
(10, 4),
(11, 1),
(11, 2),
(12, 5),
(13, 3),
(14, 2),
(15, 4);

-- insert staff
INSERT INTO Staff (Staff_ID, Staff_Name, Role, Phone, Email, Hire_Date) VALUES
(1, 'Asha Sharma', 'Housekeeping', '9454824795', 'asha.sharma@hotel.com', '2021-03-05'),
(2, 'Ravi Kumar', 'Maintenance', '9151084441', 'ravi.kumar@hotel.com', '2022-01-30'),
(3, 'Neha Mehta', 'Receptionist', '9351002149', 'neha.mehta@hotel.com', '2021-08-18'),
(4, 'Suresh Rathi', 'Security', '9768375058', 'suresh.rathi@hotel.com', '2022-07-25'),
(5, 'Kavita Singh', 'Manager', '9246982863', 'kavita.singh@hotel.com', '2022-03-01');

-- insert room staff
INSERT INTO Room_Staff (Room_ID, Staff_ID) VALUES
(1, 1), (1, 2),
(2, 1), (2, 4),
(3, 1), (3, 4),
(4, 1), (4, 4),
(5, 1), (5, 4),
(6, 1), (6, 5),
(7, 1), (7, 5),
(8, 1), (8, 5),
(9, 1), (9, 2),
(10, 1), (10, 5),
(11, 1), (11, 2),
(12, 1), (12, 2),
(13, 1), (13, 5),
(14, 1), (14, 2),
(15, 1), (15, 2);


ALTER USER 'root'@'localhost' IDENTIFIED BY 'root123';
FLUSH PRIVILEGES;


-- Additional Data for Testing
INSERT INTO Guest (Guest_Name, Phone, Email, Address, Aadhar_No) VALUES
('Nikita Sharma', '9123456780', 'nikita@example.com', 'Jaipur, India', '456789012345');

-- INSERT INTO Guest_Service (Guest_ID, Service_ID) VALUES (4, 1); -- Will throw error (no booking)
-- INSERT INTO Payment (Booking_ID, Amount, Payment_Method) VALUES (1, 2000.00, 'Cash'); -- Will throw error (incorrect amount)

-- Update room status after booking
UPDATE Room SET Status = 'Booked' WHERE Room_ID IN (1, 3, 5);
