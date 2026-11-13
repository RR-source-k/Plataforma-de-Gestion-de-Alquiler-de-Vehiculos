-- =====================================================================
-- Plataforma de Gestión de Alquiler de Vehículos
-- 02_datos_prueba_dml.sql  ·  Datos de prueba (ejecutar DESPUÉS del DDL)
--
-- Los datos son ficticios. Las fechas se ubican entre agosto y
-- diciembre de 2026 para tener reservas finalizadas, en curso y futuras.
-- Valores monetarios en pesos colombianos (COP).
-- =====================================================================

USE alquiler_vehiculos;

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------
-- SUCURSAL
-- ---------------------------------------------------------------------
INSERT INTO sucursal (idSucursal, nombre, ciudad, direccion) VALUES
(1, 'Sede Bucaramanga Centro',    'Bucaramanga', 'Carrera 27 # 36-14'),
(2, 'Sede Bogotá Aeropuerto',     'Bogotá',      'Avenida El Dorado # 103-09'),
(3, 'Sede Medellín El Poblado',   'Medellín',    'Calle 10 # 43D-30'),
(4, 'Sede Cali Norte',            'Cali',        'Avenida 6N # 28N-10'),
(5, 'Sede Cartagena Bocagrande',  'Cartagena',   'Avenida San Martín # 8-45');

-- ---------------------------------------------------------------------
-- TARIFA
-- ---------------------------------------------------------------------
INSERT INTO tarifa (idTarifa, precioPorHora, precioPorDia, precioPorKm) VALUES
(1,  9000.00,  65000.00,  400.00),   -- económica
(2, 15000.00, 120000.00,  700.00),   -- SUV
(3, 18000.00, 150000.00,  900.00),   -- carga
(4, 20000.00, 160000.00,  500.00),   -- eléctrica / híbrida
(5, 35000.00, 280000.00, 1200.00);   -- lujo

-- ---------------------------------------------------------------------
-- MEMBRESIA y beneficios
-- ---------------------------------------------------------------------
INSERT INTO membresia (idMembresia, nombre, descuentoPorcentaje) VALUES
(1, 'Básica',  5.00),
(2, 'Plus',   10.00),
(3, 'Premium', 15.00);

INSERT INTO membresia_beneficio (idMembresia, beneficio) VALUES
(1, 'Cancelación gratuita hasta 24 h antes'),
(2, 'Cancelación gratuita hasta 24 h antes'),
(2, 'Segundo conductor sin costo'),
(3, 'Cancelación gratuita hasta 24 h antes'),
(3, 'Segundo conductor sin costo'),
(3, 'Exención del depósito de garantía'),
(3, 'Upgrade de categoría sujeto a disponibilidad');

-- ---------------------------------------------------------------------
-- USUARIO (1-7 particulares, 8-10 empresariales)
-- Para los empresariales, nombres/apellidos son los del representante.
-- ---------------------------------------------------------------------
INSERT INTO usuario (idUsuario, nombres, apellidos, correo, tipoUsuario, idMembresia) VALUES
(1,  'Laura Marcela',   'Gómez Pardo',     'laura.gomez@example.com',      'PARTICULAR',  2),
(2,  'Andrés Felipe',   'Cárdenas Ruiz',   'andres.cardenas@example.com',  'PARTICULAR',  NULL),
(3,  'Valentina',       'Ortiz Mejía',     'valentina.ortiz@example.com',  'PARTICULAR',  3),
(4,  'Juan David',      'Herrera Silva',   'juan.herrera@example.com',     'PARTICULAR',  1),
(5,  'Camila Andrea',   'Rojas Beltrán',   'camila.rojas@example.com',     'PARTICULAR',  NULL),
(6,  'Sebastián',       'Mora Castaño',    'sebastian.mora@example.com',   'PARTICULAR',  2),
(7,  'Daniela',         'Peña Quintero',   'daniela.pena@example.com',     'PARTICULAR',  NULL),
(8,  'Carlos Eduardo',  'Navarro Díaz',    'cnavarro@constructoraandina.example.com', 'EMPRESARIAL', 3),
(9,  'María Fernanda',  'Londoño Vega',    'mlondono@transportesoriente.example.com', 'EMPRESARIAL', 2),
(10, 'Ricardo',         'Sarmiento Acosta','rsarmiento@tecnosoft.example.com',        'EMPRESARIAL', NULL);

INSERT INTO usuario_telefono (idUsuario, telefono) VALUES
(1,  '3001234567'),
(1,  '6076451122'),
(2,  '3109876543'),
(3,  '3205551234'),
(4,  '3157778899'),
(5,  '3012223344'),
(6,  '3183334455'),
(6,  '3004445566'),
(7,  '3226667788'),
(8,  '3101112233'),
(8,  '6017894561'),
(9,  '3134445577'),
(10, '3168889900');

INSERT INTO usuario_particular (idUsuario, documentoIdentidad) VALUES
(1, '1098765432'),
(2, '1005432109'),
(3, '1020304050'),
(4, '91234567'),
(5, '1090123456'),
(6, '1037654321'),
(7, '1143210987');

INSERT INTO usuario_empresarial (idUsuario, NIT, razonSocial, limiteCredito) VALUES
(8,  '900123456-7', 'Constructora Andina S.A.S.',     50000000.00),
(9,  '800234567-1', 'Transportes del Oriente Ltda.',  20000000.00),
(10, '901345678-2', 'Tecnosoft Colombia S.A.S.',      10000000.00);

-- ---------------------------------------------------------------------
-- VEHICULO
-- ---------------------------------------------------------------------
INSERT INTO vehiculo (placa, marca, modelo, tipoVehiculo, estado, idTarifa, idSucursal) VALUES
('KLM214', 'Chevrolet',     'Spark GT 2024',        'ECONOMICO',     'DISPONIBLE',    1, 1),
('NPR508', 'Renault',       'Logan 2023',           'ECONOMICO',     'ALQUILADO',     1, 1),
('GHT731', 'Kia',           'Picanto 2024',         'ECONOMICO',     'DISPONIBLE',    1, 2),
('JDW419', 'Mazda',         'CX-5 2024',            'SUV',           'DISPONIBLE',    2, 2),
('HRB662', 'Toyota',        'Fortuner 2023',        'SUV',           'ALQUILADO',     2, 3),
('TMC305', 'Renault',       'Duster 2024',          'SUV',           'DISPONIBLE',    2, 4),
('BXN877', 'Chevrolet',     'NHR 2022',             'CARGA',         'DISPONIBLE',    3, 1),
('LPQ190', 'Hyundai',       'H100 2022',            'CARGA',         'MANTENIMIENTO', 3, 5),
('EVT101', 'Tesla',         'Model 3 2024',         'ELECTRICO',     'DISPONIBLE',    4, 3),
('EVB202', 'BYD',           'Dolphin 2025',         'ELECTRICO',     'DISPONIBLE',    4, 2),
('EVK303', 'Kia',           'Niro EV 2024',         'ELECTRICO',     'ALQUILADO',     4, 4),
('MBZ555', 'Mercedes-Benz', 'Clase C 200 2024',     'LUJO',          'DISPONIBLE',    5, 5),
('WQD240', 'BMW',           '320i 2024',            'LUJO',          'DISPONIBLE',    5, 2);

INSERT INTO vehiculo_caracteristica (placa, caracteristica) VALUES
('KLM214', 'Aire acondicionado'),
('KLM214', 'Bluetooth'),
('NPR508', 'Aire acondicionado'),
('NPR508', 'Cámara de reversa'),
('GHT731', 'Aire acondicionado'),
('JDW419', 'Transmisión automática'),
('JDW419', 'GPS'),
('JDW419', 'Cámara de reversa'),
('HRB662', 'Transmisión automática'),
('HRB662', 'Tracción 4x4'),
('HRB662', 'Sillas para niños'),
('TMC305', 'Aire acondicionado'),
('TMC305', 'GPS'),
('BXN877', 'Capacidad de carga 3 t'),
('LPQ190', 'Capacidad de carga 1.5 t'),
('EVT101', 'Transmisión automática'),
('EVT101', 'Techo panorámico'),
('EVT101', 'GPS'),
('EVB202', 'Transmisión automática'),
('EVB202', 'Cámara de reversa'),
('EVK303', 'Transmisión automática'),
('EVK303', 'GPS'),
('MBZ555', 'Transmisión automática'),
('MBZ555', 'Interior en cuero'),
('MBZ555', 'GPS'),
('WQD240', 'Transmisión automática'),
('WQD240', 'Interior en cuero'),
('WQD240', 'Techo panorámico');

INSERT INTO vehiculo_electrico (placa, autonomiaKm, nivelCargaSOC) VALUES
('EVT101', 510, 85.00),
('EVB202', 427, 90.00),
('EVK303', 460, 40.00);

INSERT INTO vehiculo_conector (placa, conectorCarga) VALUES
('EVT101', 'Tipo 2'),
('EVT101', 'CCS2'),
('EVB202', 'Tipo 2'),
('EVB202', 'CCS2'),
('EVK303', 'Tipo 2'),
('EVK303', 'CCS2');

-- ---------------------------------------------------------------------
-- RESERVA
-- (idReserva, fechaInicio, fechaFin, estado, idUsuario, placa, origen, destino)
-- La reserva 12 es un alquiler "one-way": se recoge en Bogotá y se
-- devuelve en Medellín.
-- ---------------------------------------------------------------------
INSERT INTO reserva (idReserva, fechaInicio, fechaFin, estadoReserva, idUsuario, placa, idSucursalOrigen, idSucursalDestino) VALUES
(1,  '2026-08-03 09:00:00', '2026-08-06 09:00:00', 'FINALIZADA', 1,  'KLM214', 1, 1),
(2,  '2026-08-10 08:00:00', '2026-08-12 18:00:00', 'FINALIZADA', 2,  'GHT731', 2, 2),
(3,  '2026-09-01 07:00:00', '2026-09-05 17:00:00', 'FINALIZADA', 8,  'BXN877', 1, 1),
(4,  '2026-09-14 10:00:00', '2026-09-16 10:00:00', 'FINALIZADA', 3,  'EVT101', 3, 3),
(5,  '2026-09-20 09:00:00', '2026-09-24 09:00:00', 'FINALIZADA', 4,  'HRB662', 3, 3),
(6,  '2026-10-02 10:00:00', '2026-10-04 10:00:00', 'FINALIZADA', 5,  'MBZ555', 5, 5),
(7,  '2026-10-20 09:00:00', '2026-10-23 09:00:00', 'FINALIZADA', 10, 'NPR508', 1, 1),
(8,  '2026-10-28 09:00:00', '2026-10-30 09:00:00', 'CANCELADA',  1,  'KLM214', 1, 1),
(9,  '2026-11-11 09:00:00', '2026-11-15 09:00:00', 'EN_CURSO',   7,  'NPR508', 1, 1),
(10, '2026-11-10 08:00:00', '2026-11-14 18:00:00', 'EN_CURSO',   8,  'HRB662', 3, 3),
(11, '2026-11-12 10:00:00', '2026-11-16 10:00:00', 'EN_CURSO',   3,  'EVK303', 4, 4),
(12, '2026-12-05 09:00:00', '2026-12-08 09:00:00', 'CONFIRMADA', 9,  'WQD240', 2, 3),
(13, '2026-11-20 08:00:00', '2026-11-22 08:00:00', 'PENDIENTE',  6,  'TMC305', 4, 4),
(14, '2026-11-25 09:00:00', '2026-11-27 09:00:00', 'CONFIRMADA', 2,  'EVB202', 2, 2);

-- ---------------------------------------------------------------------
-- CONTRATO (solo reservas ya recogidas: finalizadas y en curso)
-- Depósito = 0 para membresía Premium (usuarios 3 y 8).
-- ---------------------------------------------------------------------
INSERT INTO contrato (idReserva, numeroContrato, fechaFirma, depositoGarantia) VALUES
(1,  'CTR-2026-0001', '2026-08-03',  500000.00),
(2,  'CTR-2026-0002', '2026-08-10',  500000.00),
(3,  'CTR-2026-0003', '2026-09-01',       0.00),
(4,  'CTR-2026-0004', '2026-09-14',       0.00),
(5,  'CTR-2026-0005', '2026-09-20', 1000000.00),
(6,  'CTR-2026-0006', '2026-10-02', 3000000.00),
(7,  'CTR-2026-0007', '2026-10-20',  500000.00),
(9,  'CTR-2026-0008', '2026-11-11',  500000.00),
(10, 'CTR-2026-0009', '2026-11-10',       0.00),
(11, 'CTR-2026-0010', '2026-11-12',       0.00);

-- ---------------------------------------------------------------------
-- INSPECCION: 1 = entrega, 2 = devolución (las reservas en curso solo
-- tienen la de entrega)
-- ---------------------------------------------------------------------
INSERT INTO inspeccion (idReserva, idInspeccion, tipoInspeccion, kilometraje) VALUES
(1,  1, 'ENTREGA',     12450),
(1,  2, 'DEVOLUCION',  12710),
(2,  1, 'ENTREGA',      8300),
(2,  2, 'DEVOLUCION',   8520),
(3,  1, 'ENTREGA',     45100),
(3,  2, 'DEVOLUCION',  45690),
(4,  1, 'ENTREGA',      6020),
(4,  2, 'DEVOLUCION',   6310),
(5,  1, 'ENTREGA',     33800),
(5,  2, 'DEVOLUCION',  34250),
(6,  1, 'ENTREGA',      9100),
(6,  2, 'DEVOLUCION',   9330),
(7,  1, 'ENTREGA',     27900),
(7,  2, 'DEVOLUCION',  28240),
(9,  1, 'ENTREGA',     28240),
(10, 1, 'ENTREGA',     34250),
(11, 1, 'ENTREGA',     15820);

INSERT INTO inspeccion_dano (idReserva, idInspeccion, danoReportado) VALUES
(3, 2, 'Rayón en puerta lateral derecha'),
(5, 2, 'Rayón leve en parachoques delantero'),
(7, 2, 'Abolladura en parachoques trasero'),
(7, 2, 'Llanta trasera con desgaste irregular');

-- ---------------------------------------------------------------------
-- PAGO (valor ya con el descuento de la membresía del usuario)
-- ---------------------------------------------------------------------
INSERT INTO pago (idPago, idReserva, monto, fecha, metodoPago) VALUES
(1,  1,  175500.00, '2026-08-06', 'TARJETA_CREDITO'),   -- 3 días económicos -10 %
(2,  2,  100000.00, '2026-08-10', 'EFECTIVO'),          -- anticipo
(3,  2,  120000.00, '2026-08-12', 'EFECTIVO'),          -- saldo
(4,  3,  663000.00, '2026-09-05', 'TRANSFERENCIA'),     -- empresarial Premium -15 %
(5,  4,  272000.00, '2026-09-16', 'TARJETA_CREDITO'),   -- eléctrico 2 días -15 %
(6,  5,  200000.00, '2026-09-20', 'TARJETA_DEBITO'),    -- anticipo
(7,  5,  256000.00, '2026-09-24', 'TARJETA_DEBITO'),    -- saldo (SUV 4 días -5 %)
(8,  6,  560000.00, '2026-10-04', 'TARJETA_CREDITO'),   -- lujo 2 días
(9,  7,  195000.00, '2026-10-23', 'TRANSFERENCIA'),     -- 3 días económicos
(10, 7,  150000.00, '2026-10-24', 'TRANSFERENCIA'),     -- cargo por daños
(11, 9,  100000.00, '2026-11-11', 'PSE'),               -- anticipo en curso
(12, 10, 200000.00, '2026-11-10', 'TRANSFERENCIA'),     -- anticipo en curso
(13, 11, 300000.00, '2026-11-12', 'TARJETA_CREDITO');   -- anticipo en curso
