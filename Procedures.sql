USE streamingdatabase;

/*
	Create Procedures
*/

-- Create a user using given paramters. This will also make a payment plan for the user.
DROP PROCEDURE IF EXISTS createUser;
DELIMITER $$
CREATE PROCEDURE createUser(IN firstName_p VARCHAR(64), IN lastName_p VARCHAR(64), IN email_p VARCHAR(128), IN phone_p VARCHAR(10), IN plan_id INT)
BEGIN
	DECLARE uid_found INT;
    DECLARE uid_not_found INT;
	DECLARE user_cursor CURSOR FOR SELECT userId FROM users WHERE email = email_p AND phone = phone_p;
	DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET uid_not_found = TRUE;

	SET uid_not_found = FALSE;
	OPEN user_cursor;
	
	FETCH user_cursor INTO uid_found;
	
	CLOSE user_cursor;
    
    IF uid_not_found = TRUE THEN
		INSERT INTO users VALUES(0, firstName_p, lastName_p, email_p, phone_p, plan_id, now());
	END IF;
    
END $$
DELIMITER ;
;
-- Get payment plan information
DROP PROCEDURE IF EXISTS getPaymentPlans;
DELIMITER $$
CREATE PROCEDURE getPaymentPlans()
BEGIN
	SELECT * FROM paymentplans;
END $$
DELIMITER ;
;

-- Gets songs in Playlist using playlist_id
DROP PROCEDURE IF EXISTS getPlaylistSongs;
DELIMITER $$
CREATE PROCEDURE getPlaylistSongs(IN playlist_id INT) 
BEGIN
	SELECT s.songId, title, releaseDate, duration FROM songs AS s
    JOIN playlistsong AS p ON s.songId = p.songId
    WHERE p.playlistId = playlist_id;
END $$
DELIMITER ;
;

-- Removes a song from a Playlist using playlist_id and song_id
DROP PROCEDURE IF EXISTS removeSongFromPlaylist;
DELIMITER $$
CREATE PROCEDURE removeSongFromPlaylist(IN playlist_id INT, IN song_id INT)
BEGIN
	DELETE FROM playlistsong WHERE playlistId = playlist_id AND songId = song_id;
END $$



