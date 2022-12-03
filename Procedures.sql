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

-- Create a new playlist using name status and userId 
DROP  PROCEDURE IF EXISTS createPlaylist;
DELIMITER $$
CREATE PROCEDURE createPlaylist(IN name_p VARCHAR(45), IN status_p VARCHAR(64), IN userId INT)
BEGIN
	INSERT INTO playlists VALUES(0, name_p, status_p, userId);
END $$
DELIMITER ;
;


DROP  PROCEDURE IF EXISTS addSongPlaylistLink;
DELIMITER $$
CREATE PROCEDURE addSongPlaylistLink(IN song_id INT, IN playlist_id INT)
BEGIN
	INSERT INTO playlistsong VALUES(song_id, playlist_id);
END $$
DELIMITER ;
;


/*
	Get Procedures
*/

-- Get payment plan information
DROP PROCEDURE IF EXISTS getPaymentPlans;
DELIMITER $$
CREATE PROCEDURE getPaymentPlans()
BEGIN
	SELECT * FROM paymentplans;
END $$
DELIMITER ;
;

-- Get information about the user based on the email
DROP PROCEDURE IF EXISTS getUserInformation;
DELIMITER $$
CREATE PROCEDURE getUserInformation(IN email_p VARCHAR(128))
BEGIN
	SELECT * FROM users WHERE email = email_p;
END $$
DELIMITER ;
;

-- Get information about the payment planId
DROP PROCEDURE IF EXISTS getPaymentInformation;

DELIMITER $$
CREATE PROCEDURE getPaymentInformation(IN plan_id INT) 
BEGIN
	SELECT * FROM paymentplans WHERE planId = plan_id;
END $$
DELIMITER ;
;


-- Gets songs in Playlist using playlist_id
DROP PROCEDURE IF EXISTS getPlaylistSongs;
DELIMITER $$
CREATE PROCEDURE getPlaylistSongs(IN playlist_id INT) 
BEGIN
	SELECT s.songId, title, releaseDate, duration, name FROM songs AS s
    JOIN playlistsong AS p ON s.songId = p.songId
    JOIN artistsong AS l ON s.songId = l.songId
    JOIN artists AS a ON l.artistId = a.artistId
    WHERE p.playlistId = playlist_id;
END $$

DELIMITER ;
CALL getPlaylistSongs(1)
;

-- Get songs with artist name
DROP PROCEDURE IF EXISTS getSongs;
DELIMITER $$
CREATE PROCEDURE getSongs() 
BEGIN
	SELECT s.songId, title, releaseDate, duration, name FROM songs AS s
    JOIN artistsong AS l ON s.songId = l.songId
    JOIN artists AS a ON l.artistId = a.artistId;
END $$

DELIMITER ;
CALL getSongs()
;

DROP PROCEDURE IF EXISTS getPlaylistsUser;
DELIMITER $$
CREATE PROCEDURE getPlaylistsUser(IN user_id INT) 
BEGIN
	SELECT * FROM playlists WHERE userId = user_id;
END $$

DELIMITER ;
CALL getSongs()
;

DROP PROCEDURE IF EXISTS getSongsFromSearch;
DELIMITER $$
CREATE PROCEDURE getSongsFromSearch(IN searchParam VARCHAR(127)) 
BEGIN
	SELECT s.songId, title, releaseDate, duration, name FROM songs AS s
    JOIN artistsong AS l ON s.songId = l.songId
    JOIN artists AS a ON l.artistId = a.artistId
    WHERE title LIKE searchParam;
END $$

DELIMITER ;
CALL getSongsFromSearch("%F%");
;


/*
	Delete procedures
*/

-- Removes a song from a Playlist using playlist_id and song_id
DROP PROCEDURE IF EXISTS removeSongFromPlaylist;
DELIMITER $$
CREATE PROCEDURE removeSongFromPlaylist(IN playlist_id INT, IN song_id INT)
BEGIN
	DELETE FROM playlistsong WHERE playlistId = playlist_id AND songId = song_id;
END $$
DELIMITER ;
;


