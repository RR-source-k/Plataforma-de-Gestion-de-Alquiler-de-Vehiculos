# 🚗 Plataforma de Gestión de Alquiler de Vehículos

Este repositorio contiene la arquitectura, el modelo relacional y la implementación de la base de datos para la **Plataforma de Gestión de Alquiler de Vehículos**, desarrollada como parte del proyecto académico de la carrera de Ingeniería en Ciencias de la Computación e Inteligencia Artificial en la Universidad de Santander (UDES).

---

## 📌 Estructura del Repositorio

```text
Plataforma-de-Gestion-de-Alquiler-de-Vehiculos/
├── Primera Entrega/
│   ├── Actividad_Exploratoria.md
│   └── Modelo Entidad Relación.pdf
├── Segunda entrega/
│   └── Modelo Relacional/
│       ├── Informe_Normalizacion.md
│       ├── Modelo_Relacional.md
│       └── Normalizacion_Modelo_Relacional.xlsx
├── Tercera Entrega/
│   ├── 00_usuario_dbeaver.sql          # Usuario para conectar DBeaver
│   ├── 01_esquema_ddl.sql              # Creación de la base, tablas, triggers y vistas (DDL)
│   ├── 02_datos_prueba_dml.sql         # Datos de prueba (DML)
│   ├── 03_consultas.sql                # Consultas de ejemplo y verificación
│   ├── 04_pruebas_restricciones.sql    # Pruebas negativas (deben fallar)
│   └── README.md                       # Guía detallada de la entrega
└── README.md
```

---

## 🛠️ Tecnologías Utilizadas

* **Motor de Base de Datos:** MariaDB
* **Cliente de Gestión SQL:** DBeaver Community Edition
* **Entorno de Desarrollo:** CachyOS (Arch Linux)
* **Lenguaje:** SQL (dialecto MariaDB)

---

## 🗄️ Esquema de la Base de Datos (`alquiler_vehiculos`)

La base de datos implementa el modelo relacional de la 2da entrega, normalizado hasta **3FN / BCNF**, con **17 tablas**:

| Grupo | Tablas |
|---|---|
| Sedes y precios | `sucursal`, `tarifa` |
| Membresías | `membresia`, `membresia_beneficio` |
| Usuarios | `usuario`, `usuario_telefono`, `usuario_particular`, `usuario_empresarial` |
| Flota | `vehiculo`, `vehiculo_caracteristica`, `vehiculo_electrico`, `vehiculo_conector` |
| Operación | `reserva`, `contrato`, `inspeccion`, `inspeccion_dano`, `pago` |

Además incluye:

* **7 triggers** para las reglas que no se expresan solo con llaves: especialización de usuario (particular / empresarial), especialización de vehículo eléctrico, prevención de *overbooking* (reservas solapadas del mismo vehículo) y bloqueo de contratos sobre reservas canceladas.
* **4 vistas** de apoyo: `v_usuario_detalle`, `v_reserva_detalle`, `v_usuarios_sin_subtipo` y `v_electricos_sin_detalle`.

El modelo gráfico está en [`Modelo_Relacional.md`](Segunda%20entrega/Modelo%20Relacional/Modelo_Relacional.md) y el proceso de normalización en [`Informe_Normalizacion.md`](Segunda%20entrega/Modelo%20Relacional/Informe_Normalizacion.md).

---

## 🚀 Instrucciones de Despliegue e Inicialización

> La guía completa, con la conexión paso a paso en DBeaver y las decisiones de diseño, está en [`Tercera Entrega/README.md`](Tercera%20Entrega/README.md).

### 1. Requisitos Previos

Instalar e iniciar MariaDB en Arch Linux / CachyOS:

```bash
sudo pacman -S mariadb
sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql   # solo la primera vez
sudo systemctl enable --now mariadb
```

### 2. Usuario para DBeaver

Edita la contraseña en `00_usuario_dbeaver.sql` y ejecuta:

```bash
sudo mariadb < "Tercera Entrega/00_usuario_dbeaver.sql"
```

### 3. Creación del Esquema (DDL)

> ⚠️ Este script borra y vuelve a crear la base `alquiler_vehiculos`.

```bash
mariadb -u alquiler -p < "Tercera Entrega/01_esquema_ddl.sql"
```

### 4. Carga de Datos de Prueba (DML)

```bash
mariadb -u alquiler -p < "Tercera Entrega/02_datos_prueba_dml.sql"
```

### 5. Consultas y pruebas (opcional)

* `03_consultas.sql`: consultas de ejemplo y control de integridad.
* `04_pruebas_restricciones.sql`: sentencias que **deben fallar**, para demostrar que las restricciones funcionan.

### Desde DBeaver

Abre cada script en el editor SQL y ejecútalo con **Execute SQL Script (`Alt+X`)**. No uses `Ctrl+Enter` en los scripts 01 y 02, porque solo ejecuta una sentencia y los triggers quedarían a medias.

---

## 👨‍💻 Autor

* **Erick Santiago Rincón Rojas** — Código Estudiantil: `01251151002`  
  *Universidad de Santander (UDES)*
