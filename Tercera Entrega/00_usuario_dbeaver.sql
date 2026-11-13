-- =====================================================================
-- 00_usuario_dbeaver.sql  ·  Usuario para conectar DBeaver (ejecutar UNA vez)
--
-- En Linux, el usuario `root` de MariaDB entra por socket (unix_socket) y
-- DBeaver no puede usarlo por TCP. Por eso se crea un usuario propio.
--
-- Ejecutar desde la terminal como administrador:
--     sudo mariadb < 00_usuario_dbeaver.sql
--
-- ⚠ Cambia la contraseña antes de ejecutarlo.
-- =====================================================================

CREATE USER IF NOT EXISTS 'alquiler'@'localhost' IDENTIFIED BY 'cambia_esta_clave';

-- Permisos solo sobre la base del proyecto (incluye CREATE, DROP y TRIGGER,
-- necesarios para que 01_esquema_ddl.sql pueda reiniciar la base).
GRANT ALL PRIVILEGES ON alquiler_vehiculos.* TO 'alquiler'@'localhost';

FLUSH PRIVILEGES;
