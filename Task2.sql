USE HRDatabase
GO

CREATE TABLE AccessCards (
    CardID INT PRIMARY KEY,
    CardNumber VARCHAR(50) NOT NULL UNIQUE,
    EmployeeID INT NOT NULL UNIQUE FOREIGN KEY REFERENCES Employees(EmployeeID)
);

GO

CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL
);

GO

CREATE TABLE EmployeeProjects (
    EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    ProjectID INT FOREIGN KEY REFERENCES Projects(ProjectID),
    AssignedDate DATE,
    PRIMARY KEY (EmployeeID, ProjectID)
);

GO

INSERT INTO AccessCards VALUES
(101, 'CARD-101', 1),
(102, 'CARD-102', 2),
(103, 'CARD-103', 3);

INSERT INTO Projects VALUES
(1, 'AI & Security Training'),
(2, 'Cloud Migration');

INSERT INTO EmployeeProjects VALUES
(1, 1, GETDATE()),
(1, 2, GETDATE()),
(2, 1, GETDATE()),
(3, 2, GETDATE());

GO

SELECT * FROM AccessCards;
SELECT * FROM Projects;
SELECT * FROM EmployeeProjects;

GO

SELECT e.FullName ,e.Salary,d.DepartmentName
from Employees e inner join Departments d
on e.DepartmentID = d.DepartmentID;

GO
SELECT * from Departments d  LEFT JOIN  Employees e
on e.DepartmentID = d.DepartmentID;

GO
SELECT e.FullName , a.CardNumber from Employees e 
inner JOIN AccessCards a
on e.EmployeeID= a.EmployeeID;

GO
SELECT e.FullName , p.ProjectName, ep.AssignedDate
from Employees e 
inner JOIN EmployeeProjects ep
inner JOin Projects p
on e.ProjectID = p.ProjectID
GO



SELECT SUM(Employees.Salary) AS TotalSalary ,
COUNT(*) As EmployeeCount from Employees 
group by DepartmentID

GO

SELECT DepartmentID ,AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentID
HAVING AVG(Salary) > 1000.00;

SELECT * from Employees where Salary > (Select AVG(Employees.salary) from Employees)

GO
CREATE VIEW vw_EmployeeDetails  as
SELECT Employees.EmployeeID , Employees.FullName,
Employees.Email,Departments.DepartmentName 
from Employees inner join Departments
on Employees.DepartmentID = Departments.DepartmentID
GO
SELECT * FROM vw_EmployeeDetails;

GO
CREATE Procedure sp_GetEmployeesByDepartment @DeptID INT
as 
begin
Select * from Employees where Employees.DepartmentID = @DeptID 
end
GO
EXEC sp_GetEmployeesByDepartment @DeptID = 1;


GO
CREATE TABLE EmployeeAudit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    Action VARCHAR(50),
    ActionDate DATETIME
);

GO

CREATE TRIGGER trg_EmployeeDeleted
ON Employees
AFTER DELETE
AS
BEGIN
    INSERT INTO EmployeeAudit (EmployeeID, Action, ActionDate)
    SELECT EmployeeID, 'DELETE', GETDATE()
    FROM deleted;
END;

GO

DELETE FROM Employees
WHERE EmployeeID = 1;

