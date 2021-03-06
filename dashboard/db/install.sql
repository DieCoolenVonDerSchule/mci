USE transpondersystem;
SET FOREIGN_KEY_CHECKS = 0;

SET SQL_MODE='ALLOW_INVALID_DATES';


DROP TABLE IF EXISTS TRANSPONDER;
DROP TABLE IF EXISTS RAEUME;
DROP TABLE IF EXISTS TRANSPONDER_RAEUME;
DROP TABLE IF EXISTS PERSONEN;
DROP TABLE IF EXISTS PERSONEN_RAEUME;
DROP TABLE IF EXISTS PERSONEN_TRANSPONDER;


CREATE TABLE TRANSPONDER (
	transId INTEGER PRIMARY KEY,
	transNr INTEGER NOT NULL
);





CREATE TABLE RAEUME (
	raumId INTEGER PRIMARY KEY,
	raumNr VARCHAR(10) NOT NULL,
	raumName VARCHAR(255) NOT NULL
);




CREATE TABLE TRANSPONDER_RAEUME (
	transId INTEGER NOT NULL,
	raumId INTEGER NOT NULL
);

ALTER TABLE TRANSPONDER_RAEUME ADD CONSTRAINT fk_transId FOREIGN KEY
(transId) REFERENCES TRANSPONDER (transId) ON DELETE CASCADE;

ALTER TABLE TRANSPONDER_RAEUME ADD CONSTRAINT fk_raumId FOREIGN KEY
(raumId) REFERENCES RAEUME (raumId) ON DELETE CASCADE;

ALTER TABLE TRANSPONDER_RAEUME ADD CONSTRAINT PRIMARY KEY (transId,raumId);




CREATE TABLE PERSONEN (
	personId INTEGER PRIMARY KEY,
	personNr INTEGER NOT NULL,
	personName VARCHAR(255) NOT NULL
);




CREATE TABLE PERSONEN_RAEUME (
	personId INTEGER NOT NULL,
	raumId INTEGER NOT NULL
);

ALTER TABLE PERSONEN_RAEUME ADD CONSTRAINT fk_personId FOREIGN KEY
(personId) REFERENCES PERSONEN (personId) ON DELETE CASCADE;

ALTER TABLE PERSONEN_RAEUME ADD CONSTRAINT fk2_raumId FOREIGN KEY
(raumId) REFERENCES RAEUME (raumId) ON DELETE CASCADE;


ALTER TABLE PERSONEN_RAEUME ADD CONSTRAINT PRIMARY KEY (personId,raumId);




CREATE TABLE PERSONEN_TRANSPONDER (
	personId INTEGER NOT NULL,
	transId INTEGER NOT NULL,
	von VARCHAR(50),
	bis VARCHAR(50)
);


ALTER TABLE PERSONEN_TRANSPONDER ADD CONSTRAINT fk2_personId FOREIGN KEY
(personId) REFERENCES PERSONEN (personId) ON DELETE CASCADE;

ALTER TABLE PERSONEN_TRANSPONDER ADD CONSTRAINT fk2_transId FOREIGN KEY
(transId) REFERENCES TRANSPONDER (transId) ON DELETE CASCADE;

ALTER TABLE PERSONEN_TRANSPONDER ADD CONSTRAINT PRIMARY KEY (personId,transId);


INSERT INTO TRANSPONDER VALUES (1, 11010);
INSERT INTO TRANSPONDER VALUES (2, 11012);
INSERT INTO TRANSPONDER VALUES (3, 11016);
INSERT INTO TRANSPONDER VALUES (4, 11020);

INSERT INTO RAEUME VALUES (1, "0.401", "Vorlesungsraum A");
INSERT INTO RAEUME VALUES (2, "0.402", "Vorlesungsraum B");
INSERT INTO RAEUME VALUES (3, "2.200", "KTN-Labor");
INSERT INTO RAEUME VALUES (4, "0.401", "Uebungsraum");
INSERT INTO RAEUME VALUES (5, "3.100", "Wetterstation");

INSERT INTO TRANSPONDER_RAEUME VALUES (1,1);
INSERT INTO TRANSPONDER_RAEUME VALUES (1,2);
INSERT INTO TRANSPONDER_RAEUME VALUES (2,3);
INSERT INTO TRANSPONDER_RAEUME VALUES (3,4);
INSERT INTO TRANSPONDER_RAEUME VALUES (4,5);

INSERT INTO PERSONEN VALUES (1, 11132500, "Student 1");
INSERT INTO PERSONEN VALUES (2, 11132408, "Student 2");
INSERT INTO PERSONEN VALUES (3, 83400, "Dozent 1");
INSERT INTO PERSONEN VALUES (4, 83452, "Dozent 2");


INSERT INTO PERSONEN_RAEUME VALUES (1, 1);
INSERT INTO PERSONEN_RAEUME VALUES (1, 2);
INSERT INTO PERSONEN_RAEUME VALUES (2, 4);
INSERT INTO PERSONEN_RAEUME VALUES (3, 3);
INSERT INTO PERSONEN_RAEUME VALUES (4, 2);
INSERT INTO PERSONEN_RAEUME VALUES (4, 5);

INSERT INTO PERSONEN_TRANSPONDER VALUES (1, 1, 0, 1000);
