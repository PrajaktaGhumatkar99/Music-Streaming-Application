USE streamingdatabase;

DROP PROCEDURE IF EXISTS createUser;
DELIMITER $$
CREATE PROCEDURE createUser(firstName_p VARCHAR(64), lastName_p VARCHAR(64), email_p VARCHAR(128), phone_p VARCHAR(10))
BEGIN
	DECLARE uid_found INT;
    DECLARE uid_not_found INT;
	DECLARE user_cursor CURSOR FOR SELECT userId FROM user WHERE email = email_p AND phone = phone_p;
	DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET uid_not_found = TRUE;

	SET uid_not_found = FALSE;
	OPEN user_cursor;
	
	FETCH user_cursor INTO uid_found;
	
	CLOSE user_cursor;
    
    IF uid_not_found = TRUE THEN
		INSERT INTO user VALUES(0, firstName_p, lastName_p, email_p, phone_p);
	END IF;
END $$
DELIMITER ;
CALL createUser("chunk", "broderick", "chunk.broderick@gmail.com", "6035122841");
;