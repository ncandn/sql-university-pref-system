CREATE TABLE tbl_university(
	"university_id" serial NOT NULL,
	"university_name" varchar(100) NOT NULL,
	"address" varchar(150),
	"e-mail_address" varchar(100),
	"city" varchar(50),
	"type" varchar(100),
	"year_of_foundation" int,
	CONSTRAINT "pk_university_id" PRIMARY KEY("university_id"),
	CONSTRAINT "un_university_name" UNIQUE("university_name")
);

CREATE TABLE tbl_faculty(
	"university_id" int NOT NULL,
	"faculty_id" serial NOT NULL,
	"faculty_name" varchar(100) NOT NULL,
	"e-mail_address" varchar(100),
	CONSTRAINT "pk_faculty_id" PRIMARY KEY("faculty_id"),
	CONSTRAINT "fk_university" FOREIGN KEY("university_id")
	REFERENCES tbl_university("university_id") match simple
	ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE tbl_department(
	"faculty_id" int NOT NULL,
	"department_id" serial NOT NULL,
	"department_name" varchar(100) NOT NULL,
	"e-mail_address" varchar(100),
	"language" varchar(50),
	"education_type" varchar(50),
	"quota" int,
	"quota_top_rank" int,
	"education_period" int,
	"min_score" numeric,
	"min_order" int,
	CONSTRAINT "department_pk" PRIMARY KEY("department_id"),
	CONSTRAINT "fk_faculty" FOREIGN KEY("faculty_id")
	REFERENCES tbl_faculty("faculty_id") match simple
	ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE tbl_student(
	"personal_id" serial NOT NULL,
	"name" varchar(100),
	"surname" varchar(100),
	"exam_score" numeric,
	"ranking" int,
	"top_ranked" bool NOT NULL,
	CONSTRAINT "student_pk" PRIMARY KEY("personal_id"),
	CONSTRAINT "unique_id" UNIQUE("personal_id"),
	CONSTRAINT "unique_ranking" UNIQUE("ranking")
);

CREATE TABLE tbl_pref(
	"student_id" int NOT NULL,
	"pref_1" int,
	"pref_2" int,
	"pref_3" int,
	CONSTRAINT "pk_std_id" PRIMARY KEY("student_id"),
	CONSTRAINT "fk_std_id" FOREIGN KEY("student_id")
	REFERENCES tbl_student("personal_id") match simple
	ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT "fk_pref_1" FOREIGN KEY("pref_1")
	REFERENCES tbl_department("department_id") match simple
	ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT "fk_pref_2" FOREIGN KEY("pref_2")
	REFERENCES tbl_department("department_id") match simple
	ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT "fk_pref_3" FOREIGN KEY("pref_3")
	REFERENCES tbl_department("department_id") match simple
	ON UPDATE CASCADE ON DELETE CASCADE
)

insert into tbl_university("university_name","address","e-mail_address","city","type","year_of_foundation")
values('Dokuz Eylul University','Buca','dokuzeylul@gmail.com','İzmir','state',1982),
('Izmir Technical University','Urla','izmirtechuni@gmail.com','İzmir','state',1992),
('Izmir University','Bornova','izmiruni@yahoo.com','İzmir','private',1995),
('Cukurova University','Seyhan','cuadana@gmail.com','Adana','state',1973),
('Istanbul Technical University','Tuzla','itu@gmail.com','İstanbul','state',1773),
('Cambridge University','Trinity','cambridge@outlook.com','Cambridge','private',1209);

insert into tbl_faculty("university_id","faculty_name","e-mail_address")
values(1,'Engineering','deueng@gmail.com'),
(1,'Medicine','deumed@gmail.com'),
(1,'Law','deulaw@gmail.com'),
(2,'Engineering','izmtecheng@gmail.com'),
(2,'Medicine','izmtechmed@gmail.com'),
(3,'Engineering','izmunieng@outlook.com'),
(4,'Law','culaw@yahoo.com'),
(4,'Medicine','cumed@hotmail.com'),
(5,'Engineering','itueng@gmail.com'),
(6,'Law','camlaw@yahoo.uk');

insert into tbl_department("faculty_id","department_name","e-mail_address","language","education_type","quota","quota_top_rank","education_period","min_score","min_order")
values(1,'Computer Engineering','deuceng@gmail.com','English','öö',90,3,4,444.50264,33624),
(1,'Electrical Engineering','deueeng@gmail.com','English','öö',90,3,4,448.50124,31280),
(2,'Medicine Department','deumedep@gmail.com','English','öö',120,4,6,480.54322,3560),
(3,'Law Department','deulawdep@gmail.com','Turkish','öö',240,6,4,410.65432,18000),
(4,'Mechanical Engineering','iztechmech@yahoo.com','Turkish','iö',90,3,4,395.54325,45000),
(5,'Medicine Department','iztechmedep@gmail.com','English','öö',120,4,6,465.54322,5600),
(6,'Industrial Engineering','izmunindust@outlook.com','English','iö',60,2,4,412.65431,39030),
(7,'Law Department','culawdept@outlook.com','Turkish','öö',240,6,4,410.53213,18530),
(8,'Medicine Department','cumedep@gmail.com','Turkish','öö',120,4,6,470.54322,5100),
(8,'Dentistry Department','cumedendep@outlook.com','English','öö',100,4,5,450.53392,31002),
(9,'Food Engineering','itufood@yummy.com','Turkish','iö',60,1,2,370.68732,98220),
(9,'Computer Engineering','ituceng@computers.edu','English','öö',90,3,4,475.23488,4300),
(10,'Law Department','cambrlaw@outlook.uk','English','öö',120,4,4,498.65735,700);

insert into tbl_student("name","surname","exam_score","ranking","top_ranked")
values('Gurkay','Turkmen',420.65421,43241,TRUE),
('Yiğit','Yavuzlar',395.48795,78523,FALSE),
('Ayşe Fatma','Hayriye',487.45324,1700,TRUE),
('Heidi','Doublestring',453.35435,28002,FALSE),
('Sam Ting','Wong',410.54687,18089,FALSE);

insert into tbl_pref("student_id","pref_1","pref_2","pref_3")
values(1,1,2,11),
(2,12,1,5),
(3,13,12,6),
(4,1,7,10),
(5,4,8,11);


--// QUERY 1
SELECT *
FROM tbl_university
WHERE LEFT("city",1) = 'İ' AND "year_of_foundation" >= 1990;

--// QUERY 2
SELECT uni.*
FROM tbl_university as uni INNER JOIN tbl_faculty as fclt ON uni."university_id"=fclt."university_id"
WHERE fclt."faculty_name" in ('Engineering','Medicine')
GROUP BY uni."university_id", uni."university_name"
HAVING COUNT (distinct fclt."faculty_name") = 2;

--// QUERY 3
SELECT "type", COUNT(faculty_id)
FROM tbl_university as uni INNER JOIN tbl_faculty as fclt ON uni."university_id"=fclt."university_id"
GROUP BY uni."type";

--// QUERY 4
SELECT *
FROM tbl_department
WHERE "department_name" LIKE '%Engineering%' and "education_type" LIKE 'iö';

--// QUERY 5
SELECT *
FROM tbl_department
ORDER BY "education_period" DESC, "min_score" DESC
LIMIT 5;

--// QUERY 6
WITH prefs as (
	SELECT * from tbl_department as dept INNER JOIN tbl_pref as pref 
	ON dept."department_id"=pref."pref_1"
	WHERE dept."education_period" = 4
	UNION ALL
	SELECT * from tbl_department as dept INNER JOIN tbl_pref as pref 
	ON dept."department_id"=pref."pref_2"
	WHERE dept."education_period" = 4
	UNION ALL
	SELECT * from tbl_department as dept INNER JOIN tbl_pref as pref 
	ON dept."department_id"=pref."pref_3"
	WHERE dept."education_period" = 4
)
SELECT "department_name", COUNT("department_name") as cnt
from prefs GROUP BY "department_name"
ORDER BY cnt DESC;


--// QUERY 7
SELECT std.*
FROM tbl_pref as pref INNER JOIN tbl_department as dept ON pref."pref_1"=dept."department_id"
INNER JOIN tbl_student as std ON std."personal_id"=pref."student_id"
WHERE dept."department_name"='Computer Engineering'
ORDER BY std."exam_score" DESC;

SELECT * from tbl_faculty

--// QUERY 8
UPDATE tbl_faculty
SET "university_id" = (SELECT "university_id" from tbl_university
					  WHERE "university_name" = 'Izmir Technical University')
WHERE EXISTS (SELECT * from tbl_university as uni
			 WHERE uni."university_id"=tbl_faculty."university_id" and 
			 uni."university_name" = 'Dokuz Eylul University' and 
			 tbl_faculty."faculty_name" = 'Engineering')

SELECT * FROM tbl_faculty

--// QUERY 9
UPDATE tbl_department
SET "education_period" = "education_period" + 1
WHERE "department_name" = 'Law Department';


--// QUERY 10
DELETE FROM tbl_faculty
WHERE tbl_faculty."university_id" = (SELECT "university_id" from tbl_university
									WHERE "university_name" = 'Izmir University');
