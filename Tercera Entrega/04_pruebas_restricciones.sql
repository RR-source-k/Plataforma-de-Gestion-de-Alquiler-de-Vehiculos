-- =====================================================================
-- 04_pruebas_restricciones.sql  ·  Pruebas negativas (OPCIONAL)
--
-- Cada sentencia de este archivo DEBE FALLAR. Si alguna se ejecuta sin
-- error, hay una restricción mal definida.
-- En DBeaver: ejecutar una por una con Ctrl+Enter (no en modo script,
-- porque el primer error detendría el resto).
-- =====================================================================
USE alquiler_vehiculos;

-- 1. Placa duplicada (PRIMARY KEY)
INSERT INTO vehiculo VALUES ('KLM214','Ford','Fiesta','ECONOMICO','DISPONIBLE',1,1);

-- 2. Correo duplicado (UNIQUE)
INSERT INTO usuario (nombres, apellidos, correo, tipoUsuario)
VALUES ('Prueba','Duplicado','laura.gomez@example.com','PARTICULAR');

-- 3. Tipo de usuario inválido (CHECK)
INSERT INTO usuario (nombres, apellidos, correo, tipoUsuario)
VALUES ('Prueba','Tipo','tipo@example.com','VIP');

-- 4. Tarifa con precio negativo (CHECK)
INSERT INTO tarifa (precioPorHora, precioPorDia, precioPorKm) VALUES (-1, 50000, 100);

-- 5. Vehículo con tarifa inexistente (FOREIGN KEY)
INSERT INTO vehiculo VALUES ('ZZZ999','Ford','Ka','ECONOMICO','DISPONIBLE',99,1);

-- 6. Reserva con fecha de fin anterior al inicio (CHECK)
INSERT INTO reserva (fechaInicio, fechaFin, estadoReserva, idUsuario, placa, idSucursalOrigen, idSucursalDestino)
VALUES ('2027-01-10 10:00:00','2027-01-09 10:00:00','PENDIENTE',1,'JDW419',2,2);

-- 7. Overbooking: GHT731 ya tiene la reserva 2
--    (2026-08-10 a 2026-08-12) y esta nueva se solapa con ella (TRIGGER)
INSERT INTO reserva (fechaInicio, fechaFin, estadoReserva, idUsuario, placa, idSucursalOrigen, idSucursalDestino)
VALUES ('2026-08-11 08:00:00','2026-08-13 08:00:00','PENDIENTE',1,'GHT731',2,2);

-- 8. Pago sobre una reserva sin contrato (FOREIGN KEY a contrato)
INSERT INTO pago (idReserva, monto, fecha, metodoPago) VALUES (13, 50000, '2026-11-13', 'EFECTIVO');

-- 9. Contrato sobre una reserva cancelada (TRIGGER)
INSERT INTO contrato VALUES (8, 'CTR-2026-9999', '2026-10-28', 0);

-- 10. Segundo contrato para la misma reserva (PRIMARY KEY = una reserva, un contrato)
INSERT INTO contrato VALUES (1, 'CTR-2026-8888', '2026-08-03', 0);

-- 11. Fila de usuario_empresarial para un usuario PARTICULAR (TRIGGER)
INSERT INTO usuario_empresarial VALUES (1, '999999999-9', 'Empresa Falsa', 0);

-- 12. Fila de vehiculo_electrico para un vehículo que no es eléctrico (TRIGGER)
INSERT INTO vehiculo_electrico VALUES ('KLM214', 300, 50);

-- 13. Conector asociado a un vehículo no eléctrico (FOREIGN KEY a vehiculo_electrico)
INSERT INTO vehiculo_conector VALUES ('KLM214', 'CCS2');

-- 14. Nivel de carga fuera de rango (CHECK)
UPDATE vehiculo_electrico SET nivelCargaSOC = 150 WHERE placa = 'EVT101';

-- 15. Borrar un cliente con reservas (ON DELETE RESTRICT)
DELETE FROM usuario WHERE idUsuario = 1;

-- 16. Daño en una inspección que no existe (FOREIGN KEY compuesta)
INSERT INTO inspeccion_dano VALUES (1, 99, 'Daño inventado');
