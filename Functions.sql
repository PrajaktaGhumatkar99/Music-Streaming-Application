USE streamingdatabase;

-- Find out if user exists from email and phone number
DROP FUNCTION IF EXISTS findUser;
DELIMITER $$
CREATE FUNCTION findUser(email_p VARCHAR(128), phone_p VARCHAR(10)) 
RETURNS INT
DETERMINISTIC
READS SQL DATA
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
    
	RETURN uid_found;
END $$
DELIMITER ;
; 

-- Count the number of songs in a playlist 
DROP FUNCTION IF EXISTS countSongsInPlaylist;
DELIMITER $$
CREATE FUNCTION countSongsInPlaylist(playlist_id INT) 
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN 
	DECLARE song_count INT;
    SELECT count(*) INTO song_count FROM playlistsong WHERE playlistId = playlist_id;
	RETURN song_count;
END $$
DELIMITER ;
SELECT countSongsInPlaylist(1) as a;
; 


-- Get name of playlist from playlist id
DROP FUNCTION IF EXISTS getPlaylistName;
DELIMITER $$
CREATE FUNCTION getPlaylistName(playlist_id INT)
RETURNS VARCHAR(128)
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE playlist_name VARCHAR(128);
    SELECT name INTO playlist_name FROM playlists WHERE playlistId = playlist_id;
	RETURN playlist_name;
END $$

DELIMITER ;
SELECT getPlaylistName(1);
; 
