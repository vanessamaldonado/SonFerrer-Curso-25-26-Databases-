# Lab 04:  DELETE en MongoDB

## Parte 1: deleteOne()

1. Eliminar un cliente por ID CL15.
2. Eliminar un cliente por email "old@example.com".
3. Eliminar un cliente con nombre "Raúl Castro" y sin puntos_fidelidad.
4. Eliminar un cliente que tenga "PayPal" como método de pago.
5. Eliminar un cliente que viva en "Madrid".
6. Eliminar un cliente con puntos_fidelidad igual a 500.
7. Eliminar un cliente con estatus "inactivo" y sin teléfono.
8. Eliminar un cliente con preferencias vacías.
9. Eliminar un cliente con nombre "William Suh" y ciudad "Guadalajara".
10. Eliminar un cliente que tenga definido el campo direccion.

## Parte 2: deleteMany()

1. Eliminar todos los clientes con estatus "inactivo".
2. Eliminar todos los clientes con puntos_fidelidad menor a 100.
3. Eliminar todos los clientes sin teléfono.
4. Eliminar todos los clientes que no tengan preferencias.
5. Eliminar todos los clientes que vivan en “Guadalajara” o “Querétaro”
6. Eliminar todos los clientes que no tengan historial_acceso.
7. Eliminar todos los clientes cuyo array preferencias.categorias_favoritas esté vacío.
8. Eliminar todos los clientes que vivan en "Querétaro" y tengan estatus "activo".
9. Eliminar todos los clientes que tengan campo direccion.ciudad igual a "Barcelona".
10. Eliminar todos los clientes de la colección (reset).

## Casos adicionales. Usando operadores lógicos

1. Eliminar un cliente que tenga más de una categoría favorita y estatus "activo".
2. Eliminar un cliente con puntos_fidelidad entre 200 y 500 y ciudad "Guadalajara".
3. Eliminar un cliente que tenga "tecnologia" o "hogar" en su array de categorías favoritas.
4. Eliminar un cliente que no tenga puntos_fidelidad o no tenga teléfono.
5. Eliminar un cliente con confirmación de escritura replicada en 2 nodos y estatus "activo".
6. Eliminar un cliente que tenga un método de pago tipo "tarjeta_credito" y número "3456".
7. Eliminar un cliente sin teléfono y sin historial_acceso.
8. Eliminar un cliente con puntos_fidelidad menor a 200 o mayor a 800.
9. Eliminar un cliente que viva en "Puebla" y tenga estatus "activo".
10. Eliminar un cliente que tenga definido el campo direccion y sin teléfono.

