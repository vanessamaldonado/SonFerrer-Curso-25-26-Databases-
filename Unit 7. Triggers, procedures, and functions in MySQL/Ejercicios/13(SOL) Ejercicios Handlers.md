# **Ejercicios - Handler en MySQL**

### ** Ejercicio 1: **
Crea una tabla llamada `users` con las siguientes especificaciones: 

```sql
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(50) NOT NULL
);
```

Define un stored procedure que inserte un nuevo usuario en la tabla `users`:

El procedimiento `insert_user()` acepta dos parametros: `username` y `email` y inserta una nueva fila en la tabla de `users`.

En el procedimiento almacenado, declare un controlador de salida que se activa cuando se produce una violación de restricción única, lo que se indica mediante SQLSTATE '23000'. 

Cuando se produce el error, el procedimiento almacenado devuelve el siguiente mensaje y finaliza la ejecución inmediatamente: `Error: Duplicate username. Please choose a different username.`

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER //

CREATE PROCEDURE insert_user(
	IN p_username VARCHAR(50), 
    IN p_email VARCHAR(50)
)
BEGIN
  -- SQLSTATE for unique constraint violation
  DECLARE EXIT HANDLER FOR SQLSTATE '23000'
  BEGIN
    -- Handler actions when a duplicate username is detected
    SELECT 'Error: Duplicate username. Please choose a different username.' AS Message;
  END;

  -- Attempt to insert the user into the table
  INSERT INTO users (username, email) VALUES (p_username, p_email);

  -- If the insertion was successful, display a success message
  SELECT 'User inserted successfully' AS Message;

END //

DELIMITER ;
```
</details>

---

### **Ejercicio 2: Declaración SIGNAL de MySQL**

Configura una nueva base de datos llamada hr con una tabla employees con las siguientes especificaciones:

```sql
-- Create a sample database and switch to it
CREATE DATABASE IF NOT EXISTS hr;
USE hr;

-- Create a sample employee table
CREATE TABLE IF NOT EXISTS employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2)
);

-- Insert some sample data
INSERT INTO employees (id, name, salary) 
VALUES
    (1, 'John Doe', 50000),
    (2, 'Jane Smith', 75000),
    (3, 'Bob Johnson', 90000);
```

---

Crea un procedimiento almacenado que actualiza el salario de un empleado especificado por un número de empleado y genera un error si no se encuentra el empleado o el salario es negativo:

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER $$

CREATE PROCEDURE update_employee_salary (
    IN p_employee_id INT,
    IN p_new_salary DECIMAL(10,2)
)
BEGIN
    -- 1) Validar salario
    IF p_new_salary < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Salary cannot be negative';
    END IF;

    -- 2) Intentar actualizar
    UPDATE employees
    SET salary = p_new_salary
    WHERE id = p_employee_id;

    -- 3) Si no se tocó ninguna fila, no existía el empleado
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Employee not found';
    END IF;
END$$

DELIMITER ;

SELECT * FROM employees;

CALL update_employee_salary(2, 80000.00);
SELECT * FROM employees WHERE id = 2;

CALL update_employee_salary(99, 60000.00);

CALL update_employee_salary(1, -10.00);
```
</details>

---

### **Ejercicio 3: **

Cree la base de datos `testdb` si aún no existe y cambie a ella. Luego, cree una tabla `products`, con las siguientes especificaciones:

```sql
CREATE DATABASE IF NOT EXISTS testdb;
USE testdb;

CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    quantity INT
);
```

Cree un procedimiento almacenado para insertar un nuevo producto. Incluye un DECLARE HANDLER que captura errores de clave duplicada (SQLSTATE 23000) y devuelve un mensaje personalizado.

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER //

CREATE PROCEDURE insert_product(IN p_id INT, IN p_name VARCHAR(255))
BEGIN
    -- Declare an EXIT handler for duplicate key errors
    DECLARE EXIT HANDLER FOR SQLSTATE '23000'
    BEGIN
        SELECT 'Error: Product with this ID already exists.' AS message;
    END;

    -- Attempt to insert the product
    INSERT INTO products (id, name, quantity) VALUES (p_id, p_name, 0);
    SELECT 'Product inserted successfully.' AS message;
END //

DELIMITER ;

-- Ejemplo de llamada:
CALL insert_product(1, 'Laptop');
--intente insertar un producto con el mismo id.
CALL insert_product(1, 'Desktop');
```
</details>

---

### **Ejercicio 4:** 

Cree un procedimiento almacenado para actualizar la cantidad de un producto. El procedimiento verificará si la nueva cantidad es negativa. Si lo es, generará (SIGNAL) un error personalizado.

Haz uso del siguiente script para crear la tabla producto.

```sql
CREATE DATABASE IF NOT EXISTS test;
USE test;

CREATE TABLE IF NOT EXISTS products (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL DEFAULT 0
);

INSERT INTO products (id, name, quantity)
VALUES
    (1, 'Laptop', 10),
    (2, 'Mouse', 25);
    
```
<details><summary>Mostrar Solución</summary>

```sql
DELIMITER //

CREATE PROCEDURE update_quantity(IN p_id INT, IN p_quantity INT)
BEGIN
    -- Check if the quantity is negative
    IF p_quantity < 0 THEN
        -- Raise a custom error
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Quantity cannot be negative.';
    END IF;

    -- Update the quantity if the check passes
    UPDATE products 
    SET quantity = p_quantity 
    WHERE id = p_id;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Product not found.';
    END IF;

    SELECT 'Quantity updated successfully.' AS message;
END //

DELIMITER ;

CALL update_quantity(1, 50);   -- OK
CALL update_quantity(1, -10);  -- Error: Quantity cannot be negative.
CALL update_quantity(999, 10); -- Error: Product not found.
```
</details>

---