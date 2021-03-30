CREATE TABLE IF NOT EXISTS Virus(
	ID_V 			  INT 			PRIMARY KEY NOT NULL,
	environment		  VARCHAR(100)	NOT NULL,
	type_of_algorithm VARCHAR(100)	NOT NULL,
	polymorphism      INT			NOT NULL,
	metamorphism	  INT			NOT NULL,	
	danger_lvl        INT			NOT NULL,
	CHECK (danger_lvl>=0 AND danger_lvl <=5),
	CHECK (polymorphism=0 OR polymorphism=1),
	CHECK (metamorphism=0 OR metamorphism=1)
);