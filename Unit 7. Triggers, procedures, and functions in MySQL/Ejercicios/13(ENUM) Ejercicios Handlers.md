# **Ejercicios - Handler en MySQL**

### **Ejercicio 1:**
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

Crea un procedimiento almacenado que actualiza el salario de un empleado especificado por un número de empleado y genera un error si no se encuentra el empleado o el salario es negativo:

---

### **Ejercicio 3:**

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



