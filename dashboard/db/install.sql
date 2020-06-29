
SET FOREIGN_KEY_CHECKS = 0;


DROP TABLE IF EXISTS GENRES;
DROP TABLE IF EXISTS GLOBAL_SALES;
DROP TABLE IF EXISTS REGIONAL_SALES;
DROP TABLE IF EXISTS PLATFORMS;
DROP TABLE IF EXISTS PUBLISHERS;
DROP TABLE IF EXISTS DEVELOPERS;
DROP TABLE IF EXISTS RATINGS;
DROP TABLE IF EXISTS SPECIAL_RATINGS;
DROP TABLE IF EXISTS GAMES;
DROP TABLE IF EXISTS USERS;
DROP TABLE IF EXISTS USERS_GAMES;
DROP TABLE IF EXISTS GAMES_RATINGS;
DROP TABLE IF EXISTS GAMES_PLATFORMS_SALES;

SET FOREIGN_KEY_CHECKS = 1;



CREATE TABLE GENRES (
  genre_id INTEGER PRIMARY KEY,
  genre_name VARCHAR(255) NOT NULL
);


CREATE TABLE GLOBAL_SALES(
    global_sales_id    INTEGER PRIMARY KEY AUTO_INCREMENT,
    global_sales_value INTEGER NULL
);

CREATE TABLE REGIONAL_SALES(
    regional_sales_id    INTEGER PRIMARY KEY AUTO_INCREMENT,
    regional_sales_value INTEGER NULL,
    sales_type  VARCHAR(255) NULL,
    global_sales_id INTEGER NOT NULL
);

ALTER TABLE REGIONAL_SALES ADD CONSTRAINT fk_globalsales_id FOREIGN KEY (global_sales_id) REFERENCES GLOBAL_SALES (global_sales_id) ON DELETE CASCADE;


CREATE TABLE PLATFORMS (
  platform_id INTEGER PRIMARY KEY,
  platform_name VARCHAR(255)
);

CREATE TABLE PUBLISHERS (
    pub_id INTEGER PRIMARY KEY ,
    name VARCHAR(255) NOT NULL,
    country VARCHAR(255) NULL
);

CREATE TABLE DEVELOPERS (
    dev_id INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    country VARCHAR(255) NULL
);


CREATE TABLE RATINGS(
    rating_id INTEGER PRIMARY KEY ,
    general_Rating VARCHAR(255) NOT NULL
);


CREATE TABLE SPECIAL_RATINGS(
    rating_id INTEGER NOT NULL,
    institution VARCHAR(255),
    special_rating VARCHAR(255),
    minimum_age INTEGER
);

ALTER TABLE SPECIAL_RATINGS ADD CONSTRAINT fk2_rating_id FOREIGN KEY(rating_id) REFERENCES RATINGS(rating_id);


CREATE TABLE GAMES (
    game_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    ranking INTEGER(6),
    genre_id INTEGER,
    pub_id INTEGER,
    dev_id INTEGER,
    release_date DATE,
    userpoints Integer default 0
    );

ALTER TABLE GAMES ADD CONSTRAINT fk_genre_id FOREIGN KEY (genre_id) REFERENCES GENRES(genre_id) ON DELETE CASCADE;
ALTER TABLE GAMES ADD CONSTRAINT fk_pub_id FOREIGN KEY (pub_id) REFERENCES PUBLISHERS(pub_id) ON DELETE CASCADE;
ALTER TABLE GAMES ADD CONSTRAINT fk_de_id FOREIGN KEY (dev_id) REFERENCES DEVELOPERS(dev_id) ON DELETE CASCADE;



CREATE TABLE USERS (
    user_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(25),
    user_pw VARCHAR(25),
    user_type VARCHAR(255) NOT NULL,
    last_login Date NOT NUll
);



CREATE TABLE USERS_GAMES (
    user_id INTEGER,
    game_id INTEGER
);

ALTER TABLE USERS_GAMES ADD CONSTRAINT fk2_user_id FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE;
ALTER TABLE USERS_GAMES ADD CONSTRAINT fk3_game_id FOREIGN KEY (game_id) REFERENCES GAMES(game_id) ON DELETE CASCADE;



CREATE TABLE GAMES_PLATFORMS_SALES (
  game_id INTEGER NOT NULL,
  platform_id INTEGER NOT NULL,
  global_sales_id INTEGER NOT NULL,
  CONSTRAINT pk_gamePlatformSales PRIMARY KEY (game_id, platform_id, global_sales_id)
);

ALTER TABLE GAMES_PLATFORMS_SALES ADD CONSTRAINT fk_game_id FOREIGN KEY (game_id) REFERENCES GAMES (game_id);
ALTER TABLE GAMES_PLATFORMS_SALES ADD CONSTRAINT fk_platform_id FOREIGN KEY (platform_id) REFERENCES PLATFORMS (platform_id);
ALTER TABLE GAMES_PLATFORMS_SALES ADD CONSTRAINT fk_sales_id FOREIGN KEY (global_sales_id) REFERENCES GLOBAL_SALES (global_sales_id);




CREATE TABLE GAMES_RATINGS(
    game_id INTEGER NOT NULL,
    rating_id INTEGER NOT NULL
);

ALTER TABLE GAMES_RATINGS ADD CONSTRAINT fk2_game_id FOREIGN KEY (game_id) REFERENCES GAMES(game_id);
ALTER TABLE GAMES_RATINGS ADD CONSTRAINT fk_rating_id FOREIGN KEY (rating_id) REFERENCES RATINGS(rating_id);
ALTER TABLE GAMES_RATINGS ADD CONSTRAINT game_rating_pk PRIMARY KEY (game_id,rating_id);


-- TRIGGER

-- Trigger für insert
DROP TRIGGER IF EXISTS trg_userpoints_insert;
DELIMITER //

CREATE  TRIGGER trg_userpoints_insert
AFTER INSERT ON USERS_GAMES
FOR EACH ROW
BEGIN

    UPDATE GAMES SET userpoints=userpoints+1 WHERE game_id=NEW.game_id;

END //
DELIMITER ;



-- Trigger für delete
DROP TRIGGER IF EXISTS trg_userpoints_delete;
DELIMITER //

CREATE  TRIGGER trg_userpoints_delete
AFTER DELETE ON USERS_GAMES
FOR EACH ROW
BEGIN

    UPDATE GAMES SET userpoints=userpoints-1 WHERE game_id=OLD.game_id;

END //
DELIMITER ;


-- Trigger für delete
DROP TRIGGER IF EXISTS trg_userpoints_delete_all;
DELIMITER //

CREATE  TRIGGER trg_userpoints_delete_all
BEFORE DELETE ON USERS
FOR EACH ROW
BEGIN

    DELETE FROM USERS_GAMES WHERE (user_id=OLD.user_id);

END //
DELIMITER ;


-- Trigger für sales
DROP TRIGGER IF EXISTS trg_sales;
DELIMITER //
CREATE TRIGGER trg_sales
AFTER UPDATE ON REGIONAL_SALES
FOR EACH ROW
BEGIN

    DECLARE p_game_id     INT;
    DECLARE p_platform_id INT;
    DECLARE difference    INT;

    SET difference := NEW.regional_sales_value - OLD.regional_sales_value;

    UPDATE GLOBAL_SALES
    SET global_sales_value=global_sales_value + difference
    WHERE global_sales_id = NEW.global_sales_id;


END //
DELIMITER ;


-- TRIGGER Username
DROP TRIGGER IF EXISTS trg_username;
DELIMITER //
CREATE TRIGGER trg_username
BEFORE INSERT ON USERS
FOR EACH ROW

BEGIN
DECLARE anzahl INT;

    SELECT COUNT(user_name) INTO anzahl FROM USERS WHERE user_name=NEW.user_name;
    IF (anzahl > 0) THEN

        signal sqlstate '02000' set message_text = 'User bereits vorhanden!';
    END IF;
END //
DELIMITER ;


-- FUNKTIONEN UND PROZEDUREN

-- Add to Favourites
DROP PROCEDURE IF EXISTS addToFavourites;
DELIMITER //
CREATE PROCEDURE addToFavourites (IN p_user_id INTEGER, IN p_game_id INTEGER)

BEGIN
    DECLARE anzahl INT;
    SELECT COUNT(game_id) INTO anzahl FROM USERS_GAMES WHERE user_id=p_user_id AND game_id=p_game_id;
    IF (anzahl > 0) THEN

        signal sqlstate '02000' set message_text = 'Spiel bereits in Favoriten vorhanden!';

    ELSE

        INSERT INTO USERS_GAMES VALUES (p_user_id, p_game_id);
        select 'Spiel zu Favoriten hinzugefügt' AS '';
    END IF;

END //
DELIMITER ;



-- Delete from Favourites
DROP PROCEDURE IF EXISTS deleteFromFavourites;
DELIMITER //
CREATE PROCEDURE deleteFromFavourites (IN p_user_id INTEGER, IN p_game_id INTEGER)

BEGIN
    DECLARE anzahl INT;
    SELECT COUNT(user_id) INTO anzahl FROM USERS_GAMES WHERE user_id=p_user_id AND game_id=p_game_id;
    IF (anzahl > 0 ) THEN

        DELETE FROM USERS_GAMES WHERE (user_id=p_user_id AND game_id=p_game_id);
        select 'Spiel aus Favoriten entfernt' AS '';


    ELSE
        signal sqlstate '02000' set message_text = 'Daten nicht verfügbar!';

    END IF;
END //
DELIMITER ;


-- deleteFromUsers
DROP PROCEDURE IF EXISTS deleteFromUsers;
DELIMITER //
CREATE PROCEDURE deleteFromUsers(IN p_user_id INTEGER)

BEGIN
DECLARE anzahl INT;
    SELECT COUNT(user_id) INTO anzahl FROM USERS WHERE user_id = p_user_id;
    IF (anzahl > 0) THEN

        DELETE FROM USERS WHERE (user_id = p_user_id);

    ELSE
        signal sqlstate '02000' set message_text = 'User existiert nicht!';
    END IF;
END //
DELIMITER ;


-- deleteInactiveUsers
DROP FUNCTION IF EXISTS deleteInactiveUsers;
DELIMITER //
CREATE FUNCTION deleteInactiveUsers () RETURNS INTEGER

BEGIN
DECLARE anzahl INT;
DECLARE i DATE;
DECLARE finished INT DEFAULT 0;
DECLARE user_cursor CURSOR FOR SELECT last_login FROM USERS;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET finished=1;
    SET anzahl := 0;
    OPEN user_cursor;
		REPEAT
		FETCH user_cursor INTO i;
		IF NOT finished THEN
				IF (i < (NOW() - INTERVAL 30 DAY)) THEN

					DELETE FROM USERS WHERE last_login = i;
				END IF;
				IF (i < (NOW() - INTERVAL 30 DAY)) THEN
					SET anzahl := anzahl + 1;
				END IF;
		END IF;
		UNTIL finished END REPEAT;
    CLOSE user_cursor;

    RETURN anzahl;
END //
DELIMITER ;


SET GLOBAL event_scheduler = ON;


DROP EVENT IF EXISTS upd_event;
DELIMITER //
CREATE EVENT upd_event
    -- Ab jetzt und dann jede Stunde
    ON SCHEDULE EVERY '10' SECOND STARTS now()
    DO
    BEGIN
        DECLARE c INT;
        SET c := deleteInactiveUsers(); -- Aufruf der Prozedur
        select c AS '';
        commit;
	END //
DELIMITER ;

-- Testprozedure, um den returnwert von der deleteInactiveUsers zu testen.
DROP PROCEDURE IF EXISTS test_deleteInactiveUsers;
DELIMITER //
CREATE PROCEDURE test_deleteInactiveUsers ()

BEGIN
    DECLARE anzahl INT;
    SET anzahl := deleteInactiveUsers();
    select anzahl AS '';
    commit;
END //
DELIMITER ;

-- TESTDATEN INSERT

INSERT INTO GENRES VALUES (1, 'Platformer');
INSERT INTO GENRES VALUES (2, 'Shooter');
INSERT INTO GENRES VALUES (3, 'RPG');

INSERT INTO PLATFORMS VALUES (1, 'PC');
INSERT INTO PLATFORMS VALUES (2, 'Sony Playstation');
INSERT INTO PLATFORMS VALUES (3, 'Nintendo Switch');


INSERT INTO PUBLISHERS VALUES (1, 'Nintendo', 'Japan');
INSERT INTO PUBLISHERS VALUES (2, 'Epic Games', 'USA');
INSERT INTO PUBLISHERS VALUES (3, 'Capcom', 'Japan');
INSERT INTO PUBLISHERS VALUES (4, 'Ubisoft', 'USA');
INSERT INTO PUBLISHERS VALUES (5, 'Jagex', 'USA');

INSERT INTO DEVELOPERS VALUES (1, 'Nintendo', 'Japan');
INSERT INTO DEVELOPERS VALUES (2, 'Epic Games', 'USA');
INSERT INTO DEVELOPERS VALUES (3, 'Capcom', 'Japan');
INSERT INTO DEVELOPERS VALUES (4, 'Ubisoft', 'USA');
INSERT INTO DEVELOPERS VALUES (5, 'Jagex', 'USA');


INSERT INTO GAMES (name, ranking, genre_id, pub_id, dev_id, release_date) VALUES ('Suber Mario Bros', 1, 1, 1, 1, NOW());
INSERT INTO GAMES (name, ranking, genre_id, pub_id, dev_id, release_date) VALUES ('Fortnite', 2, 2, 2, 2, NOW());
INSERT INTO GAMES (name, ranking, genre_id, pub_id, dev_id, release_date) VALUES ('Monster Hunter', 3, 3, 3, 3, NOW());
INSERT INTO GAMES (name, ranking, genre_id, pub_id, dev_id, release_date) VALUES ('Rainbow Six', 4, 2, 4, 4, NOW());
INSERT INTO GAMES (name, ranking, genre_id, pub_id, dev_id, release_date) VALUES ('Runescape', 5, 3, 5, 5, NOW());


--                                    value   typ


INSERT INTO GLOBAL_SALES (global_sales_value) VALUES (100000);


--                                  id   value   typ id
INSERT INTO REGIONAL_SALES (regional_sales_value, sales_type, global_sales_id) VALUES (10000, 'pal', 1);
INSERT INTO REGIONAL_SALES (regional_sales_value, sales_type, global_sales_id) VALUES (20000, 'north_america', 1);
INSERT INTO REGIONAL_SALES (regional_sales_value, sales_type, global_sales_id) VALUES (30000, 'japan', 1);
INSERT INTO REGIONAL_SALES (regional_sales_value, sales_type, global_sales_id) VALUES (40000, 'other', 1);


INSERT INTO RATINGS VALUES (1, 'Ohne Beschränkung');
INSERT INTO RATINGS VALUES (2, 'Kinder');
INSERT INTO RATINGS VALUES (3, 'Erwachsene');


--                                 id  inst  rating age
INSERT INTO SPECIAL_RATINGS VALUES (1, 'ESRB', 'E', 0);
INSERT INTO SPECIAL_RATINGS VALUES (2, 'ESRB', 'C', 8);
INSERT INTO SPECIAL_RATINGS VALUES (3, 'ESRB', 'A', 18);



INSERT INTO USERS (user_name, user_pw, user_type, last_login) VALUES ('Heini', '12345', 'Admin', NOW());
INSERT INTO USERS (user_name, user_pw, user_type, last_login) VALUES ('Bibo', 'gott123', 'Guest', NOW());
INSERT INTO USERS (user_name, user_pw, user_type, last_login) VALUES ('Anos', 'haustier', 'Member', NOW());


--                           user game
INSERT INTO USERS_GAMES VALUES (1,1);
INSERT INTO USERS_GAMES VALUES (1,2);
INSERT INTO USERS_GAMES VALUES (2,1);
INSERT INTO USERS_GAMES VALUES (2,2);
INSERT INTO USERS_GAMES VALUES (2,3);
INSERT INTO USERS_GAMES VALUES (3,3);

--                                     game platf sales
INSERT INTO GAMES_PLATFORMS_SALES VALUES (1, 1, 1);
/* INSERT INTO GAMES_PLATFORMS_SALES VALUES (1, 1, 2);
INSERT INTO GAMES_PLATFORMS_SALES VALUES (1, 1, 3);
INSERT INTO GAMES_PLATFORMS_SALES VALUES (1, 1, 4);
INSERT INTO GAMES_PLATFORMS_SALES VALUES (1, 1, 5); */


--                               game rating
INSERT INTO GAMES_RATINGS VALUES (1, 1);
INSERT INTO GAMES_RATINGS VALUES (2, 2);
INSERT INTO GAMES_RATINGS VALUES (3, 3);
INSERT INTO GAMES_RATINGS VALUES (4, 3);
INSERT INTO GAMES_RATINGS VALUES (5, 2);
