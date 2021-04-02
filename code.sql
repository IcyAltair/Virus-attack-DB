--delete "DROP TABLE" before get ready
DROP TABLE IF EXISTS Virus CASCADE;
DROP TABLE IF EXISTS InfectStratDict CASCADE;
DROP TABLE IF EXISTS InfectStratMany CASCADE;
DROP TABLE IF EXISTS InfectWayDict CASCADE;
DROP TABLE IF EXISTS InfectWayMany CASCADE;
DROP TABLE IF EXISTS DisgWayDict CASCADE;
DROP TABLE IF EXISTS DisgWayMany CASCADE;

--TODO add "IF NOT EXISTS" to "CREATE TABLE" after get ready

CREATE TABLE Virus(
	ID_V				INT 			PRIMARY KEY NOT NULL,
	environment			VARCHAR(100)	NOT NULL,
	type_of_algorithm	VARCHAR(100)	NOT NULL,
	polymorphism		INT				NOT NULL,
	metamorphism		INT				NOT NULL,	
	danger_lvl			INT				NOT NULL,
	CHECK (danger_lvl>=0 AND danger_lvl <=5),
	CHECK (polymorphism=0 OR polymorphism=1),
	CHECK (metamorphism=0 OR metamorphism=1)
);

CREATE TABLE InfectStratDict(
	ID_S				INT				PRIMARY KEY NOT NULL,
	strat				VARCHAR(100) 	NOT NULL
);

CREATE TABLE InfectStratMany(
	ID_V				INT				NOT NULL,
	ID_S				INT				NOT NULL,
	FOREIGN KEY(ID_V) REFERENCES Virus(ID_V),
	FOREIGN KEY(ID_S) REFERENCES InfectStratDict(ID_S),
	PRIMARY KEY (ID_V,ID_S)
);

CREATE TABLE InfectWayDict(
	ID_I				INT				PRIMARY KEY NOT NULL,
	way					VARCHAR(100)	NOT NULL
);

CREATE TABLE InfectWayMany(
	ID_V				INT				NOT NULL,
	ID_I				INT				NOT NULL,
	FOREIGN KEY(ID_V) REFERENCES Virus(ID_V),
	FOREIGN KEY(ID_I) REFERENCES InfectWayDict(ID_I),
	PRIMARY KEY (ID_V,ID_I)
);

CREATE TABLE DisgWayDict(
	ID_D				INT			PRIMARY KEY NOT NULL,
	view_prot			INT 		NOT NULL,
	detect_prot			INT			NOT NULL,
	CHECK (view_prot=0 OR view_prot=1),
	CHECK (detect_prot=0 OR detect_prot=1)	
);

CREATE TABLE DisgWayMany(
	ID_V				INT			NOT NULL,
	ID_D				INT			NOT NULL,
	FOREIGN KEY(ID_V) REFERENCES Virus(ID_V),
	FOREIGN KEY(ID_D) REFERENCES DisgWayDict(ID_D),
	PRIMARY KEY (ID_V,ID_D)
);

CREATE TABLE InfectReg(
	ID_MAIN				INT				PRIMARY KEY NOT NULL,
	ID_V				INT				NOT NULL,
	ID_SYS				INT				NOT NULL,
	time_				DATE			NOT NULL,
	damage_				VARCHAR(100)	NOT NULL,
	user_				VARCHAR(100)	NOT NULL,
	FOREIGN KEY(ID_V) REFERENCES Virus(ID_V)
	--FOREIGN KEY(ID_SYS) REFERENCES DisgW(ID_SYS)
)