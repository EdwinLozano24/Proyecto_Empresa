CREATE DATABASE inventario_equipos_gradezco;

USE inventario_equipos_gradezco;

CREATE TABLE tbl_equipos (
    Id_Equipo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Codigo_Inventario VARCHAR(255),
    Marca_Equipo VARCHAR(255),
    Numero_Serie VARCHAR(255),
    Ubicacion_Equipo VARCHAR(255),
    Propietario_Equipo Text,
    Estado_Equipo enum('Activo','Inactivo','Mantenimiento','Dado de Baja'),
    Fecha_Ad_Equipo DATE,
    Id_Equipo VARCHAR(255),
    Archivo_Equipo VARCHAR(255)
    Tipo_equipo VARCHAR(255)
);
CREATE TABLE tbl_tipo_equipo (
    Id_Tipo_Equipo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nombre_Tipo_Equipo VARCHAR(255),
    Descripcion_Tipo_Equipo TEXT
);
CREATE TABLE tbl_archivo (
    Id_Archivo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nombre_Archivo VARCHAR(255)
    Ruta_Archivo VARCHAR(255)
);


CREATE TABLE tbl_rol (
    Id_Rol INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nombre_Rol VARCHAR(255),
    Descripcion_Rol TEXT
);

CREATE TABLE tbl_cargo (
    Id_Cargo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nombre_Cargo VARCHAR(255),
    Descripcion_Cargo TEXT
);

CREATE TABLE tbl_empleado (
    Id_Empleado INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nombre_Empleado VARCHAR(255),
    Apellido_Empleado VARCHAR(255),
    Num_Telefono VARCHAR(20),
    Correo_Electronico VARCHAR(255),
    Id_Cargo INT foreign key references tbl_cargo(Id_Cargo)
);

CREATE TABLE tbl_Usuario (
    Id_Usuario INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nombre_Usuario VARCHAR(255),
    Password_Usuario VARCHAR(255),
    Id_Empleado INT foreign key references tbl_empleado(Id_Empleado),
    Id_Rol INT foreign key references tbl_rol(Id_Rol)
);

CREATE TABLE tbl_mantenimiento (
    Id_Mantenimiento INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Id_Equipo INT foreign key references tbl_equipos(Id_Equipo),
    Id_Empleado INT foreign key references tbl_empleado(Id_Empleado),
    Fecha_Mantenimiento DATE,
    Descripcion_Mantenimiento VARCHAR(255),
    Estado_Mantenimiento enum('Activo','Inactivo','Mantenimiento','Dado de Baja')
);
CREATE TABLE tbl_historial (
    Id_Historial INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Id_Equipo INT foreign key references tbl_equipos(Id_Equipo),
    Ubicacion_Antigua VARCHAR(255),
    Descripcion_Historial VARCHAR(255),
    Ubicacion_Nueva VARCHAR(255),
    Fecha_Cambio DATE,
    Id_Empleado INT foreign key references tbl_empleado(Id_Empleado)
);

