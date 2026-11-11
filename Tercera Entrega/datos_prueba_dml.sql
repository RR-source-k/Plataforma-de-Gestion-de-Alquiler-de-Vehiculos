-- ============================================================
-- Plataforma de Gestión de Alquiler de Vehículos
-- Script DML: Inserción de Datos de Prueba (MariaDB / MySQL)
-- ============================================================

USE alquiler_vehiculos;

-- 1. Insertar Categorías
INSERT INTO categorias (nombre, descripcion, tarifa_diaria) VALUES
('Económico', 'Vehículos compactos de bajo consumo de combustible', 120000.00),
('SUV', 'Camionetas amplias ideales para viajes familiares', 250000.00),
('Lujo', 'Vehículos de gama alta con máximo confort y equipamiento', 450000.00);

-- 2. Insertar Sedes
INSERT INTO sedes (nombre, direccion, ciudad) VALUES
('Sede Principal Cabecera', 'Carrera 33 # 48-15', 'Bucaramanga'),
('Sede Aeropuerto Palonegro', 'Km 15 Vía Aeropuerto', 'Lebrija'),
('Sede Centro', 'Calle 36 # 15-24', 'Bucaramanga');

-- 3. Insertar Vehículos
INSERT INTO vehiculos (placa, marca, modelo, anio, id_categoria, estado) VALUES
('KTS123', 'Chevrolet', 'Onix', 2024, 1, 'Alquilado'),
('XYZ987', 'Toyota', 'Fortuner', 2025, 2, 'Disponible'),
('BMW456', 'BMW', 'Serie 3', 2024, 3, 'Disponible');

-- 4. Insertar Clientes
INSERT INTO clientes (numero_documento, nombre, apellido, email, telefono, licencia_conduccion) VALUES
('01251151002', 'Erick Santiago', 'Rincón Rojas', 'erick.rincon@example.com', '3001234567', 'C1-01251151002'),
('1098765432', 'María', 'Gómez', 'maria.gomez@example.com', '3159876543', 'C1-1098765432');

-- 5. Insertar Alquileres
INSERT INTO alquileres (
    id_cliente, 
    id_vehiculo, 
    id_sede_recogida, 
    id_sede_devolucion, 
    fecha_inicio, 
    fecha_fin_prevista, 
    costo_total, 
    estado
) VALUES (
    1, 
    1, 
    1, 
    2, 
    NOW(), 
    DATE_ADD(NOW(), INTERVAL 3 DAY), 
    360000.00, 
    'Activo'
);
