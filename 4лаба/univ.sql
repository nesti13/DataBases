use UNIVER;
CREATE TABLE Faculty
(
Faculty CHAR(10) PRIMARY KEY NOT NULL,
FacultyName VARCHAR(50) DEFAULT '???'
)
CREATE TABLE Profession
(
Profession CHAR(20) PRIMARY KEY NOT NULL,
Faculty CHAR(10) NOT NULL FOREIGN KEY REFERENCES Faculty(Faculty),
ProfessionName VARCHAR(100) NULL,
Qualification VARCHAR(50) NULL
)
CREATE TABLE Pulpit
(
Pulpit CHAR(20) PRIMARY KEY NOT NULL,
PulpitName VARCHAR(100) NOT NULL,
Faculty CHAR(10) NOT NULL FOREIGN KEY REFERENCES Faculty(Faculty)
)
CREATE TABLE Teacher
(
Teacher CHAR(10) PRIMARY KEY NOT NULL,
TeacherName VARCHAR(100) NULL,
Pulpit CHAR(20) NOT NULL FOREIGN KEY REFERENCES Pulpit(Pulpit)
)
CREATE TABLE Subjects
(
Subjects CHAR(10) PRIMARY KEY NOT NULL,
SubjectName VARCHAR(100) NOT NULL UNIQUE,
Pulpit CHAR(20) NOT NULL FOREIGN KEY REFERENCES Pulpit(Pulpit)
)
CREATE TABLE AuditoriumType
(
AuditoriumType CHAR(10) PRIMARY KEY NOT NULL,
AuditoriumTypeName VARCHAR(30) NULL
)
CREATE TABLE Auditoriums
(
Auditorium CHAR(20) PRIMARY KEY NOT NULL,
AuditoriumType CHAR(10) NOT NULL FOREIGN KEY REFERENCES AuditoriumType(AuditoriumType),
AuditoriumCapacity INT DEFAULT 1 CHECK (AuditoriumCapacity BETWEEN 1 AND 300),
AuditoriumName VARCHAR(50) NULL
)
CREATE TABLE Groups
(
IDGroup INT PRIMARY KEY NOT NULL,
Faculty CHAR(10) NOT NULL FOREIGN KEY REFERENCES Faculty(Faculty),
Profession CHAR(20) NOT NULL FOREIGN KEY REFERENCES Profession(Profession),
Year_first smallint, CHECK (Year_first < 2022+2),
);

go
ALTER TABLE dbo.Groups ADD Course AS (GETDATE()-Year_first);

CREATE TABLE Student
(
IDstudent INT PRIMARY KEY identity (1000,1),
IDGroup INT NOT NULL FOREIGN KEY REFERENCES Groups(IDGroup),
Names nvarchar(100),
BDAY date,
Stamp timestamp,
Info xml,
Foto varbinary  
)
CREATE TABLE Progress
(
Subjects CHAR(10) FOREIGN KEY REFERENCES Subjects(Subjects),
IDstudent INT FOREIGN KEY REFERENCES Student(IDstudent),
PDATE  date,
Note int CHECK (Note BETWEEN 1 AND 10)
)