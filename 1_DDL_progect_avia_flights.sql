-- База данных по полетам типовой авиокомпании. В базу включены самые основные необходимые 
-- таблицы как график полетов данные по айропортам и пользователям и их полетам.
-- При создании добавлены условия проверки на коректность данных.
-- Введены такие процедуры как печать посадочного и просмотр прошлых полетов и предстоящих для пользователя.

DROP DATABASE IF EXISTS s721;
CREATE DATABASE s721;
USE s721;

DROP TABLE IF EXISTS airports;
CREATE TABLE airports 
	(airport_code CHAR(3) NOT NULL PRIMARY KEY,
	airoport_name VARCHAR(100) NOT NULL,
	city VARCHAR(100) NOT NULL,
	lattitude FLOAT,
	longitude FLOAT,
	UTC SMALLINT NOT NULL,
	CHECK (UTC BETWEEN -12 AND 12));

DROP TABLE IF EXISTS aircrafts;
CREATE TABLE aircrafts 
	(aircraft_code CHAR(3) NOT NULL PRIMARY KEY,
	model VARCHAR(20) NOT NULL,
	fly_range INT UNSIGNED NOT NULL
	);

DROP TABLE IF EXISTS seats;
CREATE TABLE seats
	(aircraft_code CHAR(3),
	seat_number CHAR(3) NOT NULL,
	fare_condition ENUM('Bussines', 'Economy'),
	FOREIGN KEY (aircraft_code) REFERENCES aircrafts(aircraft_code)
	);


DROP TABLE IF EXISTS schedule_flights;
CREATE TABLE schedule_flights 
	(flight_id SERIAL,
	flight_number CHAR(7) NOT NULL,
	departure_time DATETIME NOT NULL,
	departure_airport CHAR(3) NOT NULL,
	arrive_time DATETIME NOT NULL,
	arrival_airport CHAR(3) NOT NULL,
	aircraft_code CHAR(3) NOT NULL,
	real_time_departure DATETIME NOT NULL,
	real_time_arrive DATETIME NOT NULL,
	status ENUM('on time', 'delay', 'departure', 'arrived', 'canceled'),
	frontier ENUM('locall', 'foreign'),
	FOREIGN KEY (aircraft_code) REFERENCES aircrafts(aircraft_code),
	FOREIGN KEY (arrival_airport) REFERENCES airports(airport_code),
	FOREIGN KEY (departure_airport) REFERENCES airports(airport_code),
	CHECK (departure_time < arrive_time AND real_time_departure < real_time_arrive),
	CHECK (departure_airport != arrival_airport)
	);



DROP TABLE IF EXISTS bookings;
CREATE TABLE bookings( 
	book_number SERIAL,
	book_date DATETIME NOT NULL,
	book_price NUMERIC(10, 2),
	insurance BIT,
	luggage BIT);


DROP TABLE IF EXISTS passangers_info;
CREATE TABLE passangers_info(
	id SERIAL,
	name VARCHAR(250),
	surname VARCHAR(250),
	pasport_number BIGINT UNSIGNED,
	gender ENUM('f', 'm'),
	pasport_date DATE,
	birthday_date DATE);


DROP TABLE IF EXISTS tickets;
CREATE TABLE tickets(
	ticket_number BIGINT UNSIGNED NOT NULL PRIMARY KEY,
	passanger_id BIGINT UNSIGNED NOT NULL,
	book_number BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (book_number) REFERENCES bookings(book_number),
	FOREIGN KEY (passanger_id) REFERENCES passangers_info(id));


DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles(
	mills BIGINT,
	status ENUM('clasic', 'master', 'expert'),
    phone BIGINT UNSIGNED,
    pasword char(30),
	passanger_id BIGINT UNSIGNED NOT NULL  PRIMARY KEY,
	FOREIGN KEY (passanger_id) REFERENCES passangers_info(id));


DROP TABLE IF EXISTS luggage;
CREATE TABLE luggage(
	luggage_id SERIAL,
	passanger_id BIGINT UNSIGNED NOT NULL,
	flight_id BIGINT UNSIGNED NOT NULL,
	weight_kg INT,
	status ENUM('normal', 'fragily', 'temperature'),
	FOREIGN KEY (flight_id) REFERENCES schedule_flights(flight_id),
	FOREIGN KEY (passanger_id) REFERENCES passangers_info(id));

DROP TABLE IF EXISTS tikets_info;
CREATE TABLE tikets_info (
	tickets_number BIGINT UNSIGNED NOT NULL UNIQUE,
	flight_id BIGINT UNSIGNED NOT NULL,
	fare_condition ENUM('Bussines', 'Economy'),
	FOREIGN KEY (flight_id) REFERENCES schedule_flights(flight_id)); 

DROP TABLE IF EXISTS boarding_passes;
CREATE TABLE boarding_passes (
	ticket_number BIGINT UNSIGNED NOT NULL UNIQUE,
	flight_id  BIGINT UNSIGNED NOT NULL,
	broading_number BIGINT UNSIGNED NOT NULL UNIQUE,
	gate CHAR(3),
	seat_number  CHAR(3) NOT NULL,
	FOREIGN KEY (ticket_number) REFERENCES tickets(ticket_number),
	FOREIGN KEY (flight_id) REFERENCES schedule_flights(flight_id));







