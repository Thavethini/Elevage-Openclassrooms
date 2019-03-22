DROP SCHEMA IF EXISTS elevage;
CREATE DATABASE elevage CHARACTER SET 'utf8';
USE elevage;

CREATE TABLE Animal(
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT 
	,espece VARCHAR(40) NOT NULL
	,sexe CHAR(1)
	,date_naissance DATETIME NOT NULL
	,nom VARCHAR(30)
	,commentaires TEXT
	,PRIMARY KEY(id)
)
ENGINE=InnoDB;

INSERT INTO Animal 
VALUES (1, 'chien', 'M', '2010-04-05 13:43:00', 'Rox', 'Mordille beaucoup');

INSERT INTO Animal 
VALUES (2, 'chat', NULL, '2010-03-24 02:23:00', 'Roucky', NULL);

INSERT INTO Animal 
VALUES (NULL , 'chat', 'F', '2010-09-13 15:02:00', 'Schtroumpfette', NULL);

INSERT INTO Animal (espece, sexe, date_naissance) 
VALUES ('tortue', 'F', '2009-08-03 05:12:00');

INSERT INTO Animal (nom, commentaires, date_naissance, espece) 
VALUES ('Choupi', 'Né sans oreille gauche', '2010-10-03 16:44:00', 'chat');

INSERT INTO Animal (espece, date_naissance, commentaires, nom, sexe) 
VALUES ('tortue', '2009-06-13 08:17:00', 'Carapace bizarre', 'Bobosse', 'F');

INSERT INTO Animal (espece, sexe, date_naissance, nom) 
VALUES ('chien', 'F', '2008-12-06 05:18:00', 'Caroline'),
        ('chat', 'M', '2008-09-11 15:38:00', 'Bagherra'),
        ('tortue', NULL, '2010-08-23 05:18:00', NULL);

INSERT INTO Animal 
SET nom='Bobo', espece='chien', sexe='M', date_naissance='2010-07-21 15:41:00';

INSERT INTO Animal (espece, sexe, date_naissance, nom, commentaires) VALUES 
('chien', 'F', '2008-02-20 15:45:00' , 'Canaille', NULL),
('chien', 'F','2009-05-26 08:54:00'  , 'Cali', NULL),
('chien', 'F','2007-04-24 12:54:00' , 'Rouquine', NULL),
('chien', 'F','2009-05-26 08:56:00' , 'Fila', NULL),
('chien', 'F','2008-02-20 15:47:00' , 'Anya', NULL),
('chien', 'F','2009-05-26 08:50:00' ,'Louya' , NULL),
('chien', 'F', '2008-03-10 13:45:00','Welva' , NULL),
('chien', 'F','2007-04-24 12:59:00' ,'Zira' , NULL),
('chien', 'F', '2009-05-26 09:02:00','Java' , NULL),
('chien', 'M','2007-04-24 12:45:00' ,'Balou' , NULL),
('chien', 'M','2008-03-10 13:43:00' ,'Pataud' , NULL),
('chien', 'M','2007-04-24 12:42:00' , 'Bouli', NULL),
('chien', 'M', '2009-03-05 13:54:00','Zoulou' , NULL),
('chien', 'M','2007-04-12 05:23:00' ,'Cartouche' , NULL),
('chien', 'M', '2006-05-14 15:50:00', 'Zambo', NULL),
('chien', 'M','2006-05-14 15:48:00' ,'Samba' , NULL),
('chien', 'M', '2008-03-10 13:40:00','Moka' , NULL),
('chien', 'M', '2006-05-14 15:40:00','Pilou' , NULL),
('chat', 'M','2009-05-14 06:30:00' , 'Fiero', NULL),
('chat', 'M','2007-03-12 12:05:00' ,'Zonko', NULL),
('chat', 'M','2008-02-20 15:45:00' , 'Filou', NULL),
('chat', 'M','2007-03-12 12:07:00' , 'Farceur', NULL),
('chat', 'M','2006-05-19 16:17:00' ,'Caribou' , NULL),
('chat', 'M','2008-04-20 03:22:00' , 'Capou', NULL),
('chat', 'M','2006-05-19 16:56:00' , 'Raccou', 'Pas de queue depuis la naissance');

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/animal.csv'
INTO TABLE animal 
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"' LINES TERMINATED BY '\r\n' 
(espece, sexe, date_naissance, nom, commentaires);

-- Zoulou est mort
DELETE FROM Animal 
WHERE nom = 'Zoulou';

-- Pataud devient Pataude
UPDATE Animal 
SET sexe='F', nom='Pataude' 
WHERE id=21;

CREATE TABLE Espece (
    id SMALLINT UNSIGNED AUTO_INCREMENT,
    nom_courant VARCHAR(40) NOT NULL,
    nom_latin VARCHAR(40) NOT NULL UNIQUE, #On met un index UNIQUE  sur la colonne nom_latin pour être sûr que l'on ne rentrera pas deux fois la même espèce. 
    description TEXT,
    PRIMARY KEY(id)
)
ENGINE=InnoDB;

INSERT INTO Espece (nom_courant, nom_latin, description) VALUES
    ('Chien', 'Canis canis', 'Bestiole à quatre pattes qui aime les caresses et tire souvent la langue'),
    ('Chat', 'Felis silvestris', 'Bestiole à quatre pattes qui saute très haut et grimpe aux arbres'),
    ('Tortue d''Hermann', 'Testudo hermanni', 'Bestiole avec une carapace très dure'),
    ('Perroquet amazone', 'Alipiopsitta xanthops', 'Joli oiseau parleur vert et jaune');

-- Ajout d'une colonne espece_id
ALTER TABLE Animal ADD COLUMN espece_id SMALLINT UNSIGNED; -- même type que la colonne id de Espece

-- Remplissage de espece_id
UPDATE Animal SET espece_id = 1 WHERE espece = 'chien';
UPDATE Animal SET espece_id = 2 WHERE espece = 'chat';
UPDATE Animal SET espece_id = 3 WHERE espece = 'tortue';
UPDATE Animal SET espece_id = 4 WHERE espece = 'perroquet';

-- Suppression de la colonne espece
ALTER TABLE Animal DROP COLUMN espece;

-- Ajout de la clé étrangère
ALTER TABLE Animal
ADD CONSTRAINT fk_espece_id FOREIGN KEY (espece_id) REFERENCES Espece(id);



-- On ajoute une contrainte NOT NULL sur espece_id
ALTER TABLE Animal MODIFY espece_id SMALLINT UNSIGNED NOT NULL; #Après tout, si espece ne pouvait pas être NULL, pas de raison qu'espece_id puisse l'être ! 

CREATE UNIQUE INDEX ind_uni_nom_espece_id ON Animal (nom, espece_id);
# Notez qu'il n'était pas possible de mettre la contrainte NOT NULL  à la création de la colonne, puisque, tant que l'on n'avait pas rempli espece_id, elle contenait NULL  pour toutes les lignes.

-- --------------------------
-- CREATION DE  LA TABLE Race
-- --------------------------
CREATE TABLE Race (
    id SMALLINT UNSIGNED AUTO_INCREMENT,
    nom VARCHAR(40) NOT NULL,
    espece_id SMALLINT UNSIGNED NOT NULL,     -- pas de nom latin, mais une référence vers l'espèce
    description TEXT,
    PRIMARY KEY(id),
    CONSTRAINT fk_race_espece_id FOREIGN KEY (espece_id) REFERENCES Espece(id)  -- pour assurer l'intégrité de la référence
)
ENGINE = InnoDB;

-- -----------------------
-- REMPLISSAGE DE LA TABLE
-- -----------------------
INSERT INTO Race (nom, espece_id, description)
VALUES ('Berger allemand', 1, 'Chien sportif et élégant au pelage dense, noir-marron-fauve, noir ou gris.'),
('Berger blanc suisse', 1, 'Petit chien au corps compact, avec des pattes courtes mais bien proportionnées et au pelage tricolore ou bicolore.'),
('Boxer', 1, 'Chien de taille moyenne, au poil ras de couleur fauve ou bringé avec quelques marques blanches.'),
('Bleu russe', 2, 'Chat aux yeux verts et à la robe épaisse et argentée.'),
('Maine coon', 2, 'Chat de grande taille, à poils mi-longs.'),
('Singapura', 2, 'Chat de petite taille aux grands yeux en amandes.'),
('Sphynx', 2, 'Chat sans poils.');

-- ---------------------------------------------
-- AJOUT DE LA COLONNE race_id A LA TABLE Animal
-- ---------------------------------------------
ALTER TABLE Animal ADD COLUMN race_id SMALLINT UNSIGNED;

ALTER TABLE Animal
ADD CONSTRAINT fk_race_id FOREIGN KEY (race_id) REFERENCES Race(id);

-- -------------------------
-- REMPLISSAGE DE LA COLONNE
-- -------------------------
UPDATE Animal SET race_id = 1 WHERE id IN (1, 13, 20, 18, 22, 25, 26, 28);
UPDATE Animal SET race_id = 2 WHERE id IN (12, 14, 19, 7);
UPDATE Animal SET race_id = 3 WHERE id IN (17, 21, 27);
UPDATE Animal SET race_id = 4 WHERE id IN (33, 35, 37, 41, 44, 31, 3);
UPDATE Animal SET race_id = 5 WHERE id IN (43, 40, 30, 32, 42, 34, 39, 8);
UPDATE Animal SET race_id = 6 WHERE id IN (29, 36, 38);

-- -------------------------------------------------------
-- AJOUT DES COLONNES mere_id ET pere_id A LA TABLE Animal
-- -------------------------------------------------------
ALTER TABLE Animal ADD COLUMN mere_id SMALLINT UNSIGNED;

ALTER TABLE Animal
ADD CONSTRAINT fk_mere_id FOREIGN KEY (mere_id) REFERENCES Animal(id);

ALTER TABLE Animal ADD COLUMN pere_id SMALLINT UNSIGNED;

ALTER TABLE Animal
ADD CONSTRAINT fk_pere_id FOREIGN KEY (pere_id) REFERENCES Animal(id);

-- -------------------------------------------
-- REMPLISSAGE DES COLONNES mere_id ET pere_id
-- -------------------------------------------
UPDATE Animal SET mere_id = 18, pere_id = 22 WHERE id = 1;
UPDATE Animal SET mere_id = 7, pere_id = 21 WHERE id = 10;
UPDATE Animal SET mere_id = 41, pere_id = 31 WHERE id = 3;
UPDATE Animal SET mere_id = 40, pere_id = 30 WHERE id = 2;

-- --------------------------------------
--  Insertion de Yoda, le Main coon
-- ------------------------------------

INSERT INTO Animal 
    (nom, sexe, date_naissance, race_id, espece_id)              
    -- Je précise les colonnes puisque je ne donne pas une valeur pour toutes.
SELECT  'Yoda', 'M', '2010-11-09', id AS race_id, espece_id     
    -- Attention à l'ordre !
FROM Race WHERE nom = 'Maine coon';

-- --------------------------------------------
-- Ajouter un commentaire à tous les perroquets
-- --------------------------------------------
UPDATE Animal SET commentaires = 'Coco veut un gâteau !'
 WHERE espece_id = (
    SELECT id FROM Espece WHERE nom_courant LIKE 'Perroquet%'
    );

-- ------------------------
-- Nouvelle race : Nebelung
-- ------------------------
INSERT INTO Race (nom, espece_id, description)
VALUES ('Nebelung', 2, 'Chat bleu russe, mais avec des poils longs...');

# Modification de Cawette
UPDATE Animal
SET race_id = (
    SELECT id FROM Race WHERE nom = 'Nebelung' AND espece_id = 2)
WHERE nom = 'Cawette';

-- Animal.mere_id --
-- -----------------
ALTER TABLE Animal DROP FOREIGN KEY fk_mere_id;

ALTER TABLE Animal
ADD CONSTRAINT fk_mere_id FOREIGN KEY (mere_id) REFERENCES Animal(id) ON DELETE SET NULL;

-- Animal.pere_id --
-- -----------------
ALTER TABLE Animal DROP FOREIGN KEY fk_pere_id;

ALTER TABLE Animal
ADD CONSTRAINT fk_pere_id FOREIGN KEY (pere_id) REFERENCES Animal(id) ON DELETE SET NULL;

-- Race.espece_id --
-- -----------------
ALTER TABLE Race DROP FOREIGN KEY fk_race_espece_id;

ALTER TABLE Race
ADD CONSTRAINT fk_race_espece_id FOREIGN KEY (espece_id) REFERENCES Espece(id) ON DELETE CASCADE;