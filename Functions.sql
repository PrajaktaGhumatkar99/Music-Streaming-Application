USE streamingdatabase;

DROP FUNCTION IF EXISTS findUser;

DELIMITER $$
CREATE FUNCTION findUser(email_p VARCHAR(128), phone_p VARCHAR(10)) 
RETURNS INT
DETERMINISTIC
READS SQL DATA
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
    
	RETURN uid_found;
END $$

DELIMITER ;
SELECT findUser("seamus.rioux3@gmail.com", "6038608279") as foundUser;
; 

-- INSERT INTO user VALUES(0, "Seamus", "Rioux", "seamus.rioux3@gmail.com", "6038608279");