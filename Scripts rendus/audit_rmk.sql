CREATE TABLE audit(
	id INT NOT NULL AUTO_INCREMENT,
	nom VARCHAR(20),
	date DATE,
	PRIMARY KEY(id)
	);
	
INSERT INTO audit VALUES (NULL, 'premierAudit', CURDATE());

CREATE TABLE instance (
	id INT NOT NULL AUTO_INCREMENT,
	idAudit INT,
	nbUtilisateurs INT,
	nbDatafiles INT,
	nbLogfiles INT,
	nbCtrlFiles INT,
	tailleSGA REAL,
	nbTablespaces INT,
	nbSegments INT,
	nbExtents INT,
	nbBlocs INT,
	tailleBlocs INT,
	nbVues INT,
	PRIMARY KEY (id),
	FOREIGN KEY (idAudit)
	REFERENCES audit(id)
	);

CREATE TABLE serveur (
	id INT NOT NULL AUTO_INCREMENT,
	idInstance INT,
	nom VARCHAR(50),
	version VARCHAR(50),
	PRIMARY KEY (id),
	FOREIGN KEY (idInstance)
	REFERENCES instance(id)
	);
		
	
CREATE TABLE table_(
	id INT NOT NULL AUTO_INCREMENT,
	idInstance INT,
	nomTable VARCHAR(70),
	owner VARCHAR(70),
	nbIndex INT,
	hasPK INT,
	nbEntrees INT,
	nbFK INT,
	PRIMARY KEY (id),
	FOREIGN KEY (idInstance)
	REFERENCES instance(id)
	);
	
	
CREATE TABLE colonne(
	nom VARCHAR(70),
	idTable INT,
	nbValeursNULL INT,
	nbValeursDifferentes INT,
	largeurColonne INT,
	type VARCHAR(50),
	nomTable VARCHAR(70),
	owner VARCHAR(70),
	PRIMARY KEY (nom, idTable, nomTable, owner),
	FOREIGN KEY (idTable)
	REFERENCES table_(id)
	);