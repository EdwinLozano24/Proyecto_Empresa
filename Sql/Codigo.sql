
CREATE DATABASE inventario_equipos_gradezco;
USE inventario_equipos_gradezco;

-- Tabla: Tipos de equipos
CREATE TABLE tbl_tipo_equipo (
    Id_Tipo_Equipo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nombre_Tipo_Equipo VARCHAR(255) UNIQUE,
    Descripcion_Tipo_Equipo TEXT
);

-- Tabla: Archivos
CREATE TABLE tbl_archivo (
    Id_Archivo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nombre_Archivo VARCHAR(255),
    Ruta_Archivo VARCHAR(255)
);

-- Tabla: Roles
CREATE TABLE tbl_rol (
    Id_Rol INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nombre_Rol VARCHAR(255) UNIQUE,
    Descripcion_Rol TEXT
);

-- Tabla: Cargos
CREATE TABLE tbl_cargo (
    Id_Cargo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nombre_Cargo VARCHAR(255) UNIQUE,
    Descripcion_Cargo TEXT
);

-- Tabla: Empleados
CREATE TABLE tbl_empleado (
    Id_Empleado INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    documento_Empleado VARCHAR(50) NOT NULL,
    Nombre_Empleado VARCHAR(255),
    Apellido_Empleado VARCHAR(255),
    Num_Telefono VARCHAR(20),
    Correo_Electronico VARCHAR(255),
    Id_Cargo INT,
    FOREIGN KEY (Id_Cargo) REFERENCES tbl_cargo(Id_Cargo)
);


-- Tabla: Usuarios
CREATE TABLE tbl_usuario (
    Id_Usuario INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    documento_Usuario VARCHAR(50) UNIQUE NOT NULL,
    Nombre_Usuario VARCHAR(255) UNIQUE NOT NULL,
    Password_Usuario VARCHAR(255) NOT NULL,
    Id_Empleado INT NULL,
    Id_Rol INT NOT NULL,
    Token_Recuperacion VARCHAR(255) NULL,
    Token_Expira DATETIME NULL,
    FOREIGN KEY (Id_Empleado) REFERENCES tbl_empleado(Id_Empleado),
    FOREIGN KEY (Id_Rol) REFERENCES tbl_rol(Id_Rol)
);


-- Tabla: Equipos
CREATE TABLE tbl_equipos (
    Id_Equipo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Codigo_Inventario VARCHAR(255),
    Marca_Equipo VARCHAR(255),
    Numero_Serie VARCHAR(255),
    Ubicacion_Equipo VARCHAR(255),
    Propietario_Equipo INT,
    Estado_Equipo ENUM('Activo','Inactivo','Mantenimiento','Dado de Baja'),
    Fecha_Ad_Equipo DATE,
    Id_Archivo INT,
    Id_Tipo_Equipo INT,
    FOREIGN KEY (Propietario_Equipo) REFERENCES tbl_empleado(Id_Empleado),
    FOREIGN KEY (Id_Archivo) REFERENCES tbl_archivo(Id_Archivo),
    FOREIGN KEY (Id_Tipo_Equipo) REFERENCES tbl_tipo_equipo(Id_Tipo_Equipo)
);

-- Tabla: Mantenimientos
CREATE TABLE tbl_mantenimiento (
    Id_Mantenimiento INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Id_Equipo INT,
    Id_Empleado INT,
    Fecha_Mantenimiento DATE,
    Descripcion_Mantenimiento VARCHAR(255),
    Estado_Mantenimiento ENUM('Activo','Inactivo','Mantenimiento','Dado de Baja'),
    FOREIGN KEY (Id_Equipo) REFERENCES tbl_equipos(Id_Equipo),
    FOREIGN KEY (Id_Empleado) REFERENCES tbl_empleado(Id_Empleado)
);

-- Tabla: Historial de movimientos
CREATE TABLE tbl_historial (
    Id_Historial INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Id_Equipo INT,
    Tipo_Entidad ENUM('Equipo', 'Mantenimiento') NOT NULL DEFAULT 'Equipo',
    Campo_Cambiado VARCHAR(255),
    Valor_Anterior VARCHAR(255),
    Descripcion_Historial VARCHAR(255),
    Valor_Nuevo VARCHAR(255),
    Fecha_Cambio DATE,
    Id_Empleado INT,
    FOREIGN KEY (Id_Equipo) REFERENCES tbl_equipos(Id_Equipo),
    FOREIGN KEY (Id_Empleado) REFERENCES tbl_empleado(Id_Empleado)
);

-- Triggers
--hay que probar si funciona
DELIMITER $$

CREATE TRIGGER trg_usuario_set_empleado
BEFORE INSERT ON tbl_usuario
FOR EACH ROW
BEGIN
    DECLARE v_id_empleado INT;

    -- Buscar empleado con el mismo documento
    SELECT Id_Empleado INTO v_id_empleado
    FROM tbl_empleado
    WHERE documento_Empleado = NEW.documento_Usuario
    LIMIT 1;

    -- Si existe, asignar el Id_Empleado al usuario
    SET NEW.Id_Empleado = v_id_empleado;
END$$

DELIMITER ;


 
DELIMITER $$

CREATE TRIGGER trg_empleado_link_usuario
AFTER INSERT ON tbl_empleado
FOR EACH ROW
BEGIN
    -- Enlazar el usuario con el empleado si coincide el documento
    UPDATE tbl_usuario
    SET Id_Empleado = NEW.Id_Empleado
    WHERE documento_Usuario = NEW.documento_Empleado;
END$$

DELIMITER ;


-- BORRAR funciones/triggers previos (opcional, para evitar duplicados)
DROP FUNCTION IF EXISTS CapitalizarPalabras;
DROP FUNCTION IF EXISTS Capitalizar;
DROP TRIGGER IF EXISTS trg_empleado_bi;
DROP TRIGGER IF EXISTS trg_empleado_bu;
DROP TRIGGER IF EXISTS trg_tipo_equipo_bi;
DROP TRIGGER IF EXISTS trg_tipo_equipo_bu;
-- (Añade más DROP TRIGGER si ya creaste otros)

-- 1) Función: Capitalizar cada palabra -> "aLGO ASI" => "Algo Asi"
DELIMITER $$
CREATE FUNCTION CapitalizarPalabras(txt VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE resultado VARCHAR(255) DEFAULT '';
    DECLARE palabra VARCHAR(255);
    DECLARE espacio_pos INT DEFAULT 1;
    DECLARE len INT;
    DECLARE i INT DEFAULT 1;

    IF txt IS NULL THEN
        RETURN NULL;
    END IF;

    SET txt = TRIM(txt);
    SET len = CHAR_LENGTH(txt);

    WHILE i <= len DO
        -- extraer palabra por palabra usando LOCATE de espacios
        SET espacio_pos = LOCATE(' ', txt, 1);
        IF espacio_pos = 0 THEN
            SET palabra = txt;
            SET txt = '';
            SET i = len + 1;
        ELSE
            SET palabra = LEFT(txt, espacio_pos - 1);
            SET txt = LTRIM(SUBSTRING(txt, espacio_pos));
            SET len = CHAR_LENGTH(txt);
        END IF;

        IF palabra <> '' THEN
            SET palabra = CONCAT( UPPER(LEFT(LOWER(palabra),1)), SUBSTRING(LOWER(palabra),2) );
            IF resultado = '' THEN
                SET resultado = palabra;
            ELSE
                SET resultado = CONCAT(resultado, ' ', palabra);
            END IF;
        END IF;
    END WHILE;

    RETURN resultado;
END$$
DELIMITER ;

-- 2) Función: Capitalizar sólo la primera letra (por si la prefieres)
DELIMITER $$
CREATE FUNCTION Capitalizar(txt VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    IF txt IS NULL OR txt = '' THEN
        RETURN txt;
    END IF;
    RETURN CONCAT( UPPER(LEFT(LOWER(txt),1)), SUBSTRING(LOWER(txt),2) );
END$$
DELIMITER ;

-- 3) Ejemplo triggers para tbl_empleado (usar CapitalizarPalabras en nombres, correo en lowercase)
DELIMITER $$
CREATE TRIGGER trg_empleado_bi
BEFORE INSERT ON tbl_empleado
FOR EACH ROW
BEGIN
    SET NEW.Nombre_Empleado   = CapitalizarPalabras(NEW.Nombre_Empleado);
    SET NEW.Apellido_Empleado = CapitalizarPalabras(NEW.Apellido_Empleado);
    SET NEW.Correo_Electronico = LOWER(NEW.Correo_Electronico);
END$$

CREATE TRIGGER trg_empleado_bu
BEFORE UPDATE ON tbl_empleado
FOR EACH ROW
BEGIN
    SET NEW.Nombre_Empleado   = CapitalizarPalabras(NEW.Nombre_Empleado);
    SET NEW.Apellido_Empleado = CapitalizarPalabras(NEW.Apellido_Empleado);
    SET NEW.Correo_Electronico = LOWER(NEW.Correo_Electronico);
END$$
DELIMITER ;

-- 4) Triggers para tbl_tipo_equipo (ejemplo)
DELIMITER $$
CREATE TRIGGER trg_tipo_equipo_bi
BEFORE INSERT ON tbl_tipo_equipo
FOR EACH ROW
BEGIN
    SET NEW.Nombre_Tipo_Equipo = CapitalizarPalabras(NEW.Nombre_Tipo_Equipo);
    SET NEW.Descripcion_Tipo_Equipo = CapitalizarPalabras(NEW.Descripcion_Tipo_Equipo);
END$$

CREATE TRIGGER trg_tipo_equipo_bu
BEFORE UPDATE ON tbl_tipo_equipo
FOR EACH ROW
BEGIN
    SET NEW.Nombre_Tipo_Equipo = CapitalizarPalabras(NEW.Nombre_Tipo_Equipo);
    SET NEW.Descripcion_Tipo_Equipo = CapitalizarPalabras(NEW.Descripcion_Tipo_Equipo);
END$$
DELIMITER ;

-- 5) Triggers para tbl_archivo
DELIMITER $$
CREATE TRIGGER trg_archivo_bi
BEFORE INSERT ON tbl_archivo
FOR EACH ROW
BEGIN
    SET NEW.Nombre_Archivo = CapitalizarPalabras(NEW.Nombre_Archivo);
    SET NEW.Ruta_Archivo = LOWER(NEW.Ruta_Archivo);
END$$

CREATE TRIGGER trg_archivo_bu
BEFORE UPDATE ON tbl_archivo
FOR EACH ROW
BEGIN
    SET NEW.Nombre_Archivo = CapitalizarPalabras(NEW.Nombre_Archivo);
    SET NEW.Ruta_Archivo = LOWER(NEW.Ruta_Archivo);
END$$
DELIMITER ;

-- 6) Triggers para tbl_cargo
DELIMITER $$
CREATE TRIGGER trg_cargo_bi
BEFORE INSERT ON tbl_cargo
FOR EACH ROW
BEGIN
    SET NEW.Nombre_Cargo = CapitalizarPalabras(NEW.Nombre_Cargo);
    SET NEW.Descripcion_Cargo = CapitalizarPalabras(NEW.Descripcion_Cargo);
END$$

CREATE TRIGGER trg_cargo_bu
BEFORE UPDATE ON tbl_cargo
FOR EACH ROW
BEGIN
    SET NEW.Nombre_Cargo = CapitalizarPalabras(NEW.Nombre_Cargo);
    SET NEW.Descripcion_Cargo = CapitalizarPalabras(NEW.Descripcion_Cargo);
END$$
DELIMITER ;

-- 7) Triggers para tbl_rol
DELIMITER $$
CREATE TRIGGER trg_rol_bi
BEFORE INSERT ON tbl_rol
FOR EACH ROW
BEGIN
    SET NEW.Nombre_Rol = CapitalizarPalabras(NEW.Nombre_Rol);
    SET NEW.Descripcion_Rol = CapitalizarPalabras(NEW.Descripcion_Rol);
END$$

CREATE TRIGGER trg_rol_bu
BEFORE UPDATE ON tbl_rol
FOR EACH ROW
BEGIN
    SET NEW.Nombre_Rol = CapitalizarPalabras(NEW.Nombre_Rol);
    SET NEW.Descripcion_Rol = CapitalizarPalabras(NEW.Descripcion_Rol);
END$$
DELIMITER ;

-- 8) Triggers para tbl_equipos
DELIMITER $$
CREATE TRIGGER trg_equipos_bi
BEFORE INSERT ON tbl_equipos
FOR EACH ROW
BEGIN
    SET NEW.Marca_Equipo     = CapitalizarPalabras(NEW.Marca_Equipo);
    SET NEW.Ubicacion_Equipo = CapitalizarPalabras(NEW.Ubicacion_Equipo);
    SET NEW.Numero_Serie = UPPER(NEW.Numero_Serie);
END$$

CREATE TRIGGER trg_equipos_bu
BEFORE UPDATE ON tbl_equipos
FOR EACH ROW
BEGIN
    SET NEW.Marca_Equipo     = CapitalizarPalabras(NEW.Marca_Equipo);
    SET NEW.Ubicacion_Equipo = CapitalizarPalabras(NEW.Ubicacion_Equipo);
    SET NEW.Numero_Serie = UPPER(NEW.Numero_Serie);
END$$
DELIMITER ;

-- 9) Triggers para tbl_mantenimiento
DELIMITER $$
CREATE TRIGGER trg_mantenimiento_bi
BEFORE INSERT ON tbl_mantenimiento
FOR EACH ROW
BEGIN
    SET NEW.Descripcion_Mantenimiento = CapitalizarPalabras(NEW.Descripcion_Mantenimiento);
END$$

CREATE TRIGGER trg_mantenimiento_bu
BEFORE UPDATE ON tbl_mantenimiento
FOR EACH ROW
BEGIN
    SET NEW.Descripcion_Mantenimiento = CapitalizarPalabras(NEW.Descripcion_Mantenimiento);
END$$
DELIMITER ;

-- 10) Triggers para tbl_historial
DELIMITER $$
CREATE TRIGGER trg_historial_bi
BEFORE INSERT ON tbl_historial
FOR EACH ROW
BEGIN
    SET NEW.Descripcion_Historial = CapitalizarPalabras(NEW.Descripcion_Historial);
END$$

CREATE TRIGGER trg_historial_bu
BEFORE UPDATE ON tbl_historial
FOR EACH ROW
BEGIN
    SET NEW.Descripcion_Historial = CapitalizarPalabras(NEW.Descripcion_Historial);
END$$

-- Triggers de auditoría para equipos y mantenimientos
CREATE TRIGGER trg_equipos_auditoria AFTER UPDATE ON tbl_equipos
FOR EACH ROW
BEGIN
    IF OLD.Marca_Equipo != NEW.Marca_Equipo THEN
        INSERT INTO tbl_historial (Id_Equipo, Tipo_Entidad, Campo_Cambiado, Valor_Anterior, Valor_Nuevo, Descripcion_Historial, Fecha_Cambio, Id_Empleado)
        VALUES (NEW.Id_Equipo, 'Equipo', 'Marca_Equipo', OLD.Marca_Equipo, NEW.Marca_Equipo, CONCAT('Cambio de marca'), CURDATE(), NEW.Propietario_Equipo);
    END IF;
    -- Agregar más IF para otros campos
END$$

CREATE TRIGGER trg_mantenimiento_auditoria_insert AFTER INSERT ON tbl_mantenimiento
FOR EACH ROW
BEGIN
    INSERT INTO tbl_historial (Id_Equipo, Tipo_Entidad, Campo_Cambiado, Valor_Anterior, Valor_Nuevo, Descripcion_Historial, Fecha_Cambio, Id_Empleado)
    VALUES (NEW.Id_Equipo, 'Mantenimiento', 'Nuevo_Mantenimiento', NULL, NEW.Id_Mantenimiento, CONCAT('Nuevo mantenimiento: ', NEW.Descripcion_Mantenimiento), NEW.Fecha_Mantenimiento, NEW.Id_Empleado);
END$$

DELIMITER ;

-- 11) NORMALIZAR datos existentes (ejecutar después de crear funciones y triggers)
-- Normalizar empleados
UPDATE tbl_empleado
SET Nombre_Empleado = CapitalizarPalabras(Nombre_Empleado),
    Apellido_Empleado = CapitalizarPalabras(Apellido_Empleado),
    Correo_Electronico = LOWER(Correo_Electronico);

-- Normalizar tipos de equipo
UPDATE tbl_tipo_equipo
SET Nombre_Tipo_Equipo = CapitalizarPalabras(Nombre_Tipo_Equipo),

    Descripcion_Tipo_Equipo = CapitalizarPalabras(Descripcion_Tipo_Equipo);

-- Normalizar archivos
UPDATE tbl_archivo
SET Nombre_Archivo = CapitalizarPalabras(Nombre_Archivo),
    Ruta_Archivo = LOWER(Ruta_Archivo);

-- Normalizar cargos
UPDATE tbl_cargo
SET Nombre_Cargo = CapitalizarPalabras(Nombre_Cargo),
    Descripcion_Cargo = CapitalizarPalabras(Descripcion_Cargo);

-- Normalizar roles
UPDATE tbl_rol
SET Nombre_Rol = CapitalizarPalabras(Nombre_Rol),
    Descripcion_Rol = CapitalizarPalabras(Descripcion_Rol);

-- Normalizar equipos
UPDATE tbl_equipos
SET Marca_Equipo = CapitalizarPalabras(Marca_Equipo),
    Ubicacion_Equipo = CapitalizarPalabras(Ubicacion_Equipo),
    Numero_Serie = UPPER(Numero_Serie);

-- Normalizar mantenimiento e historial
UPDATE tbl_mantenimiento
SET Descripcion_Mantenimiento = CapitalizarPalabras(Descripcion_Mantenimiento);

UPDATE tbl_historial
SET Ubicacion_Antigua = CapitalizarPalabras(Ubicacion_Antigua),
    Descripcion_Historial = CapitalizarPalabras(Descripcion_Historial),
    Ubicacion_Nueva = CapitalizarPalabras(Ubicacion_Nueva);

-- NOTA: No se ejecutan updates sobre tbl_usuario (contraseñas/tokens).

-- ==========================================
-- DATOS DE INICIALIZACIÓN
-- ==========================================

-- Insertar roles por defecto
INSERT INTO tbl_rol (Nombre_Rol, Descripcion_Rol) VALUES 
('Administrador', 'Acceso total al sistema'),
('Usuario', 'Acceso básico al sistema'),
('Supervisor', 'Supervisión de inventario'),
('Técnico', 'Técnico de mantenimiento');

-- Insertar cargos por defecto
INSERT INTO tbl_cargo (Nombre_Cargo, Descripcion_Cargo) VALUES 
('Gerente', 'Gerente del departamento'),
('Asistente', 'Asistente administrativo'),
('Técnico', 'Técnico de soporte'),
('Operario', 'Personal operativo');

-- Insertar tipos de equipos por defecto
INSERT INTO tbl_tipo_equipo (Nombre_Tipo_Equipo, Descripcion_Tipo_Equipo) VALUES 
('Computadora', 'Equipos de cómputo de escritorio y portátiles'),
('Monitor', 'Monitores para visualización'),
('Impresora', 'Impresoras y multifuncionales'),
('Router', 'Equipos de red'),
('Escáner', 'Equipos de escaneo de documentos'),
('Teléfono', 'Teléfonos y equipos de comunicación'),
('Servidor', 'Servidores de red');

-- ==========================================
-- VERIFICACIÓN DE DATOS
-- ==========================================

-- SELECT 'Roles creados:' as tipo;
-- SELECT * FROM tbl_rol;

-- SELECT 'Cargos creados:' as tipo;
-- SELECT * FROM tbl_cargo;

-- SELECT 'Tipos de equipos creados:' as tipo;
-- SELECT * FROM tbl_tipo_equipo;

