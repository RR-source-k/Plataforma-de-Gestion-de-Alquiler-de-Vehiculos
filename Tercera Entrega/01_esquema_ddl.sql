-- =====================================================================
-- Plataforma de Gestión de Alquiler de Vehículos
-- 01_esquema_ddl.sql  ·  Creación del esquema (MariaDB 10.5+)
--
-- Basado en el modelo relacional normalizado (3FN) de la 2da entrega:
-- 17 relaciones, con sus llaves primarias, foráneas y alternas.
--
-- ⚠ ADVERTENCIA: este script BORRA y vuelve a crear la base de datos
--   `alquiler_vehiculos`. Úsalo para reiniciar el proyecto desde cero.
--
-- Cómo ejecutarlo en DBeaver:
--   Abrir este archivo en el editor SQL y pulsar "Execute SQL Script"
--   (Alt+X). No usar Ctrl+Enter: solo ejecutaría una sentencia.
-- =====================================================================

DROP DATABASE IF EXISTS alquiler_vehiculos;

CREATE DATABASE alquiler_vehiculos
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE alquiler_vehiculos;

-- ---------------------------------------------------------------------
-- 1. SUCURSAL
-- ---------------------------------------------------------------------
CREATE TABLE sucursal (
    idSucursal  INT          NOT NULL AUTO_INCREMENT,
    nombre      VARCHAR(100) NOT NULL,
    ciudad      VARCHAR(60)  NOT NULL,
    direccion   VARCHAR(150) NOT NULL,
    CONSTRAINT pk_sucursal        PRIMARY KEY (idSucursal),
    CONSTRAINT uq_sucursal_nombre UNIQUE (nombre)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 2. TARIFA
-- ---------------------------------------------------------------------
CREATE TABLE tarifa (
    idTarifa      INT           NOT NULL AUTO_INCREMENT,
    precioPorHora DECIMAL(12,2) NOT NULL,
    precioPorDia  DECIMAL(12,2) NOT NULL,
    precioPorKm   DECIMAL(12,2) NOT NULL,
    CONSTRAINT pk_tarifa        PRIMARY KEY (idTarifa),
    CONSTRAINT ck_tarifa_hora   CHECK (precioPorHora > 0),
    CONSTRAINT ck_tarifa_dia    CHECK (precioPorDia  > 0),
    CONSTRAINT ck_tarifa_km     CHECK (precioPorKm  >= 0),
    -- el día completo debe salir más barato que 24 horas sueltas
    CONSTRAINT ck_tarifa_dia_hora CHECK (precioPorDia <= precioPorHora * 24)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 3. MEMBRESIA  y  4. MEMBRESIA_BENEFICIO (atributo multivaluado)
-- ---------------------------------------------------------------------
CREATE TABLE membresia (
    idMembresia         INT          NOT NULL AUTO_INCREMENT,
    nombre              VARCHAR(50)  NOT NULL,
    descuentoPorcentaje DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT pk_membresia        PRIMARY KEY (idMembresia),
    CONSTRAINT uq_membresia_nombre UNIQUE (nombre),
    CONSTRAINT ck_membresia_desc   CHECK (descuentoPorcentaje BETWEEN 0 AND 100)
) ENGINE=InnoDB;

CREATE TABLE membresia_beneficio (
    idMembresia INT          NOT NULL,
    beneficio   VARCHAR(120) NOT NULL,
    CONSTRAINT pk_membresia_beneficio PRIMARY KEY (idMembresia, beneficio),
    CONSTRAINT fk_mbenef_membresia FOREIGN KEY (idMembresia)
        REFERENCES membresia (idMembresia)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 5. USUARIO (supertipo)  ·  6. USUARIO_TELEFONO (multivaluado)
-- ---------------------------------------------------------------------
CREATE TABLE usuario (
    idUsuario   INT          NOT NULL AUTO_INCREMENT,
    nombres     VARCHAR(100) NOT NULL,
    apellidos   VARCHAR(100) NOT NULL,
    correo      VARCHAR(120) NOT NULL,
    tipoUsuario VARCHAR(15)  NOT NULL,
    idMembresia INT          NULL,          -- (0,1): puede no tener membresía
    CONSTRAINT pk_usuario        PRIMARY KEY (idUsuario),
    CONSTRAINT uq_usuario_correo UNIQUE (correo),
    CONSTRAINT ck_usuario_tipo   CHECK (tipoUsuario IN ('PARTICULAR','EMPRESARIAL')),
    CONSTRAINT fk_usuario_membresia FOREIGN KEY (idMembresia)
        REFERENCES membresia (idMembresia)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE usuario_telefono (
    idUsuario INT         NOT NULL,
    telefono  VARCHAR(20) NOT NULL,
    CONSTRAINT pk_usuario_telefono PRIMARY KEY (idUsuario, telefono),
    CONSTRAINT fk_utel_usuario FOREIGN KEY (idUsuario)
        REFERENCES usuario (idUsuario)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 7. USUARIO_PARTICULAR  ·  8. USUARIO_EMPRESARIAL (especialización)
-- ---------------------------------------------------------------------
CREATE TABLE usuario_particular (
    idUsuario          INT         NOT NULL,
    documentoIdentidad VARCHAR(20) NOT NULL,
    CONSTRAINT pk_usuario_particular PRIMARY KEY (idUsuario),
    CONSTRAINT uq_particular_doc     UNIQUE (documentoIdentidad),
    CONSTRAINT fk_particular_usuario FOREIGN KEY (idUsuario)
        REFERENCES usuario (idUsuario)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE usuario_empresarial (
    idUsuario     INT           NOT NULL,
    NIT           VARCHAR(20)   NOT NULL,
    razonSocial   VARCHAR(150)  NOT NULL,
    limiteCredito DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT pk_usuario_empresarial PRIMARY KEY (idUsuario),
    CONSTRAINT uq_empresarial_nit     UNIQUE (NIT),
    CONSTRAINT ck_empresarial_credito CHECK (limiteCredito >= 0),
    CONSTRAINT fk_empresarial_usuario FOREIGN KEY (idUsuario)
        REFERENCES usuario (idUsuario)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 9. VEHICULO  ·  10. VEHICULO_CARACTERISTICA (multivaluado)
-- ---------------------------------------------------------------------
CREATE TABLE vehiculo (
    placa        VARCHAR(10) NOT NULL,
    marca        VARCHAR(50) NOT NULL,
    modelo       VARCHAR(60) NOT NULL,
    tipoVehiculo VARCHAR(15) NOT NULL,
    estado       VARCHAR(15) NOT NULL DEFAULT 'DISPONIBLE',
    idTarifa     INT         NOT NULL,
    idSucursal   INT         NOT NULL,
    CONSTRAINT pk_vehiculo        PRIMARY KEY (placa),
    CONSTRAINT ck_vehiculo_tipo   CHECK (tipoVehiculo IN
        ('ECONOMICO','SUV','CARGA','ELECTRICO','HIBRIDO','LUJO')),
    CONSTRAINT ck_vehiculo_estado CHECK (estado IN
        ('DISPONIBLE','ALQUILADO','MANTENIMIENTO')),
    CONSTRAINT fk_vehiculo_tarifa   FOREIGN KEY (idTarifa)
        REFERENCES tarifa (idTarifa)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_vehiculo_sucursal FOREIGN KEY (idSucursal)
        REFERENCES sucursal (idSucursal)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE vehiculo_caracteristica (
    placa          VARCHAR(10) NOT NULL,
    caracteristica VARCHAR(80) NOT NULL,
    CONSTRAINT pk_vehiculo_caracteristica PRIMARY KEY (placa, caracteristica),
    CONSTRAINT fk_vcar_vehiculo FOREIGN KEY (placa)
        REFERENCES vehiculo (placa)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 11. VEHICULO_ELECTRICO (especialización parcial)
-- 12. VEHICULO_CONECTOR (multivaluado, depende del eléctrico)
-- ---------------------------------------------------------------------
CREATE TABLE vehiculo_electrico (
    placa         VARCHAR(10)  NOT NULL,
    autonomiaKm   INT          NOT NULL,
    nivelCargaSOC DECIMAL(5,2) NOT NULL,
    CONSTRAINT pk_vehiculo_electrico PRIMARY KEY (placa),
    CONSTRAINT ck_electrico_autonomia CHECK (autonomiaKm > 0),
    CONSTRAINT ck_electrico_soc       CHECK (nivelCargaSOC BETWEEN 0 AND 100),
    CONSTRAINT fk_electrico_vehiculo FOREIGN KEY (placa)
        REFERENCES vehiculo (placa)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE vehiculo_conector (
    placa         VARCHAR(10) NOT NULL,
    conectorCarga VARCHAR(30) NOT NULL,
    CONSTRAINT pk_vehiculo_conector PRIMARY KEY (placa, conectorCarga),
    CONSTRAINT fk_vcon_electrico FOREIGN KEY (placa)
        REFERENCES vehiculo_electrico (placa)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 13. RESERVA
-- ---------------------------------------------------------------------
CREATE TABLE reserva (
    idReserva          INT         NOT NULL AUTO_INCREMENT,
    fechaInicio        DATETIME    NOT NULL,
    fechaFin           DATETIME    NOT NULL,
    estadoReserva      VARCHAR(15) NOT NULL DEFAULT 'PENDIENTE',
    idUsuario          INT         NOT NULL,
    placa              VARCHAR(10) NOT NULL,
    idSucursalOrigen   INT         NOT NULL,
    idSucursalDestino  INT         NOT NULL,
    CONSTRAINT pk_reserva PRIMARY KEY (idReserva),
    CONSTRAINT ck_reserva_fechas CHECK (fechaFin > fechaInicio),
    CONSTRAINT ck_reserva_estado CHECK (estadoReserva IN
        ('PENDIENTE','CONFIRMADA','EN_CURSO','FINALIZADA','CANCELADA')),
    CONSTRAINT fk_reserva_usuario  FOREIGN KEY (idUsuario)
        REFERENCES usuario (idUsuario)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_reserva_vehiculo FOREIGN KEY (placa)
        REFERENCES vehiculo (placa)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_reserva_origen   FOREIGN KEY (idSucursalOrigen)
        REFERENCES sucursal (idSucursal)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_reserva_destino  FOREIGN KEY (idSucursalDestino)
        REFERENCES sucursal (idSucursal)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX ix_reserva_vehiculo_fechas (placa, fechaInicio, fechaFin),
    INDEX ix_reserva_usuario (idUsuario)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 14. CONTRATO (como máximo uno por reserva: idReserva es PK y FK)
-- ---------------------------------------------------------------------
CREATE TABLE contrato (
    idReserva        INT           NOT NULL,
    numeroContrato   VARCHAR(20)   NOT NULL,
    fechaFirma       DATE          NOT NULL,
    depositoGarantia DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT pk_contrato        PRIMARY KEY (idReserva),
    CONSTRAINT uq_contrato_numero UNIQUE (numeroContrato),
    CONSTRAINT ck_contrato_deposito CHECK (depositoGarantia >= 0),
    CONSTRAINT fk_contrato_reserva FOREIGN KEY (idReserva)
        REFERENCES reserva (idReserva)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 15. INSPECCION (entidad débil de CONTRATO)
-- 16. INSPECCION_DANO (multivaluado, llave foránea compuesta)
-- ---------------------------------------------------------------------
CREATE TABLE inspeccion (
    idReserva      INT         NOT NULL,
    idInspeccion   INT         NOT NULL,
    tipoInspeccion VARCHAR(15) NOT NULL,
    kilometraje    INT         NOT NULL,
    CONSTRAINT pk_inspeccion PRIMARY KEY (idReserva, idInspeccion),
    CONSTRAINT ck_inspeccion_tipo CHECK (tipoInspeccion IN ('ENTREGA','DEVOLUCION')),
    CONSTRAINT ck_inspeccion_km   CHECK (kilometraje >= 0),
    CONSTRAINT ck_inspeccion_id   CHECK (idInspeccion > 0),
    CONSTRAINT fk_inspeccion_contrato FOREIGN KEY (idReserva)
        REFERENCES contrato (idReserva)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE inspeccion_dano (
    idReserva     INT          NOT NULL,
    idInspeccion  INT          NOT NULL,
    danoReportado VARCHAR(150) NOT NULL,
    CONSTRAINT pk_inspeccion_dano PRIMARY KEY (idReserva, idInspeccion, danoReportado),
    CONSTRAINT fk_idano_inspeccion FOREIGN KEY (idReserva, idInspeccion)
        REFERENCES inspeccion (idReserva, idInspeccion)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 17. PAGO
-- ---------------------------------------------------------------------
CREATE TABLE pago (
    idPago     INT           NOT NULL AUTO_INCREMENT,
    idReserva  INT           NOT NULL,
    monto      DECIMAL(12,2) NOT NULL,
    fecha      DATE          NOT NULL,
    metodoPago VARCHAR(20)   NOT NULL,
    CONSTRAINT pk_pago PRIMARY KEY (idPago),
    CONSTRAINT ck_pago_monto  CHECK (monto > 0),
    CONSTRAINT ck_pago_metodo CHECK (metodoPago IN
        ('EFECTIVO','TARJETA_CREDITO','TARJETA_DEBITO','TRANSFERENCIA','PSE')),
    CONSTRAINT fk_pago_contrato FOREIGN KEY (idReserva)
        REFERENCES contrato (idReserva)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX ix_pago_reserva (idReserva)
) ENGINE=InnoDB;


-- =====================================================================
-- TRIGGERS: reglas que no se pueden expresar solo con llaves
-- (DBeaver: ejecutar con "Execute SQL Script", Alt+X)
-- =====================================================================
DELIMITER $$

-- Especialización total y disjunta de USUARIO:
-- la fila de usuario_particular solo es válida si tipoUsuario = 'PARTICULAR'
CREATE TRIGGER trg_particular_bi BEFORE INSERT ON usuario_particular
FOR EACH ROW
BEGIN
    IF (SELECT tipoUsuario FROM usuario WHERE idUsuario = NEW.idUsuario) <> 'PARTICULAR' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El usuario no es de tipo PARTICULAR';
    END IF;
END$$

CREATE TRIGGER trg_empresarial_bi BEFORE INSERT ON usuario_empresarial
FOR EACH ROW
BEGIN
    IF (SELECT tipoUsuario FROM usuario WHERE idUsuario = NEW.idUsuario) <> 'EMPRESARIAL' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El usuario no es de tipo EMPRESARIAL';
    END IF;
END$$

-- Impide cambiar el tipo de un usuario que ya tiene su subtipo registrado
CREATE TRIGGER trg_usuario_bu BEFORE UPDATE ON usuario
FOR EACH ROW
BEGIN
    IF NEW.tipoUsuario <> OLD.tipoUsuario AND (
          EXISTS (SELECT 1 FROM usuario_particular  WHERE idUsuario = OLD.idUsuario)
       OR EXISTS (SELECT 1 FROM usuario_empresarial WHERE idUsuario = OLD.idUsuario)) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se puede cambiar tipoUsuario: ya existe su subtipo';
    END IF;
END$$

-- Especialización parcial de VEHICULO: solo los ELECTRICO tienen fila en vehiculo_electrico
CREATE TRIGGER trg_electrico_bi BEFORE INSERT ON vehiculo_electrico
FOR EACH ROW
BEGIN
    IF (SELECT tipoVehiculo FROM vehiculo WHERE placa = NEW.placa) <> 'ELECTRICO' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El vehículo no es de tipo ELECTRICO';
    END IF;
END$$

-- Anti-overbooking: un vehículo no puede tener dos reservas (no canceladas)
-- cuyos rangos de fecha se solapen.
CREATE TRIGGER trg_reserva_bi BEFORE INSERT ON reserva
FOR EACH ROW
BEGIN
    IF NEW.estadoReserva <> 'CANCELADA' AND EXISTS (
        SELECT 1 FROM reserva r
        WHERE r.placa = NEW.placa
          AND r.estadoReserva <> 'CANCELADA'
          AND r.fechaInicio < NEW.fechaFin
          AND r.fechaFin    > NEW.fechaInicio) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El vehículo ya tiene una reserva en ese rango de fechas';
    END IF;
END$$

CREATE TRIGGER trg_reserva_bu BEFORE UPDATE ON reserva
FOR EACH ROW
BEGIN
    IF NEW.estadoReserva <> 'CANCELADA' AND EXISTS (
        SELECT 1 FROM reserva r
        WHERE r.placa = NEW.placa
          AND r.idReserva <> NEW.idReserva
          AND r.estadoReserva <> 'CANCELADA'
          AND r.fechaInicio < NEW.fechaFin
          AND r.fechaFin    > NEW.fechaInicio) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El vehículo ya tiene una reserva en ese rango de fechas';
    END IF;
END$$

-- No se firma contrato sobre una reserva cancelada
CREATE TRIGGER trg_contrato_bi BEFORE INSERT ON contrato
FOR EACH ROW
BEGIN
    IF (SELECT estadoReserva FROM reserva WHERE idReserva = NEW.idReserva) = 'CANCELADA' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se puede crear un contrato para una reserva cancelada';
    END IF;
END$$

DELIMITER ;


-- =====================================================================
-- VISTAS de apoyo (útiles para consultar desde DBeaver)
-- =====================================================================

-- Usuario con su subtipo y membresía en una sola fila
CREATE VIEW v_usuario_detalle AS
SELECT u.idUsuario,
       CONCAT(u.nombres, ' ', u.apellidos)        AS nombreCompleto,
       u.correo,
       u.tipoUsuario,
       COALESCE(p.documentoIdentidad, e.NIT)      AS identificacion,
       e.razonSocial,
       e.limiteCredito,
       m.nombre                                   AS membresia,
       COALESCE(m.descuentoPorcentaje, 0)         AS descuentoPorcentaje
FROM usuario u
LEFT JOIN usuario_particular  p ON p.idUsuario  = u.idUsuario
LEFT JOIN usuario_empresarial e ON e.idUsuario  = u.idUsuario
LEFT JOIN membresia           m ON m.idMembresia = u.idMembresia;

-- Reserva con todos sus datos relacionados y lo pagado hasta ahora
CREATE VIEW v_reserva_detalle AS
SELECT r.idReserva,
       CONCAT(u.nombres, ' ', u.apellidos) AS cliente,
       v.placa, v.marca, v.modelo, v.tipoVehiculo,
       so.ciudad  AS ciudadOrigen,
       sd.ciudad  AS ciudadDestino,
       r.fechaInicio, r.fechaFin, r.estadoReserva,
       c.numeroContrato,
       c.depositoGarantia,
       COALESCE(SUM(p.monto), 0) AS totalPagado
FROM reserva r
JOIN usuario  u  ON u.idUsuario  = r.idUsuario
JOIN vehiculo v  ON v.placa      = r.placa
JOIN sucursal so ON so.idSucursal = r.idSucursalOrigen
JOIN sucursal sd ON sd.idSucursal = r.idSucursalDestino
LEFT JOIN contrato c ON c.idReserva = r.idReserva
LEFT JOIN pago     p ON p.idReserva = r.idReserva
GROUP BY r.idReserva, u.nombres, u.apellidos, v.placa, v.marca, v.modelo,
         v.tipoVehiculo, so.ciudad, sd.ciudad, r.fechaInicio, r.fechaFin,
         r.estadoReserva, c.numeroContrato, c.depositoGarantia;

-- Control de integridad: usuarios que NO tienen su fila de subtipo
-- (la especialización es total, así que esta vista debe quedar vacía)
CREATE VIEW v_usuarios_sin_subtipo AS
SELECT u.idUsuario, u.nombres, u.apellidos, u.tipoUsuario
FROM usuario u
LEFT JOIN usuario_particular  p ON p.idUsuario = u.idUsuario
LEFT JOIN usuario_empresarial e ON e.idUsuario = u.idUsuario
WHERE p.idUsuario IS NULL AND e.idUsuario IS NULL;

-- Control de integridad: vehículos ELECTRICO sin su fila en vehiculo_electrico
CREATE VIEW v_electricos_sin_detalle AS
SELECT v.placa, v.marca, v.modelo
FROM vehiculo v
LEFT JOIN vehiculo_electrico e ON e.placa = v.placa
WHERE v.tipoVehiculo = 'ELECTRICO' AND e.placa IS NULL;
