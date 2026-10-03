# Modelo Relacional Normalizado

**Proyecto:** Plataforma de Gestión de Alquiler de Vehículos  
**Estudiante:** Erick Santiago Rincon Rojas  
**Código:** 01251151002  
**Asignatura:** Bases de Datos  
**Entrega:** 2da Entrega - Proyecto de Clase

---

## 1. Introducción

Este informe describe cómo se aplicaron la primera, la segunda y la tercera forma normal al modelo de la Plataforma de Gestión de Alquiler de Vehículos, a partir del modelo entidad-relación de la primera entrega. El resultado es un modelo relacional de 17 relaciones en tercera forma normal (3FN).

Un mapeo directo del modelo entidad-relación ya produce relaciones casi normalizadas, por lo que no permitiría ver qué corrige cada forma normal. Por eso el proceso se hizo así:

1. Se reunieron todos los atributos del MER en una sola relación (`ALQUILER_BASE`), tal como estarían sin normalizar.
2. Se identificaron las dependencias funcionales a partir de las cardinalidades y llaves del MER.
3. Se aplicó cada forma normal en orden, mostrando el problema, la dependencia que lo causa y la corrección.
4. Las relaciones obtenidas en 3FN son el modelo final, y coinciden con lo que se obtiene al mapear el MER, incluyendo las especializaciones y las entidades débiles.

## 2. Contenido de la carpeta

| Archivo | Descripción |
|---|---|
| `Informe_Normalizacion.md` | Este informe. |
| `Modelo_Relacional.md` | Gráfico del modelo relacional normalizado en 3FN, hecho con Mermaid. |
| `Normalizacion_Modelo_Relacional.xlsx` | El mismo proceso en cuatro hojas: modelo base, 1FN, 2FN y 3FN. |

## 3. Modelo relacional base

### 3.1 Relación base

`ALQUILER_BASE` tiene una columna por cada atributo del MER (53 en total). La llave provisional es `idReserva`. Los atributos con nombre repetido entre entidades (`nombre`, `ciudad`, `direccion`, `estado`) llevan el nombre de la entidad o del rol como sufijo para no confundirlos. Al descomponer la relación recuperan su nombre original.

| Entidad de origen | Atributos |
|---|---|
| RESERVA | idReserva, fechaInicio, fechaFin, estadoReserva |
| USUARIO | idUsuario, nombreCompleto (compuesto), correo, tipoUsuario, telefono (multivaluado) |
| USUARIO_PARTICULAR | documentoIdentidad |
| USUARIO_EMPRESARIAL | NIT, razonSocial, limiteCredito |
| MEMBRESIA | idMembresia, nombreMembresia, descuentoPorcentaje, beneficio (multivaluado) |
| VEHICULO | placa, marca, modelo, tipoVehiculo, estadoVehiculo, caracteristica (multivaluado) |
| VEHICULO_ELECTRICO | autonomiaKm, nivelCargaSOC, conectorCarga (multivaluado) |
| TARIFA | idTarifa, precioPorHora, precioPorDia, precioPorKm |
| SUCURSAL (origen) | idSucursalOrigen, nombreSucursalOrigen, ciudadOrigen, direccionOrigen |
| SUCURSAL (destino) | idSucursalDestino, nombreSucursalDestino, ciudadDestino, direccionDestino |
| SUCURSAL (del vehículo) | idSucursalVehiculo, nombreSucursalVehiculo, ciudadVehiculo, direccionVehiculo |
| CONTRATO | numeroContrato, fechaFirma, depositoGarantia |
| INSPECCION | idInspeccion, tipoInspeccion, kilometraje, danoReportado (multivaluado) |
| PAGO | idPago, monto, fecha, metodoPago |

Los atributos compuestos, multivaluados y los grupos repetitivos (inspecciones y pagos) son los que se corrigen en 1FN.

### 3.2 Dependencias funcionales

Se deducen de las cardinalidades del MER (por ejemplo, una reserva tiene un solo usuario, un solo vehículo y una sola sucursal de origen) y de sus llaves primarias y alternas.

| N° | Determinante | Determina | Origen en el MER |
|---|---|---|---|
| 1 | `idReserva` | fechaInicio, fechaFin, estadoReserva, idUsuario, placa, idSucursalOrigen, idSucursalDestino, numeroContrato, fechaFirma, depositoGarantia | Una reserva la hace un solo usuario, es de un solo vehículo y tiene una sucursal de origen y una de destino (1,1). Genera como máximo un contrato (0,1). |
| 2 | `idUsuario` | nombreCompleto, correo, tipoUsuario, idMembresia, documentoIdentidad, NIT | Un usuario se suscribe como máximo a una membresía (0,1). documentoIdentidad y NIT dependen de su subtipo. |
| 3 | `correo` | idUsuario | Llave alterna de USUARIO. |
| 4 | `documentoIdentidad` | idUsuario | Llave alterna de USUARIO_PARTICULAR. |
| 5 | `NIT` | idUsuario, razonSocial, limiteCredito | Llave alterna de USUARIO_EMPRESARIAL. |
| 6 | `idMembresia` | nombreMembresia, descuentoPorcentaje | Atributos propios de MEMBRESIA. |
| 7 | `placa` | marca, modelo, tipoVehiculo, estadoVehiculo, idTarifa, idSucursalVehiculo, autonomiaKm, nivelCargaSOC | Cada vehículo tiene una tarifa y está en una sucursal (1,1). autonomiaKm y nivelCargaSOC solo aplican a eléctricos. |
| 8 | `idTarifa` | precioPorHora, precioPorDia, precioPorKm | Atributos propios de TARIFA. |
| 9 | `idSucursalOrigen / idSucursalDestino / idSucursalVehiculo` | nombre, ciudad y dirección de la sucursal correspondiente | Atributos propios de SUCURSAL. Se repite para cada uno de sus tres roles. |
| 10 | `numeroContrato` | idReserva, fechaFirma, depositoGarantia | Se supone que el número de contrato es único. |
| 11 | `idReserva, idInspeccion` | tipoInspeccion, kilometraje | INSPECCION es entidad débil de CONTRATO. |
| 12 | `idPago` | idReserva, monto, fecha, metodoPago | Cada pago pertenece a un solo contrato (1,1). |

### 3.3 Supuestos

1. Las cardinalidades se tomaron del MER de la primera entrega: una reserva tiene un usuario, un vehículo, una sucursal de origen y una de destino (1,1), y genera como máximo un contrato (0,1).
2. TARIFA se asigna directamente a cada vehículo, como indica el MER. Se supone que tipoVehiculo no determina la tarifa. Si el proyecto definiera la tarifa por tipo de vehículo, habría que crear una relación TIPO_VEHICULO.
3. correo, documentoIdentidad, NIT y numeroContrato son únicos (llaves alternas).
4. direccion es el texto de la dirección dentro de la ciudad, por lo que no determina a ciudad.
5. CONTRATO es entidad débil de RESERVA, pero como una reserva genera como máximo un contrato, idReserva por sí sola ya lo identifica y se usa como llave primaria. numeroContrato queda como llave alterna.
6. tipoUsuario se conserva como atributo que indica a qué subtipo pertenece el usuario.

## 4. Primera forma normal (1FN)

**Definición.** Una relación está en 1FN si todos sus atributos tienen un único valor indivisible y no existen grupos repetitivos.

**Problemas encontrados y solución:**

| N° | Atributo(s) | Problema | Solución |
|---|---|---|---|
| 1 | `nombreCompleto` | Atributo compuesto, no es atómico | Se separa en dos atributos: nombres y apellidos. |
| 2 | `telefono` | Atributo multivaluado | Se escribe una fila por cada teléfono. telefono pasa a ser parte de la llave. |
| 3 | `beneficio` | Atributo multivaluado | Se escribe una fila por cada beneficio. beneficio pasa a ser parte de la llave. |
| 4 | `caracteristica` | Atributo multivaluado | Se escribe una fila por cada característica. caracteristica pasa a ser parte de la llave. |
| 5 | `conectorCarga` | Atributo multivaluado | Se escribe una fila por cada conector. conectorCarga pasa a ser parte de la llave. |
| 6 | `idInspeccion, tipoInspeccion, kilometraje` | Grupo repetitivo | Se escribe una fila por cada inspección. idInspeccion pasa a ser parte de la llave. |
| 7 | `danoReportado` | Multivaluado dentro del grupo de inspección | Se escribe una fila por cada daño. danoReportado pasa a ser parte de la llave. |
| 8 | `idPago, monto, fecha, metodoPago` | Grupo repetitivo | Se escribe una fila por cada pago. idPago pasa a ser parte de la llave. |

**Resultado.** Se obtiene la relación `ALQUILER_1FN`, con 54 atributos y llave primaria compuesta por 8 de ellos:

```text
ALQUILER_1FN
  PK: (idReserva, telefono, beneficio, caracteristica, conectorCarga, idInspeccion, danoReportado, idPago)
  Atributos: idReserva, fechaInicio, fechaFin, estadoReserva, idUsuario, nombres, apellidos, correo, tipoUsuario, telefono, documentoIdentidad, NIT, razonSocial, limiteCredito, idMembresia, nombreMembresia, descuentoPorcentaje, beneficio, placa, marca, modelo, tipoVehiculo, estadoVehiculo, caracteristica, autonomiaKm, nivelCargaSOC, conectorCarga, idTarifa, precioPorHora, precioPorDia, precioPorKm, idSucursalOrigen, nombreSucursalOrigen, ciudadOrigen, direccionOrigen, idSucursalDestino, nombreSucursalDestino, ciudadDestino, direccionDestino, idSucursalVehiculo, nombreSucursalVehiculo, ciudadVehiculo, direccionVehiculo, numeroContrato, fechaFirma, depositoGarantia, idInspeccion, tipoInspeccion, kilometraje, danoReportado, idPago, monto, fecha, metodoPago
```

**Consecuencias.** La relación cumple 1FN, pero no es utilizable todavía:

- Los datos de la reserva, el usuario, el vehículo y las demás entidades se repiten en cada fila. Una reserva con 2 teléfonos, 2 inspecciones y 3 pagos necesita al menos 12 filas, cada una con los 41 datos de la reserva repetidos.
- Si una reserva no tiene contrato, inspecciones o pagos, o el usuario no tiene teléfono, las columnas de la llave correspondientes quedarían vacías, y una llave no puede tener valores vacíos.

Estos problemas se resuelven en 2FN.

## 5. Segunda forma normal (2FN)

**Definición.** Una relación está en 2FN si está en 1FN y ningún atributo que no es llave depende solo de una parte de la llave compuesta (no hay dependencias parciales).

**Dependencias parciales detectadas en `ALQUILER_1FN`:**

| N° | Parte de la llave | Atributos que determina | Relación resultante |
|---|---|---|---|
| 1 | `idReserva` | Todos los atributos de reserva, usuario, membresía, vehículo, tarifa, sucursales y contrato (41 atributos) | `RESERVA_DATOS` |
| 2 | `idReserva, idInspeccion` | tipoInspeccion, kilometraje | `INSPECCION` |
| 3 | `idPago` | idReserva, monto, fecha, metodoPago | `PAGO` |
| 4 | `idReserva, telefono` | Ninguno. Solo forman llave | `RESERVA_TELEFONO` |
| 5 | `idReserva, beneficio` | Ninguno. Solo forman llave | `RESERVA_BENEFICIO` |
| 6 | `idReserva, caracteristica` | Ninguno. Solo forman llave | `RESERVA_CARACTERISTICA` |
| 7 | `idReserva, conectorCarga` | Ninguno. Solo forman llave | `RESERVA_CONECTOR` |
| 8 | `idReserva, idInspeccion, danoReportado` | Ninguno. Solo forman llave | `INSPECCION_DANO` |

Por ejemplo, `fechaInicio` depende solo de `idReserva`, que es una parte de la llave de 8 atributos; `kilometraje` depende de `(idReserva, idInspeccion)`; y `monto` depende solo de `idPago`. Se descompuso la relación para que cada atributo dependa de toda la llave de su relación.

**Resultado:** 8 relaciones en 2FN.

| N° | Relación | Llave primaria | Atributos que no son llave |
|---|---|---|---|
| 1 | `RESERVA_DATOS` | idReserva | fechaInicio, fechaFin, estadoReserva, idUsuario, nombres, apellidos, correo, tipoUsuario, documentoIdentidad, NIT, razonSocial, limiteCredito, idMembresia, nombreMembresia, descuentoPorcentaje, placa, marca, modelo, tipoVehiculo, estadoVehiculo, autonomiaKm, nivelCargaSOC, idTarifa, precioPorHora, precioPorDia, precioPorKm, idSucursalOrigen, nombreSucursalOrigen, ciudadOrigen, direccionOrigen, idSucursalDestino, nombreSucursalDestino, ciudadDestino, direccionDestino, idSucursalVehiculo, nombreSucursalVehiculo, ciudadVehiculo, direccionVehiculo, numeroContrato, fechaFirma, depositoGarantia |
| 2 | `RESERVA_TELEFONO` | idReserva, telefono | Ninguno |
| 3 | `RESERVA_BENEFICIO` | idReserva, beneficio | Ninguno |
| 4 | `RESERVA_CARACTERISTICA` | idReserva, caracteristica | Ninguno |
| 5 | `RESERVA_CONECTOR` | idReserva, conectorCarga | Ninguno |
| 6 | `INSPECCION` | idReserva, idInspeccion | tipoInspeccion, kilometraje |
| 7 | `INSPECCION_DANO` | idReserva, idInspeccion, danoReportado | Ninguno |
| 8 | `PAGO` | idPago | idReserva, monto, fecha, metodoPago |

En `RESERVA_DATOS` la llave es un solo atributo, por lo que no puede haber dependencias parciales. En las demás relaciones, o todos los atributos forman la llave, o los atributos dependen de la llave completa. Quedan dependencias transitivas dentro de `RESERVA_DATOS`, que se resuelven en 3FN.

## 6. Tercera forma normal (3FN)

**Definición.** Una relación está en 3FN si está en 2FN y ningún atributo que no es llave depende de otro atributo que no es llave (no hay dependencias transitivas).

En `RESERVA_DATOS` los datos del usuario, la membresía, el vehículo, la tarifa, las sucursales y el contrato dependen de `idReserva` solo a través de otro atributo (`idUsuario`, `idMembresia`, `placa`, `idTarifa`, `idSucursal`, `numeroContrato`). Se separó cada grupo en su propia relación.

| N° | Dependencia o motivo | Atributos que pasan a la nueva relación | Relación resultante | Justificación |
|---|---|---|---|---|
| 1 | idReserva → idUsuario → datos del usuario | nombres, apellidos, correo, tipoUsuario, idMembresia | USUARIO | Dependencia transitiva |
| 2 | idUsuario → idMembresia → datos de la membresía | nombre, descuentoPorcentaje | MEMBRESIA | Dependencia transitiva |
| 3 | idReserva → placa → datos del vehículo | marca, modelo, tipoVehiculo, estado, idTarifa, idSucursal | VEHICULO | Dependencia transitiva |
| 4 | placa → idTarifa → precios | precioPorHora, precioPorDia, precioPorKm | TARIFA | Dependencia transitiva |
| 5 | idReserva → idSucursal (origen, destino y del vehículo) → datos de la sucursal | nombre, ciudad, direccion | SUCURSAL (una sola relación para los tres roles) | Dependencia transitiva |
| 6 | idReserva → numeroContrato → datos del contrato | numeroContrato, fechaFirma, depositoGarantia | CONTRATO | Dependencia transitiva (si numeroContrato es único) y opcionalidad (0,1) del contrato |
| 7 | NIT → razonSocial, limiteCredito. documentoIdentidad → idUsuario | documentoIdentidad, NIT, razonSocial, limiteCredito | USUARIO_PARTICULAR, USUARIO_EMPRESARIAL | Dependencia transitiva y especialización total disjunta del MER (evita valores vacíos) |
| 8 | placa → autonomiaKm, nivelCargaSOC | autonomiaKm, nivelCargaSOC | VEHICULO_ELECTRICO | Especialización parcial del MER. No es una dependencia transitiva estricta, pero evita valores vacíos |
| 9 | telefono depende del usuario, no de la reserva | telefono | USUARIO_TELEFONO | Redundancia: el mismo teléfono se repetía por cada reserva del usuario |
| 10 | beneficio depende de la membresía, no de la reserva | beneficio | MEMBRESIA_BENEFICIO | Redundancia: el mismo beneficio se repetía por cada reserva con esa membresía |
| 11 | caracteristica depende del vehículo, no de la reserva | caracteristica | VEHICULO_CARACTERISTICA | Redundancia: la misma característica se repetía por cada reserva del vehículo |
| 12 | conectorCarga depende del vehículo eléctrico, no de la reserva | conectorCarga | VEHICULO_CONECTOR | Redundancia: el mismo conector se repetía por cada reserva del vehículo |
| 13 | INSPECCION, INSPECCION_DANO y PAGO | Sin cambios en sus atributos | INSPECCION, INSPECCION_DANO, PAGO | Ya estaban en 3FN. Solo cambia su llave foránea idReserva, que ahora apunta a CONTRATO |

Hay dos casos que no son dependencias transitivas estrictas y conviene decirlo: `VEHICULO_ELECTRICO` se separa por la especialización parcial del MER, y `CONTRATO` por la opcionalidad (0,1) de la relación con la reserva. En ambos casos la separación evita columnas con muchos valores vacíos.

## 7. Modelo relacional final

### 7.1 Relaciones

| N° | Relación | Llave primaria | Atributos que no son llave | Llaves foráneas | Llaves alternas |
|---|---|---|---|---|---|
| 1 | `SUCURSAL` | idSucursal | nombre, ciudad, direccion | Ninguna | Ninguna |
| 2 | `TARIFA` | idTarifa | precioPorHora, precioPorDia, precioPorKm | Ninguna | Ninguna |
| 3 | `MEMBRESIA` | idMembresia | nombre, descuentoPorcentaje | Ninguna | Ninguna |
| 4 | `MEMBRESIA_BENEFICIO` | idMembresia, beneficio | Ninguno | idMembresia → MEMBRESIA | Ninguna |
| 5 | `USUARIO` | idUsuario | nombres, apellidos, correo, tipoUsuario, idMembresia | idMembresia → MEMBRESIA (opcional) | correo |
| 6 | `USUARIO_TELEFONO` | idUsuario, telefono | Ninguno | idUsuario → USUARIO | Ninguna |
| 7 | `USUARIO_PARTICULAR` | idUsuario | documentoIdentidad | idUsuario → USUARIO | documentoIdentidad |
| 8 | `USUARIO_EMPRESARIAL` | idUsuario | NIT, razonSocial, limiteCredito | idUsuario → USUARIO | NIT |
| 9 | `VEHICULO` | placa | marca, modelo, tipoVehiculo, estado, idTarifa, idSucursal | idTarifa → TARIFA<br>idSucursal → SUCURSAL | Ninguna |
| 10 | `VEHICULO_CARACTERISTICA` | placa, caracteristica | Ninguno | placa → VEHICULO | Ninguna |
| 11 | `VEHICULO_ELECTRICO` | placa | autonomiaKm, nivelCargaSOC | placa → VEHICULO | Ninguna |
| 12 | `VEHICULO_CONECTOR` | placa, conectorCarga | Ninguno | placa → VEHICULO_ELECTRICO | Ninguna |
| 13 | `RESERVA` | idReserva | fechaInicio, fechaFin, estadoReserva, idUsuario, placa, idSucursalOrigen, idSucursalDestino | idUsuario → USUARIO<br>placa → VEHICULO<br>idSucursalOrigen → SUCURSAL<br>idSucursalDestino → SUCURSAL | Ninguna |
| 14 | `CONTRATO` | idReserva | numeroContrato, fechaFirma, depositoGarantia | idReserva → RESERVA | numeroContrato |
| 15 | `INSPECCION` | idReserva, idInspeccion | tipoInspeccion, kilometraje | idReserva → CONTRATO | Ninguna |
| 16 | `INSPECCION_DANO` | idReserva, idInspeccion, danoReportado | Ninguno | (idReserva, idInspeccion) → INSPECCION | Ninguna |
| 17 | `PAGO` | idPago | idReserva, monto, fecha, metodoPago | idReserva → CONTRATO | Ninguna |

### 7.2 Gráfico

El gráfico del modelo relacional está en [`Modelo_Relacional.md`](Modelo_Relacional.md), dibujado con Mermaid, que GitHub muestra directamente. Incluye las 17 relaciones con sus llaves primarias (PK), foráneas (FK) y alternas (UK), y las cardinalidades.

### 7.3 Restricciones que no se expresan solo con llaves

- **Especialización de USUARIO (total y disjunta):** todo usuario debe tener exactamente una fila en `USUARIO_PARTICULAR` o en `USUARIO_EMPRESARIAL`, según `tipoUsuario`. Se controla con un `CHECK` sobre `tipoUsuario` y con disparadores (triggers) o en la aplicación.
- **Especialización de VEHICULO (parcial y disjunta):** solo los vehículos eléctricos tienen fila en `VEHICULO_ELECTRICO`.
- **Membresía opcional:** `USUARIO.idMembresia` admite valor nulo, porque un usuario puede no tener membresía (0,1).
- **Sucursales de la reserva:** `idSucursalOrigen` e `idSucursalDestino` son dos llaves foráneas a `SUCURSAL`. Esto permite devolver el vehículo en otra ciudad.
- **Contrato:** `CONTRATO` usa `idReserva` como llave primaria y foránea, por lo que cada reserva genera como máximo un contrato.

## 8. Verificación de 3FN

Para cada relación final se listan sus dependencias funcionales. Cumple 3FN si todo determinante es llave primaria o alterna.

| N° | Relación | Dependencias funcionales | Resultado |
|---|---|---|---|
| 1 | `SUCURSAL` | idSucursal → nombre, ciudad, direccion | Cumple. Todo determinante es llave |
| 2 | `TARIFA` | idTarifa → precioPorHora, precioPorDia, precioPorKm | Cumple. Todo determinante es llave |
| 3 | `MEMBRESIA` | idMembresia → nombre, descuentoPorcentaje | Cumple. Todo determinante es llave |
| 4 | `MEMBRESIA_BENEFICIO` | Ninguna (todos los atributos forman la llave) | Cumple. No tiene atributos fuera de la llave |
| 5 | `USUARIO` | idUsuario → nombres, apellidos, correo, tipoUsuario, idMembresia. correo → idUsuario | Cumple. Todo determinante es llave |
| 6 | `USUARIO_TELEFONO` | Ninguna (todos los atributos forman la llave) | Cumple. No tiene atributos fuera de la llave |
| 7 | `USUARIO_PARTICULAR` | idUsuario → documentoIdentidad. documentoIdentidad → idUsuario | Cumple. Todo determinante es llave |
| 8 | `USUARIO_EMPRESARIAL` | idUsuario → NIT, razonSocial, limiteCredito. NIT → idUsuario, razonSocial, limiteCredito | Cumple. Todo determinante es llave |
| 9 | `VEHICULO` | placa → marca, modelo, tipoVehiculo, estado, idTarifa, idSucursal | Cumple. Todo determinante es llave |
| 10 | `VEHICULO_CARACTERISTICA` | Ninguna (todos los atributos forman la llave) | Cumple. No tiene atributos fuera de la llave |
| 11 | `VEHICULO_ELECTRICO` | placa → autonomiaKm, nivelCargaSOC | Cumple. Todo determinante es llave |
| 12 | `VEHICULO_CONECTOR` | Ninguna (todos los atributos forman la llave) | Cumple. No tiene atributos fuera de la llave |
| 13 | `RESERVA` | idReserva → fechaInicio, fechaFin, estadoReserva, idUsuario, placa, idSucursalOrigen, idSucursalDestino | Cumple. Todo determinante es llave |
| 14 | `CONTRATO` | idReserva → numeroContrato, fechaFirma, depositoGarantia. numeroContrato → idReserva, fechaFirma, depositoGarantia | Cumple. Todo determinante es llave |
| 15 | `INSPECCION` | (idReserva, idInspeccion) → tipoInspeccion, kilometraje | Cumple. Todo determinante es llave |
| 16 | `INSPECCION_DANO` | Ninguna (todos los atributos forman la llave) | Cumple. No tiene atributos fuera de la llave |
| 17 | `PAGO` | idPago → idReserva, monto, fecha, metodoPago | Cumple. Todo determinante es llave |

Como en todas las relaciones los determinantes son llaves candidatas, las relaciones también cumplen la forma normal de Boyce-Codd (BCNF), con las dependencias funcionales y supuestos indicados.

## 9. Conclusión

Partiendo de una relación con todos los atributos del MER, la 1FN eliminó los atributos compuestos y multivaluados y los grupos repetitivos; la 2FN eliminó las dependencias parciales de la llave compuesta; y la 3FN eliminó las dependencias transitivas y llevó cada atributo multivaluado a la entidad a la que pertenece. El modelo final tiene 17 relaciones sin redundancia por dependencias funcionales, y conserva las cardinalidades, las especializaciones y las entidades débiles del modelo entidad-relación de la primera entrega.
