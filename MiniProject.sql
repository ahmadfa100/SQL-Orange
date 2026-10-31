USE CourseHubDB
GO

CREATE TABLE Departments (
DepartmentID INT PRIMARY KEY,
DepartmentName VARCHAR(100) not null unique
);

GO

CREATE TABLE Students (
StudentID INT PRIMARY KEY,
FullName VARCHAR(100) not null,
Email VARCHAR(100) unique,
GPA DECIMAL(3,2),
DepartmentID INT foreign key references Departments(DepartmentID)
);

GO

CREATE TABLE StudentProfiles (
ProfileID INT PRIMARY KEY,
StudentID INT unique foreign key references Students(StudentID),
Address VARCHAR(200),
EmergencyPhone VARCHAR(20)
);

GO

CREATE TABLE Courses (
CourseID INT PRIMARY KEY,
CourseName VARCHAR(100) not null,
Credits INT,
DepartmentID INT foreign key references Departments(DepartmentID)
);

GO

CREATE TABLE StudentCourses (
StudentID INT foreign key references Students(StudentID),
CourseID INT foreign key references Courses(CourseID),
EnrollmentDate DATE default GETDATE(),
PRIMARY KEY (StudentID,CourseID)
);

GO

ALTER TABLE Students ADD Age INT;

DROP TABLE TempInstructors;

GO

INSERT INTO Departments VALUES
(1,'Computer Science'),
(2,'Software Engineering'),
(3,'Business Administration');

GO

INSERT INTO Students VALUES
(101,'Ali Smadi','ali@coursehub.com',3.80,1,22),
(102,'Omar Ahmad','omar@coursehub.com',2.90,1,21),
(103,'Laila Hassan','laila@coursehub.com',3.50,2,23),
(104,'Tariq Zaid','tariq@coursehub.com',2.10,3,20);

GO

INSERT INTO StudentProfiles VALUES
(1,101,'Amman, Jordan','0791111111'),
(2,102,'Irbid, Jordan','0792222222'),
(3,103,'Zarqa, Jordan','0793333333');

GO

INSERT INTO Courses VALUES
(201,'Database Systems',3,1),
(202,'Web Development',3,1),
(203,'Software Architecture',3,2);

GO

INSERT INTO StudentCourses (StudentID,CourseID) VALUES
(101,201),
(101,202),
(102,201),
(103,203);

GO

UPDATE Students SET GPA = 2.50 where StudentID = 104;

DELETE FROM Students where StudentID = 104;

GO

SELECT * FROM Departments;
SELECT * FROM Students;
SELECT * FROM StudentProfiles;
SELECT * FROM Courses;
SELECT * FROM StudentCourses;

GO

SELECT Students.FullName ,Students.GPA,Departments.DepartmentName
from Students inner join Departments
on Students.DepartmentID = Departments.DepartmentID;

GO

SELECT Departments.DepartmentName ,Students.FullName
from Departments left join Students
on Departments.DepartmentID = Students.DepartmentID;

GO

SELECT Students.FullName ,StudentProfiles.Address,StudentProfiles.EmergencyPhone
from Students inner join StudentProfiles
on Students.StudentID = StudentProfiles.StudentID;

GO

SELECT Students.FullName ,Courses.CourseName,StudentCourses.EnrollmentDate
from Students inner join StudentCourses
on Students.StudentID = StudentCourses.StudentID
inner join Courses
on StudentCourses.CourseID = Courses.CourseID;



SELECT COUNT(*) AS TotalStudents,
AVG(GPA) AS AverageGPA,
MAX(GPA) AS HighestGPA,
MIN(GPA) AS LowestGPA
from Students;

GO

SELECT DepartmentID, AVG(GPA) AS AverageGPA,
COUNT(*) AS TotalStudents
from Students
group by DepartmentID;

GO

SELECT DepartmentID, AVG(GPA) AS AverageGPA
from Students
group by DepartmentID
having AVG(GPA) > 3.00;

GO

SELECT DepartmentID, COUNT(*) AS TotalStudents
from Students
where GPA >= 2.50
group by DepartmentID
having COUNT(*) > 1;

USE CourseHubDB
GO

CREATE NONCLUSTERED INDEX IX_Students_Email
ON Students(Email);

GO

SELECT * from Students
where GPA > (SELECT AVG(GPA) from Students);

GO

CREATE VIEW vw_StudentAcademicDetails as
SELECT Students.StudentID ,Students.FullName,
Students.GPA,Departments.DepartmentName
from Students inner join Departments
on Students.DepartmentID = Departments.DepartmentID;

GO

SELECT * FROM vw_StudentAcademicDetails;

GO

CREATE Procedure sp_GetStudentsByDepartment @DeptID INT
as
begin
Select * from Students where Students.DepartmentID = @DeptID
end

GO

EXEC sp_GetStudentsByDepartment @DeptID = 1;