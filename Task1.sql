use HRDatabase;
go

create table dbo.Departments (
    DepartmentID int primary key,
    DepartmentName varchar(50) not null unique
);
go

create table dbo.Employees (
    EmployeeID int primary key,
    FullName varchar(100) not null,
    Email varchar(100) unique,
    Salary decimal(10,2),
    DepartmentID int
);
go

alter table dbo.Employees
add PhoneNumber varchar(20);
go

drop table if exists dbo.TemporaryStaff;
go

insert into dbo.Departments (DepartmentID, DepartmentName)
values
(1, 'IT'),
(2, 'HR'),
(3, 'Finance');

insert into dbo.Employees
(EmployeeID, FullName, Email, Salary, DepartmentID, PhoneNumber)
values
(1, 'Ahmad Ali', 'ahmad@techworld.com', 1200.00, 1, '0791111111'),
(2, 'Sara Hassan', 'sara@techworld.com', 950.00, 2, '0792222222'),
(3, 'Zaid Omar', 'zaid@techworld.com', 1500.00, 1, '0793333333'),
(4, 'Mona Khaled', 'mona@techworld.com', 800.00, 3, '0794444444');
go

update dbo.Employees
set Salary = 1350.00
where EmployeeID = 1;

delete from dbo.Employees
where EmployeeID = 4;

select * from dbo.Employees;

select FullName, Salary from dbo.Employees;

select sum(Salary) as TotalSalaries from dbo.Employees;

select avg(Salary) as AverageSalary from dbo.Employees;

select max(Salary) as HighestSalary,
       min(Salary) as LowestSalary
from dbo.Employees;

select count(*) as TotalEmployees from dbo.Employees;