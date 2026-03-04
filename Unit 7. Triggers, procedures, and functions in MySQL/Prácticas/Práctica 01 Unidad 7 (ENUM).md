# Práctica 01 de la unidad 7: Procedimiento, funciones y triggers

## Ejercicio 1:
Crea la bbd: `Empresa` y añede las siguientes tablas:

- Trabajador (id PK, nombre, apellidos, oficio, fecha_alta, salario, comision, id_departamento FK)
- Departamentos (id PK, nombre, ubicacion).

Añade los departamentos:
  - Nombre: Administración, Ubicación: Madrid
  - Nombre: Ventas, Ubicación: Barcelona
  - Nombre: IT, Ubicación: Madrid
  - Nombre: RRHH, Ubicación: Sevilla
  
Añade los trabajadores:
- Nombre:Ana, Apellidos: García López, Oficio: Administrativa, Fecha de Alta: 2023-02-10, Salario:1800.00, Comisión: no, Departamento: Administración
- Nombre:Luis, Apellidos: Martín Pérez, Oficio: Comercial, Fecha de Alta: 2022-06-01, Salario:1500.00, Comisión: 300.00, Departamento: Ventas
- Nombre:Marta, Apellidos: Sánchez Ruiz, Oficio: Desarrolladora, Fecha de Alta: 2021-09-15, Salario:2600.00, Comisión: no, Departamento: IT
- Nombre:Jorge, Apellidos: Navarro Gil, Oficio: Técnico Soporte, Fecha de Alta: 2024-01-20, Salario:1900.00, Comisión: no, Departamento: RRHH
- Nombre:Sara, Apellidos: López Fernández, Oficio: RRHH, Fecha de Alta: 2020-03-05, Salario:2200.00, Comisión: no, Departamento: RRHH
- Nombre:Pablo, Apellidos: Torres Molina, Oficio: Comercial, Fecha de Alta: 2023-11-08, Salario:1400.00, Comisión: 450.00, Departamento: Ventas


Se pide implementar los siguientes procedimientos almacenados y funciones:

a) Crear un procedimiento que reciba como parámetro el id_departamento y muestre todos los trabajadores pertenecientes a dicho departamento.

Si el departamento no existe, deberá lanzar una excepción con: SQLSTATE '45000' y el mensaje: 'El departamento no existe'.


b) Crear un procedimiento que inserte un nuevo trabajador en la tabla Trabajador.

Parámetros:
  - id
  - nombre
  - apellidos
  - oficio
  - fecha_alta
  - salario
  - comision
  - id_departamento

Si el departamento no existe, lanzar excepción: SQLSTATE '45000' y el mensaje: 'El departamento no existe'.

Si el salario o la comisión son negativos, lanzar excepción: SQLSTATE '45000'y el mensaje: 'El salario o la comisión no pueden ser negativos'.

Si el id del trabajador ya existe, lanzará automáticamente el error de clave primaria duplicada (1062).


c) Crear un procedimiento que elimine un trabajador a partir de su id.

Si el trabajador no existe, lanzar excepción: SQLSTATE '45000' y el mensaje Mensaje: 'El trabajador no existe'.

d) Crear un procedimiento que incremente el salario de todos los trabajadores de un departamento determinado.

El incremento podrá realizarse:
  - Porcentaje (por ejemplo, +10%)
  - Cantidad fija (por ejemplo, +200€)

Si el departamento no existe, lanzar excepción: SQLSTATE '45000' y el mensaje 'El departamento no existe'.

Si el porcentaje o la cantidad es negativa, lanzar excepción: SQLSTATE '45000' y el mensaje: 'El incremento no puede ser negativo'.

e) Crear una función que reciba el id_departamento y devuelva el salario total (SUM) de todos los trabajadores del departamento.

Si no existen trabajadores en el departamento, deberá devolver 0.

La función debe declararse como:
- DETERMINISTIC
- READS SQL DATA

f) Crear una función que reciba el id_departamento y devuelva el número total de trabajadores del departamento.

Si no existen trabajadores en el departamento, deberá devolver 0.

La función debe declararse como:
- DETERMINISTIC
- READS SQL DATA

---

## Ejercicio 2:

Añade a la tabla `trabajador` la columna:
- anios_experiencia INT

Asigna los siguientes años de experiencia a los trabajadores:

| id | nombre | años experiencia |
| -- | ------ | ---------------- |
| 1  | Ana    | 4                |
| 2  | Luis   | 6                |
| 3  | Marta  | 3                |
| 4  | Jorge  | 2                |
| 5  | Sara   | 7                |
| 6  | Pablo  | 1                |


a) Crea un procedimiento llamado `ajustar_salario` que reciba el identificador de un trabajador y ajuste su salario según el departamento al que pertenece.

- Si el departamento es 'Ventas', aumenta el salario un 10%.
- Si es 'Administración', aumenta el salario un 5%.
- Si es 'IT', disminuye el salario un 3%.
- En cualquier otro caso, no se realizarán cambios.

Utiliza la estructura CASE.

> El nombre del departamento debe obtenerse a partir de la tabla departamentos usando id_departamento.


b) Crea un procedimiento llamado `incrementar_salarios` que aumente en 100 euros el salario de todos los trabajadores de la empresa hasta que el salario medio (AVG) supere los 3000 euros.

Debes utilizar la estructura REPEAT ... UNTIL ... END REPEAT.


c) Crea una función llamada `calcular_ahorro` que reciba el id de un trabajador y calcule cuánto dinero habría ahorrado si hubiera guardado el 5% de su salario mensual durante todos los meses de su experiencia laboral.

- Meses trabajados = anios_experiencia * 12
- Ahorro mensual = salario * 0.05

Debes utilizar la estructura WHILE.
