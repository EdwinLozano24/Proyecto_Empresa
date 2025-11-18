CREATE DATABASE inventario_equipos_gradezco;
USE inventario_equipos_gradezco;

-- Tabla: Tipos de equipos
CREATE TABLE tbl_tipo_equipo (
    Id_Tipo_Equipo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nombre_Tipo_Equipo VARCHAR(255),
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
    Nombre_Rol VARCHAR(255),
    Descripcion_Rol TEXT
);

-- Tabla: Cargos
CREATE TABLE tbl_cargo (
    Id_Cargo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nombre_Cargo VARCHAR(255),
    Descripcion_Cargo TEXT
);

-- Tabla: Empleados
CREATE TABLE tbl_empleado (
    Id_Empleado INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
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
    Propietario_Equipo TEXT,
    Estado_Equipo ENUM('Activo','Inactivo','Mantenimiento','Dado de Baja'),
    Fecha_Ad_Equipo DATE,
    Id_Archivo INT,
    Id_Tipo_Equipo INT,
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
    Ubicacion_Antigua VARCHAR(255),
    Descripcion_Historial VARCHAR(255),
    Ubicacion_Nueva VARCHAR(255),
    Fecha_Cambio DATE,
    Id_Empleado INT,
    FOREIGN KEY (Id_Equipo) REFERENCES tbl_equipos(Id_Equipo),
    FOREIGN KEY (Id_Empleado) REFERENCES tbl_empleado(Id_Empleado)
);

-- Triggers
--hay que probar si funciona
DELIMITER $$

CREATE TRIGGER trg_usuario_set_empleado
BEFORE INSERT ON tbl_usuarios
FOR EACH ROW
BEGIN
    DECLARE v_id_empleado INT;

    -- Buscar el empleado cuyo número de identificación coincide
    SELECT id_empleado INTO v_id_empleado
    FROM tbl_empleados
    WHERE numero_identificacion = NEW.numero_identificacion
    LIMIT 1;

    -- Si existe, se asigna el id_empleado al usuario
    SET NEW.id_empleado = v_id_empleado;
END$$

DELIMITER ;

 
DELIMITER $$

CREATE TRIGGER trg_empleado_link_usuario
AFTER INSERT ON tbl_empleados
FOR EACH ROW
BEGIN
    -- Actualizar usuario cuyo número de identificación coincida
    UPDATE tbl_usuarios
    SET id_empleado = NEW.id_empleado
    WHERE numero_identificacion = NEW.numero_identificacion;
END$$

DELIMITER ;

