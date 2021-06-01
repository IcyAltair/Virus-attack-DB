--delete "DROP TABLE" before get ready
/*
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
*/
--TODO add "IF NOT EXISTS" to "CREATE TABLE" after get ready

CREATE TABLE IF NOT EXISTS Virus(
	ID_V				SERIAL 			PRIMARY KEY NOT NULL,
	name_				VARCHAR(100)	NOT NULL,
	environment			VARCHAR(100)	NOT NULL,
	type_of_algorithm	VARCHAR(100)	NOT NULL,
	polymorphism		INT				NOT NULL,
	metamorphism		INT				NOT NULL,	
	danger_lvl			INT				NOT NULL,
	CHECK (danger_lvl>=0 AND danger_lvl <=5),
	CHECK (polymorphism=0 OR polymorphism=1),
	CHECK (metamorphism=0 OR metamorphism=1)
);

CREATE TABLE IF NOT EXISTS InfectStratDict(
	ID_S				SERIAL				PRIMARY KEY NOT NULL,
	strat				VARCHAR(100) 	NOT NULL
);

CREATE TABLE IF NOT EXISTS InfectStratMany(
	ID_VS				INT				PRIMARY KEY NOT NULL,
	ID_V				INT				NOT NULL,
	ID_S				INT				NOT NULL,
	FOREIGN KEY(ID_V) REFERENCES Virus(ID_V),
	FOREIGN KEY(ID_S) REFERENCES InfectStratDict(ID_S)
	--PRIMARY KEY (ID_V,ID_S)
);

CREATE TABLE IF NOT EXISTS InfectWayDict(
	ID_I				SERIAL				PRIMARY KEY NOT NULL,
	way					VARCHAR(100)	NOT NULL
);

CREATE TABLE IF NOT EXISTS InfectWayMany(
	ID_VI				INT				PRIMARY KEY NOT NULL,
	ID_V				INT				NOT NULL,
	ID_I				INT				NOT NULL,
	FOREIGN KEY(ID_V) REFERENCES Virus(ID_V),
	FOREIGN KEY(ID_I) REFERENCES InfectWayDict(ID_I)
	--PRIMARY KEY (ID_V,ID_I)
);

CREATE TABLE IF NOT EXISTS DisgWayDict(
	ID_D				SERIAL				PRIMARY KEY NOT NULL,
	protection			VARCHAR(100)	NOT NULL	
);

CREATE TABLE IF NOT EXISTS DisgWayMany(
	ID_VD				INT				PRIMARY KEY NOT NULL,
	ID_V				INT				NOT NULL,
	ID_D				INT				NOT NULL,
	FOREIGN KEY(ID_V) REFERENCES Virus(ID_V),
	FOREIGN KEY(ID_D) REFERENCES DisgWayDict(ID_D)
	--PRIMARY KEY (ID_V,ID_D)
);

CREATE TABLE IF NOT EXISTS Architecture(
	ID_ARCH				SERIAL				PRIMARY KEY NOT NULL,
	type_				VARCHAR(100)	NOT NULL
);

CREATE TABLE IF NOT EXISTS Area(
	ID_AR				SERIAL			PRIMARY KEY NOT NULL,
	type_				VARCHAR(100)	NOT NULL
);

CREATE TABLE IF NOT EXISTS Mechanism(
	ID_MECH				SERIAL				PRIMARY KEY NOT NULL,
	ID_AR				INT				NOT NULL,
	kind				VARCHAR(100)	NOT NULL,
	algorithm			VARCHAR(100)	NOT NULL,
	FOREIGN KEY(ID_AR) REFERENCES Area(ID_AR)
);

CREATE TABLE IF NOT EXISTS Protection(
	ID_P				SERIAL				PRIMARY KEY NOT NULL,
	ID_MECH				INT				NOT NULL,
	name_				VARCHAR(100)	NOT NULL,
	version_			VARCHAR(100)	NOT NULL,
	FOREIGN KEY(ID_MECH) REFERENCES Mechanism(ID_MECH)
);

CREATE TABLE IF NOT EXISTS System_(
	ID_SYS				SERIAL				PRIMARY KEY NOT NULL,
	ID_ARCH				INT				NOT NULL,
	name_				VARCHAR(100)	NOT NULL,
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

CREATE TABLE IF NOT EXISTS InfectReg(
	ID_MAIN				SERIAL				PRIMARY KEY NOT NULL,
	ID_V				INT				NOT NULL,
	ID_SYS				INT				NOT NULL,
	time_				DATE			NOT NULL,
	damage_				VARCHAR(100)	NOT NULL,
	user_				VARCHAR(100)	NOT NULL,
	FOREIGN KEY(ID_V) REFERENCES Virus(ID_V),
	FOREIGN KEY(ID_SYS) REFERENCES System_(ID_SYS)
);

CREATE TABLE IF NOT EXISTS Setup(
	ID_SET				INT				PRIMARY KEY NOT NULL,
	ID_SYS				INT				NOT NULL,
	ID_P				INT				NOT NULL,
	FOREIGN KEY(ID_SYS) REFERENCES System_(ID_SYS),
	FOREIGN KEY(ID_P) REFERENCES Protection(ID_P)
);
/*
INSERT INTO InfectStratDict VALUES(1, 'on conditionals');
INSERT INTO InfectStratDict VALUES(2, 'on objects');
*/
--SELECT * FROM InfectStratDict

/*
INSERT INTO InfectWayDict VALUES(1, 'resident');
INSERT INTO InfectWayDict VALUES(2, 'non resident');
*/
--SELECT * FROM InfectWayDict

/*
INSERT INTO DisgWayDict VALUES(1, 'viewer protection');
INSERT INTO DisgWayDict VALUES(2, 'detection protection');
*/
--SELECT * FROM DisgWayDict

/*
INSERT INTO Architecture VALUES(1,'CISC');
INSERT INTO Architecture VALUES(2, 'RISC');
INSERT INTO Architecture VALUES(3, 'MISC');
INSERT INTO Architecture VALUES(4, 'VLIW');
*/
--SELECT * FROM Architecture

/*
INSERT INTO Area VALUES(1, 'software');
INSERT INTO Area VALUES(2, 'hardware');
INSERT INTO Area VALUES(3, 'software and hardware');
*/
--SELECT * FROM Area;

/*
INSERT INTO Mechanism VALUES(1, 1, 'file scanner', 'signature analysis');
INSERT INTO Mechanism VALUES(2, 1, 'process detection', 'signature analysis');
INSERT INTO Mechanism VALUES(3, 1, 'process detection', 'heuristic analysis');
INSERT INTO Mechanism VALUES(4, 1, 'firewall', 'honeypot');
INSERT INTO Mechanism VALUES(5, 3, 'firewall', 'anomaly detection');
INSERT INTO Mechanism VALUES(6, 3, 'hypervisor protection', 'set of rules');
INSERT INTO Mechanism VALUES(7, 2, 'data protection', 'checksum');
INSERT INTO Mechanism VALUES(8, 2, 'system protection', 'biometrics');
INSERT INTO Mechanism VALUES(9, 2, 'BIOS/UEFFI protection', 'crypto module');
INSERT INTO Mechanism VALUES(10, 2, 'resilience', 'warranty lock');
INSERT INTO Mechanism VALUES(11, 3, 'protection against unauthorized access', 'security model');
INSERT INTO Mechanism VALUES(12, 3, 'network protection', 'set of rules and crypto module');
*/
--SELECT * FROM Mechanism

/*
INSERT INTO Protection VALUES(1, 1, 'Staffcop Enterprise', '4.9');
INSERT INTO Protection VALUES(2, 2, 'Kaspersky Anti-Virus', '21.3');
INSERT INTO Protection VALUES(3, 3, 'ESET NOD 32', '19.1');
INSERT INTO Protection VALUES(4, 4, 'Kaspersky Endpoint Security Cloud', '11.3');
INSERT INTO Protection VALUES(5, 5, 'Cisco NGFW', '7.3');
INSERT INTO Protection VALUES(6, 6, 'VMware', '2.3');
INSERT INTO Protection VALUES(7, 7, 'Crypto Pro CSP', '12.7');
INSERT INTO Protection VALUES(8, 8, 'KYC check', '1.2');
INSERT INTO Protection VALUES(9, 9, 'Secure Boot', '1.0');
INSERT INTO Protection VALUES(10, 10, 'Build checker', '1.0');
INSERT INTO Protection VALUES(11, 11, 'Dallas Lock', '8.0-K');
INSERT INTO Protection VALUES(12, 12, 'Cisco Umbrella', '2.7');
*/
--SELECT * FROM Protection

--DROP TABLE OS;
CREATE TABLE IF NOT EXISTS OS(
	ID_				SERIAL				PRIMARY KEY,
	name_ VARCHAR(100)
); --temporary table
/*
INSERT INTO OS(name_) VALUES('Windows 10 x86');
INSERT INTO OS(name_) 
VALUES
('Windows 10 x64'),
('Linux Ubuntu 18.04'),
('Linux Ubuntu 16.04'),
('Linux Ubuntu 12.04'),
('Kali Linux'),
('CentOS'),
('Red Hat Linux'),
('Debian'),
('OS X'),
('MAC OS'),
('Free BSD'),
('Solaris'),
('Windows Server 2012'),
('Windows XP'),
('Windows 2000'),
('Windows ME'),
('Windows 7'),
('Windows 8'),
('Windows Vista'),
('Windows 8.1');
INSERT INTO OS(name_) 
VALUES
('Free DOS'),
('Amiga OS'),
('ReactOS'),
('DOS');
*/
--SELECT * FROM OS
CREATE TABLE IF NOT EXISTS UpdateVersion(
	ID_				SERIAL				PRIMARY KEY,
	name_ VARCHAR(100)
); --temporary table
/*
INSERT INTO UpdateVersion(name_) 
VALUES
('Up to date'),
('Stable'),
('Beta'),
('Custom mode'),
('First release'),
('Zero trust'),
('Unknown'),
('Unique build'),
('With dependencies'),
('Test release');
*/
--SELECT * FROM UpdateVersion
CREATE TABLE IF NOT EXISTS CPU(
	ID_				SERIAL				PRIMARY KEY,
	name_ VARCHAR(100)
); --temporary table
/*
INSERT INTO CPU(name_) 
VALUES
('AMD Ryzen 5 1600'),
('AMD Ryzen 5 2600'),
('AMD Ryzen 5 3600'),
('AMD Ryzen 7 1700'),
('AMD Ryzen 7 2700'),
('AMD Ruzen 7 3700'),
('AMD Ryzen 7 3800'),
('AMD Ryzen 9 3900'),
('AMD Ryzen 9 3950'),
('AMD Ruzen 7 3700X'),
('AMD Ruzen 7 3800X'),
('AMD Ryzen 9 3900X'),
('AMD Ryzen 9 3950X'),
('AMD Ryzen Threadripper 3960X'),
('AMD Ryzen Threadripper 3970X'),
('AMD Ryzen Threadripper 3990X'),
('AMD EPYC 7232P'),
('AMD EPYC 7302P'),
('AMD EPYC 7402P'),
('AMD EPYC 7502P'),
('AMD EPYC 7252'),
('AMD EPYC 7262'),
('AMD EPYC 7272'),
('AMD EPYC 7282'),
('AMD EPYC 7352');
*/
--SELECT * FROM CPU



