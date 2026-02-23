# Triggers Exercises with solutions 

## 1. Create a Trigger to Log Salary Changes
Write a MySQL query to create a trigger that logs salary changes in the Employees table to a SalaryLog table.

<details><summary>Click me to see the solution</summary>

```sql
-- Change the delimiter to allow multi-line trigger definition
DELIMITER //

-- Create a trigger named 'LogSalaryChange'
CREATE TRIGGER LogSalaryChange  -- Trigger name
AFTER UPDATE ON Employees       -- Trigger fires after an update on the Employees table
FOR EACH ROW                    -- The trigger will execute for each row affected by the update
BEGIN
    -- Insert the old and new salary into the SalaryLog table
    INSERT INTO SalaryLog (EmployeeID, OldSalary, NewSalary, ChangeDate)  -- Insert into SalaryLog table
    VALUES (OLD.EmployeeID, OLD.Salary, NEW.Salary, NOW());  -- Use OLD and NEW values to capture the old and new salary and the current timestamp
END //
-- Reset the delimiter back to ';'
DELIMITER ;
```
</details>

---

## 2. Create a Trigger to Prevent Invalid Salary Updates
Write a MySQL query to create a trigger that prevents updating an employee's salary to a negative value.

<details><summary>Click me to see the solution</summary>

```sql
-- Change the delimiter to allow multi-line trigger definition
DELIMITER //

-- Create a trigger named `PreventNegativeSalary`
CREATE TRIGGER PreventNegativeSalary  -- Trigger name
BEFORE UPDATE ON Employees            -- Trigger fires before an update on the Employees table
FOR EACH ROW                         -- The trigger will execute for each row affected by the update
BEGIN
    -- Check if the new salary is negative
    IF NEW.Salary < 0 THEN  -- Compares the new salary (after update) with 0
        -- Raise an error and prevent the update
        SIGNAL SQLSTATE '45000'  -- Signals a custom error
        SET MESSAGE_TEXT = 'Salary cannot be negative';  -- Custom error message
    END IF;
END //

-- Reset the delimiter back to `;`
DELIMITER ;
```
</details>

---

## 3. Create a Trigger to Update Last Modified Date
Write a MySQL query to create a trigger that updates the LastModified column in the Employees table whenever a row is updated.

<details><summary>Click me to see the solution</summary>

```sql
-- Change the delimiter to allow defining a multi-line trigger
DELIMITER //

-- Create a trigger named `UpdateLastModified`
CREATE TRIGGER UpdateLastModified  

-- This trigger will execute before an update operation on the Employees table
BEFORE UPDATE ON Employees  

-- Ensures that the trigger runs for each row being updated
FOR EACH ROW  

BEGIN
    -- Automatically update the LastModified column with the current timestamp
    SET NEW.LastModified = NOW();  
END //  

-- Reset the delimiter back to default `;`
DELIMITER ;
```
</details>

---

## 4. Create a Trigger to Prevent Deleting Active Employees
Write a MySQL query to create a trigger that prevents deleting employees who are marked as active.

<details><summary>Click me to see the solution</summary>

```sql
-- Set the delimiter to `//` to allow multi-line trigger definition
DELIMITER //

-- Create a trigger named `PreventDeleteActiveEmployees`
CREATE TRIGGER PreventDeleteActiveEmployees
BEFORE DELETE ON Employees  -- Trigger activates before deleting a row from the Employees table
FOR EACH ROW  -- Executes for every row that is being deleted
BEGIN
    -- Check if the employee is active (assuming `IsActive = 1` means active)
    IF OLD.IsActive = 1 THEN
        -- Raise an error and prevent the deletion
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Cannot delete active employees';
    END IF;
END //  -- End of the trigger definition

-- Reset the delimiter to `;` for normal MySQL execution
DELIMITER ; 
```
</details>

---

## 5. Create a Trigger to Enforce Maximum Salary
Write a MySQL query to create a trigger that prevents inserting or updating an employee's salary if it exceeds a maximum value.

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

## 6. Create a Trigger to Log Employee Deletions
Write a MySQL query to create a trigger that logs deleted employees to a DeletedEmployeesLog table.

<details><summary>Click me to see the solution</summary>

```sql
-- Create a trigger named `LogDeletedEmployees`
-- This trigger will log deleted employees into the DeletedEmployeesLog table
DELIMITER //

-- Define the trigger `LogDeletedEmployees` that will fire after a delete operation on the Employees table
CREATE TRIGGER LogDeletedEmployees
AFTER DELETE ON Employees
FOR EACH ROW
BEGIN
    -- Insert the deleted employee's details into the DeletedEmployeesLog table
    -- The details include EmployeeID, Name, DepartmentID, Salary, and DeletionDate (current timestamp)
    INSERT INTO DeletedEmployeesLog (EmployeeID, Name, DepartmentID, Salary, DeletionDate)
    VALUES (OLD.EmployeeID, OLD.Name, OLD.DepartmentID, OLD.Salary, NOW());
END //

-- Reset the delimiter to the default `;`
DELIMITER ;
```
</details>

---