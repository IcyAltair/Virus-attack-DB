--delete "DROP TABLE" before get ready
DROP TABLE IF EXISTS Virus CASCADE;
DROP TABLE IF EXISTS InfectStratDict CASCADE;
DROP TABLE IF EXISTS InfectStratMany CASCADE;
DROP TABLE IF EXISTS InfectWayDict CASCADE;
DROP TABLE IF EXISTS InfectWayMany CASCADE;
DROP TABLE IF EXISTS DisgWayDict CASCADE;
DROP TABLE IF EXISTS DisgWayMany CASCADE;
DROP TABLE IF EXISTS Architecture CASCADE;
DROP TABLE IF EXISTS Protection CASCADE;
DROP TABLE IF EXISTS Area CASCADE;
DROP TABLE IF EXISTS Mechanism CASCADE;
DROP TABLE IF EXISTS System_ CASCADE;
DROP TABLE IF EXISTS InfectReg CASCADE;
DROP TABLE IF EXISTS Setup CASCADE;

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
	ID_VS				INT				PRIMARY KEY NOT NULL,
	ID_V				INT				NOT NULL,
	ID_S				INT				NOT NULL,
	FOREIGN KEY(ID_V) REFERENCES Virus(ID_V),
	FOREIGN KEY(ID_S) REFERENCES InfectStratDict(ID_S)
	--PRIMARY KEY (ID_V,ID_S)
);

CREATE TABLE InfectWayDict(
	ID_I				INT				PRIMARY KEY NOT NULL,
	way					VARCHAR(100)	NOT NULL
);

CREATE TABLE InfectWayMany(
	ID_VI				INT				PRIMARY KEY NOT NULL,
	ID_V				INT				NOT NULL,
	ID_I				INT				NOT NULL,
	FOREIGN KEY(ID_V) REFERENCES Virus(ID_V),
	FOREIGN KEY(ID_I) REFERENCES InfectWayDict(ID_I)
	--PRIMARY KEY (ID_V,ID_I)
);

CREATE TABLE DisgWayDict(
	ID_D				INT				PRIMARY KEY NOT NULL,
	view_prot			INT 			NOT NULL,
	detect_prot			INT				NOT NULL,
	CHECK (view_prot=0 OR view_prot=1),
	CHECK (detect_prot=0 OR detect_prot=1)	
);

CREATE TABLE DisgWayMany(
	ID_VD				INT				PRIMARY KEY NOT NULL,
	ID_V				INT				NOT NULL,
	ID_D				INT				NOT NULL,
	FOREIGN KEY(ID_V) REFERENCES Virus(ID_V),
	FOREIGN KEY(ID_D) REFERENCES DisgWayDict(ID_D)
	--PRIMARY KEY (ID_V,ID_D)
);

CREATE TABLE Architecture(
	ID_ARCH				INT				PRIMARY KEY NOT NULL,
	type_				VARCHAR(100)	NOT NULL
);

CREATE TABLE Area(
	ID_AR				INT				PRIMARY KEY NOT NULL,
	type_				VARCHAR(100)	NOT NULL
);

CREATE TABLE Mechanism(
	ID_MECH				INT				PRIMARY KEY NOT NULL,
	ID_AR				INT				NOT NULL,
	kind				VARCHAR(100)	NOT NULL,
	algorithm			VARCHAR(100)	NOT NULL,
	FOREIGN KEY(ID_AR) REFERENCES Area(ID_AR)
);

CREATE TABLE Protection(
	ID_P				INT				PRIMARY KEY NOT NULL,
	ID_MECH				INT				NOT NULL,
	name_				VARCHAR(100)	NOT NULL,
	version_			VARCHAR(100)	NOT NULL,
	FOREIGN KEY(ID_MECH) REFERENCES Mechanism(ID_MECH)
);

CREATE TABLE System_(
	ID_SYS				INT				PRIMARY KEY NOT NULL,
	ID_ARCH				INT				NOT NULL,
	OS_type				VARCHAR(100)	NOT NULL,
	upd_version			VARCHAR(100)	NOT NULL,
	time_usage			VARCHAR(100)	NOT NULL,
	cpu					VARCHAR(100)	NOT NULL,
	gpu					VARCHAR(100)	NOT NULL,
	ram					VARCHAR(100)	NOT NULL,
	rom					VARCHAR(100)	NOT NULL,
	network				VARCHAR(100)	NOT NULL,
	mother				VARCHAR(100)	NOT NULL,
	ueffi_bios			VARCHAR(100)	NOT NULL,
	FOREIGN KEY(ID_ARCH) REFERENCES Architecture(ID_ARCH)
);

CREATE TABLE InfectReg(
	ID_MAIN				INT				PRIMARY KEY NOT NULL,
	ID_V				INT				NOT NULL,
	ID_SYS				INT				NOT NULL,
	time_				DATE			NOT NULL,
	damage_				VARCHAR(100)	NOT NULL,
	user_				VARCHAR(100)	NOT NULL,
	FOREIGN KEY(ID_V) REFERENCES Virus(ID_V),
	FOREIGN KEY(ID_SYS) REFERENCES System_(ID_SYS)
);

CREATE TABLE Setup(
	ID_SET				INT				PRIMARY KEY NOT NULL,
	ID_SYS				INT				NOT NULL,
	ID_P				INT				NOT NULL,
	FOREIGN KEY(ID_SYS) REFERENCES System_(ID_SYS),
	FOREIGN KEY(ID_P) REFERENCES Protection(ID_P)
)

