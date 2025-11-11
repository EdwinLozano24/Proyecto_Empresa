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
    Nombre_Usuario VARCHAR(255),
    Password_Usuario VARCHAR(255),
    Id_Empleado INT,
    Id_Rol INT,
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
