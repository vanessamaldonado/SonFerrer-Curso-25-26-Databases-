# Ejercicios de Triggers

## Ejercicio 1: 

Crear una tabla llamada CambioPrecios con los siguientes campos:
- NombreProducto varchar(50)
- PrecioAnterior decimal(14,4)
- PrecioActual decimal(14,4)

Crear un trigger que, cada vez que se modifique el precio de un producto, inserte una fila en `CambioPrecios` con los datos correspondientes al producto modificado.

El trigger no debe hacer nada cuando se modifique cualquier otro campo de la tabla Productos.

---

## Ejercicio 2.
Crea un trigger que cada vez que se de alta un nuevo empleado, almacene en el campo FechaContratación la fecha actual.

--- 

## Ejercicio 3.
Crear un trigger que, cada vez que se de de alta un nuevo pedido, almacene en los campos correspondientes al destinatario los datos del cliente que efectúa el pedido.

---

## Ejercicio 4:
Crear un trigger asociado a la tabla PRODUCTOS para evitar que haya dos productos con el  mismo nombre.
Para ello, si al dar de alta un producto su nombre coincide con otro ya existente deberá poner ese campo a null.

---

## Ejercicio 5:
Crear un trigger que impida que se pueda dar de alta a un empleado sin asignarle como jefe a alguno de los empleados que ya son jefes.

Hay que tener en cuenta que en MySQL no es posible deshacer una acción desde un trigger, por lo que habrá que buscar algún "truco".

---

## Ejercicio 6:
Crear un trigger que, al dar de alta un detalle de pedido haga lo siguiente:

- a) Disminuya las unidades en existencia del producto en la cantidad pedida.

Si la cantidad pedida es mayor que las existencias deberá cambiar el valor de la cantidad por las existencias y dejar éstas a 0.

ej, Si las existencias de un producto son 20 y la cantidad pedida 30, deberá dejar las existencias a 0 y almacenar un 20 en la cantidad pedida. 

- b) Almacene el precio unitario del producto en el precio unitario de la fila insertada.

- c) Si Preciounidad * Cantidad es mayor o igual a 500,  almacene el valor 0.10 en Descuento; si es menor que 500 pero mayor o igual a 100, el 0.05 y si es menor que 100 el 0.

---

## Ejercicio 7:
Crear una tabla VentasEmpleados con los siguientes campos:
- IdEmpleado (Clave Primaria)
- TotalVentas

Crear un trigger de manera que, cada vez que se de de alta un nuevo pedido, con uno o más detalles de pedidos, si el empleado que consiguió el pedido no existía de VentasEmpleados, deberá insertar una nueva fila con el identificador del empleado y el valor del pedido (con descuentos) en el campo TotalVentas.

Si el empleado ya existía en VentasEmpleados deberá sumar a TotalVentas el valor del pedido. 

---

## Ejercicio 8:
Crear un trigger que, si se pretende dar de alta a un producto con un id de proveedor no existente, de previamente de alta a dicho proveedor (con el id indicado y el resto de campos a null).

---
