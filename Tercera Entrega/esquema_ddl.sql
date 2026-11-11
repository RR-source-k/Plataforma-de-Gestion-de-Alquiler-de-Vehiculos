-- ============================================================
-- Plataforma de Gestión de Alquiler de Vehículos
-- Script DDL: Creación de Esquema y Tablas (MariaDB / MySQL)
-- ============================================================

CREATE DATABASE IF NOT EXISTS alquiler_vehiculos;
USE alquiler_vehiculos;

-- 1. Tabla: Categorías de Vehículos
CREATE TABLE IF NOT EXISTS categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    tarifa_diaria DECIMAL(10,2) NOT NULL CHECK (tarifa_diaria > 0)
);

-- 2. Tabla: Vehículos
CREATE TABLE IF NOT EXISTS vehiculos (
    id_vehiculo INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(10) NOT NULL UNIQUE,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    anio INT NOT NULL,
    id_categoria INT NOT NULL,
    estado ENUM('Disponible', 'Alquilado', 'Mantenimiento') DEFAULT 'Disponible',
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria) ON DELETE RESTRICT
);

-- 3. Tabla: Clientes
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    numero_documento VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    licencia_conduccion VARCHAR(30) NOT NULL UNIQUE
);

-- 4. Tabla: Sedes / Sucursales
CREATE TABLE IF NOT EXISTS sedes (
    id_sede INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(150) NOT NULL,
    ciudad VARCHAR(50) NOT NULL
);

-- 5. Tabla: Alquileres
CREATE TABLE IF NOT EXISTS alquileres (
    id_alquiler INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_vehiculo INT NOT NULL,
    id_sede_recogida INT NOT NULL,
    id_sede_devolucion INT NOT NULL,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin_prevista DATETIME NOT NULL,
    fecha_entrega_real DATETIME,
    costo_total DECIMAL(10,2) DEFAULT 0.00,
    estado ENUM('Activo', 'Completado', 'Cancelado') DEFAULT 'Activo',
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE RESTRICT,
    FOREIGN KEY (id_vehiculo) REFERENCES vehiculos(id_vehiculo) ON DELETE RESTRICT,
    FOREIGN KEY (id_sede_recogida) REFERENCES sedes(id_sede) ON DELETE RESTRICT,
    FOREIGN KEY (id_sede_devolucion) REFERENCES sedes(id_sede) ON DELETE RESTRICT
);
