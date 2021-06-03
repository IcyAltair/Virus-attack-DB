CREATE OR REPLACE FUNCTION f_random_sample(_limit int = 1000, _gaps real = 1.03)
  RETURNS SETOF OS
  LANGUAGE plpgsql VOLATILE ROWS 1000 AS
$func$
DECLARE
   _surplus  int := _limit * _gaps;
   _estimate int := (           
      SELECT c.reltuples * _gaps
      FROM   pg_class c
      WHERE  c.oid = 'OS'::regclass);
BEGIN
   RETURN QUERY
   WITH RECURSIVE random_pick AS (
      SELECT *
      FROM  (
         SELECT 1 + trunc(random() * _estimate)::int
         FROM   generate_series(1, _surplus) g
         LIMIT  _surplus           
         ) r (ID_)
      JOIN   OS USING (ID_)        

      UNION                        
      SELECT *
      FROM  (
         SELECT 1 + trunc(random() * _estimate)::int
         FROM   random_pick        
         LIMIT  _limit             
         ) r (ID_)
      JOIN   OS USING (ID_)        
   )
   TABLE  random_pick
   LIMIT  _limit;
END
$func$;
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
	environment			VARCHAR(100)	,
	type_of_algorithm	VARCHAR(100)	,
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
	ID_VS				SERIAL			PRIMARY KEY NOT NULL,
	ID_V				INT				,
	ID_S				INT				,
	FOREIGN KEY(ID_V) REFERENCES Virus(ID_V),
	FOREIGN KEY(ID_S) REFERENCES InfectStratDict(ID_S)
	--PRIMARY KEY (ID_V,ID_S)
);

CREATE TABLE IF NOT EXISTS InfectWayDict(
	ID_I				SERIAL				PRIMARY KEY NOT NULL,
	way					VARCHAR(100)	NOT NULL
);

CREATE TABLE IF NOT EXISTS InfectWayMany(
	ID_VI				SERIAL			PRIMARY KEY NOT NULL,
	ID_V				INT				,
	ID_I				INT				,
	FOREIGN KEY(ID_V) REFERENCES Virus(ID_V),
	FOREIGN KEY(ID_I) REFERENCES InfectWayDict(ID_I)
	--PRIMARY KEY (ID_V,ID_I)
);

CREATE TABLE IF NOT EXISTS DisgWayDict(
	ID_D				SERIAL				PRIMARY KEY NOT NULL,
	protection			VARCHAR(100)	NOT NULL	
);

CREATE TABLE IF NOT EXISTS DisgWayMany(
	ID_VD				SERIAL			PRIMARY KEY NOT NULL,
	ID_V				INT				,
	ID_D				INT				,
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
	ID_ARCH				INT				,
	name_				TEXT			,
	OS_type				VARCHAR(100)	,
	upd_version			VARCHAR(100)	,
	time_usage			INT				,
	cpu					VARCHAR(100)	,
	gpu					VARCHAR(100)	,
	ram					VARCHAR(100)	,
	rom					VARCHAR(100)	,
	network				VARCHAR(100)	,
	mother				VARCHAR(100)	,
	ueffi_bios			VARCHAR(100)	,
	FOREIGN KEY(ID_ARCH) REFERENCES Architecture(ID_ARCH)
);

CREATE TABLE IF NOT EXISTS InfectReg(
	ID_MAIN				SERIAL				PRIMARY KEY NOT NULL,
	ID_V				INT				,
	ID_SYS				INT				,
	time_				DATE			NOT NULL,
	damage_				INT				NOT NULL,
	user_				VARCHAR(50)		NOT NULL,
	FOREIGN KEY(ID_V) REFERENCES Virus(ID_V),
	FOREIGN KEY(ID_SYS) REFERENCES System_(ID_SYS)
);

CREATE TABLE IF NOT EXISTS Setup(
	ID_SET				SERIAL			PRIMARY KEY NOT NULL,
	ID_SYS				INT				,
	ID_P				INT				,
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
('AMD Ryzen 7 3700'),
('AMD Ryzen 7 3800'),
('AMD Ryzen 9 3900'),
('AMD Ryzen 9 3950'),
('AMD Ryzen 7 3700X'),
('AMD Ryzen 7 3800X'),
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
CREATE TABLE IF NOT EXISTS GPU(
	ID_				SERIAL				PRIMARY KEY,
	name_ VARCHAR(100)
); --temporary table
/*
INSERT INTO GPU(name_) 
VALUES
('NVIDIA GTX 1050'),
('NVIDIA GTX 1050 Ti'),
('NVIDIA GTX 1060'),
('NVIDIA GTX 1060 Ti'),
('NVIDIA GTX 1070 Ti'),
('NVIDIA GTX 1080'),
('NVIDIA GTX 1080 Ti'),
('NVIDIA GTX 1650'),
('NVIDIA GTX 1650 Super'),
('NVIDIA GTX 1660'),
('NVIDIA GTX 1660 Super'),
('NVIDIA GTX 1660 Ti'),
('NVIDIA RTX 2060'),
('NVIDIA RTX 2060 Super'),
('NVIDIA RTX 2070'),
('NVIDIA RTX 2070 Super'),
('NVIDIA RTX 2080'),
('NVIDIA RTX 2080 Super'),
('NVIDIA RTX 2080 Ti'),
('NVIDIA Titan RTX'),
('NVIDIA Tesla V100'),
('NVIDIA Tesla K20'),
('NVIDIA Tesla K40'),
('AMD RADEON VII');
INSERT INTO GPU(name_) VALUES('AMD Embedded RADEON E9260 MXM Module');
*/
--SELECT * FROM GPU

CREATE TABLE IF NOT EXISTS RAM(
	ID_				SERIAL				PRIMARY KEY,
	name_ VARCHAR(100)
); --temporary table
/*
INSERT INTO RAM(name_)
VALUES
('4 Gb'),
('8 Gb'),
('16 Gb'),
('32 Gb'),
('64 Gb'),
('128 Gb'),
('256 Gb'),
('512 Gb'),
('1 Tb');
INSERT INTO RAM(name_) VALUES ('2 Tb');
*/
--SELECT * FROM RAM
CREATE TABLE IF NOT EXISTS ROM(
	ID_				SERIAL				PRIMARY KEY,
	name_ VARCHAR(100)
); --temporary table
/*
INSERT INTO ROM(name_)
VALUES
('128 Gb SSD + 512 Gb HDD'),
('256 Gb SSD + 1 Tb HDD'),
('512 Gb SSD + 1 Tb HDD'),
('512 Gb SSD + 2 Tb HDD'),
('1 Tb SSD + 1 Tb HDD'),
('1 Tb SSD + 2 Tb HDD'),
('2 Tb SSD + 4 Tb HDD'),
('2 Tb SSD + 8 Tb HDD'),
('4 Tb SSD + 16 Tb HDD'),
('4 Tb SSD + 32 Tb HDD');
*/
--SELECT * FROM ROM;
CREATE TABLE IF NOT EXISTS Network(
	ID_				SERIAL				PRIMARY KEY,
	name_ VARCHAR(100)
); --temporary table
/*
INSERT INTO Network(name_)
VALUES
('WiFi 5 + Bluetooth 4.2'),
('WiFi 5 + Bluetooth 5.0'),
('WiFi 5 + Bluetooth 5.1'),
('WiFi 5 + Bluetooth 5.2'),
('Ethernet Gigabit LAN'),
('WiFi 6 + Bluetooth 4.2'),
('WiFi 6 + Bluetooth 5.0'),
('WiFi 6 + Bluetooth 5.1'),
('WiFi 6 + Bluetooth 5.2'),
('None');
*/
--SELECT * FROM Network

CREATE TABLE IF NOT EXISTS Mother(
	ID_				SERIAL				PRIMARY KEY,
	name_ VARCHAR(100)
); --temporary table
/*
INSERT INTO Mother(name_) VALUES
('AT'),
('ATX'),
('LPX'),
('NLX'),
('Baby-AT'),
('Mini-ATX'),
('microATX'),
('microNLX'),
('Unknown'),
('Mobile stand');
*/
--SELECT * FROM Mother;

CREATE TABLE IF NOT EXISTS BIOSver(
	ID_				SERIAL				PRIMARY KEY,
	name_ VARCHAR(100)
); --temporary table
/*
INSERT INTO BIOSver(name_)
VALUES
('Stable'),
('Beta'),
('Protected'),
('OEM'),
('Up to date');
*/
--SELECT * FROM BIOSver;

--DROP TABLE System_ CASCADE
--SELECT * FROM System_

--SELECT * FROM OS TABLESAMPLE SYSTEM ((1 * 100) / 5100.0);
--SELECT * FROM OS TABLESAMPLE BERNOULLI ((1 * 100) / 5100.0);
--SELECT * FROM f_random_sample(1,1.05);
--SELECT name_ FROM OS
--SELECT name_ FROM OS ORDER BY random() LIMIT 1; --this works


--ADDING TO System_
/*
DO
$do$
BEGIN
FOR I IN 1..1000 LOOP
	INSERT INTO System_(ID_ARCH)
	SELECT trunc(random() * 4 + 1);

	UPDATE System_
	SET name_ = md5(random()::TEXT),
	OS_type = subquery.name_
	FROM (SELECT name_ FROM OS ORDER BY random() LIMIT 1) AS subquery
	WHERE ID_SYS = I;

	UPDATE System_
	SET upd_version = subquery.name_
	FROM (SELECT name_ FROM UpdateVersion ORDER BY random() LIMIT 1) AS subquery
	WHERE ID_SYS = I;

	UPDATE System_
	SET time_usage = trunc(random() * 1000 + 100),
	cpu = subquery.name_
	FROM (SELECT name_ FROM CPU ORDER BY random() LIMIT 1) AS subquery
	WHERE ID_SYS = I;
	
	UPDATE System_
	SET gpu = subquery.name_
	FROM (SELECT name_ FROM GPU ORDER BY random() LIMIT 1) AS subquery
	WHERE ID_SYS = I;

	UPDATE System_
	SET ram = subquery.name_
	FROM (SELECT name_ FROM RAM ORDER BY random() LIMIT 1) AS subquery
	WHERE ID_SYS = I;

	UPDATE System_
	SET rom = subquery.name_
	FROM (SELECT name_ FROM ROM ORDER BY random() LIMIT 1) AS subquery
	WHERE ID_SYS = I;

	UPDATE System_
	SET network = subquery.name_
	FROM (SELECT name_ FROM Network ORDER BY random() LIMIT 1) AS subquery
	WHERE ID_SYS = I;

	UPDATE System_
	SET mother = subquery.name_
	FROM (SELECT name_ FROM Mother ORDER BY random() LIMIT 1) AS subquery
	WHERE ID_SYS = I;

	UPDATE System_
	SET ueffi_bios = subquery.name_
	FROM (SELECT name_ FROM BIOSver ORDER BY random() LIMIT 1) AS subquery
	WHERE ID_SYS = I;
END LOOP;
END
$do$;
*/
CREATE UNIQUE INDEX IF NOT EXISTS SysName ON System_ (name_);
CREATE INDEX IF NOT EXISTS SysArch ON System_ (ID_ARCH);
--SELECT * FROM System_

--DROP TABLE Virus CASCADE
CREATE TABLE IF NOT EXISTS Environment(
	ID_				SERIAL				PRIMARY KEY,
	name_ VARCHAR(100)
); --temporary table
/*
INSERT INTO Environment(name_)
VALUES
('Files'),
('Boot sectors'),
('Macrovirus'),
('Network'),
('Source codes');
*/
--SELECT * FROM Environment;

CREATE TABLE IF NOT EXISTS Algorithm(
	ID_				SERIAL				PRIMARY KEY,
	name_ VARCHAR(100)
); --temporary table
/*
INSERT INTO Algorithm(name_)
VALUES
('Companion virus'),
('Worm'),
('Parasite virus'),
('Student virus'),
('Stels virus'),
('Macro virus'),
('Net virus');
*/
--SELECT * FROM Algorithm

--ADDING TO Virus
/*
DO
$do$
BEGIN
FOR I IN 1..1000 LOOP
	INSERT INTO Virus(name_, polymorphism, metamorphism, danger_lvl)
	VALUES(md5(random()::TEXT), trunc(random() * 1 + 0), trunc(random() * 1 + 0), trunc(random() * 5 + 0));

	UPDATE Virus
	SET environment = subquery.name_
	FROM (SELECT name_ FROM Environment ORDER BY random() LIMIT 1) AS subquery
	WHERE ID_V = I;

	UPDATE Virus
	SET type_of_algorithm = subquery.name_
	FROM (SELECT name_ FROM Algorithm ORDER BY random() LIMIT 1) AS subquery
	WHERE ID_V = I;
	
END LOOP;
END
$do$;
*/
--SELECT * FROM Virus
CREATE UNIQUE INDEX IF NOT EXISTS VirusName ON Virus (name_);

--ADDING TO InfectReg takes time
/*
DO
$do$
BEGIN
FOR I IN 1..200000 LOOP
	INSERT INTO InfectReg(time_, user_, damage_)
	VALUES(timestamp '2014-01-10 20:00:00' +
       random() * (timestamp '2014-01-20 20:00:00' -
                   timestamp '2014-01-10 10:00:00'), md5(random()::TEXT), trunc(random() * 100 + 0));

	UPDATE InfectReg
	SET ID_V = subquery.ID_V	
	FROM (SELECT ID_V FROM Virus ORDER BY random() LIMIT 1) AS subquery
	WHERE ID_MAIN = I;
	
	UPDATE InfectReg
	SET ID_SYS = subquery.ID_SYS
	FROM (SELECT ID_SYS FROM System_ ORDER BY random() LIMIT 1) AS subquery
	WHERE ID_MAIN = I;
	
END LOOP;
END
$do$;
*/
--SELECT * FROM InfectReg
CREATE INDEX IF NOT EXISTS SysReg ON InfectReg (ID_SYS);
CREATE INDEX IF NOT EXISTS VirusReg ON InfectReg (ID_V);
--ADDING TO Setup and Dicts
/*
DO
$do$
BEGIN
FOR I IN 1..1000 LOOP
	INSERT INTO Setup(ID_SET)
	VALUES
	(I);
	
	INSERT INTO InfectStratMany(ID_VS)
	VALUES
	(I);
	
	INSERT INTO InfectWayMany(ID_VI)
	VALUES
	(I);
	
	INSERT INTO DisgWayMany(ID_VD)
	VALUES
	(I);
	
	UPDATE Setup
	SET ID_SYS = subquery.ID_SYS	
	FROM (SELECT ID_SYS FROM System_ ORDER BY random() LIMIT 1) AS subquery
	WHERE ID_SET = I;
	
	UPDATE Setup
	SET ID_P = subquery.ID_P
	FROM (SELECT ID_P FROM Protection ORDER BY random() LIMIT 1) AS subquery
	WHERE ID_SET = I;
	
	UPDATE InfectStratMany
	SET ID_V = subquery.ID_V
	FROM (SELECT ID_V FROM Virus ORDER BY random() LIMIT 1) AS subquery
	WHERE ID_VS = I;
	
	UPDATE InfectStratMany
	SET ID_S = subquery.ID_S
	FROM (SELECT ID_S FROM InfectStratDict ORDER BY random() LIMIT 1) AS subquery
	WHERE ID_VS = I;
	
	UPDATE InfectWayMany
	SET ID_V = subquery.ID_V
	FROM (SELECT ID_V FROM Virus ORDER BY random() LIMIT 1) AS subquery
	WHERE ID_VI = I;
	
	UPDATE InfectWayMany
	SET ID_I = subquery.ID_I
	FROM (SELECT ID_I FROM InfectWayDict ORDER BY random() LIMIT 1) AS subquery
	WHERE ID_VI = I;
	
	UPDATE DisgWayMany
	SET ID_V = subquery.ID_V
	FROM (SELECT ID_V FROM Virus ORDER BY random() LIMIT 1) AS subquery
	WHERE ID_VD = I;
	
	UPDATE DisgWayMany
	SET ID_D = subquery.ID_D
	FROM (SELECT ID_D FROM DisgWayDict ORDER BY random() LIMIT 1) AS subquery
	WHERE ID_VD = I;
	
END LOOP;
END
$do$;
*/
CREATE INDEX IF NOT EXISTS SysProt ON Setup (ID_SYS, ID_P);
CREATE INDEX IF NOT EXISTS VirusStrat ON InfectStratMany (ID_V, ID_S);
CREATE INDEX IF NOT EXISTS VirusWay ON InfectWayMany (ID_V, ID_I);
CREATE INDEX IF NOT EXISTS VirusDisg ON DisgWayMany (ID_V, ID_D);
--SELECT * FROM System_
--SELECT * FROM Setup
--SELECT * FROM InfectStratMany;
--SELECT * FROM InfectWayMany;
--SELECT * FROM DisgWayMany;

--1) найти вирусы, которые заражают системы с архитектурой А способом В и для которых применяется механизм С
/*
EXPLAIN ANALYZE SELECT InfectReg.ID_V, System_.ID_ARCH, InfectWayMany.ID_I, Protection.ID_MECH
FROM InfectReg
JOIN System_ ON System_.ID_SYS = InfectReg.ID_SYS
JOIN InfectWayMany on InfectWayMany.ID_V = InfectReg.ID_V
JOIN Setup on Setup.ID_SYS = InfectReg.ID_SYS
JOIN Protection on Protection.ID_P = Setup.ID_P
WHERE
	System_.ID_ARCH = '3' AND
	InfectWayMany.ID_I = '2' AND
	Protection.ID_MECH = '1';
*/
--2) посчитать количество систем зараженных вирусом А способом В
/*
EXPLAIN ANALYZE SELECT COUNT(InfectReg.ID_SYS)
FROM InfectReg JOIN InfectWayMany ON InfectReg.ID_V = InfectWayMany.ID_V
WHERE
InfectReg.ID_V = '777' AND
InfectWayMany.ID_I = '2';
*/
--3а)найти вирусы, заражавшие системы наибольшее число раз
/*
EXPLAIN ANALYZE WITH RES AS (SELECT COUNT(InfectReg.ID_MAIN) AS infect_count
	FROM InfectReg
	GROUP BY InfectReg.ID_V
	ORDER BY infect_count DESC
	LIMIT 1)
SELECT COUNT(InfectReg.ID_MAIN), InfectReg.ID_V
FROM InfectReg
GROUP BY InfectReg.ID_V
HAVING COUNT(InfectReg.ID_MAIN) = (SELECT infect_count FROM RES);
*/
--3б) найти вирусы, заражавшие системы наименьшее число раз
/*
EXPLAIN ANALYZE WITH RES AS (SELECT COUNT(InfectReg.ID_MAIN) AS infect_count
	FROM InfectReg
	GROUP BY InfectReg.ID_V
	ORDER BY infect_count
	LIMIT 1)
SELECT COUNT(InfectReg.ID_MAIN), InfectReg.ID_V
FROM InfectReg
GROUP BY InfectReg.ID_V
HAVING COUNT(InfectReg.ID_MAIN) = (SELECT infect_count FROM RES);
*/
--4) найти системы, которые заражались чаще, чем система А
/*
EXPLAIN ANALYZE SELECT DISTINCT InfectReg.ID_SYS
FROM InfectReg
JOIN (
	SELECT COUNT(ID_MAIN) AS infect_count, ID_SYS
	FROM InfectReg
	GROUP BY ID_SYS
	) as t2
ON InfectReg.ID_SYS = t2.ID_SYS
WHERE t2.infect_count >
(
	SELECT COUNT(ID_MAIN)
	FROM InfectReg
	GROUP BY ID_SYS
	HAVING ID_SYS = '777'
);
*/
--5) посчитать число систем с одинаковым числом заражений (гистограмма)
/*
--EXPLAIN ANALYZE 
SELECT COUNT(*) AS sys_count, t2.infct_count
FROM InfectReg
JOIN (
	SELECT COUNT(*) AS infct_count, ID_SYS
	FROM InfectReg
	GROUP By ID_SYS) AS t2
ON InfectReg.ID_SYS = t2.ID_SYS
GROUP BY t2.infct_count;
*/
--6) посчитать число заражений каждым механизмом (гистограмма)
/*
--EXPLAIN ANALYZE 
SELECT COUNT(*) AS infect_count, Protection.ID_MECH as ID_MECH
FROM InfectReg
JOIN Setup ON Setup.ID_SYS = InfectReg.ID_SYS
JOIN Protection ON Protection.ID_P = Setup.ID_P
GROUP BY Protection.ID_MECH;
*/
--7) найти вирус, который не заразил ни одной системы способом А
/*
EXPLAIN ANALYZE WITH temp_table AS (SELECT InfectReg.ID_V, InfectReg.ID_SYS, InfectWayMany.ID_I
FROM InfectReg
JOIN InfectWayMany ON InfectWayMany.ID_V = InfectReg.ID_V)
SELECT ID_V, ID_SYS, ID_I
FROM temp_table
WHERE ID_I != '1';
*/
--8) для каждой архитектуры посчитать число заражений на каждый механизм (3D диаграмма???)
/*
EXPLAIN ANALYZE SELECT System_.ID_ARCH, Protection.ID_MECH, COUNT(InfectReg.ID_MAIN)
FROM InfectReg
JOIN System_ ON System_.ID_SYS = InfectReg.ID_SYS
JOIN Setup ON Setup.ID_SYS = InfectReg.ID_SYS
JOIN Protection on Protection.ID_P = Setup.ID_P
GROUP BY System_.ID_ARCH, Protection.ID_MECH;
*/









