SET @id_number = 1


DROP PROCEDURE IF EXISTS broad_pass_for_passanger;
DELIMITER //
CREATE PROCEDURE broad_pass_for_passanger(IN id_number int)
BEGIN
	SELECT  passangers_info.name AS 'First Name',
		passangers_info.surname AS 'Last Name', 
		schedule_flights.flight_number 'Flight number',
		SUBSTRING(schedule_flights.departure_time, 1, 16) AS 'Departure time ', 
		SUBSTRING(schedule_flights.arrive_time, 1, 16) AS 'Arrive time', 
		boarding_passes.gate AS 'Gate', 
		boarding_passes.seat_number AS 'Seat number',
		schedule_flights.departure_airport AS 'From',
		schedule_flights.arrive_time AS 'TO'
	FROM passangers_info 
		 JOIN tickets ON passangers_info.id = tickets.passanger_id 
		 JOIN boarding_passes ON tickets.ticket_number = boarding_passes.ticket_number 
		 JOIN schedule_flights ON boarding_passes.flight_id = schedule_flights.flight_id 
	WHERE passangers_info.id = @id_number 
	AND schedule_flights.departure_time > NOW()
	AND schedule_flights.departure_time < DATE_ADD(NOW(), INTERVAL 6 HOUR)-- за 6 часов печатает посадочный
	GROUP BY schedule_flights.departure_time 
	ORDER BY schedule_flights.departure_time DESC;
END //
DELIMITER ;



-- see past trevel
DROP PROCEDURE IF EXISTS see_past_trevel; 
DELIMITER //
CREATE PROCEDURE see_past_trevel(IN id_number int)
BEGIN
SELECT schedule_flights.flight_number AS 'flight number' , airports.city AS City FROM passangers_info 
	JOIN tickets ON passangers_info.id = tickets.passanger_id 
	JOIN boarding_passes ON tickets.ticket_number  = boarding_passes.ticket_number 
	JOIN schedule_flights ON boarding_passes.flight_id = schedule_flights.flight_id 
	JOIN airports ON  airports.airport_code = schedule_flights.arrival_airport
WHERE passangers_info.id = @id_number AND schedule_flights.departure_time < NOW()
GROUP BY schedule_flights.departure_time;
END //
DELIMITER ;

--- future travel
DROP PROCEDURE IF EXISTS see_future_trevel();
DELIMITER //
CREATE PROCEDURE see_future_trevel(IN id_number int)
BEGIN
SELECT schedule_flights.flight_number AS 'flight number' , airports.city AS City FROM passangers_info 
	JOIN tickets ON passangers_info.id = tickets.passanger_id 
	JOIN boarding_passes ON tickets.ticket_number  = boarding_passes.ticket_number 
	JOIN schedule_flights ON boarding_passes.flight_id = schedule_flights.flight_id 
	JOIN airports ON  airports.airport_code = schedule_flights.arrival_airport
WHERE passangers_info.id = @id_number AND schedule_flights.departure_time > NOW()
GROUP BY schedule_flights.departure_time;
END //
DELIMITER ;


CALL see_future_trevel()
CALL see_past_trevel()


SET @id_number = 2
CALL broad_pass_for_passanger(@id_number)
CALL see_future_trevel(@id_number)
CALL see_past_trevel(@id_number)
SET @id_number = 1
CALL see_future_trevel(@id_number)
-