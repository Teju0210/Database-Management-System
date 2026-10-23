-- Hotel Management System: MySQL 8
-- Run schema first, then sample data.


CREATE DATABASE hotel_management;
USE hotel_management;

CREATE TABLE Guests (
  guest_id INT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE,
  phone VARCHAR(15) NOT NULL,
  address VARCHAR(150),
  id_proof_type VARCHAR(30),
  id_proof_number VARCHAR(30) UNIQUE
);

CREATE TABLE RoomTypes (
  room_type_id INT PRIMARY KEY,
  type_name VARCHAR(30) NOT NULL UNIQUE,
  base_price DECIMAL(10,2) NOT NULL CHECK (base_price >= 0),
  max_occupancy INT NOT NULL CHECK (max_occupancy > 0),
  description VARCHAR(200)
);

CREATE TABLE Rooms (
  room_id INT PRIMARY KEY,
  room_number VARCHAR(10) NOT NULL UNIQUE,
  floor_number INT NOT NULL CHECK (floor_number >= 0),
  room_type_id INT NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'Available'
    CHECK (status IN ('Available','Occupied','Under Maintenance')),
  FOREIGN KEY (room_type_id) REFERENCES RoomTypes(room_type_id)
);

CREATE TABLE Staff (
  staff_id INT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  designation VARCHAR(40) NOT NULL,
  phone VARCHAR(15) NOT NULL,
  shift VARCHAR(20) NOT NULL DEFAULT 'Morning'
    CHECK (shift IN ('Morning','Evening','Night'))
);

CREATE TABLE Reservations (
  reservation_id INT PRIMARY KEY,
  guest_id INT NOT NULL,
  room_id INT NOT NULL,
  staff_id INT NOT NULL,
  check_in_date DATE NOT NULL,
  check_out_date DATE NOT NULL,
  num_guests INT NOT NULL CHECK (num_guests > 0),
  booking_status VARCHAR(20) NOT NULL DEFAULT 'Confirmed'
    CHECK (booking_status IN ('Confirmed','Checked-In','Checked-Out','Cancelled')),
  booked_room_rate DECIMAL(10,2) NOT NULL CHECK (booked_room_rate >= 0),
  CHECK (check_out_date > check_in_date),
  FOREIGN KEY (guest_id) REFERENCES Guests(guest_id),
  FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
  FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

CREATE TABLE Payments (
  payment_id INT PRIMARY KEY,
  reservation_id INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
  payment_date DATE NOT NULL,
  payment_mode VARCHAR(20) NOT NULL
    CHECK (payment_mode IN ('Cash','Card','UPI','Net Banking')),
  payment_status VARCHAR(20) NOT NULL DEFAULT 'Pending'
    CHECK (payment_status IN ('Paid','Pending','Refunded')),
  FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id)
);

CREATE TABLE Services (
  service_id INT PRIMARY KEY,
  service_name VARCHAR(50) NOT NULL UNIQUE,
  price DECIMAL(10,2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE ServiceOrders (
  service_order_id INT PRIMARY KEY,
  reservation_id INT NOT NULL,
  service_id INT NOT NULL,
  quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
  order_date DATE NOT NULL,
  FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id),
  FOREIGN KEY (service_id) REFERENCES Services(service_id)
);


-- SAMPLE DATA

INSERT INTO Guests VALUES
(1,'Asha','Rao','asha.rao@example.com','9876500001','Bengaluru','Aadhaar','ID1001'),
(2,'Rahul','Shah','rahul.shah@example.com','9876500002','Mysuru','Aadhaar','ID1002'),
(3,'Meera','Nair','meera.nair@example.com','9876500003','Chennai','Passport','P2003'),
(4,'Arjun','Das','arjun.das@example.com','9876500004','Hyderabad','Passport','P2004'),
(5,'Sara','Khan','sara.khan@example.com','9876500005','Pune','Aadhaar','ID1005');

INSERT INTO RoomTypes VALUES
(1,'Single',1800.00,1,'Compact room for one guest'),
(2,'Deluxe',3200.00,2,'Comfortable room with extra amenities'),
(3,'Suite',6500.00,4,'Large premium room');

INSERT INTO Rooms VALUES
(101,'101',1,1,'Available'),
(102,'102',1,2,'Occupied'),
(103,'201',2,2,'Available'),
(104,'202',2,3,'Occupied'),
(105,'301',3,1,'Under Maintenance');

INSERT INTO Staff VALUES
(1,'Nisha','Patel','Receptionist','9000000001','Morning'),
(2,'Kiran','Reddy','Manager','9000000002','Evening'),
(3,'Dev','Kumar','Receptionist','9000000003','Night');

INSERT INTO Reservations VALUES
(1001,1,102,1,'2026-10-10','2026-10-12',2,'Checked-Out',3200.00),
(1002,2,103,1,'2026-10-16','2026-10-18',2,'Checked-In',3200.00),
(1003,3,104,2,'2026-10-15','2026-10-18',3,'Checked-In',6500.00),
(1004,4,101,3,'2026-10-20','2026-10-21',1,'Confirmed',1800.00),
(1005,5,102,2,'2026-11-01','2026-11-03',2,'Confirmed',3200.00);

INSERT INTO Payments VALUES
(501,1001,6400.00,'2026-10-12','UPI','Paid'),
(502,1002,2000.00,'2026-10-16','Card','Paid'),
(503,1002,4400.00,'2026-10-16','UPI','Pending'),
(504,1003,13000.00,'2026-10-15','Card','Paid'),
(505,1004,1800.00,'2026-10-19','Cash','Pending');

INSERT INTO Services VALUES
(1,'Laundry',250.00),
(2,'Spa',1200.00),
(3,'Room Dining',500.00),
(4,'Airport Pickup',900.00);

INSERT INTO ServiceOrders VALUES
(701,1001,1,2,'2026-10-11'),
(702,1002,3,2,'2026-10-16'),
(703,1003,2,1,'2026-10-16'),
(704,1003,4,1,'2026-10-16'),
(705,1004,1,1,'2026-10-20');
