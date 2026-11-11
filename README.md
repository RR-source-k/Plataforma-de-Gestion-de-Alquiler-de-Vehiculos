# 🚗 Plataforma de Gestión de Alquiler de Vehículos

Este repositorio contiene la arquitectura, modelo relacional e implementación de la base de datos para la **Plataforma de Gestión de Alquiler de Vehículos**, desarrollada como parte del proyecto académico de la carrera de Ingeniería en Ciencias de la Computación e Inteligencia Artificial en la Universidad de Santander (UDES).

---

## 📌 Estructura del Repositorio

```text
Plataforma-de-Gestion-de-Alquiler-de-Vehiculos/
├── Primera Entrega/
│   ├── Actividad_Exploratoria.md
│   └── Modelo Entidad Relacion.pdf
├── Segunda Entrega/
│   └── Modelo Relacional/
│       ├── Informe_Normalizacion.md
│       ├── Modelo_Relacional.md
│       └── Normalizacion_Modelo_Relacional.xlsx
├── Tercera Entrega/
│   ├── esquema_ddl.sql           # Script de creación del esquema y tablas (DDL)
│   └── datos_prueba_dml.sql      # Script de inserción de datos de prueba (DML)
└── README.md
```

---

## 🛠️ Tecnologías Utilizadas

* **Motor de Base de Datos:** MariaDB / MySQL
* **Cliente de Gestión SQL:** DBeaver Community Edition
* **Entorno de Desarrollo:** CachyOS (Arch Linux)
* **Lenguaje:** SQL (ANSI/MariaDB Dialect)

---

## 🗄️ Esquema de la Base de Datos (`alquiler_vehiculos`)

La base de datos está normalizada hasta **3NF / BCNF** y se compone de las siguientes entidades principales:

1. `categorias`: Tipos de vehículos (Económico, SUV, Lujo) con sus respectivas tarifas diarias.
2. `vehiculos`: Registro del parque automotor, placas, modelo, año y estado actual (Disponible, Alquilado, Mantenimiento).
3. `clientes`: Información de contacto, documento de identidad y licencia de conducción de los usuarios.
4. `sedes`: Puntos de recogida y devolución de vehículos en distintas ubicaciones/ciudades.
5. `alquileres`: Registro del flujo principal de alquileres, vinculando clientes, vehículos, sedes de origen/destino, fechas y costo total acumulado.

---

## 🚀 Instrucciones de Despliegue e Inicialización

### 1. Requisitos Previos

Asegúrate de tener instalado y corriendo el servicio de MariaDB en tu sistema:

```bash
# Iniciar el servicio local en Arch Linux / CachyOS
sudo systemctl start mariadb
```

### 2. Creación del Esquema (DDL)

Para construir la base de datos, tablas y restricciones relacionales (`FOREIGN KEY`, `CHECK`, `UNIQUE`):

```bash
mariadb -u root -p < "Tercera Entrega/esquema_ddl.sql"
```

### 3. Carga de Datos de Prueba (DML)

Para poblar la base de datos con registros de prueba:

```bash
mariadb -u root -p < "Tercera Entrega/datos_prueba_dml.sql"
```

---

## 👨‍💻 Autor

* **Erick Santiago Rincón Rojas** — Código Estudiantil: `01251151002`  
  *Universidad de Santander (UDES)*
