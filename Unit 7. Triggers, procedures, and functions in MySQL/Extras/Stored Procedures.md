# Stored Procedures Exercises with solutions 

## 1. Create a Stored Procedure to Insert a New Employee
Write a MySQL query to create a stored procedure that inserts a new employee into the Employees table.

<details><summary>Click me to see the solution</summary>

```sql
-- Change the delimiter to allow multi-line stored procedure definition
DELIMITER //

-- Create a stored procedure named `InsertEmployee`
CREATE PROCEDURE InsertEmployee(
    IN p_Name VARCHAR(100),       -- Input parameter: Employee name
    IN p_DepartmentID INT,        -- Input parameter: Department ID
    IN p_Salary DECIMAL(10,2)     -- Input parameter: Employee salary
)
BEGIN
    -- Insert the new employee into the Employees table
    INSERT INTO Employees (Name, DepartmentID, Salary)
    VALUES (p_Name, p_DepartmentID, p_Salary);
END //

-- Reset the delimiter back to `;`
DELIMITER ;
```
</details>

---

## 2. Call the Stored Procedure to Insert an Employee
Write a MySQL query to call the InsertEmployee stored procedure to add a new employee.

<details><summary>Click me to see the solution</summary>

```sql
-- Call the `InsertEmployee` stored procedure to insert a new employee
CALL InsertEmployee('Kamilla Njord', 2, 50000.00);
```
</details>

---

## 3. Create a Stored Procedure to Update Employee Salary
Write a MySQL query to create a stored procedure that updates an employee's salary.

<details><summary>Click me to see the solution</summary>

```sql
-- Change the delimiter to allow multi-line stored procedure definition
DELIMITER //

-- Create a stored procedure named `UpdateEmployeeSalary`
CREATE PROCEDURE UpdateEmployeeSalary(
    IN p_EmployeeID INT,          -- Input parameter: Employee ID
    IN p_NewSalary DECIMAL(10,2)  -- Input parameter: New salary amount
)
BEGIN
    -- Update the salary of the employee with the given EmployeeID
    UPDATE Employees 
    SET Salary = p_NewSalary 
    WHERE EmployeeID = p_EmployeeID;
END //

-- Reset the delimiter back to `;`
DELIMITER ;
```
</details>

---

## 4. Call the Stored Procedure to Update Salary
Write a MySQL query to call the UpdateEmployeeSalary stored procedure to update an employee's salary.

<details><summary>Click me to see the solution</summary>

```sql
-- Call the `UpdateEmployeeSalary` stored procedure to update EmployeeID 1's salary
CALL UpdateEmployeeSalary(1, 55000.00);
```
</details>

---

## 5. Create a Stored Procedure to Delete an Employee
Write a MySQL query to create a stored procedure that deletes an employee from the Employees table.

<details><summary>Click me to see the solution</summary>

```sql
-- Create a stored procedure named `DeleteEmployee`
DELIMITER //
CREATE PROCEDURE DeleteEmployee(IN p_EmployeeID INT)
BEGIN
    -- Delete the employee from the Employees table
    DELETE FROM Employees 
    WHERE EmployeeID = p_EmployeeID;
END //
DELIMITER ;
```
</details>

---

## 6. Call the Stored Procedure to Delete an Employee
Write a MySQL query to call the DeleteEmployee stored procedure to delete an employee.

<details><summary>Click me to see the solution</summary>

```sql
-- Call the `DeleteEmployee` stored procedure
CALL DeleteEmployee(1);
```
</details>

---

## 7. Create a Stored Procedure to Calculate Average Salary
Write a MySQL query to create a stored procedure that calculates the average salary of employees in a department.

<details><summary>Click me to see the solution</summary>

```sql
-- Change the delimiter to allow multi-line stored procedure definition
DELIMITER //

-- Create a stored procedure named `CalculateAverageSalary`
CREATE PROCEDURE CalculateAverageSalary(IN p_DepartmentID INT, OUT p_AverageSalary DECIMAL(10, 2))  
    -- Input parameter: DepartmentID for which the average salary is calculated
    -- Output parameter: AverageSalary to return the calculated average salary

BEGIN
    -- Calculate the average salary for the department
    SELECT AVG(Salary) INTO p_AverageSalary  -- Calculate the average salary and store it into the output variable
    FROM Employees  -- From the Employees table
    WHERE DepartmentID = p_DepartmentID;  -- Filter by the input DepartmentID
END //

-- Reset the delimiter back to `;`
DELIMITER ;
```
</details>

---

## 8. Call the Stored Procedure to Calculate Average Salary
Write a MySQL query to call the CalculateAverageSalary stored procedure and retrieve the average salary.

<details><summary>Click me to see the solution</summary>

```sql
-- Declare a variable to store the average salary
SET @avg_salary = 0;

-- Call the `CalculateAverageSalary` stored procedure
CALL CalculateAverageSalary(2, @avg_salary);

-- Retrieve the average salary
SELECT @avg_salary AS AverageSalary;
```
</details>

---

## 9. Create a Stored Procedure to Count Employees in a Department
Write a MySQL query to create a stored procedure that counts the number of employees in a specific department.

<details><summary>Click me to see the solution</summary>

```sql
-- Change the delimiter to allow defining a multi-line stored procedure
DELIMITER //

-- Create a stored procedure named `CountEmployeesInDepartment`
CREATE PROCEDURE CountEmployeesInDepartment(
    -- Input parameter: Department ID to filter employees
    IN p_DepartmentID INT,  
    -- Output parameter: Stores the total count of employees in the department
    OUT p_EmployeeCount INT  
)
BEGIN
    -- Count the number of employees in the given department
    SELECT COUNT(*) INTO p_EmployeeCount  
    FROM Employees  
    WHERE DepartmentID = p_DepartmentID;  
END //  

-- Reset the delimiter back to default `;`
DELIMITER ;
```
</details>

---

## 10. Call the Stored Procedure to Count Employees
Write a MySQL query to call the CountEmployeesInDepartment stored procedure and retrieve the employee count.

<details><summary>Click me to see the solution</summary>

```sql
-- Declare a variable to store the employee count and initialize it to 0
SET @employee_count = 0;

-- Call the `CountEmployeesInDepartment` stored procedure with DepartmentID = 2
-- The result will be stored in the `@employee_count` variable
CALL CountEmployeesInDepartment(2, @employee_count);

-- Retrieve and display the employee count as `EmployeeCount`
SELECT @employee_count AS EmployeeCount;
```
</details>

---

## 11. Stored Procedure to Calculate Total Salary by Department
Write a MySQL query to create a stored procedure that calculates the total salary for a specific department.

<details><summary>Click me to see the solution</summary>

```sql
-- Set the delimiter to `//` to allow multi-line procedure definition
DELIMITER //

-- Create a stored procedure named `CalculateTotalSalaryByDepartment`
CREATE PROCEDURE CalculateTotalSalaryByDepartment(
    IN p_DepartmentID INT,  -- Input parameter: Department ID to filter employees
    OUT p_TotalSalary DECIMAL(10, 2)  -- Output parameter: Total salary of the department
)
BEGIN
    -- Calculate the total salary for the specified department
    SELECT SUM(Salary) INTO p_TotalSalary  
    FROM Employees  
    WHERE DepartmentID = p_DepartmentID;  -- Filter by the given department ID
END //  -- End of the procedure definition

-- Reset the delimiter to `;` for normal MySQL execution
DELIMITER ; 
```
</details>

---

## 12. Call the Stored Procedure to Calculate Total Salary
Write a MySQL query to call the CalculateTotalSalaryByDepartment stored procedure and retrieve the total salary.

<details><summary>Click me to see the solution</summary>

```sql
-- Declare a variable to store the total salary, initializing it to 0
SET @total_salary = 0;

-- Call the `CalculateTotalSalaryByDepartment` stored procedure
-- Pass the department ID (2) as input and store the result in @total_salary
CALL CalculateTotalSalaryByDepartment(2, @total_salary);

-- Retrieve and display the total salary for the specified department
SELECT @total_salary AS TotalSalary; 
```
</details>

---

## 13. Create a Stored Procedure to Archive Old Employees
Write a MySQL query to create a stored procedure that moves old employees to an ArchivedEmployees table.

<details><summary>Click me to see the solution</summary>

```sql
-- Create a trigger named `EnforceMaxSalary`
DELIMITER //

-- Define the trigger `EnforceMaxSalary`
-- This trigger executes BEFORE an INSERT operation on the `Employees` table
CREATE TRIGGER EnforceMaxSalary
BEFORE INSERT ON Employees
FOR EACH ROW
BEGIN
    -- Check if the new employee's salary exceeds the allowed maximum (100000)
    IF NEW.Salary > 100000 THEN
        -- Raise an MySQL error and prevent the insertion
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salary cannot exceed 100000';
    END IF;
END //

-- Reset the delimiter to the default `;`
DELIMITER ; 
```
</details>

---

## 14. Call the Stored Procedure to Archive Old Employees
Write a MySQL query to call the ArchiveOldEmployees stored procedure.

<details><summary>Click me to see the solution</summary>

```sql
-- Call the 'ArchiveOldEmployees' stored procedure
-- This will execute the procedure that archives and deletes old employees
CALL ArchiveOldEmployees();
```
</details>

---