# Tercera Entrega (rehecha): Base de datos en MariaDB + DBeaver

Implementación física del modelo relacional en 3FN de la 2da entrega (**17 relaciones**), lista para correr en MariaDB y administrar con DBeaver.

> Esta versión **reemplaza** la tercera entrega anterior, que usaba un esquema de 5 tablas (`categorias`, `clientes`, `alquileres`…) que no correspondía al modelo normalizado.

## Archivos

| Orden | Archivo | Qué hace |
|---|---|---|
| 0 | `00_usuario_dbeaver.sql` | Crea el usuario `alquiler` para conectar DBeaver (una sola vez). |
| 1 | `01_esquema_ddl.sql` | Borra y crea la base `alquiler_vehiculos`: 17 tablas, 7 triggers, 4 vistas. |
| 2 | `02_datos_prueba_dml.sql` | Carga datos ficticios (5 sucursales, 10 usuarios, 13 vehículos, 14 reservas…). |
| 3 | `03_consultas.sql` | 15 consultas de ejemplo y de control de integridad. |
| 4 | `04_pruebas_restricciones.sql` | 16 sentencias que **deben fallar** (opcional, para demostrar las restricciones). |

## Paso a paso

### 1. Instalar e iniciar MariaDB (CachyOS / Arch)

```bash
sudo pacman -S mariadb
sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql   # solo la primera vez
sudo systemctl enable --now mariadb
```

### 2. Crear el usuario para DBeaver

Edita la contraseña en `00_usuario_dbeaver.sql` y ejecuta:

```bash
sudo mariadb < 00_usuario_dbeaver.sql
```

(`root` entra por socket y DBeaver no puede usarlo por TCP; por eso el usuario propio.)

### 3. Conectar DBeaver

1. **Database → New Database Connection → MariaDB**.
2. Host `localhost`, puerto `3306`, usuario `alquiler`, la contraseña que pusiste.
3. Deja **Database** vacío (la crea el script). DBeaver descarga el driver la primera vez: acepta.
4. **Test Connection → Finish**.

### 4. Crear la base y cargar los datos

1. Con la conexión seleccionada: **SQL Editor → Open SQL script** y abre `01_esquema_ddl.sql`.
2. Ejecútalo con **Execute SQL Script (`Alt+X`)**. No uses `Ctrl+Enter`: ese atajo ejecuta una sola sentencia y los triggers quedarían a medias.
3. Repite con `02_datos_prueba_dml.sql`.
4. Pulsa `F5` sobre la conexión para refrescar. Debe aparecer `alquiler_vehiculos` con 17 tablas.

### 5. Ver el diagrama ER

Clic derecho sobre la base `alquiler_vehiculos` → **View Diagram**. DBeaver dibuja las 17 tablas y sus llaves foráneas a partir de lo que creó el DDL.

## Decisiones de diseño

- **Nombres:** tablas en minúscula (MariaDB en Linux distingue mayúsculas en tablas) y columnas con los mismos nombres del modelo relacional (`idUsuario`, `fechaInicio`, `precioPorDia`…).
- **Llaves:** todas las PK, FK y llaves alternas del modelo (`correo`, `documentoIdentidad`, `NIT`, `numeroContrato`) están declaradas. `contrato` usa `idReserva` como PK y FK, por lo que una reserva tiene como máximo un contrato. `inspeccion_dano` tiene FK compuesta hacia `inspeccion`.
- **Acciones referenciales:** los atributos multivaluados (teléfonos, beneficios, características, conectores, daños) se borran en cascada con su dueño; reservas, contratos y pagos usan `RESTRICT` para no perder historial.
- **Dominios con `CHECK`:** estados, tipos, métodos de pago, fechas (`fechaFin > fechaInicio`), montos positivos y porcentajes entre 0 y 100.
- **Reglas que no caben en llaves** (sección 7.3 del informe de normalización), resueltas con triggers:
  - Un usuario solo puede tener fila en `usuario_particular` o `usuario_empresarial` si su `tipoUsuario` coincide.
  - Solo los vehículos `ELECTRICO` tienen fila en `vehiculo_electrico`.
  - Un vehículo no puede tener dos reservas solapadas (evita el *overbooking* que menciona la actividad exploratoria).
  - No se firma contrato sobre una reserva cancelada.
- **Especialización total de USUARIO:** SQL no puede exigir que cada usuario *tenga* su fila de subtipo en el mismo `INSERT`. Por eso insertas primero en `usuario` y luego en el subtipo, y las vistas `v_usuarios_sin_subtipo` y `v_electricos_sin_detalle` deben devolver 0 filas.
- **`idInspeccion`:** forma parte de la PK compuesta `(idReserva, idInspeccion)`; InnoDB no autonumera la segunda columna, así que se asigna a mano (1 = entrega, 2 = devolución en los datos de prueba).
- **Montos:** pesos colombianos, `DECIMAL(12,2)`. Los pagos de prueba ya traen aplicado el descuento de la membresía.

## Reiniciar desde cero

Volver a ejecutar `01_esquema_ddl.sql` y luego `02_datos_prueba_dml.sql`. El primero borra la base completa, así que no lo corras si ya tienes datos propios que quieras conservar.

## Autor

Erick Santiago Rincón Rojas · Código `01251151002` · Universidad de Santander (UDES)
