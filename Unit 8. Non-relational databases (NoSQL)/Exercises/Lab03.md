## Lab03: UPDATE en MongoDB

1. Crear la base de datos `LabTestDB` y la colección `clientes`.
2. Utiliza el archivo `clientes.json` para precargar datos: [download link](../BBDD/clientes.json)
3. Verifica que la colección `clientes` no está vacía.

## Parte 1: updateOne()

1. Cambiar el nombre de un cliente: Actualiza el nombre del cliente con _id: "CL1" a "William Sun" utilizando $set.
2. Activar notificaciones de un cliente específico: Busca el cliente con email `john.booth@example.com` y activa el campo: `preferencias.notificaciones = true`
3. Incrementar puntos de fidelidad: Aumenta en 50 puntos el campo `puntos_fidelidad` del cliente con _id: "CL2" usando $inc.
4. Crear un cliente si no existe (upsert): Si no existe un cliente con _id: "CL999", créalo con:
   - nombre: "Nuevo Cliente"
   - puntos_fidelidad: 10
5. Añadir categoría favorita: Añade  juguetes` al array `preferencias.categorias_favoritas` del cliente con _id: "CL3".
6. Añadir un nuevo campo al cliente: Añade el campo estatus con valor "verificado" al cliente con _id: "CL1".
7. Eliminar un campo: Elimina el campo telefono del cliente con _id: "CL4".
8. Añadir varios valores a un array: Añade los valores `música` y `deportes` al array preferencias.categorias_favoritas del cliente con _id: "CL3" usando $push y $each.
9. Incrementar un campo existente o crearlo si no existe: Incrementa en 10 el campo puntos_fidelidad del cliente con _id: "CL10".
10. Añadir un campo anidado: Añade al cliente con _id: "CL5" el siguiente campo:
```javascript
    direccion: {
      ciudad: "Valencia"
    }
```
---

## Parte 2: updateMany()

11. Cambiar estatus de clientes inactivos: Actualiza todos los clientes con estatus: "inactivo" y cambia su estatus a "suspendido".
12. Añadir categoría a todos los clientes: Añade la categoría "hogar" al array preferencias.categorias_favoritas de todos los clientes.
13. Establecer puntos mínimos: Actualiza todos los clientes que tengan puntos_fidelidad menor que 50 y establece el valor a 50.
14. Marcar clientes con notificaciones activas: Busca los clientes con preferencias.notificaciones = true y añade un nuevo campo: notificacion_activa = true
15. Completar teléfonos nulos: A los clientes que tengan telefono: null, asígnales el valor: "+34-000-000000"
16. Actualizar emails de Hotmail: Busca los clientes cuyo email termine en @hotmail.com y cambia su email a: "actualizado@dominio.com"
17. Eliminar campo innecesario: Elimina el campo comentarios de todos los clientes.
18. Incrementar puntos de clientes fieles: Aumenta en 100 puntos el campo puntos_fidelidad de los clientes que tengan 900 o más puntos.
19. Añadir campo a clientes de una ciudad: Añade el campo actualizado: true a todos los clientes cuya ciudad sea "Puebla".
20. Actualizar múltiples condiciones: Busca los clientes que: vivan en "Guadalajara" y tengan estatus: "activo" y añade el campo: zona_prioritaria = true

---

## Casos adicionales

21. Añadir campo de auditoría: Añade el campo actualizado_por: "sistema" a todos los documentos.
22. Vaciar un array: Vacía el array historial_acceso del cliente con _id: "CL6".
23. Eliminar elementos de un array: Elimina el método de pago "PayPal" del cliente que lo tenga.
24. Modificar un valor dentro de un array: Cambia el dispositivo "iPad" por "Tablet" en el historial del cliente con _id: "CL7".
25. Añadir múltiples valores a un array: Añade "música" y "deportes" al array preferencias.categorias_favoritas del cliente con _id: "CL8".
26. Añadir campo de fecha actual: Añade un campo ultima_actualizacion con la fecha actual al cliente con _id: "CL10".
27. Establecer valor mínimo: Si el cliente con _id: "CL11" tiene menos de 100 puntos, actualízalo a 100.
28. Establecer valor máximo: Si el cliente con _id: "CL12" tiene más de 900 puntos, ajústalo a 900.
29. Activar notificaciones: Activa las notificaciones (true) para los clientes que las tengan desactivadas.
30. Añadir un array nuevo: Añade al cliente con _id: "CL13" un campo tags con los valores:
    - "VIP"
    - "reciente"
31. Renombrar un campo: Renombra el campo telefono a telefono_movil en los documentos.
32. Actualizar múltiples campos a la vez: Para el cliente con _id: "CL14":
    - incrementa puntos_fidelidad en 10
    - añade "hogar" a categorias_favoritas (sin duplicados)
33. Actualizar campo anidado: Cambia la ciudad dentro de direccion del cliente con _id: "CL16" a "Tijuana".


---


<details><summary>Mostrar Solución Parte 1</summary>

```javascript
use LabTestDB
db.createCollection("clientes")
db.clientes.find()

//1
db.clientes.updateOne(
 { _id: "CL1" },
 { $set: { nombre: "William Sun" } }
)

//2
db.clientes.updateOne(
 { email: "john.booth@example.com" },
 { $set: { "preferencias.notificaciones": true } }
)

//3
db.clientes.updateOne(
 { _id: "CL2" },
 { $inc: { puntos_fidelidad: 50 } }
)

//4
db.clientes.updateOne(
 { _id: "CL999" },
 { $set: { nombre: "Nuevo Cliente", puntos_fidelidad: 10 } },
 { upsert: true }
)

//5
db.clientes.updateOne(
 { _id: "CL3" },
 { $push: { "preferencias.categorias_favoritas": "juguetes" } }
)

//6
db.clientes.updateOne(
 { _id: "CL1" },
 { $set: { estatus: "verificado" } }
)

//7
db.clientes.updateOne(
 { _id: "CL4" },
 { $unset: { telefono: "" } }
)

//8
db.clientes.updateOne(
 { _id: "CL3" },
 {
   $push: {
     "preferencias.categorias_favoritas": {
       $each: ["música", "deportes"]
     }
   }
 }
)

//9
db.clientes.updateOne(
 { _id: "CL10" },
 { $inc: { puntos_fidelidad: 10 } }
)

//10
db.clientes.updateOne(
 { _id: "CL5" },
 { $set: { "direccion.ciudad": "Valencia" } }
)
```

</details>

---

<details><summary>Mostrar Solución Parte 2</summary>

```javascript
use LabTestDB
db.clientes.find()

//11
db.clientes.updateMany(
 { estatus: "inactivo" },
 { $set: { estatus: "suspendido" } }
)

//12
db.clientes.updateMany(
 {},
 { $push: { "preferencias.categorias_favoritas": "hogar" } }
 //$addToSet: { "preferencias.categorias_favoritas": "hogar" }
)

//13
db.clientes.updateMany(
 { puntos_fidelidad: { $lt: 50 } },
 { $set: { puntos_fidelidad: 50 } }
)

//14
db.clientes.updateMany(
 { "preferencias.notificaciones": true },
 { $set: { notificacion_activa: true } }
)

//15
db.clientes.updateMany(
 { telefono: null },
 { $set: { telefono: "+34-000-000000" } }
)

//16
db.clientes.updateMany(
 { email: /@hotmail\.com$/ },
 { $set: { email: "actualizado@dominio.com" } }
)

//17
db.clientes.updateMany(
 {},
 { $unset: { comentarios: "" } }
)

//18
db.clientes.updateMany(
 { puntos_fidelidad: { $gte: 900 } },
 { $inc: { puntos_fidelidad: 100 } }
)

//19
db.clientes.updateMany(
 { ciudad: "Puebla" },
 { $set: { actualizado: true } }
)

//20
db.clientes.updateMany(
 { ciudad: "Guadalajara", estatus: "activo" },
 { $set: { zona_prioritaria: true } }
)
```

</details>

--- 

<details><summary>Mostrar Solución Casos adicionales</summary>

```javascript
use LabTestDB

//21
db.clientes.updateMany(
 {},
 { $set: { actualizado_por: "sistema" } }
)

//22
db.clientes.updateOne(
 { _id: "CL6" },
 { $set: { historial_acceso: [] } }
)

//23
db.clientes.updateOne(
 { "metodos_pago.tipo": "PayPal" },
 { $pull: { metodos_pago: { tipo: "PayPal" } } }
)

//24
db.clientes.updateOne(
 { _id: "CL7", "historial_acceso.dispositivo": "iPad" },
 { $set: { "historial_acceso.$.dispositivo": "Tablet" } }
)

//25
db.clientes.updateOne(
 { _id: "CL8" },
 {
   $push: {
     "preferencias.categorias_favoritas": {
       $each: ["música", "deportes"]
     }
   }
 }
)

//26
db.clientes.updateOne(
 { _id: "CL10" },
 { $currentDate: { ultima_actualizacion: true } }
)

//27
db.clientes.updateOne(
 { _id: "CL11" },
 { $min: { puntos_fidelidad: 100 } }
)

//28
db.clientes.updateOne(
 { _id: "CL12" },
 { $max: { puntos_fidelidad: 900 } }
)

//29
db.clientes.updateMany(
 { "preferencias.notificaciones": false },
 { $set: { "preferencias.notificaciones": true } }
)

//30
db.clientes.updateOne(
 { _id: "CL13" },
 { $set: { tags: ["VIP", "reciente"] } }
)

//31
db.clientes.updateMany(
 {},
 { $rename: { telefono: "telefono_movil" } }
)

//32
db.clientes.updateOne(
 { _id: "CL14" },
 {
   $inc: { puntos_fidelidad: 10 },
   $addToSet: { "preferencias.categorias_favoritas": "hogar" }
 }
)

//33
db.clientes.updateOne(
 { _id: "CL16" },
 { $set: { "direccion.ciudad": "Tijuana" } }
)
```
</details>
