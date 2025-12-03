SELECT hire_date, TRUNC(hire_date, 'MONTH') AS month_start
FROM employees;

SELECT hire_date, ROUND(hire_date, 'MONTH') AS rounded_month
FROM employees;

SELECT 
    employee_id,
    first_name || ' ' || last_name AS "Employee Name",salary,
    CASE
        WHEN salary < 5000 THEN 'Low'
        WHEN salary BETWEEN 5000 AND 10000 THEN 'Medium'
        WHEN salary > 10000 THEN 'High'
    END AS "Category"
FROM employees;


PL/SQL
-- IF THEN ELSE
DECLARE

v_marks int := 61;

BEGIN

if(v_marks < 50) THEN
dbms_output.put_line('Student Has Failed');
elsif(v_marks BETWEEN 50 and 60) then
dbms_output.put_line('Student is just Passed');
ELSE
dbms_output.put_line('Student Has Passed');
end if;


END;
/


--CASE
DECLARE

    v_marks int := 60;

BEGIN

CASE
    WHEN v_marks between 90 and 100 THEN 
        DBMS_OUTPUT.PUT_LINE('A');
    WHEN v_marks between 75 and 89 THEN 
        DBMS_OUTPUT.PUT_LINE('B');
    WHEN v_marks between 50 and 74 THEN 
        DBMS_OUTPUT.PUT_LINE('C');
    WHEN v_marks between 0 and 49 THEN 
        DBMS_OUTPUT.PUT_LINE('F');
    ELSE 
        DBMS_output.put_line('Invalid Marks');
  END CASE;

END;
/


--LOOP
declare

begin
for c in (select first_name, employee_id, Salary, Department_id from employees where department_id = 90)
loop

dbms_output.put_line('The salary of employee with Name '|| c.first_name ||' having employee ID '|| c.employee_id||
    ' recieves a salary of ' || c.salary || ' works in department '|| c.department_id);
end loop;

end;
/

-- views

create or replace view hello AS
select employee_id, First_name, Last_name, Salary, DEPARTMENT_Name
from employees e inner join DEPARTMENTS d
on e.department_id = d.department_id
where salary > 1000;

select * from hello;

/
create or replace view hello2 AS
select employee_id, First_name, Last_name, Salary, DEPARTMENT_Name
from employees e inner join DEPARTMENTS d
on e.department_id = d.department_id
where e.DEPARTMENT_ID = 80;

update hello2 set first_name = 'Daniyal' where EMPLOYEE_ID = 150;
select * from hello2 where employee_id = 150;
select * from employees  where employee_id = 150;

/

--parametrized functions

create or replace function calc(dept_id in int)
return INT
is
    total_salary int;
begin
    select sum(salary)
    into total_salary
    from employees
    where department_id = dept_id;
    
    RETURN total_salary;

END;

select calc(80)as Sum from dual;
/

--non parametrized
create or replace function calc2
return int
is 
total_salary int;
begin
select sum(salary) into total_salary from EMPLOYEES;
return(total_salary);
end;
/
select calc2 as total_Salary from dual;
/

--procedure
create or replace procedure insert_data(depid in department.departmentid%type,depname in department.departmentname%type)
is 

begin
    insert into DEPARTMENT(departmentid,departmentname) 
    values(depid,depname);
end;
/
savepoint s1;
EXEC insert_data(4,'Admin');
rollback to s1;

-- cursor

declare
CURSOR c_emp IS
    SELECT employee_id, first_name, last_name
    FROM employees
    where employee_id between 150 and 200;
    
    row_emp c_emp%rowtype;


begin
open c_emp;
loop
    fetch c_emp into row_emp;
    exit when c_emp%notfound;
    dbms_output.put_line('Employee ID: '|| row_emp.employee_id|| ' Employee Name: ' || row_emp.first_name||' '||row_emp.last_name);
    
    end loop;
    close c_emp;
end;


--triggers ddl
1. Before CREATE Trigger (Schema-Level)
CREATE OR REPLACE TRIGGER ddl_before_create
BEFORE CREATE ON SCHEMA
BEGIN
    DBMS_OUTPUT.PUT_LINE('A CREATE statement is about to run in this schema.');
END;
/
2. After CREATE Trigger (Schema-Level)CREATE OR REPLACE TRIGGER ddl_after_create
AFTER CREATE ON SCHEMA
BEGIN
    DBMS_OUTPUT.PUT_LINE('A CREATE statement just executed in this schema.');
END;
/
3. Before ALTER Trigger (Schema-Level)
CREATE OR REPLACE TRIGGER ddl_before_alter
BEFORE ALTER ON SCHEMA
BEGIN
    DBMS_OUTPUT.PUT_LINE('About to ALTER an object in this schema.');
END;
/
4. After ALTER Trigger (Schema-Level)
CREATE OR REPLACE TRIGGER ddl_after_alter
AFTER ALTER ON SCHEMA
BEGIN
    DBMS_OUTPUT.PUT_LINE('An object has been ALTERED in this schema.');
END;
/
5. Before DROP Trigger (Schema-Level)
CREATE OR REPLACE TRIGGER ddl_before_drop
BEFORE DROP ON SCHEMA
BEGIN
    RAISE_APPLICATION_ERROR(-20001, 'Dropping objects in this schema is not allowed!');
END;
/
6. Database-Level DDL Trigger (Before DROP)
CREATE OR REPLACE TRIGGER ddl_db_drop
BEFORE DROP ON DATABASE
BEGIN
    RAISE_APPLICATION_ERROR(-20002, 'Dropping objects anywhere in the database is forbidden!');
END;
/
7. Combined DDL Trigger Example (Schema-Level)
CREATE OR REPLACE TRIGGER ddl_multiple_events
AFTER CREATE OR ALTER OR DROP ON SCHEMA
BEGIN
    DBMS_OUTPUT.PUT_LINE('DDL operation occurred: ' || ORA_DICT_OBJ_TYPE || ' ' || ORA_DICT_OBJ_NAME);
END;
/ 
--DML Triggers Examples
1. Before Insert Trigger (Row-Level)
CREATE OR REPLACE TRIGGER trg_before_insert_student
BEFORE INSERT ON student
FOR EACH ROW
BEGIN
    IF :NEW.faculty_id IS NULL THEN
        :NEW.faculty_id := 1;
    END IF;
END;
/
Purpose: Sets default faculty_id if none is provided during insert.
2. After Insert Trigger (Row-Level, Logging/Audit)
CREATE TABLE student_logs (
    student_id INT,
    student_name VARCHAR2(50),
    inserted_by VARCHAR2(30),
    inserted_on DATE
);

CREATE OR REPLACE TRIGGER trg_after_insert_student
AFTER INSERT ON student
FOR EACH ROW
BEGIN
    INSERT INTO student_logs(student_id, student_name, inserted_by, inserted_on)
    VALUES(:NEW.student_id, :NEW.student_name, SYS_CONTEXT('USERENV','SESSION_USER'), SYSDATE);
END;
/
Purpose: Logs each insertion into student_logs.
3. Before Update Trigger (Row-Level)
CREATE OR REPLACE TRIGGER trg_before_update_student
BEFORE UPDATE OF h_pay ON student
FOR EACH ROW
BEGIN
    :NEW.y_pay := :NEW.h_pay * 1920;
END;
/
Purpose: Automatically updates yearly pay (y_pay) when hourly pay (h_pay) changes.
4. After Update Trigger (Row-Level)
CREATE OR REPLACE TRIGGER trg_after_update_student
AFTER UPDATE ON student
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Updated student: ' || :NEW.student_name || ' with new hourly pay: ' || :NEW.h_pay);
END;
/
Purpose: Optional logging after update.
5. Before Delete Trigger (Row-Level, Prevent deletion)
CREATE OR REPLACE TRIGGER trg_before_delete_student
BEFORE DELETE ON student
FOR EACH ROW
BEGIN
    IF :OLD.student_name = 'Sana' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cannot delete record: student_name is Sana!');
    END IF;
END;
/
Purpose: Prevents deletion of specific rows.
6. After Delete Trigger (Row-Level, Logging)
CREATE TABLE student_delete_logs (
    student_id INT,
    student_name VARCHAR2(50),
    deleted_by VARCHAR2(30),
    deleted_on DATE
);

CREATE OR REPLACE TRIGGER trg_after_delete_student
AFTER DELETE ON student
FOR EACH ROW
BEGIN
    INSERT INTO student_delete_logs(student_id, student_name, deleted_by, deleted_on)
    VALUES(:OLD.student_id, :OLD.student_name, SYS_CONTEXT('USERENV','SESSION_USER'), SYSDATE);
END;
/
Purpose: Logs deletion events for audit purposes.
________________________________________
DDL Triggers Examples
1. Before CREATE Trigger (Schema-Level)
CREATE OR REPLACE TRIGGER ddl_before_create
BEFORE CREATE ON SCHEMA
BEGIN
    DBMS_OUTPUT.PUT_LINE('A CREATE statement is about to run in this schema.');
END;
/
2. After CREATE Trigger (Schema-Level)
CREATE OR REPLACE TRIGGER ddl_after_create
AFTER CREATE ON SCHEMA
BEGIN
    DBMS_OUTPUT.PUT_LINE('A CREATE statement just executed in this schema.');
END;
/
3. Before ALTER Trigger (Schema-Level)
CREATE OR REPLACE TRIGGER ddl_before_alter
BEFORE ALTER ON SCHEMA
BEGIN
    DBMS_OUTPUT.PUT_LINE('About to ALTER an object in this schema.');
END;
/
4. After ALTER Trigger (Schema-Level)
CREATE OR REPLACE TRIGGER ddl_after_alter
AFTER ALTER ON SCHEMA
BEGIN
    DBMS_OUTPUT.PUT_LINE('An object has been ALTERED in this schema.');
END;
/
5. Before DROP Trigger (Schema-Level)
CREATE OR REPLACE TRIGGER ddl_before_drop
BEFORE DROP ON SCHEMA
BEGIN
    RAISE_APPLICATION_ERROR(-20001, 'Dropping objects in this schema is not allowed!');
END;
/
6. Database-Level DDL Trigger (Before DROP)
CREATE OR REPLACE TRIGGER ddl_db_drop
BEFORE DROP ON DATABASE
BEGIN
    RAISE_APPLICATION_ERROR(-20002, 'Dropping objects anywhere in the database is forbidden!');
END;
/
7. Combined DDL Trigger Example (Schema-Level)
CREATE OR REPLACE TRIGGER ddl_multiple_events
AFTER CREATE OR ALTER OR DROP ON SCHEMA
BEGIN
    DBMS_OUTPUT.PUT_LINE('DDL operation occurred: ' || ORA_DICT_OBJ_TYPE || ' ' || ORA_DICT_OBJ_NAME);
END;
/
Notes: DML triggers use :NEW/:OLD, DDL triggers use ORA_DICT_OBJ_TYPE and ORA_DICT_OBJ_NAME.


Types of Joins
1. INNER JOIN
- Returns rows that have matching values in both tables.
Syntax:
SELECT a.column1, b.column2
FROM table1 a
INNER JOIN table2 b
ON a.common_column = b.common_column;
Example:
SELECT e.first_name, d.department_name
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id;
2. LEFT (OUTER) JOIN
- Returns all rows from the left table, and matched rows from the right table. Unmatched right table columns show NULL.
Syntax:
SELECT a.column1, b.column2
FROM table1 a
LEFT JOIN table2 b
ON a.common_column = b.common_column;
Example:
SELECT e.first_name, d.department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id;
3. RIGHT (OUTER) JOIN
- Returns all rows from the right table, and matched rows from the left table.
Syntax:
SELECT a.column1, b.column2
FROM table1 a
RIGHT JOIN table2 b
ON a.common_column = b.common_column;
Example:
SELECT e.first_name, d.department_name
FROM employees e
RIGHT JOIN departments d
ON e.department_id = d.department_id;
4. FULL OUTER JOIN
- Returns all rows when there is a match in one of the tables. Unmatched columns show NULL.
Syntax:
SELECT a.column1, b.column2
FROM table1 a
FULL OUTER JOIN table2 b
ON a.common_column = b.common_column;
Example:
SELECT e.first_name, d.department_name
FROM employees e
FULL OUTER JOIN departments d
ON e.department_id = d.department_id;
5. CROSS JOIN
- Returns the Cartesian product of two tables.
Syntax:
SELECT a.column1, b.column2
FROM table1 a
CROSS JOIN table2 b;
Example:
SELECT e.first_name, d.department_name
FROM employees e
CROSS JOIN departments d;
6. SELF JOIN
- A table joined with itself, useful for comparing rows within the same table.
Syntax:
SELECT a.employee_id, a.first_name, b.first_name AS manager_name
FROM employees a
LEFT JOIN employees b
ON a.manager_id = b.employee_id;
Example: Shows each employee with their manager’s name.
Key Points
- Joins require a common column between tables.
- Always specify the ON condition for INNER, LEFT, RIGHT, and FULL joins.
- Use aliases for readability.
- Oracle also supports old-style joins using (+), but ANSI JOIN syntax is recommended.



CREATE TYPE Employee_t AS OBJECT (
  emp_id   NUMBER,
  name     VARCHAR2(30),
  salary   NUMBER,

  MEMBER FUNCTION annual RETURN NUMBER,
  MEMBER PROCEDURE raise(p NUMBER)
);
/

CREATE TYPE BODY Employee_t AS

  MEMBER FUNCTION annual RETURN NUMBER IS
  BEGIN
    RETURN salary * 12;
  END;

  MEMBER PROCEDURE raise(p NUMBER) IS
  BEGIN
    salary := salary + p;
  END;

END;
/

CREATE TABLE Employees OF Employee_t;

INSERT INTO Employees VALUES(Employee_t(1,'Ali',50000));
INSERT INTO Employees VALUES(Employee_t(2,'Sara',65000));
INSERT INTO Employees VALUES(Employee_t(3,'Umar',72000));

COMMIT;

DECLARE
  CURSOR c_emp IS SELECT VALUE(e) FROM Employees e;
  obj Employee_t;
BEGIN
  OPEN c_emp;
  LOOP
    FETCH c_emp INTO obj;
    EXIT WHEN c_emp%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(obj.name || ' -> ' || obj.salary);
  END LOOP;
  CLOSE c_emp;
END;
/
