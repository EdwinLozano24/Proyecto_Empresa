-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 11-11-2025 a las 17:17:33
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `inventario_equipos_gradezco`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_archivo`
--

CREATE TABLE `tbl_archivo` (
  `Id_Archivo` int(11) NOT NULL,
  `Nombre_Archivo` varchar(255) DEFAULT NULL,
  `Ruta_Archivo` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_cargo`
--

CREATE TABLE `tbl_cargo` (
  `Id_Cargo` int(11) NOT NULL,
  `Nombre_Cargo` varchar(255) DEFAULT NULL,
  `Descripcion_Cargo` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_empleado`
--

CREATE TABLE `tbl_empleado` (
  `Id_Empleado` int(11) NOT NULL,
  `Nombre_Empleado` varchar(255) DEFAULT NULL,
  `Apellido_Empleado` varchar(255) DEFAULT NULL,
  `Num_Telefono` varchar(20) DEFAULT NULL,
  `Correo_Electronico` varchar(255) DEFAULT NULL,
  `Id_Cargo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_equipos`
--

CREATE TABLE `tbl_equipos` (
  `Id_Equipo` int(11) NOT NULL,
  `Codigo_Inventario` varchar(255) DEFAULT NULL,
  `Marca_Equipo` varchar(255) DEFAULT NULL,
  `Numero_Serie` varchar(255) DEFAULT NULL,
  `Ubicacion_Equipo` varchar(255) DEFAULT NULL,
  `Propietario_Equipo` text DEFAULT NULL,
  `Estado_Equipo` enum('Activo','Inactivo','Mantenimiento','Dado de Baja') DEFAULT NULL,
  `Fecha_Ad_Equipo` date DEFAULT NULL,
  `Id_Archivo` int(11) DEFAULT NULL,
  `Id_Tipo_Equipo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_historial`
--

CREATE TABLE `tbl_historial` (
  `Id_Historial` int(11) NOT NULL,
  `Id_Equipo` int(11) DEFAULT NULL,
  `Ubicacion_Antigua` varchar(255) DEFAULT NULL,
  `Descripcion_Historial` varchar(255) DEFAULT NULL,
  `Ubicacion_Nueva` varchar(255) DEFAULT NULL,
  `Fecha_Cambio` date DEFAULT NULL,
  `Id_Empleado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_mantenimiento`
--

CREATE TABLE `tbl_mantenimiento` (
  `Id_Mantenimiento` int(11) NOT NULL,
  `Id_Equipo` int(11) DEFAULT NULL,
  `Id_Empleado` int(11) DEFAULT NULL,
  `Fecha_Mantenimiento` date DEFAULT NULL,
  `Descripcion_Mantenimiento` varchar(255) DEFAULT NULL,
  `Estado_Mantenimiento` enum('Activo','Inactivo','Mantenimiento','Dado de Baja') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_rol`
--

CREATE TABLE `tbl_rol` (
  `Id_Rol` int(11) NOT NULL,
  `Nombre_Rol` varchar(255) DEFAULT NULL,
  `Descripcion_Rol` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_tipo_equipo`
--

CREATE TABLE `tbl_tipo_equipo` (
  `Id_Tipo_Equipo` int(11) NOT NULL,
  `Nombre_Tipo_Equipo` varchar(255) DEFAULT NULL,
  `Descripcion_Tipo_Equipo` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_usuario`
--

CREATE TABLE `tbl_usuario` (
  `Id_Usuario` int(11) NOT NULL,
  `Nombre_Usuario` varchar(255) DEFAULT NULL,
  `Password_Usuario` varchar(255) DEFAULT NULL,
  `Id_Empleado` int(11) DEFAULT NULL,
  `Id_Rol` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `tbl_archivo`
--
ALTER TABLE `tbl_archivo`
  ADD PRIMARY KEY (`Id_Archivo`);

--
-- Indices de la tabla `tbl_cargo`
--
ALTER TABLE `tbl_cargo`
  ADD PRIMARY KEY (`Id_Cargo`);

--
-- Indices de la tabla `tbl_empleado`
--
ALTER TABLE `tbl_empleado`
  ADD PRIMARY KEY (`Id_Empleado`),
  ADD KEY `Id_Cargo` (`Id_Cargo`);

--
-- Indices de la tabla `tbl_equipos`
--
ALTER TABLE `tbl_equipos`
  ADD PRIMARY KEY (`Id_Equipo`),
  ADD KEY `Id_Archivo` (`Id_Archivo`),
  ADD KEY `Id_Tipo_Equipo` (`Id_Tipo_Equipo`);

--
-- Indices de la tabla `tbl_historial`
--
ALTER TABLE `tbl_historial`
  ADD PRIMARY KEY (`Id_Historial`),
  ADD KEY `Id_Equipo` (`Id_Equipo`),
  ADD KEY `Id_Empleado` (`Id_Empleado`);

--
-- Indices de la tabla `tbl_mantenimiento`
--
ALTER TABLE `tbl_mantenimiento`
  ADD PRIMARY KEY (`Id_Mantenimiento`),
  ADD KEY `Id_Equipo` (`Id_Equipo`),
  ADD KEY `Id_Empleado` (`Id_Empleado`);

--
-- Indices de la tabla `tbl_rol`
--
ALTER TABLE `tbl_rol`
  ADD PRIMARY KEY (`Id_Rol`);

--
-- Indices de la tabla `tbl_tipo_equipo`
--
ALTER TABLE `tbl_tipo_equipo`
  ADD PRIMARY KEY (`Id_Tipo_Equipo`);

--
-- Indices de la tabla `tbl_usuario`
--
ALTER TABLE `tbl_usuario`
  ADD PRIMARY KEY (`Id_Usuario`),
  ADD KEY `Id_Empleado` (`Id_Empleado`),
  ADD KEY `Id_Rol` (`Id_Rol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `tbl_archivo`
--
ALTER TABLE `tbl_archivo`
  MODIFY `Id_Archivo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_cargo`
--
ALTER TABLE `tbl_cargo`
  MODIFY `Id_Cargo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_empleado`
--
ALTER TABLE `tbl_empleado`
  MODIFY `Id_Empleado` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_equipos`
--
ALTER TABLE `tbl_equipos`
  MODIFY `Id_Equipo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_historial`
--
ALTER TABLE `tbl_historial`
  MODIFY `Id_Historial` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_mantenimiento`
--
ALTER TABLE `tbl_mantenimiento`
  MODIFY `Id_Mantenimiento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_rol`
--
ALTER TABLE `tbl_rol`
  MODIFY `Id_Rol` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_tipo_equipo`
--
ALTER TABLE `tbl_tipo_equipo`
  MODIFY `Id_Tipo_Equipo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_usuario`
--
ALTER TABLE `tbl_usuario`
  MODIFY `Id_Usuario` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `tbl_empleado`
--
ALTER TABLE `tbl_empleado`
  ADD CONSTRAINT `tbl_empleado_ibfk_1` FOREIGN KEY (`Id_Cargo`) REFERENCES `tbl_cargo` (`Id_Cargo`);

--
-- Filtros para la tabla `tbl_equipos`
--
ALTER TABLE `tbl_equipos`
  ADD CONSTRAINT `tbl_equipos_ibfk_1` FOREIGN KEY (`Id_Archivo`) REFERENCES `tbl_archivo` (`Id_Archivo`),
  ADD CONSTRAINT `tbl_equipos_ibfk_2` FOREIGN KEY (`Id_Tipo_Equipo`) REFERENCES `tbl_tipo_equipo` (`Id_Tipo_Equipo`);

--
-- Filtros para la tabla `tbl_historial`
--
ALTER TABLE `tbl_historial`
  ADD CONSTRAINT `tbl_historial_ibfk_1` FOREIGN KEY (`Id_Equipo`) REFERENCES `tbl_equipos` (`Id_Equipo`),
  ADD CONSTRAINT `tbl_historial_ibfk_2` FOREIGN KEY (`Id_Empleado`) REFERENCES `tbl_empleado` (`Id_Empleado`);

--
-- Filtros para la tabla `tbl_mantenimiento`
--
ALTER TABLE `tbl_mantenimiento`
  ADD CONSTRAINT `tbl_mantenimiento_ibfk_1` FOREIGN KEY (`Id_Equipo`) REFERENCES `tbl_equipos` (`Id_Equipo`),
  ADD CONSTRAINT `tbl_mantenimiento_ibfk_2` FOREIGN KEY (`Id_Empleado`) REFERENCES `tbl_empleado` (`Id_Empleado`);

--
-- Filtros para la tabla `tbl_usuario`
--
ALTER TABLE `tbl_usuario`
  ADD CONSTRAINT `tbl_usuario_ibfk_1` FOREIGN KEY (`Id_Empleado`) REFERENCES `tbl_empleado` (`Id_Empleado`),
  ADD CONSTRAINT `tbl_usuario_ibfk_2` FOREIGN KEY (`Id_Rol`) REFERENCES `tbl_rol` (`Id_Rol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
