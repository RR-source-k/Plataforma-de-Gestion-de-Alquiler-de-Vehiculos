-- =====================================================================
-- 03_consultas.sql  ·  Consultas de ejemplo y verificación
-- En DBeaver: seleccionar una consulta y pulsar Ctrl+Enter.
-- =====================================================================
USE alquiler_vehiculos;

-- 1. Flota completa con tarifa y sede
SELECT v.placa, v.marca, v.modelo, v.tipoVehiculo, v.estado,
       s.ciudad, t.precioPorDia
FROM vehiculo v
JOIN sucursal s ON s.idSucursal = v.idSucursal
JOIN tarifa   t ON t.idTarifa   = v.idTarifa
ORDER BY s.ciudad, v.tipoVehiculo;

-- 2. Vehículos disponibles por ciudad
SELECT s.ciudad, COUNT(*) AS disponibles
FROM vehiculo v
JOIN sucursal s ON s.idSucursal = v.idSucursal
WHERE v.estado = 'DISPONIBLE'
GROUP BY s.ciudad
ORDER BY disponibles DESC;

-- 3. Vehículos libres en un rango de fechas (cambiar las fechas a gusto)
SELECT v.placa, v.marca, v.modelo, s.ciudad
FROM vehiculo v
JOIN sucursal s ON s.idSucursal = v.idSucursal
WHERE v.estado <> 'MANTENIMIENTO'
  AND NOT EXISTS (
      SELECT 1 FROM reserva r
      WHERE r.placa = v.placa
        AND r.estadoReserva <> 'CANCELADA'
        AND r.fechaInicio < '2026-11-20 18:00:00'
        AND r.fechaFin    > '2026-11-20 08:00:00');

-- 4. Usuarios con su tipo, identificación y membresía (vista)
SELECT * FROM v_usuario_detalle;

-- 5. Detalle de reservas con lo pagado (vista)
SELECT * FROM v_reserva_detalle ORDER BY idReserva;

-- 6. Reservas en curso o confirmadas
SELECT idReserva, cliente, placa, fechaInicio, fechaFin, estadoReserva
FROM v_reserva_detalle
WHERE estadoReserva IN ('EN_CURSO','CONFIRMADA')
ORDER BY fechaInicio;

-- 7. Alquileres "one-way" (origen distinto de destino)
SELECT idReserva, cliente, placa, ciudadOrigen, ciudadDestino
FROM v_reserva_detalle
WHERE ciudadOrigen <> ciudadDestino;

-- 8. Ingresos por método de pago
SELECT metodoPago, COUNT(*) AS pagos, SUM(monto) AS total
FROM pago
GROUP BY metodoPago
ORDER BY total DESC;

-- 9. Ingresos por tipo de vehículo
SELECT v.tipoVehiculo, SUM(p.monto) AS ingresos
FROM pago p
JOIN reserva  r ON r.idReserva = p.idReserva
JOIN vehiculo v ON v.placa     = r.placa
GROUP BY v.tipoVehiculo
ORDER BY ingresos DESC;

-- 10. Kilómetros recorridos por contrato (devolución - entrega)
SELECT e.idReserva,
       d.kilometraje - e.kilometraje AS kmRecorridos
FROM inspeccion e
JOIN inspeccion d ON d.idReserva = e.idReserva
                 AND d.tipoInspeccion = 'DEVOLUCION'
WHERE e.tipoInspeccion = 'ENTREGA'
ORDER BY kmRecorridos DESC;

-- 11. Daños reportados por vehículo
SELECT r.placa, i.idReserva, d.danoReportado
FROM inspeccion_dano d
JOIN inspeccion i ON i.idReserva = d.idReserva AND i.idInspeccion = d.idInspeccion
JOIN reserva    r ON r.idReserva = i.idReserva
ORDER BY r.placa;

-- 12. Vehículos eléctricos con su autonomía y conectores
SELECT ve.placa, v.marca, v.modelo, ve.autonomiaKm, ve.nivelCargaSOC,
       GROUP_CONCAT(vc.conectorCarga ORDER BY vc.conectorCarga SEPARATOR ', ') AS conectores
FROM vehiculo_electrico ve
JOIN vehiculo v ON v.placa = ve.placa
LEFT JOIN vehiculo_conector vc ON vc.placa = ve.placa
GROUP BY ve.placa, v.marca, v.modelo, ve.autonomiaKm, ve.nivelCargaSOC;

-- 13. Membresías con sus beneficios
SELECT m.nombre, m.descuentoPorcentaje,
       GROUP_CONCAT(b.beneficio ORDER BY b.beneficio SEPARATOR ' | ') AS beneficios
FROM membresia m
LEFT JOIN membresia_beneficio b ON b.idMembresia = m.idMembresia
GROUP BY m.idMembresia, m.nombre, m.descuentoPorcentaje;

-- 14. Clientes con más de una reserva
SELECT CONCAT(u.nombres, ' ', u.apellidos) AS cliente, COUNT(*) AS reservas
FROM reserva r
JOIN usuario u ON u.idUsuario = r.idUsuario
GROUP BY u.idUsuario, u.nombres, u.apellidos
HAVING COUNT(*) > 1;

-- 15. Control de integridad (ambas deben devolver 0 filas)
SELECT * FROM v_usuarios_sin_subtipo;
SELECT * FROM v_electricos_sin_detalle;
