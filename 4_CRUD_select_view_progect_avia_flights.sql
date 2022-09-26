
-- Selectors

USE s721;

-- показывает сумарное количество полетов модели которое совершено во время
SELECT aircrafts.model, count(aircrafts.model) AS 'total flight on time'  FROM aircrafts
	JOIN schedule_flights  ON aircrafts.aircraft_code = schedule_flights.aircraft_code 
WHERE schedule_flights.status = 'on time'
GROUP BY aircrafts.model
ORDER BY aircrafts.model


-- предстоящие полеты
SELECT schedule_flights.flight_number, schedule_flights.departure_time, airports.city, airports.airoport_name FROM airports
	JOIN schedule_flights ON airports.airport_code = schedule_flights.departure_airport
WHERE schedule_flights.departure_time > NOW()
GROUP BY schedule_flights.flight_id 
ORDER BY schedule_flights.departure_time 

-- информация о пассажире и его багаже 
SELECT passangers_info.name, luggage.weight_kg, schedule_flights.flight_number, schedule_flights.status FROM luggage
	JOIN passangers_info ON passangers_info.id = luggage.passanger_id 
	JOIN schedule_flights ON luggage.flight_id  = schedule_flights.flight_id 
WHERE passangers_info.name RLIKE '^A'
ORDER BY schedule_flights.departure_time;


-- VIEW 
-- будующие полеты
CREATE OR REPLACE VIEW myview AS 
SELECT 
CONCAT(passangers_info.name, ' ', passangers_info.surname) AS full_name,
schedule_flights.flight_number,
schedule_flights.status,
schedule_flights.departure_time,
boarding_passes.gate, 
boarding_passes.seat_number FROM passangers_info 
	JOIN tickets ON passangers_info.id = tickets.passanger_id 
	JOIN boarding_passes ON tickets.ticket_number = boarding_passes.ticket_number 
	JOIN schedule_flights ON boarding_passes.flight_id = schedule_flights.flight_id 
WHERE schedule_flights.departure_time > NOW()
GROUP BY schedule_flights.flight_id 
ORDER BY departure_time 


SELECT * 
FROM  myview2;

-- потрачено на билеты пользователями у меня только 3 пользователя что то покупали и летали
CREATE OR REPLACE VIEW myview2 AS 
SELECT concat(pi2.name, ' ', pi2.surname) AS Passanger_name, sum(b.book_price) AS total FROM bookings b 
	JOIN tickets t  ON t.book_number  = b.book_number 
	JOIN tikets_info ti  ON ti.tickets_number  = t.ticket_number 
	JOIN passangers_info pi2 ON pi2.id = t.passanger_id 
GROUP BY Passanger_name


SELECT * 
FROM  myview2;


