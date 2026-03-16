-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 10, 2026 at 09:12 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */; 

--
-- Database: `inventario_equipos_gradezco`
--

DELIMITER //
--
-- Functions
--
CREATE FUNCTION `Capitalizar` (`txt` VARCHAR(255)) RETURNS VARCHAR(255) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    IF txt IS NULL OR txt = '' THEN
        RETURN txt;
    END IF;
    RETURN CONCAT( UPPER(LEFT(LOWER(txt),1)), SUBSTRING(LOWER(txt),2) );
END//

CREATE FUNCTION `CapitalizarPalabras` (`txt` VARCHAR(255)) RETURNS VARCHAR(255) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
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
END//

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_archivo`
--

CREATE TABLE `tbl_archivo` (
  `Id_Archivo` int(11) NOT NULL,
  `Nombre_Archivo` varchar(255) DEFAULT NULL,
  `Ruta_Archivo` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `tbl_archivo`
--
DELIMITER //
CREATE TRIGGER `trg_archivo_bi` BEFORE INSERT ON `tbl_archivo` FOR EACH ROW BEGIN
    SET NEW.Nombre_Archivo = CapitalizarPalabras(NEW.Nombre_Archivo);
    SET NEW.Ruta_Archivo = LOWER(NEW.Ruta_Archivo);
END
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER `trg_archivo_bu` BEFORE UPDATE ON `tbl_archivo` FOR EACH ROW BEGIN
    SET NEW.Nombre_Archivo = CapitalizarPalabras(NEW.Nombre_Archivo);
    SET NEW.Ruta_Archivo = LOWER(NEW.Ruta_Archivo);
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_cargo`
--

CREATE TABLE `tbl_cargo` (
  `Id_Cargo` int(11) NOT NULL,
  `Nombre_Cargo` varchar(255) DEFAULT NULL,
  `Descripcion_Cargo` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_cargo`
--

INSERT INTO `tbl_cargo` (`Id_Cargo`, `Nombre_Cargo`, `Descripcion_Cargo`) VALUES
(1, 'Gerente', 'Gerente Del Departamento'),
(2, 'Asistente', 'Asistente Administrativo'),
(3, 'Técnico', 'Técnico De Soporte'),
(4, 'Operario', 'Personal Operativo');

--
-- Triggers `tbl_cargo`
--
DELIMITER //
CREATE TRIGGER `trg_cargo_bi` BEFORE INSERT ON `tbl_cargo` FOR EACH ROW BEGIN
    SET NEW.Nombre_Cargo = CapitalizarPalabras(NEW.Nombre_Cargo);
    SET NEW.Descripcion_Cargo = CapitalizarPalabras(NEW.Descripcion_Cargo);
END
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER `trg_cargo_bu` BEFORE UPDATE ON `tbl_cargo` FOR EACH ROW BEGIN
    SET NEW.Nombre_Cargo = CapitalizarPalabras(NEW.Nombre_Cargo);
    SET NEW.Descripcion_Cargo = CapitalizarPalabras(NEW.Descripcion_Cargo);
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_empleado`
--

CREATE TABLE `tbl_empleado` (
  `Id_Empleado` int(11) NOT NULL,
  `documento_Empleado` varchar(50) NOT NULL,
  `Nombre_Empleado` varchar(255) DEFAULT NULL,
  `Apellido_Empleado` varchar(255) DEFAULT NULL,
  `Num_Telefono` varchar(20) DEFAULT NULL,
  `Correo_Electronico` varchar(255) DEFAULT NULL,
  `Id_Cargo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_empleado`
--

INSERT INTO `tbl_empleado` (`Id_Empleado`, `documento_Empleado`, `Nombre_Empleado`, `Apellido_Empleado`, `Num_Telefono`, `Correo_Electronico`, `Id_Cargo`) VALUES
(1, '1000019052', 'Djimenezl', NULL, NULL, NULL, NULL),
(2, '1000020098', 'Mejoramiento', NULL, NULL, NULL, NULL),
(3, '1000121146', 'Angy Tatiana Cifuentes Contreras', NULL, NULL, NULL, NULL),
(4, '1000122758', 'Sebastian Camilo Sanchez Diaz', NULL, NULL, NULL, NULL),
(5, '1000284778', 'Jrodriguezt', NULL, NULL, NULL, NULL),
(6, '1000284778', 'Juan Carlos Rodriguez Torres', NULL, NULL, NULL, NULL),
(7, '1000319698', 'Sardila', NULL, NULL, NULL, NULL),
(8, '1000338112', 'Stefanny Michell Rodriguez Rodriguez', NULL, NULL, NULL, NULL),
(9, '1000382630', 'Estefany Hernandez', NULL, NULL, NULL, NULL),
(10, '1000382630', 'Stefanny Hernandez Romero', NULL, NULL, NULL, NULL),
(11, '1000472105', 'Paula Andrea Cortes Castillo', NULL, NULL, NULL, NULL),
(12, '1000809590', 'Senacartera', NULL, NULL, NULL, NULL),
(13, '1000810653', 'Gisella Gonzalez Vargas', NULL, NULL, NULL, NULL),
(14, '1000990126', 'Laura Joya', NULL, NULL, NULL, NULL),
(15, '1001284592', 'Mcaballero', NULL, NULL, NULL, NULL),
(16, '1001285705', 'Dilver Andrey Diaz Mahecha', NULL, NULL, NULL, NULL),
(17, '1001298519', 'Lizeth Alejandra Velasquez Lizarazo', NULL, NULL, NULL, NULL),
(18, '1001947637', 'Adulfo Keenier Acosta Jimenez', NULL, NULL, NULL, NULL),
(19, '100241183', 'Lucia Bohorquez', NULL, NULL, NULL, NULL),
(20, '1002623435', 'Karen Natalia Sierra Gualdron', NULL, NULL, NULL, NULL),
(21, '1002623435', 'Ksierra', NULL, NULL, NULL, NULL),
(22, '1003521565', 'Egonzalezr', NULL, NULL, NULL, NULL),
(23, '1003640451', 'Jorley Vanessa Gamboa Mancipe', NULL, NULL, NULL, NULL),
(24, '1003699017', 'Practicanteid', NULL, NULL, NULL, NULL),
(25, '1003777424', 'Jaime Enrique Tobar Aguilar', NULL, NULL, NULL, NULL),
(26, '1003777424', 'Jtobar', NULL, NULL, NULL, NULL),
(27, '1003935012', 'Nelson Enrique Palacios Becerra', NULL, NULL, NULL, NULL),
(28, '1004507024', 'Giovanni Andres Prada Luna', NULL, NULL, NULL, NULL),
(29, '100465079', 'Prodriguez', NULL, NULL, NULL, NULL),
(30, '1005339037', 'Maria Manuela Llain Gomez', NULL, NULL, NULL, NULL),
(31, '1005825187', 'Gprada', NULL, NULL, NULL, NULL),
(32, '1007295226', 'Lparra', NULL, NULL, NULL, NULL),
(33, '1007354572', 'Mgalvisv', NULL, NULL, NULL, NULL),
(34, '1007354572', 'Michael Felipe Galvis Vento', NULL, NULL, NULL, NULL),
(35, '1007409625', 'Cadenas', NULL, NULL, NULL, NULL),
(36, '1010019368', 'Yulian Stiven Ninco Lara', NULL, NULL, NULL, NULL),
(37, '1010098446', 'Santolinez', NULL, NULL, NULL, NULL),
(38, '1010960434', 'Dilan Michel Jaime Montiel', NULL, NULL, NULL, NULL),
(39, '1011094749', 'Chpinfgcomecial', NULL, NULL, NULL, NULL),
(40, '1012321901', 'Catherin Yesenia Rojas Gonzalez', NULL, NULL, NULL, NULL),
(41, '1012325003', 'Lrojass', NULL, NULL, NULL, NULL),
(42, '1012339906', 'Ysanchez', NULL, NULL, NULL, NULL),
(43, '1012349428', 'Diego Alexander Hurtado Delgado', NULL, NULL, NULL, NULL),
(44, '1012400168', 'Karen Rincon', NULL, NULL, NULL, NULL),
(45, '1012411008', 'Anggie Julieth Alba Garzón', NULL, NULL, NULL, NULL),
(46, '1012430556', 'Juan Camilo Bernal Luque', NULL, NULL, NULL, NULL),
(47, '1012436508', 'Dalia Selinia Leon Romero', NULL, NULL, NULL, NULL),
(48, '1012441117', 'Jbocanegra', NULL, NULL, NULL, NULL),
(49, '1012441117', 'Juan Carlos Bocanegra Parra', NULL, NULL, NULL, NULL),
(50, '1012446172', 'Dayana Marin', NULL, NULL, NULL, NULL),
(51, '1012447121', 'Dayana Puentes Jutinico', NULL, NULL, NULL, NULL),
(52, '1013105982', 'Kjimenez', NULL, NULL, NULL, NULL),
(53, '1013592777', 'Lady Viviana Saray Diaz', NULL, NULL, NULL, NULL),
(54, '1013616043', 'Jenifer Natalia Acevedo Sanchez', NULL, NULL, NULL, NULL),
(55, '1013642799', 'Laura Bibiana Morales Chacon', NULL, NULL, NULL, NULL),
(56, '1013645608', 'Fabian Leandro Ortiz Guerrero - Cesar Melo', NULL, NULL, NULL, NULL),
(57, '1013647143', 'Llcoca', NULL, NULL, NULL, NULL),
(58, '1013647143', 'Lorena Elvira Coca Rodriguez', NULL, NULL, NULL, NULL),
(59, '1013648812', 'Ingrit Dalirla Llanos Ramirez', NULL, NULL, NULL, NULL),
(60, '1013672639', 'Kevin Diaz', NULL, NULL, NULL, NULL),
(61, '1013672639', 'Kevin Joel Diaz Gonzalez', NULL, NULL, NULL, NULL),
(62, '1013691247', 'Dpachon', NULL, NULL, NULL, NULL),
(63, '1014220172', 'Laura Isabel Bohorquez Polania', NULL, NULL, NULL, NULL),
(64, '1014223714', 'Miguel Antonio Clavijo Heredia', NULL, NULL, NULL, NULL),
(65, '1014228155', 'Ycorrea', NULL, NULL, NULL, NULL),
(66, '1014228155', 'Yessica Correa Acuña', NULL, NULL, NULL, NULL),
(67, '1014284595', 'Mateo Lamprea Peña', NULL, NULL, NULL, NULL),
(68, '1015393281', 'Carol Viviana Castiblanco Parra', NULL, NULL, NULL, NULL),
(69, '1015393723', 'Yarevalo', NULL, NULL, NULL, NULL),
(70, '1015430057', 'Jdimate', NULL, NULL, NULL, NULL),
(71, '1015437863', 'Jcbernal', NULL, NULL, NULL, NULL),
(72, '1015455033', 'Nalarcon', NULL, NULL, NULL, NULL),
(73, '1015481668', 'Juan Pablo Pacheco', NULL, NULL, NULL, NULL),
(74, '1016021795', 'Julieth Johanna Avila Ramirez', NULL, NULL, NULL, NULL),
(75, '1016031662', 'Apena', NULL, NULL, NULL, NULL),
(76, '1016061086', 'Ashly Marcela Martinez Daza', NULL, NULL, NULL, NULL),
(77, '1016064481', 'Geraldin Ramirez', NULL, NULL, NULL, NULL),
(78, '1016079915', 'Porteriavcitandes Dersa', NULL, NULL, NULL, NULL),
(79, '1016084030', 'Lisbet Martinez', NULL, NULL, NULL, NULL),
(80, '101610222', 'Bhernandez', NULL, NULL, NULL, NULL),
(81, '1016102595', 'Jony Alexander Castiblanco Peña', NULL, NULL, NULL, NULL),
(82, '1018438558', 'Daniel Felipe Alvarez Reyes', NULL, NULL, NULL, NULL),
(83, '1018453043', 'Nicolas Pacheco Triana', NULL, NULL, NULL, NULL),
(84, '1018459147', 'Daniel Felipe Rodriguez Sanchez', NULL, NULL, NULL, NULL),
(85, '1018468470', 'Bridgie Alexandra Sanchez Garcia', NULL, NULL, NULL, NULL),
(86, '1018468470', 'Bsanchezg', NULL, NULL, NULL, NULL),
(87, '1018509344', 'Karen Dayana Quilaguy Salamanca', NULL, NULL, NULL, NULL),
(88, '10188448081', 'Natalia Andrea Lizarazo Virguez', NULL, NULL, NULL, NULL),
(89, '1019011347', 'Juan Manuel Rodriguez Panesso', NULL, NULL, NULL, NULL),
(90, '1019054492', 'Kelly Johana Ramirez Ossa', NULL, NULL, NULL, NULL),
(91, '1019762711', 'Sara Daniela Calvo Torres', NULL, NULL, NULL, NULL),
(92, '1019762711', 'Scalvo', NULL, NULL, NULL, NULL),
(93, '10199303', 'Luis Fernando Nieto Montoya', NULL, NULL, NULL, NULL),
(94, '1020740200', 'Malvarez', NULL, NULL, NULL, NULL),
(95, '1020759379', 'Yessika Alejandra Becerra Garcia', NULL, NULL, NULL, NULL),
(96, '1020759379', 'Yessika Alejandra Becerra Garcia (retirar)', NULL, NULL, NULL, NULL),
(97, '1020774999', 'Maria Del Pilar Ramirez Florian', NULL, NULL, NULL, NULL),
(98, '1020774999', 'Mramirez', NULL, NULL, NULL, NULL),
(99, '1020781229', 'Luisa Fernanda Camargo', NULL, NULL, NULL, NULL),
(100, '1020825859', 'Carmen Rosa Perez Hernandez', NULL, NULL, NULL, NULL),
(101, '1020838743', 'Diego Fernando Cardona Otalvaro', NULL, NULL, NULL, NULL),
(102, '1021667889', 'Estefani Vergara', NULL, NULL, NULL, NULL),
(103, '102232531', 'Amendoza', NULL, NULL, NULL, NULL),
(104, '1022349994', 'Adrisna Milena Prieto', NULL, NULL, NULL, NULL),
(105, '1022372331', 'Stefania Gutierrez Camacho', NULL, NULL, NULL, NULL),
(106, '1022398789', 'Aaromero', NULL, NULL, NULL, NULL),
(107, '1022398789', 'Valentina Pachon Torres', NULL, NULL, NULL, NULL),
(108, '1022405643', 'Andres Felipe Hernandez Almanza', NULL, NULL, NULL, NULL),
(109, '1022414693', 'Macebedo', NULL, NULL, NULL, NULL),
(110, '1022415604', 'Ginna Marcela Puerto Rodriguez', NULL, NULL, NULL, NULL),
(111, '1022415604', 'Mpuerto', NULL, NULL, NULL, NULL),
(112, '1022428753', 'Ncruz', NULL, NULL, NULL, NULL),
(113, '1022442219', 'Asisitenteventasinter', NULL, NULL, NULL, NULL),
(114, '1022444458', 'Carlos Alberto Gonzalez Largo', NULL, NULL, NULL, NULL),
(115, '1022934060', 'Omar Yobany Cano Ibañez', NULL, NULL, NULL, NULL),
(116, '1022967595', 'Jgalvish', NULL, NULL, NULL, NULL),
(117, '1022967595', 'Yeison Leonardo Galvis Hernandez', NULL, NULL, NULL, NULL),
(118, '1022985326', 'Michel Lilian Rivera Betancur', NULL, NULL, NULL, NULL),
(119, '1022990549', 'Iparra', NULL, NULL, NULL, NULL),
(120, '1022990549', 'Israel Antonio Parra Jimenez', NULL, NULL, NULL, NULL),
(121, '1023033587', 'Jmancipe', NULL, NULL, NULL, NULL),
(122, '1023882944', 'Dcamargod', NULL, NULL, NULL, NULL),
(123, '1023882944', 'Diana Marcela Camargo Diaz', NULL, NULL, NULL, NULL),
(124, '1023884572', 'Lida Constanza Galindo Lopez', NULL, NULL, NULL, NULL),
(125, '1023902262', 'Angelica Taotiva', NULL, NULL, NULL, NULL),
(126, '1023911134', 'Angie Lorena Lopez', NULL, NULL, NULL, NULL),
(127, '1023963574', 'Jhordy Rene Zamora Corredor', NULL, NULL, NULL, NULL),
(128, '1023963574', 'Jzamora', NULL, NULL, NULL, NULL),
(129, '1023969629', 'Cristian David Rueda Ariza', NULL, NULL, NULL, NULL),
(130, '1023977586', 'Opopayan', NULL, NULL, NULL, NULL),
(131, '1024467893', 'Yuri Carolina Lopez Carranza', NULL, NULL, NULL, NULL),
(132, '1024470787', 'Nubia Tovar', NULL, NULL, NULL, NULL),
(133, '1024494048', 'Smautistab', NULL, NULL, NULL, NULL),
(134, '1024509721', 'Mcarry', NULL, NULL, NULL, NULL),
(135, '1024557124', 'Greyes', NULL, NULL, NULL, NULL),
(136, '1024565405', 'Maria Jose Camargo Fonseca', NULL, NULL, NULL, NULL),
(137, '1024567936', 'Estiven Montaño', NULL, NULL, NULL, NULL),
(138, '1024579949', 'Ajhenandez', NULL, NULL, NULL, NULL),
(139, '1024589190', 'Brando Alberto Morales Rincón', NULL, NULL, NULL, NULL),
(140, '1024589190', 'Brincon', NULL, NULL, NULL, NULL),
(141, '1024589849', 'Jolman Harley Gamboa Salamanca', NULL, NULL, NULL, NULL),
(142, '1024589849', 'Jolman Harley Gamboa Salamanca', NULL, NULL, NULL, NULL),
(143, '1026294941', 'Jfcamargo', NULL, NULL, NULL, NULL),
(144, '1026584409', 'Lizeth Viviana Arevalo Zambrano', NULL, NULL, NULL, NULL),
(145, '1030528232', 'Harol Triviño', NULL, NULL, NULL, NULL),
(146, '1030528232', 'Harold Eduardo Triviño Roa', NULL, NULL, NULL, NULL),
(147, '1030546063', 'Marcela Hernandez', NULL, NULL, NULL, NULL),
(148, '1030619840', 'Laura Alejandra Vargas Ramirez', NULL, NULL, NULL, NULL),
(149, '1030619930', 'Viviana Nieto', NULL, NULL, NULL, NULL),
(150, '1030626923', 'Fabian Sanchez', NULL, NULL, NULL, NULL),
(151, '1030646885', 'Jennifer Paredes', NULL, NULL, NULL, NULL),
(152, '1030648548', 'Andres Felipe Peñaloza Rivera', NULL, NULL, NULL, NULL),
(153, '1030648548', 'Andres Peñaloza', NULL, NULL, NULL, NULL),
(154, '1030651149', 'Ccifuentes', NULL, NULL, NULL, NULL),
(155, '1030653359', 'Alejandro Melo', NULL, NULL, NULL, NULL),
(156, '1031040451', 'Vganboa', NULL, NULL, NULL, NULL),
(157, '1031128980', 'Lady Julliette Ardila Vargas', NULL, NULL, NULL, NULL),
(158, '1031134368', 'Flopez', NULL, NULL, NULL, NULL),
(159, '1031150300', 'Yon Fredi Gomez Prada', NULL, NULL, NULL, NULL),
(160, '1031165446', 'Diana Carolina Marin Silva', NULL, NULL, NULL, NULL),
(161, '1031172335', 'Jose Alejandro Avila Molina', NULL, NULL, NULL, NULL),
(162, '1031421494', 'Kbejarano', NULL, NULL, NULL, NULL),
(163, '1031642448', 'Pmaldonado', NULL, NULL, NULL, NULL),
(164, '1032393591', 'Diego Felipe Santana Niño', NULL, NULL, NULL, NULL),
(165, '1032434644', 'Jtriana', NULL, NULL, NULL, NULL),
(166, '1032441063', 'Proceso De Contratación - Angelica Malagon Medina', NULL, NULL, NULL, NULL),
(167, '1032448601', 'Proceso De Contratación - Valery Johana Yusti Cabeza', NULL, NULL, NULL, NULL),
(168, '1032463802', 'Agomezc', NULL, NULL, NULL, NULL),
(169, '1032472438', 'Deysy Lorena Quijano Barrera', NULL, NULL, NULL, NULL),
(170, '1032472438', 'Dquijano', NULL, NULL, NULL, NULL),
(171, '1032486794', 'Allison Alejandra Mojica Santa', NULL, NULL, NULL, NULL),
(172, '1032488444', 'Bperdomo', NULL, NULL, NULL, NULL),
(173, '1032501656', 'Helen Dayanna Bernal Paez', NULL, NULL, NULL, NULL),
(174, '103250656', 'Hbernal', NULL, NULL, NULL, NULL),
(175, '1032677405', 'Ssistemas', NULL, NULL, NULL, NULL),
(176, '1033726711', 'Yeni Milena Leguizamon Penagos', NULL, NULL, NULL, NULL),
(177, '1033726711', 'Ylgizamon', NULL, NULL, NULL, NULL),
(178, '1033737941', 'Ginna Andrea Mendez Lopez', NULL, NULL, NULL, NULL),
(179, '1033762406', 'Camilo Andres Silva', NULL, NULL, NULL, NULL),
(180, '1033763253', 'Tania Yulied Vargas Ruiz', NULL, NULL, NULL, NULL),
(181, '10337663253', 'Tvargas', NULL, NULL, NULL, NULL),
(182, '1033774944', 'Johanna Alejandra Bejarano Beltran', NULL, NULL, NULL, NULL),
(183, '1033815152', 'Jverjel', NULL, NULL, NULL, NULL),
(184, '1034279581', 'Ana Maria Bayona Alzate', NULL, NULL, NULL, NULL),
(185, '103558383', 'Frojasb', NULL, NULL, NULL, NULL),
(186, '1036607394', 'Juan Sebastian Velez Agudelo', NULL, NULL, NULL, NULL),
(187, '1044907311', 'Rsimancas', NULL, NULL, NULL, NULL),
(188, '1045721947', 'Kenny Buitrago', NULL, NULL, NULL, NULL),
(189, '1047389145', 'Frank Avila', NULL, NULL, NULL, NULL),
(190, '1048205865', 'Porteriacdndersa', NULL, NULL, NULL, NULL),
(191, '1049023166', 'Ssistemas', NULL, NULL, NULL, NULL),
(192, '1049610055', 'Dania Lorena Ortiz Velasco', NULL, NULL, NULL, NULL),
(193, '1049610055', 'Lortiz', NULL, NULL, NULL, NULL),
(194, '1050693012', 'Laura Isabel Borda Espinosa', NULL, NULL, NULL, NULL),
(195, '1051336596', 'Diana Yizzeth Lopez Piñeros', NULL, NULL, NULL, NULL),
(196, '1053803948', 'Jeyson Leonardo Vallejo Muñoz', NULL, NULL, NULL, NULL),
(197, '1054678159', 'Becerra', NULL, NULL, NULL, NULL),
(198, '1054994018', 'Luisa Fernanda Patiño Cardona', NULL, NULL, NULL, NULL),
(199, '1056956913', 'Laura Porras', NULL, NULL, NULL, NULL),
(200, '1057589982', 'Grodriguez', NULL, NULL, NULL, NULL),
(201, '1061527', 'Gerardo Sierra Montañez', NULL, NULL, NULL, NULL),
(202, '1069731310', 'Juan Manuel Salazar Buitrago', NULL, NULL, NULL, NULL),
(203, '1070330512', 'Dmuñoz', NULL, NULL, NULL, NULL),
(204, '1070330512', 'Yuber Sebastian Muñoz Espitia', NULL, NULL, NULL, NULL),
(205, '1070922782', 'Luis Fernando Vargas Jara', NULL, NULL, NULL, NULL),
(206, '1070954699', 'Yeison Armando Gracia Pinto', NULL, NULL, NULL, NULL),
(207, '1070957399', 'Jorge Leonardo Lugo Triana', NULL, NULL, NULL, NULL),
(208, '1070958760', 'Paola Andrea Lopez Mora', NULL, NULL, NULL, NULL),
(209, '1070969186', 'Mbalaguera', NULL, NULL, NULL, NULL),
(210, '1070976940', 'Maria Angelica Porras Rubio', NULL, NULL, NULL, NULL),
(211, '1072189096', 'Jgarzon', NULL, NULL, NULL, NULL),
(212, '1072421711', 'Yordana Borda', NULL, NULL, NULL, NULL),
(213, '1072431328', 'Rsuaza', NULL, NULL, NULL, NULL),
(214, '1072494937', 'Cbeltran', NULL, NULL, NULL, NULL),
(215, '1072494937', 'Cristian Camilo Beltran Avilan', NULL, NULL, NULL, NULL),
(216, '1072716966', 'Jenny Paola Guerrero Estepa', NULL, NULL, NULL, NULL),
(217, '1072716976', 'Jpguerrero', NULL, NULL, NULL, NULL),
(218, '1073509437', 'Edwin Agustin Cubillos Espinosa', NULL, NULL, NULL, NULL),
(219, '1073528594', 'Brayan Cañon', NULL, NULL, NULL, NULL),
(220, '1073689574', 'William Alexander Martinez Cuta', NULL, NULL, NULL, NULL),
(221, '1073689574', 'Wmartinez', NULL, NULL, NULL, NULL),
(222, '1073720729', 'Maria Jose Gutierrez Benavides', NULL, NULL, NULL, NULL),
(223, '1074158009', 'Jose Carlos Linares Villalba', NULL, NULL, NULL, NULL),
(224, '1075659597', 'Milena Parra', NULL, NULL, NULL, NULL),
(225, '1085275392', 'Jaime Felipe Carreño Villarreal', NULL, NULL, NULL, NULL),
(226, '1085943794', 'Proceso De Contratación - Encustodia De Juan Pablo Acosta', NULL, NULL, NULL, NULL),
(227, '1088275736', 'Cristian Camilo Gonzalez Gonzalez', NULL, NULL, NULL, NULL),
(228, '1088283170', 'Ana Maria Piedrahita Giraldo', NULL, NULL, NULL, NULL),
(229, '1090475643', 'Jalvares', NULL, NULL, NULL, NULL),
(230, '1090475643', 'Jean Carlos Alvarez Rojas', NULL, NULL, NULL, NULL),
(231, '1091675563', 'Averjel', NULL, NULL, NULL, NULL),
(232, '1091675564', 'Andrea Paola Verjel Sepulveda', NULL, NULL, NULL, NULL),
(233, '1096200400', 'Javier Enrique Cisneros Martinez', NULL, NULL, NULL, NULL),
(234, '1098622755', 'Nruiz', NULL, NULL, NULL, NULL),
(235, '1098669279', 'Sonia Rocio Arciniegas Toloza', NULL, NULL, NULL, NULL),
(236, '1098795440', 'Cesar Yesid Caballero Mantilla', NULL, NULL, NULL, NULL),
(237, '1099209234', 'Willian Pardo Santamaria', NULL, NULL, NULL, NULL),
(238, '1101596746', 'Yudy Bermudez', NULL, NULL, NULL, NULL),
(239, '1102885618', 'Cangulo', NULL, NULL, NULL, NULL),
(240, '1104069391', 'Elizabeth Ramirez Melo', NULL, NULL, NULL, NULL),
(241, '1105334840', 'Katerin Lozano', NULL, NULL, NULL, NULL),
(242, '1110448437', 'Diana Tique', NULL, NULL, NULL, NULL),
(243, '1110552197', 'Lina Paola Ramirez Cruz', NULL, NULL, NULL, NULL),
(244, '11108935010', 'Yaranda', NULL, NULL, NULL, NULL),
(245, '1111200708', 'Ana Maria Duran Torres', NULL, NULL, NULL, NULL),
(246, '1120353460', 'Jpoloche', NULL, NULL, NULL, NULL),
(247, '1120356460', 'Jehison Alberto Poloche Alvarez', NULL, NULL, NULL, NULL),
(248, '11225599', 'Andres Felipe Forero Gamez', NULL, NULL, NULL, NULL),
(249, '11276395', 'Mauricio Morales Usma', NULL, NULL, NULL, NULL),
(250, '1136886956', 'Jhoan Sebastian Rivera Monroy', NULL, NULL, NULL, NULL),
(251, '11430434', 'Edgar Gonzalez Avellaneda', NULL, NULL, NULL, NULL),
(252, '11430434', 'Egonzalezr', NULL, NULL, NULL, NULL),
(253, '11431933', 'Hernando Heli Sang Ramirez', NULL, NULL, NULL, NULL),
(254, '11436598', 'German Bravo Rubiano', NULL, NULL, NULL, NULL),
(255, '11441402', 'Euclides Eslava Alvarez', NULL, NULL, NULL, NULL),
(256, '11590302', 'Edwin Alixon Velazquez Martinez', NULL, NULL, NULL, NULL),
(257, '1192762157', 'Jeimy Nataly Peña Penagos', NULL, NULL, NULL, NULL),
(258, '1192762157', 'Jpenape', NULL, NULL, NULL, NULL),
(259, '1193468145', 'Shirley Camila Pirajan Galvis', NULL, NULL, NULL, NULL),
(260, '1233503698', 'Ingry Alejandra Escamilla Camacho', NULL, NULL, NULL, NULL),
(261, '1233503698', 'Yescamilla', NULL, NULL, NULL, NULL),
(262, '1233898906', 'Dmijia', NULL, NULL, NULL, NULL),
(263, '1233898906', 'Jeily Dayanna Mejia Salamanca', NULL, NULL, NULL, NULL),
(264, '124565405', 'Mcamargof', NULL, NULL, NULL, NULL),
(265, '1254', 'Alquilado Devolver', NULL, NULL, NULL, NULL),
(266, '12608395', 'Luis Eduardo Palacios Torres', NULL, NULL, NULL, NULL),
(267, '133774944', 'Jbejarano', NULL, NULL, NULL, NULL),
(268, '13511437', 'Miguel Fernando Gomez Suarez', NULL, NULL, NULL, NULL),
(269, '13747195', 'Oscar Alirio Tarazona Pedraza', NULL, NULL, NULL, NULL),
(270, '14296577', 'Pablo Andres Mayorga Rodriguez', NULL, NULL, NULL, NULL),
(271, '16680887', 'Carlos Alberto Campiño Rubio', NULL, NULL, NULL, NULL),
(272, '16758352', 'Carlos Humberto Prado Martinez', NULL, NULL, NULL, NULL),
(273, '16791313', 'Jorge Luis Rios Murillo', NULL, NULL, NULL, NULL),
(274, '16859480', 'Ogonzalez', NULL, NULL, NULL, NULL),
(275, '16864680', 'William Humberto Gongora Hurtado', NULL, NULL, NULL, NULL),
(276, '179033604', 'Jalmonacita', NULL, NULL, NULL, NULL),
(277, '17958668', 'Emerson Arregoces Duarte', NULL, NULL, NULL, NULL),
(278, '17958668', 'Emerson Paul Arregoces Duarte', NULL, NULL, NULL, NULL),
(279, '18003768', 'Walford Augusto Hooker Corpus', NULL, NULL, NULL, NULL),
(280, '19179342', 'Ricardo Mauricio Foschi Salazar', NULL, NULL, NULL, NULL),
(281, '19264048', 'Jrojas', NULL, NULL, NULL, NULL),
(282, '19338611', 'Ricardopredraza', NULL, NULL, NULL, NULL),
(283, '19349570', 'Jorge Rubiano', NULL, NULL, NULL, NULL),
(284, '19420316', 'Juan Carlos Moreno Ortiz', NULL, NULL, NULL, NULL),
(285, '19421746', 'Luis Alberto Melo Espitia', NULL, NULL, NULL, NULL),
(286, '19445466', 'Gilberto Garcia', NULL, NULL, NULL, NULL),
(287, '19479077', 'Jaime Tacha Vargas', NULL, NULL, NULL, NULL),
(288, '19600501', 'Luis Maria Redondo Herrera', NULL, NULL, NULL, NULL),
(289, '19710042', 'Manuel Jose Narvaez Peñaloza', NULL, NULL, NULL, NULL),
(290, '199209234', 'Wpardo', NULL, NULL, NULL, NULL),
(291, '20159', 'Jose Avendaño', NULL, NULL, NULL, NULL),
(292, '20168', 'Juan C Escorcia', NULL, NULL, NULL, NULL),
(293, '20302', 'Hector Menco', NULL, NULL, NULL, NULL),
(294, '20343', 'Pertuz', NULL, NULL, NULL, NULL),
(295, '21071', 'Pasante Administrativo Baq', NULL, NULL, NULL, NULL),
(296, '21073', 'Edgardo Urueta', NULL, NULL, NULL, NULL),
(297, '21095', 'Pasante Calidad', NULL, NULL, NULL, NULL),
(298, '21097', 'Marcos Figueroa', NULL, NULL, NULL, NULL),
(299, '21100', 'Cuarto Control', NULL, NULL, NULL, NULL),
(300, '21105', 'Cuarto Control', NULL, NULL, NULL, NULL),
(301, '21116', 'Pasante Sig', NULL, NULL, NULL, NULL),
(302, '21123', 'Carlos Toro', NULL, NULL, NULL, NULL),
(303, '21126', 'Sst Barranquilla', NULL, NULL, NULL, NULL),
(304, '21126', 'Walter Rojas', NULL, NULL, NULL, NULL),
(305, '21128', 'Auxsst', NULL, NULL, NULL, NULL),
(306, '21137', 'Gth Baq', NULL, NULL, NULL, NULL),
(307, '21140', 'Cuarto Control', NULL, NULL, NULL, NULL),
(308, '21141', 'Aprendiz Sena', NULL, NULL, NULL, NULL),
(309, '21143', 'Carlos Barcelo', NULL, NULL, NULL, NULL),
(310, '21147', 'Antonio Rebolledo', NULL, NULL, NULL, NULL),
(311, '21150', 'Operacionesbaq(aprendiz)', NULL, NULL, NULL, NULL),
(312, '21152', 'Manuel Jimenez', NULL, NULL, NULL, NULL),
(313, '21155', 'Jaime Martinez', NULL, NULL, NULL, NULL),
(314, '22207', 'Tatiana Gonzalez', NULL, NULL, NULL, NULL),
(315, '22221', 'Jamartinez', NULL, NULL, NULL, NULL),
(316, '22222', 'Jamartinez', NULL, NULL, NULL, NULL),
(317, '22292.0', 'Dc1pdmde01', NULL, NULL, NULL, NULL),
(318, '22308.0', 'Jessica Castillo', NULL, NULL, NULL, NULL),
(319, '23248', 'Aprendiz Sena Gth', NULL, NULL, NULL, NULL),
(320, '23480', 'Porteria Cdn Gradezco - Segmento Aseo', NULL, NULL, NULL, NULL),
(321, '23490', 'Capacitacion Mantenimiento 3', NULL, NULL, NULL, NULL),
(322, '23580.0', 'Liliana Marcela Diaz/vacante', NULL, NULL, NULL, NULL),
(323, '23635', 'Analista De Laboratorios Liquidos', NULL, NULL, NULL, NULL),
(324, '23645', 'Planta Jaboneria', NULL, NULL, NULL, NULL),
(325, '23657', 'Material Emaques', NULL, NULL, NULL, NULL),
(326, '23661', 'Mejoramiento Gradezco - Segmento Aseo', NULL, NULL, NULL, NULL),
(327, '23662', 'Preparadores Liquidos 2', NULL, NULL, NULL, NULL),
(328, '23736.0', 'Sena', NULL, NULL, NULL, NULL),
(329, '23737', 'Jorge Rodriguez - Jefes De Turno', NULL, NULL, NULL, NULL),
(330, '23755', 'Almacen Dersa - 6', NULL, NULL, NULL, NULL),
(331, '23785', 'Sergio Arley Gracia Tequia', NULL, NULL, NULL, NULL),
(332, '23787', 'Practicante I&d 2', NULL, NULL, NULL, NULL),
(333, '23790', 'Daniel Rodriguez', NULL, NULL, NULL, NULL),
(334, '23805', 'Capacitación Gth', NULL, NULL, NULL, NULL),
(335, '23888.0', 'German Devia', NULL, NULL, NULL, NULL),
(336, '24002', 'Backup', NULL, NULL, NULL, NULL),
(337, '24003', 'Anderson Aguacias - Nova', NULL, NULL, NULL, NULL),
(338, '24006', 'Equipo A Retirar Cdn Grasco', NULL, NULL, NULL, NULL),
(339, '24008', 'Disponible Tic - 9', NULL, NULL, NULL, NULL),
(340, '24018', 'Jose Stiven Montaño Lotero', NULL, NULL, NULL, NULL),
(341, '24019', 'Oscar Leonardo Ahumada Florez - Nova', NULL, NULL, NULL, NULL),
(342, '24022', 'Omar Yobany Cano Ibañez - Jose Daniel Pana / Nova', NULL, NULL, NULL, NULL),
(343, '24023', 'Maria Paula Rodriguez', NULL, NULL, NULL, NULL),
(344, '24027', 'Julissa Santamaria', NULL, NULL, NULL, NULL),
(345, '24042', 'Gth Baq', NULL, NULL, NULL, NULL),
(346, '24050', 'Jose Avendaño', NULL, NULL, NULL, NULL),
(347, '24093', 'Jimena Perez', NULL, NULL, NULL, NULL),
(348, '24098', 'Programador Cdn', NULL, NULL, NULL, NULL),
(349, '24100', 'Hurto-(alejandro Espinosa Leon)', NULL, NULL, NULL, NULL),
(350, '24101', 'Suply Chain', NULL, NULL, NULL, NULL),
(351, '24102', 'Porteria Faca', NULL, NULL, NULL, NULL),
(352, '24105', 'Jairo Enrique Ortiz - Almacen Raza', NULL, NULL, NULL, NULL),
(353, '24110', 'Diego Vargas', NULL, NULL, NULL, NULL),
(354, '24123', 'Laboratorio Gradezco - Segmento Nutricion Animal', NULL, NULL, NULL, NULL),
(355, '24124', 'Inventario Materias Primas', NULL, NULL, NULL, NULL),
(356, '24125', 'Jefe Turno Gradezco - Segmento Nutricion Animal', NULL, NULL, NULL, NULL),
(357, '24127', 'Auxiliar Logistica', NULL, NULL, NULL, NULL),
(358, '24128', 'Recepción Raza 1', NULL, NULL, NULL, NULL),
(359, '24136.0', 'Marta Janeth Luna Mejia', NULL, NULL, NULL, NULL),
(360, '24138.0', 'Jainer Miranda', NULL, NULL, NULL, NULL),
(361, '24141.0', 'Lina Paola Ramirez Cruz', NULL, NULL, NULL, NULL),
(362, '24142.0', 'D-lrnieto', NULL, NULL, NULL, NULL),
(363, '24144.0', 'Dora Patricia Vasquez', NULL, NULL, NULL, NULL),
(364, '24145.0', 'Yiliant Amalia Hernandez Carrillo', NULL, NULL, NULL, NULL),
(365, '24149.0', 'Naileth Parra', NULL, NULL, NULL, NULL),
(366, '24152', 'Backup', NULL, NULL, NULL, NULL),
(367, '24158.0', 'Ana Victoria Gomez Rodrigez', NULL, NULL, NULL, NULL),
(368, '24160.0', 'Sharon Alejandra Solano Medina', NULL, NULL, NULL, NULL),
(369, '24161.0', 'Bladimir Quimbayo', NULL, NULL, NULL, NULL),
(370, '24162.0', 'D-mmanares', NULL, NULL, NULL, NULL),
(371, '24166', 'Portería Funcionarios Gradezco - Segmento Aseo', NULL, NULL, NULL, NULL),
(372, '24171.0', 'Jessika De Lahoz', NULL, NULL, NULL, NULL),
(373, '24178', 'Practicante Investigacion Y Desarrollo', NULL, NULL, NULL, NULL),
(374, '24179.0', 'Nicol Escorcia', NULL, NULL, NULL, NULL),
(375, '24182.0', 'Maria Del Pilar Gil', NULL, NULL, NULL, NULL),
(376, '24185.0', 'Maria Ines Hernandez Villamil', NULL, NULL, NULL, NULL),
(377, '24186', 'Mejoramiento Gradezco - Segmento Aseo', NULL, NULL, NULL, NULL),
(378, '24190', 'Analista Materia Prima', NULL, NULL, NULL, NULL),
(379, '24191', 'Planta Detergentes', NULL, NULL, NULL, NULL),
(380, '24194', 'Ambiental', NULL, NULL, NULL, NULL),
(381, '24195.0', 'Luisa Fernanda Patiño', NULL, NULL, NULL, NULL),
(382, '24202.0', 'Breiner Borja (vacante)', NULL, NULL, NULL, NULL),
(383, '24203.0', 'Leonel Polanco', NULL, NULL, NULL, NULL),
(384, '24204.0', 'Raul Ibaague', NULL, NULL, NULL, NULL),
(385, '24206', 'Disponible Tic', NULL, NULL, NULL, NULL),
(386, '24212', 'Sena Crm', NULL, NULL, NULL, NULL),
(387, '24221', 'Juan Carlos Bocanegra Parra', NULL, NULL, NULL, NULL),
(388, '24224.0', 'Nelly Tores Alonso', NULL, NULL, NULL, NULL),
(389, '24228', 'Analista Crema Lavaloza', NULL, NULL, NULL, NULL),
(390, '24231.0', 'Jasson Delprado', NULL, NULL, NULL, NULL),
(391, '24235.0', 'D-ogarcia', NULL, NULL, NULL, NULL),
(392, '24237', 'Andres Felipe Beltran', NULL, NULL, NULL, NULL),
(393, '24242', 'Backup', NULL, NULL, NULL, NULL),
(394, '24243.0', 'Dc1pdmde01', NULL, NULL, NULL, NULL),
(395, '24245', 'Luis Octavio Cruz Rocha', NULL, NULL, NULL, NULL),
(396, '24246', 'Diego Alexander Hurtado Delgado', NULL, NULL, NULL, NULL),
(397, '24254', 'Backup', NULL, NULL, NULL, NULL),
(398, '24255.0', 'Mary Luz Largo Lopez', NULL, NULL, NULL, NULL),
(399, '24257', 'Patricia Cuintaco Tobon - Asistente Almacen', NULL, NULL, NULL, NULL),
(400, '24259', 'Backup', NULL, NULL, NULL, NULL),
(401, '24260.0', 'D-ncardenas', NULL, NULL, NULL, NULL),
(402, '24262.0', 'Sergio Guantiva', NULL, NULL, NULL, NULL),
(403, '24266.0', 'Sandra Milena Cacua Rodriguez', NULL, NULL, NULL, NULL),
(404, '24272', 'Brigith Alejandra Perdomo Roman', NULL, NULL, NULL, NULL),
(405, '24273.0', 'William Alonso Castro', NULL, NULL, NULL, NULL),
(406, '24276.0', 'Robinson Perez', NULL, NULL, NULL, NULL),
(407, '24281.0', 'Laura Villanova', NULL, NULL, NULL, NULL),
(408, '24295', 'Intermedias Plantas', NULL, NULL, NULL, NULL),
(409, '24839632', 'Luz Amparo Restrepo', NULL, NULL, NULL, NULL),
(410, '25041', 'Puesto 2 Piso Bahia', NULL, NULL, NULL, NULL),
(411, '26458', 'Lorena Calderon - Practicante Sena', NULL, NULL, NULL, NULL),
(412, '26572', 'Almacen Dersa - 5', NULL, NULL, NULL, NULL),
(413, '26578', 'Sin Asignar', NULL, NULL, NULL, NULL),
(414, '26711', 'Pasante Mercadeo', NULL, NULL, NULL, NULL),
(415, '27241', 'Mi Portal', NULL, NULL, NULL, NULL),
(416, '27271.0', 'Sandra Salazar', NULL, NULL, NULL, NULL),
(417, '27272', 'Reemplazo De Maria Jose Gutierrez Benavides', NULL, NULL, NULL, NULL),
(418, '27306.0', 'D-asaldarriaga', NULL, NULL, NULL, NULL),
(419, '27359', 'Sebastián Torres Varela (sap)', NULL, NULL, NULL, NULL),
(420, '27378', 'Margarita Zuleta', NULL, NULL, NULL, NULL),
(421, '27382', 'Gloria Amparo Escobar', NULL, NULL, NULL, NULL),
(422, '27390', 'Jaime Martinez', NULL, NULL, NULL, NULL),
(423, '27419', 'Martha Mejia', NULL, NULL, NULL, NULL),
(424, '27435', 'Carmen Silva', NULL, NULL, NULL, NULL),
(425, '27468', 'Daniela Pisciotti', NULL, NULL, NULL, NULL),
(426, '27470', 'Luis David Valderrama', NULL, NULL, NULL, NULL),
(427, '27471', 'Steven Viloria', NULL, NULL, NULL, NULL),
(428, '27472', 'Jordan Caballero', NULL, NULL, NULL, NULL),
(429, '27507', 'Sena Cartera', NULL, NULL, NULL, NULL),
(430, '2781 / 27305', 'Almacen Grasco', NULL, NULL, NULL, NULL),
(431, '28541640', 'Lina Marcela Cuellar Perez', NULL, NULL, NULL, NULL),
(432, '2984497', 'Felix Gabriel Alarcon Pachon', NULL, NULL, NULL, NULL),
(433, '30354867', 'Heliana Maria Valencia Hernandez', NULL, NULL, NULL, NULL),
(434, '3056747', 'Jpenad', NULL, NULL, NULL, NULL),
(435, '3056747', 'Prometalicos', NULL, NULL, NULL, NULL),
(436, '3158452', 'Mario Augusto Bernal Parra', NULL, NULL, NULL, NULL),
(437, '31968282', 'Mariateresaperez', NULL, NULL, NULL, NULL),
(438, '32209846', 'Astrid Catalina Gil Hoyos', NULL, NULL, NULL, NULL),
(439, '3229328', 'Ivan Paez Duran', NULL, NULL, NULL, NULL),
(440, '32896208', 'Gina Paola Fawcett Lebolo', NULL, NULL, NULL, NULL),
(441, '35508870', 'Adriana Del Socorro Orozco Avendaño', NULL, NULL, NULL, NULL),
(442, '35522320', 'Abocanegra', NULL, NULL, NULL, NULL),
(443, '35522320', 'Ana Cecilia Bocanegra Rico', NULL, NULL, NULL, NULL),
(444, '37510466', 'Lissette Saray Guiza Sierra', NULL, NULL, NULL, NULL),
(445, '37944121', 'Ana Rita Martinez Correa', NULL, NULL, NULL, NULL),
(446, '38364325', 'Darlyn Dayana Jaramillo', NULL, NULL, NULL, NULL),
(447, '39538208', 'Juan Sebastian Velez Agudelo', NULL, NULL, NULL, NULL),
(448, '39542363', 'Sandra Angelica Andrade Avila', NULL, NULL, NULL, NULL),
(449, '39646784', 'Luz Angelica Valenzuela Ceballos', NULL, NULL, NULL, NULL),
(450, '39650349', 'Emilse Marin Velasco', NULL, NULL, NULL, NULL),
(451, '39651325', 'Correspondencia', NULL, NULL, NULL, NULL),
(452, '39657804', 'Martha Janneth Torres Malagon', NULL, NULL, NULL, NULL),
(453, '39657804', 'Mtorres', NULL, NULL, NULL, NULL),
(454, '39763020', 'Contactenos', NULL, NULL, NULL, NULL),
(455, '40032854', 'Maria Ines Hernandez Villamil', NULL, NULL, NULL, NULL),
(456, '40421952', 'Darliz Zapata Agudelo', NULL, NULL, NULL, NULL),
(457, '42145248', 'Monica Andrea Muñoz Corrales', NULL, NULL, NULL, NULL),
(458, '43565220', 'Monica Lucia Sierra Ramirez', NULL, NULL, NULL, NULL),
(459, '43612301', 'Iparra', NULL, NULL, NULL, NULL),
(460, '43613301', 'Isabel Cristina Parra Restrepo', NULL, NULL, NULL, NULL),
(461, '45762070', 'Carolina Benedetti Navarro', NULL, NULL, NULL, NULL),
(462, '46364009', 'Patricia Cuintaco Tobon', NULL, NULL, NULL, NULL),
(463, '46387398', 'Liliana Esperanza Rodriguez Rincon', NULL, NULL, NULL, NULL),
(464, '51680814', 'Disponible Tic', NULL, NULL, NULL, NULL),
(465, '51707445', 'Doris Del Socorro Barrera Pardo', NULL, NULL, NULL, NULL),
(466, '51789473', 'Jasmine Ibarra Viracacha', NULL, NULL, NULL, NULL),
(467, '51830542', 'Macosta', NULL, NULL, NULL, NULL),
(468, '51830542', 'Martha Jeanet Acosta Vega', NULL, NULL, NULL, NULL),
(469, '51875975', 'Maria Cristina Chacon', NULL, NULL, NULL, NULL),
(470, '51906273', 'Nancy Vanegas', NULL, NULL, NULL, NULL),
(471, '51965563', 'Elsa Julia Mazo Artiaga', NULL, NULL, NULL, NULL),
(472, '51972831', 'Sandra Patricia Arciniegas Buitrago', NULL, NULL, NULL, NULL),
(473, '51972831', 'Sarciniegasb', NULL, NULL, NULL, NULL),
(474, '52011311', 'Elsy Mogollon', NULL, NULL, NULL, NULL),
(475, '52051712', 'Adriana Manrique', NULL, NULL, NULL, NULL),
(476, '52054072', 'Maria Alexandra Romero Molina', NULL, NULL, NULL, NULL),
(477, '52062096', 'Lgarzon', NULL, NULL, NULL, NULL),
(478, '52062096', 'Luz Mary Garzon Patiño', NULL, NULL, NULL, NULL),
(479, '52097589', 'Nora Patricia Martinez Alvarez', NULL, NULL, NULL, NULL),
(480, '52102178', 'Alexandra Torres', NULL, NULL, NULL, NULL),
(481, '52102178', 'Janneth Alexandra Torres Mora', NULL, NULL, NULL, NULL),
(482, '52184051', 'Flor Stella Quintero Quintero', NULL, NULL, NULL, NULL),
(483, '52206224', 'Erica Maryuri Vargas Gomez', NULL, NULL, NULL, NULL),
(484, '52224915', 'Martha Patricia Bermudez Peña', NULL, NULL, NULL, NULL),
(485, '52273906', 'Marta Perilla', NULL, NULL, NULL, NULL),
(486, '52273906', 'Martha Yaneth Perilla Plata', NULL, NULL, NULL, NULL),
(487, '52297103', 'Dcruz', NULL, NULL, NULL, NULL),
(488, '52317324', 'Ldlalodeotus', NULL, NULL, NULL, NULL),
(489, '52317324', 'Luz Dary Cruz Gutierrez', NULL, NULL, NULL, NULL),
(490, '52365123', 'Sandra Marithza Fajardo Baquero', NULL, NULL, NULL, NULL),
(491, '52384025', 'Indira Johanna Arevalo', NULL, NULL, NULL, NULL),
(492, '52393071', 'Diana Milena Garzon', NULL, NULL, NULL, NULL),
(493, '52412713', 'Maria Victoria Cediel Escobar', NULL, NULL, NULL, NULL),
(494, '52412713', 'Mcediel', NULL, NULL, NULL, NULL),
(495, '52423103', 'Luz Mary Patarroyo Gutierrez', NULL, NULL, NULL, NULL),
(496, '52444126', 'Maria Del Carmel Villamil Cortes', NULL, NULL, NULL, NULL),
(497, '52547356', 'Sonia Mireya Contreras', NULL, NULL, NULL, NULL),
(498, '52586327', 'Dcastillo', NULL, NULL, NULL, NULL),
(499, '52661339', 'Marcela Del Pilar Martinez Romero', NULL, NULL, NULL, NULL),
(500, '52698114', 'Linda Magaly Montoya Ruiz', NULL, NULL, NULL, NULL),
(501, '52711360', 'Maria Claudia Silva', NULL, NULL, NULL, NULL),
(502, '52731486', 'Diana Paola Pastrana Cruz', NULL, NULL, NULL, NULL),
(503, '52747908', 'Salfonso', NULL, NULL, NULL, NULL),
(504, '52760767', 'Carolina Cepeda', NULL, NULL, NULL, NULL),
(505, '52760767', 'Leidy Carolina Cepeda Henao', NULL, NULL, NULL, NULL),
(506, '52798350', 'Gina Marcela Beltran', NULL, NULL, NULL, NULL),
(507, '52809090', 'Paola Flores Ortiz', NULL, NULL, NULL, NULL),
(508, '52818531', 'Diana Carolina Lopez Sanchez', NULL, NULL, NULL, NULL),
(509, '52818993', 'Adriana Sanchez', NULL, NULL, NULL, NULL),
(510, '52832175', 'Bibiana Maria Leiva Fajardo', NULL, NULL, NULL, NULL),
(511, '52832175', 'Bleiba', NULL, NULL, NULL, NULL),
(512, '52836681', 'Laura Camila Poveda Rosas', NULL, NULL, NULL, NULL),
(513, '52836681', 'Lpoveda', NULL, NULL, NULL, NULL),
(514, '52852057', 'Eruiz', NULL, NULL, NULL, NULL),
(515, '52857065', 'Nsachica', NULL, NULL, NULL, NULL),
(516, '52889024', 'Diana Romero', NULL, NULL, NULL, NULL),
(517, '52899348', 'Johana Tellez', NULL, NULL, NULL, NULL),
(518, '52918915', 'Elizabeth Triviño Acuña', NULL, NULL, NULL, NULL),
(519, '52932551', 'Lquintero', NULL, NULL, NULL, NULL),
(520, '52962893', 'Ruth Mery Cortes Zapata', NULL, NULL, NULL, NULL),
(521, '52963390', 'Mgonzales', NULL, NULL, NULL, NULL),
(522, '52963390', 'Milena Gonzalez Oyola', NULL, NULL, NULL, NULL),
(523, '52981766', 'Lady Maryuri Barragan Rodriguez', NULL, NULL, NULL, NULL),
(524, '53010318', 'Ayda Mayerli Quintero Contreras', NULL, NULL, NULL, NULL),
(525, '53030477', 'Ana Maria Dennis Santamaria Maldonado', NULL, NULL, NULL, NULL),
(526, '53031967', 'Marixa Leon', NULL, NULL, NULL, NULL),
(527, '53032877', 'Edna Rocio Bermudez Morales', NULL, NULL, NULL, NULL),
(528, '53047663', 'Astrid Moreno', NULL, NULL, NULL, NULL),
(529, '53065039', 'Aguerra', NULL, NULL, NULL, NULL),
(530, '53065039', 'Andrea Bibiana Guerra Pesca', NULL, NULL, NULL, NULL),
(531, '53070048', 'Diana Paola Barbosa Navas', NULL, NULL, NULL, NULL),
(532, '53129152', 'Amuete', NULL, NULL, NULL, NULL),
(533, '53176891', 'Maryluz Salamanca Mojica', NULL, NULL, NULL, NULL),
(534, '547231', 'Alejandro Espinosa Leon', NULL, NULL, NULL, NULL),
(535, '5771056', 'Noel Ricardo Ariza Perez', NULL, NULL, NULL, NULL),
(536, '60377502', 'Flavia Patricia Ruiz Florez', NULL, NULL, NULL, NULL),
(537, '6107534', 'Mauricio Loaiza', NULL, NULL, NULL, NULL),
(538, '63560517', 'Laura Juliana Supelano Prada', NULL, NULL, NULL, NULL),
(539, '63560567', 'Lsupelano', NULL, NULL, NULL, NULL),
(540, '65718166', 'Ana Eloisa Calderon Quiñones', NULL, NULL, NULL, NULL),
(541, '65742265', 'Evalbuena', NULL, NULL, NULL, NULL),
(542, '65742265', 'Maria Elizabeth Valbuena Pinzon', NULL, NULL, NULL, NULL),
(543, '65756719', 'Marta Isabel Ferreira Duarte', NULL, NULL, NULL, NULL),
(544, '65763799', 'Maria Del Pilar Gil Castillo', NULL, NULL, NULL, NULL),
(545, '66759383', 'Claudia Ximena Mateus Rizo', NULL, NULL, NULL, NULL),
(546, '66951775', 'Jisley Paz Molano', NULL, NULL, NULL, NULL),
(547, '674739', 'Jose Miguel Ortiz Pereira', NULL, NULL, NULL, NULL),
(548, '7185355', 'Juan Carlos Ojeda Ramirez', NULL, NULL, NULL, NULL),
(549, '72050614', 'Oscar Orlando Ortega Ordoñez', NULL, NULL, NULL, NULL),
(550, '72142465', 'Aquiles Rafael Bilbao Granados', NULL, NULL, NULL, NULL),
(551, '72234445', 'Alberto Enrique Perez Numa', NULL, NULL, NULL, NULL),
(552, '7225280', 'Jairo Emilio Cruz Corregidor', NULL, NULL, NULL, NULL),
(553, '72275089', 'Gregori Michel Castro Uribe', NULL, NULL, NULL, NULL),
(554, '72303818', 'Gustavo Rafael Hadechini Gomez', NULL, NULL, NULL, NULL),
(555, '7321168', 'Almilcar Pinilla Pinilla', NULL, NULL, NULL, NULL),
(556, '7333879', 'Rodrigo Molina Fula', NULL, NULL, NULL, NULL),
(557, '74150316', 'Emerson Orjuela', NULL, NULL, NULL, NULL),
(558, '74357287', 'William Ricardo Jimenez Munevar', NULL, NULL, NULL, NULL),
(559, '74364348', 'Portertias Funcionales', NULL, NULL, NULL, NULL),
(560, '7698012', 'Raul Eduardo Ortiz Lugo', NULL, NULL, NULL, NULL),
(561, '77097103', 'Cristian Fuentes', NULL, NULL, NULL, NULL),
(562, '79055396', 'Jesus Augusto Rodriguez Mesa', NULL, NULL, NULL, NULL),
(563, '79137120', 'Jmahecha', NULL, NULL, NULL, NULL),
(564, '79137643', 'Carlos Gabriel Martinez Benitez', NULL, NULL, NULL, NULL),
(565, '79138504', 'Cesar Augusto Sierra Gil', NULL, NULL, NULL, NULL),
(566, '79151407', 'Olaf De Greiff Muñoz', NULL, NULL, NULL, NULL),
(567, '79156599', 'Andres Monsalve Cadavid', NULL, NULL, NULL, NULL),
(568, '79215597', 'Ronal Bello', NULL, NULL, NULL, NULL),
(569, '79244604', 'Mauricio Avendaño', NULL, NULL, NULL, NULL),
(570, '79285404', 'Jorge Alberto Montoya Villa', NULL, NULL, NULL, NULL),
(571, '79300915', 'Jorge Alberto Davila Rozo', NULL, NULL, NULL, NULL),
(572, '79321050', 'William Armando Corredor Correal', NULL, NULL, NULL, NULL),
(573, '79352326', 'Luis Hernando Garcia Pulga', NULL, NULL, NULL, NULL),
(574, '79386980', 'Carlos Hernando Espejo', NULL, NULL, NULL, NULL),
(575, '79404732', 'Fernando Montenegro Arevalo', NULL, NULL, NULL, NULL),
(576, '79416752', 'Rtraslaviña', NULL, NULL, NULL, NULL),
(577, '79424427', 'Fcastro', NULL, NULL, NULL, NULL),
(578, '79424427', 'Rafael Castro Sasa', NULL, NULL, NULL, NULL),
(579, '794255', 'Cmelo', NULL, NULL, NULL, NULL),
(580, '79435585', 'Ricardo Arturo Granados Puentes', NULL, NULL, NULL, NULL),
(581, '79485370', 'Julio Quijano', NULL, NULL, NULL, NULL),
(582, '79541002', 'Camilo Andres Rodriguez Obregon', NULL, NULL, NULL, NULL),
(583, '79543974', 'Carlos Arturo Silva Buitrago', NULL, NULL, NULL, NULL),
(584, '79566879', 'Carlosabril', NULL, NULL, NULL, NULL),
(585, '79569636', 'Nelson Julian Hernandez Henao', NULL, NULL, NULL, NULL),
(586, '79593582', 'Raul Nunpaque', NULL, NULL, NULL, NULL),
(587, '79602961', 'Wilson Rodriguez', NULL, NULL, NULL, NULL),
(588, '79645829', 'Alirio Agustin Escobar Ruiz', NULL, NULL, NULL, NULL),
(589, '79645929', 'Aescobar', NULL, NULL, NULL, NULL),
(590, '79726024', 'Edis Mauricio Ospina Giraldo', NULL, NULL, NULL, NULL),
(591, '79729133', 'John Raul Forero Malagon', NULL, NULL, NULL, NULL),
(592, '79742737', 'Jorge Alberto Cuellar Garavito', NULL, NULL, NULL, NULL),
(593, '79761699', 'Malbarador', NULL, NULL, NULL, NULL),
(594, '79790400', 'Jbunevar', NULL, NULL, NULL, NULL),
(595, '79796397', 'Arturo Riaño Patiño', NULL, NULL, NULL, NULL),
(596, '79797001', 'William Sanchez', NULL, NULL, NULL, NULL),
(597, '79808101', 'Giovanny Mejia', NULL, NULL, NULL, NULL),
(598, '79811156', 'Jaime Antonio Cruz Rojas', NULL, NULL, NULL, NULL),
(599, '79811156', 'Jcruz', NULL, NULL, NULL, NULL),
(600, '79842043', 'Fabio Eduardo Agudelo Segura', NULL, NULL, NULL, NULL),
(601, '79849654', 'Jhon Henry Lotta Rojas', NULL, NULL, NULL, NULL),
(602, '79877856', 'Saul Hernando Pareja Ossa', NULL, NULL, NULL, NULL),
(603, '79882364', 'Encustodia Tic Remplazo Vendedor', NULL, NULL, NULL, NULL),
(604, '79893101', 'Jhon Heredia', NULL, NULL, NULL, NULL),
(605, '79942760', 'Cvelez', NULL, NULL, NULL, NULL),
(606, '79946801', 'Acardoso', NULL, NULL, NULL, NULL),
(607, '79977468', 'Edwin Gamboa', NULL, NULL, NULL, NULL),
(608, '80005000', 'Ruben Dario Garcia Reyes', NULL, NULL, NULL, NULL),
(609, '80055439', 'Jose William Cardozo Orjuela', NULL, NULL, NULL, NULL),
(610, '80056318', 'Fabio Alexander Casallas Jimenez', NULL, NULL, NULL, NULL),
(611, '80061308', 'Oscar Cucaita', NULL, NULL, NULL, NULL),
(612, '80084374', 'Harry Daniel Bautista Susa', NULL, NULL, NULL, NULL),
(613, '80095633', 'Fernando Ortiz Ariza', NULL, NULL, NULL, NULL),
(614, '80095633', 'Fortiz', NULL, NULL, NULL, NULL),
(615, '80122348', 'Oscar Julian Garavito Hortua', NULL, NULL, NULL, NULL),
(616, '80137078', 'Jalvarado', NULL, NULL, NULL, NULL),
(617, '80146225', 'Sergio Alejandro Guantiva Espinosa', NULL, NULL, NULL, NULL),
(618, '80160476', 'Proceso De Contratación - Trade Marketing', NULL, NULL, NULL, NULL),
(619, '80190918', 'Omacias', NULL, NULL, NULL, NULL),
(620, '80198367', 'Raul Andres Leaño Barreto', NULL, NULL, NULL, NULL),
(621, '80198779', 'Juan Esteban Cabal Dominguez', NULL, NULL, NULL, NULL),
(622, '80232684', 'Jorge Pinto', NULL, NULL, NULL, NULL),
(623, '80234887', 'Jorge Enrique Rodriguez Medina', NULL, NULL, NULL, NULL),
(624, '80270733', 'German Alberto Piamonte Diaz', NULL, NULL, NULL, NULL),
(625, '803011970', 'Ldiazd', NULL, NULL, NULL, NULL),
(626, '80311970', 'Luis Hernan Diaz Diaz', NULL, NULL, NULL, NULL),
(627, '80369163', 'Porteria Funcionales', NULL, NULL, NULL, NULL),
(628, '80383558', 'Juan Carlos Leon Herrera', NULL, NULL, NULL, NULL),
(629, '80403931', 'Ycardoso', NULL, NULL, NULL, NULL),
(630, '80403931', 'Yonh Fredy Cardozo Mancilla', NULL, NULL, NULL, NULL),
(631, '80413923', 'Luis Fernando Bustamante Varon', NULL, NULL, NULL, NULL),
(632, '80414482', 'Adolfo Martinez Martinez', NULL, NULL, NULL, NULL),
(633, '80729211', 'Diego Armando Tovar Guaqueta', NULL, NULL, NULL, NULL),
(634, '80743706', 'Wcubides', NULL, NULL, NULL, NULL),
(635, '80743706', 'Wilson Farley Cubides Marquez', NULL, NULL, NULL, NULL),
(636, '80770573', 'Dañado Equipo', NULL, NULL, NULL, NULL),
(637, '80773759', 'Daniel Augusto Merchan Rojas', NULL, NULL, NULL, NULL),
(638, '80773759', 'Dmerchan', NULL, NULL, NULL, NULL),
(639, '80795812', 'Lcolorado', NULL, NULL, NULL, NULL),
(640, '80829610', 'Leonardo Beltran Gonzalez', NULL, NULL, NULL, NULL),
(641, '80849686', 'Jaime Alberto Barreto Espitia', NULL, NULL, NULL, NULL),
(642, '80859370', 'Luis Fernando Botiva', NULL, NULL, NULL, NULL),
(643, '8128435', 'Carlos Alberto Castañeda Garces', NULL, NULL, NULL, NULL),
(644, '81715624', 'Milton Franco', NULL, NULL, NULL, NULL),
(645, '82392190', 'Proceso De Contratación - Eduardo Rodolfo Cubillos', NULL, NULL, NULL, NULL),
(646, '8505873', 'Juan Fernando Serna Jimenez', NULL, NULL, NULL, NULL),
(647, '86057961', 'Gilberto Palacios Herrera', NULL, NULL, NULL, NULL),
(648, '91282117', 'Framirez', NULL, NULL, NULL, NULL),
(649, '91473816', 'Juan Carlos Leguizamon Mila', NULL, NULL, NULL, NULL),
(650, '91493464', 'William Rodriguez Peñaloza', NULL, NULL, NULL, NULL),
(651, '91535767', 'Edwin Alixon Velazquez Martinez', NULL, NULL, NULL, NULL),
(652, '91535767', 'Julian Leonardo Rocha Jaime', NULL, NULL, NULL, NULL),
(653, '93290892', 'Luis Carlos Villa Torres', NULL, NULL, NULL, NULL),
(654, '93290892', 'Lvilla', NULL, NULL, NULL, NULL),
(655, '93398727', 'German Antonio Devia Herrera', NULL, NULL, NULL, NULL),
(656, '93405171', 'Jose Luciano Garcia Cespedes', NULL, NULL, NULL, NULL),
(657, '94474853', 'Diego Mauricio Morales Lopera', NULL, NULL, NULL, NULL),
(658, '94510350', 'Mauricio Londoño Robledo', NULL, NULL, NULL, NULL),
(659, '94523703', 'Carlos Julio Jimenez Prager', NULL, NULL, NULL, NULL),
(660, 'GCO-A-0901/26405', 'Bascula', NULL, NULL, NULL, NULL),
(661, 'GCO-A-2456', 'Luis Olarte', NULL, NULL, NULL, NULL),
(662, 'GCO-A-2457', 'Tania Acosta', NULL, NULL, NULL, NULL),
(663, 'GCO-A-2459', 'Erika Martinez', NULL, NULL, NULL, NULL),
(664, 'GCO-A-2461', 'Juliana Rolon', NULL, NULL, NULL, NULL),
(665, 'GCO-A-2466', 'Katiuska Bayona', NULL, NULL, NULL, NULL),
(666, 'GCO-A-2467', 'Juan Serna', NULL, NULL, NULL, NULL),
(667, 'GCO-A-2469', 'Angelly Vargas', NULL, NULL, NULL, NULL),
(668, 'GCO-A-2470', 'Jesus Jaraba', NULL, NULL, NULL, NULL),
(669, 'GCO-A-2511', 'Alfonso Perez', NULL, NULL, NULL, NULL),
(670, 'GCO-A-2512', 'Wilmer Castro', NULL, NULL, NULL, NULL),
(671, 'GCO-A-2513', 'Fredy Stand', NULL, NULL, NULL, NULL),
(672, 'GCO-A-2514', 'Victor Madarriaga', NULL, NULL, NULL, NULL),
(673, 'GCO-A-2515', 'Virgilio Castaño', NULL, NULL, NULL, NULL),
(674, 'GCO-A-2517', 'Luis Martinez', NULL, NULL, NULL, NULL),
(675, 'GCO-A-2518', 'Maria Alejandra Valera', NULL, NULL, NULL, NULL),
(676, 'GCO-A-2519', 'Jose Avendaño', NULL, NULL, NULL, NULL),
(677, 'GCO-A-2520', 'Jose Avendaño', NULL, NULL, NULL, NULL),
(678, 'GCO-A-2521', 'Gerencia', NULL, NULL, NULL, NULL),
(679, 'GCO-A-2522', 'Nicolas De La Rosa', NULL, NULL, NULL, NULL),
(680, 'GCO-A-2524', 'Secretaria', NULL, NULL, NULL, NULL),
(681, 'GCO-A-2525', 'Arleth Perez', NULL, NULL, NULL, NULL),
(682, 'GCO-A-2527', 'Brinder Mato', NULL, NULL, NULL, NULL),
(683, 'GCO-A-2528', 'Daniel Rodriguez', NULL, NULL, NULL, NULL),
(684, 'GCO-A-2530', 'Bodega Mezzanine', NULL, NULL, NULL, NULL),
(685, 'GCO-A-2531', 'Eugenia Polo', NULL, NULL, NULL, NULL),
(686, 'GCO-A-2532', 'Antonio Rebolledo', NULL, NULL, NULL, NULL),
(687, 'GCO-A-2533', 'Juan C Escorcia', NULL, NULL, NULL, NULL),
(688, 'GCO-A-2534', 'Wilson Yanez', NULL, NULL, NULL, NULL),
(689, 'GCO-A-2536', 'Basculabqa', NULL, NULL, NULL, NULL),
(690, 'GCO-A-2538', 'Alvert Vega', NULL, NULL, NULL, NULL),
(691, 'GCO-A-2539', 'Olga Guerra', NULL, NULL, NULL, NULL),
(692, 'GCO-A-2540', 'Jose Perez', NULL, NULL, NULL, NULL),
(693, 'GCO-A-2542', 'Edgar Vasquez', NULL, NULL, NULL, NULL),
(694, 'GCO-A-2544', 'Roger Serrano', NULL, NULL, NULL, NULL),
(695, 'GCO-A-2591', 'Asesor Sst', NULL, NULL, NULL, NULL),
(696, 'GCO-A-2643', 'Analistas Bodega 7', NULL, NULL, NULL, NULL),
(697, 'GCO-A-2651', 'Usuarios Departamento Electrico', NULL, NULL, NULL, NULL),
(698, 'GCO-A-2759', 'Jose Avendaño', NULL, NULL, NULL, NULL),
(699, 'GCO-A-2766', 'Jose Avendaño', NULL, NULL, NULL, NULL),
(700, 'GCO-A-35', 'Cuarto Control', NULL, NULL, NULL, NULL),
(701, 'GDZ-000033', 'Angela Johana Perez', NULL, NULL, NULL, NULL),
(702, 'GDZ-000034', 'Avieser Ivan Quintero', NULL, NULL, NULL, NULL),
(703, 'GDZ-000036', 'Cristian Camilo Gonzalez', NULL, NULL, NULL, NULL),
(704, 'GDZ-00019', 'Juan David Martinez Staper', NULL, NULL, NULL, NULL),
(705, 'NO TIENE', 'Aprendiz Sena Relaciones Laborales', NULL, NULL, NULL, NULL),
(706, 'NO TIENE', 'Euclides Eslava Alvarez - 1', NULL, NULL, NULL, NULL),
(707, 'NO TIENE', 'Soporte Agora', NULL, NULL, NULL, NULL),
(708, 'No aplica', 'Control', NULL, NULL, NULL, NULL),
(709, 'No aplica', 'Dersa', NULL, NULL, NULL, NULL),
(710, 'No aplica', 'Grasco', NULL, NULL, NULL, NULL),
(711, 'No aplica', 'Laboratorio De Calidad', NULL, NULL, NULL, NULL),
(712, 'No aplica', 'Logistica', NULL, NULL, NULL, NULL),
(713, 'No aplica', 'Material De Empaques', NULL, NULL, NULL, NULL),
(714, 'No aplica', 'No Aplica', NULL, NULL, NULL, NULL),
(715, 'No aplica', 'Porteria', NULL, NULL, NULL, NULL),
(716, 'No aplica', 'Practicante', NULL, NULL, NULL, NULL),
(717, 'No aplica', 'Sin Asignar', NULL, NULL, NULL, NULL),
(718, 'No tiene', 'Almacen Raza Faca', NULL, NULL, NULL, NULL),
(719, 'No tiene', 'Aprendiz Sst Gradezco - Segmento Nutricion Animal', NULL, NULL, NULL, NULL),
(720, 'No tiene', 'Argenis Ballesteros', NULL, NULL, NULL, NULL),
(721, 'No tiene', 'Auxiliar Ingenieria', NULL, NULL, NULL, NULL),
(722, 'No tiene', 'Bascula Oro Rojo', NULL, NULL, NULL, NULL),
(723, 'No tiene', 'Capacitación 1', NULL, NULL, NULL, NULL),
(724, 'No tiene', 'Cesar Augusto Melo Retavizca - 1', NULL, NULL, NULL, NULL),
(725, 'No tiene', 'Cesar Augusto Sanchez Perez', NULL, NULL, NULL, NULL),
(726, 'No tiene', 'Cristian David Rodriguez Mejia', NULL, NULL, NULL, NULL),
(727, 'No tiene', 'Diego Mauricio Morales Lopera', NULL, NULL, NULL, NULL),
(728, 'No tiene', 'Diliana María Riquett Mercado', NULL, NULL, NULL, NULL),
(729, 'No tiene', 'Edd Josimar Pimienta', NULL, NULL, NULL, NULL),
(730, 'No tiene', 'Gustavo Castellanos Alfonso', NULL, NULL, NULL, NULL),
(731, 'No tiene', 'Ivan Paez Duran - Casa', NULL, NULL, NULL, NULL),
(732, 'No tiene', 'Javier Bonilla', NULL, NULL, NULL, NULL),
(733, 'No tiene', 'Jhon Fredy Sanchez Rincon', NULL, NULL, NULL, NULL),
(734, 'No tiene', 'Jhon Jairo Bambague Chaves', NULL, NULL, NULL, NULL),
(735, 'No tiene', 'Jhoy Javier Rojas', NULL, NULL, NULL, NULL),
(736, 'No tiene', 'John Alexander Martinez Gonzalez', NULL, NULL, NULL, NULL),
(737, 'No tiene', 'Jorge Eduardo Castillo Cardona', NULL, NULL, NULL, NULL),
(738, 'No tiene', 'Jorge Rodriguez - Jefes De Turno', NULL, NULL, NULL, NULL),
(739, 'No tiene', 'Juan Carlos Moreno Ortiz - Capacitacion Mantenimeinto 2', NULL, NULL, NULL, NULL),
(740, 'No tiene', 'Juan Carlos Moreno Ortiz- Capacitacion Mantenimiento 1', NULL, NULL, NULL, NULL),
(741, 'No tiene', 'Juan Sebastian Aristizabal Gonzalez', NULL, NULL, NULL, NULL),
(742, 'No tiene', 'Leon Eduardo Moskovitz Trujillo', NULL, NULL, NULL, NULL),
(743, 'No tiene', 'Luisa Fernanda Alvarez', NULL, NULL, NULL, NULL),
(744, 'No tiene', 'Mabel Bautista Rojas', NULL, NULL, NULL, NULL),
(745, 'No tiene', 'Mesa De Servicio', NULL, NULL, NULL, NULL),
(746, 'No tiene', 'Mi Portal Raza', NULL, NULL, NULL, NULL),
(747, 'No tiene', 'Nathali Moreno Palomo', NULL, NULL, NULL, NULL),
(748, 'No tiene', 'Nelson Julian Hernandez Henao / Bascula', NULL, NULL, NULL, NULL),
(749, 'No tiene', 'Omar Roberto Mipaz Ortega', NULL, NULL, NULL, NULL),
(750, 'No tiene', 'Pasante Administrativo', NULL, NULL, NULL, NULL),
(751, 'No tiene', 'Pasante Oro Rojo', NULL, NULL, NULL, NULL),
(752, 'No tiene', 'Porteria Planta', NULL, NULL, NULL, NULL),
(753, 'No tiene', 'Raul Armando Ortegon Gomez', NULL, NULL, NULL, NULL),
(754, 'No tiene', 'Raul Ernesto Rubio Botto', NULL, NULL, NULL, NULL),
(755, 'No tiene', 'Secado Cosmeticos', NULL, NULL, NULL, NULL),
(756, 'No tiene', 'Supervisor Agronomico Induariari', NULL, NULL, NULL, NULL),
(757, 'No tiene', 'Supervisor Automatización 2', NULL, NULL, NULL, NULL),
(758, 'No tiene', 'Yeny Eudine Moya Hernandez', NULL, NULL, NULL, NULL),
(759, 'No tiene', 'Yesica Paola Vargas Surmay', NULL, NULL, NULL, NULL),
(760, 'No tiene', 'Yormary Rodriguez (indupalma)', NULL, NULL, NULL, NULL),
(761, 'No tiene', 'Yulibeth Diaz Guerrero', NULL, NULL, NULL, NULL),
(762, 'No tiene', 'Zona Franca', NULL, NULL, NULL, NULL),
(763, 'No tiene', 'Zurisaday Leon Ronderos', NULL, NULL, NULL, NULL);

--
-- Triggers `tbl_empleado`
--
DELIMITER //
CREATE TRIGGER `trg_empleado_bi` BEFORE INSERT ON `tbl_empleado` FOR EACH ROW BEGIN
    SET NEW.Nombre_Empleado   = CapitalizarPalabras(NEW.Nombre_Empleado);
    SET NEW.Apellido_Empleado = CapitalizarPalabras(NEW.Apellido_Empleado);
    SET NEW.Correo_Electronico = LOWER(NEW.Correo_Electronico);
END
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER `trg_empleado_bu` BEFORE UPDATE ON `tbl_empleado` FOR EACH ROW BEGIN
    SET NEW.Nombre_Empleado   = CapitalizarPalabras(NEW.Nombre_Empleado);
    SET NEW.Apellido_Empleado = CapitalizarPalabras(NEW.Apellido_Empleado);
    SET NEW.Correo_Electronico = LOWER(NEW.Correo_Electronico);
END
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER `trg_empleado_link_usuario` AFTER INSERT ON `tbl_empleado` FOR EACH ROW BEGIN
    -- Enlazar el usuario con el empleado si coincide el documento
    UPDATE tbl_usuario
    SET Id_Empleado = NEW.Id_Empleado
    WHERE documento_Usuario = NEW.documento_Empleado;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_equipos`
--

CREATE TABLE `tbl_equipos` (
  `Id_Equipo` int(11) NOT NULL,
  `Codigo_Inventario` varchar(255) DEFAULT NULL,
  `Marca_Equipo` varchar(255) DEFAULT NULL,
  `Numero_Serie` varchar(255) DEFAULT NULL,
  `Ubicacion_Equipo` varchar(255) DEFAULT NULL,
  `Propietario_Equipo` int(11) DEFAULT NULL,
  `Estado_Equipo` enum('Activo','Inactivo','Mantenimiento','Dado de Baja') DEFAULT NULL,
  `Fecha_Ad_Equipo` date DEFAULT NULL,
  `Id_Archivo` int(11) DEFAULT NULL,
  `Id_Tipo_Equipo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_equipos`
--

INSERT INTO `tbl_equipos` (`Id_Equipo`, `Codigo_Inventario`, `Marca_Equipo`, `Numero_Serie`, `Ubicacion_Equipo`, `Propietario_Equipo`, `Estado_Equipo`, `Fecha_Ad_Equipo`, `Id_Archivo`, `Id_Tipo_Equipo`) VALUES
(1, NULL, 'Dell Latutude 3420', 'ST6JWBFG3', 'Dersa Cartera', 513, 'Activo', NULL, NULL, 1),
(2, NULL, 'Dell Latitude 3420', 'STJ7W8FG3', 'Dersa Tesoreria', 140, 'Activo', NULL, NULL, 1),
(3, NULL, 'Dell Latitude 3420', 'JJFF2B3', 'Dersa', 217, 'Activo', NULL, NULL, 1),
(4, NULL, 'Dell Latitude 5480', '898C0N2', 'Dersa Tesoreria', 29, 'Activo', NULL, NULL, 1),
(5, NULL, 'Dell Latitude 3420', 'F2WBFG3', 'Dersa Gestion Humana', 168, 'Activo', NULL, NULL, 1),
(6, NULL, 'Dell Latitude 3420', '38W8FG3', 'Dersa Gestion Humana', 468, 'Activo', NULL, NULL, 1),
(7, NULL, 'Dell Latitude 3420', '7BWBFG3', 'Dersa Gestion Humana', 143, 'Activo', NULL, NULL, 1),
(8, NULL, 'Dell Latitude 3420', '5KFF2B3', 'Dersa Gestion Humana', 156, 'Activo', NULL, NULL, 1),
(9, NULL, 'Dell Latitude 3410', '8CLD86', 'Dersa Gestion Humana', 134, 'Activo', NULL, NULL, 1),
(10, NULL, 'Dell Latitude 3420', '4ZV8FG3', 'Dersa Gestion Humana', 112, 'Activo', NULL, NULL, 1),
(11, NULL, 'Dell Latitude 3420', '5SFF2B3', 'Dersa Gestion Humana', 532, 'Activo', NULL, NULL, 1),
(12, NULL, 'Dell Latitude 3420', '6SVBFG3', 'Dersa Rhh', 34, 'Activo', NULL, NULL, 1),
(13, NULL, 'Dell Latitude 3420', 'H7W8FG3', 'Dersa Rhh Selección', 244, 'Activo', NULL, NULL, 1),
(14, NULL, 'Dell Latitude E7470', '9JPGXF2', 'Dersa Rhh', 267, 'Activo', NULL, NULL, 1),
(15, NULL, 'Dell Latutude 3420', '8FHH2B3', 'Dersa Rhh', 62, 'Activo', NULL, NULL, 1),
(16, NULL, 'Dell Latitude 3440', '4Q8Q824', 'Dersa Rhh', 193, 'Activo', NULL, NULL, 1),
(17, NULL, 'Dell Latitude 3420', 'F8W8FG3', 'Dersa Rhh', 498, 'Activo', NULL, NULL, 1),
(18, NULL, 'Dell Latitude 3440', '1YYBQ04', 'Dersa Rhh', 21, 'Activo', NULL, NULL, 1),
(19, NULL, 'Dell Latitude 3420', '39WBFG3', 'Dersa Rhh', 209, 'Activo', NULL, NULL, 1),
(20, NULL, 'Dell', 'HFCCVF2', 'Dersa Inducción', NULL, 'Activo', NULL, NULL, 1),
(21, NULL, 'Dell', '40GV5H2', 'Dersa Inducción', NULL, 'Activo', NULL, NULL, 1),
(22, NULL, 'Dell Latitude 7450', 'DCRFD74', 'Dersa Tic', 94, 'Activo', NULL, NULL, 1),
(23, NULL, 'Dell Latitude 3450', 'J00ZS34', 'Dersa Tic', 213, 'Activo', NULL, NULL, 1),
(24, NULL, 'Dell Latitude 3450', '7M0ZS34', 'Dersa Tic', 130, 'Activo', NULL, NULL, 1),
(25, NULL, 'Dell Latitude 2450', 'H00ZS34', 'Dersa Tic', 70, 'Activo', NULL, NULL, 1),
(26, NULL, 'Dell Latitude 3420', '08KUVFY', 'Dersa Tic', 175, 'Activo', NULL, NULL, 1),
(27, NULL, 'Dell Latitude 3420', 'JYV8FG3', 'Dersa Tic', 1, 'Activo', NULL, NULL, 1),
(28, NULL, 'Dell Latitude 3420', 'CZZYS34', 'Dersa Tic', 211, 'Activo', NULL, NULL, 1),
(29, NULL, 'Dell Lalitude 3420', 'CJVBFG3', 'Dersa Tic', 191, 'Activo', NULL, NULL, 1),
(30, NULL, 'Dell Latitude 3420', '2PV8FG3', 'Dersa Tic', 103, 'Activo', NULL, NULL, 1),
(31, NULL, 'Dell Latitude 3410', '7CLD863', 'Dersa Ventas Internacionales', 113, 'Activo', NULL, NULL, 1),
(32, NULL, 'Dell Latitude 7320', 'B00Z2J3', 'Dersa Infraestructura', 121, 'Activo', NULL, NULL, 1),
(33, NULL, 'Dell Latitude 7320', '9Z5Z2J3', 'Dersa Infraestructura', 165, 'Activo', NULL, NULL, 1),
(34, NULL, 'Dell Latitude 3420', '8PV8FG3', 'Dersa Infraestructura', 135, 'Activo', NULL, NULL, 1),
(35, NULL, 'Dell Latitude 3420', 'DPV8G3', 'Dersa Tic', 511, 'Activo', NULL, NULL, 1),
(36, NULL, 'Dell Latitude 3440', 'F0SMX14', 'Dersa Asistencia De Gerencia', 522, 'Activo', NULL, NULL, 1),
(37, NULL, 'Dell Latitude 3420', '8JVBFG3', 'Dersa Tesoreria', 594, 'Activo', NULL, NULL, 1),
(38, NULL, 'Dell Latitude 3420', '1RV8FG3', 'Dersa Comercial', 39, 'Activo', NULL, NULL, 1),
(39, NULL, 'Dell Latitude 3420', '8QV8FG3', 'Dersa Comercial', 605, 'Activo', NULL, NULL, 1),
(40, NULL, 'Dell Latitude 3420', 'B2WBFG3', 'Dersa Comercial', 274, 'Activo', NULL, NULL, 1),
(41, NULL, 'Dell Latitude 3420', 'DQV8FG3', 'Dersa Comercial', 123, 'Activo', NULL, NULL, 1),
(42, NULL, 'Dell Latitude 3420', 'HJFF2B3', 'Dersa Comercial', 454, 'Activo', NULL, NULL, 1),
(43, NULL, 'Dell Latitude 3440', '6MZBQ04', 'Dersa Comercial', 281, 'Activo', NULL, NULL, 1),
(44, NULL, 'Dell Latitude 3450', '1R0ZS34', 'Dersa Comercial', 503, 'Activo', NULL, NULL, 1),
(45, NULL, 'Dell Latitude 3440', 'HYL8LY3', 'Dersa Comercial', 515, 'Activo', NULL, NULL, 1),
(46, NULL, 'Dell Latitude 3420', 'GCFF2B3', 'Dersa Comercial', 639, 'Activo', NULL, NULL, 1),
(47, NULL, 'Dell Latitude 3420', '2RV8FG3', 'Dersa Comercial', 162, 'Activo', NULL, NULL, 1),
(48, NULL, 'Dell', 'G-7J4BMQ2', 'Dersa Comercial', 181, 'Activo', NULL, NULL, 1),
(49, NULL, 'Dell Latitude 3420', 'DJFF2B3', 'Dersa Comercial', 519, 'Activo', NULL, NULL, 1),
(50, NULL, 'Dell Latitude 3420', '97W8FG3', 'Dersa Comercial', 487, 'Activo', NULL, NULL, 1),
(51, NULL, 'Dell Latitude 3420', 'B8W8FG3', 'Dersa Comercial', 576, 'Activo', NULL, NULL, 1),
(52, NULL, 'Dell Latitude 3450', 'HK0ZS34', 'Dersa Comercial', 35, 'Activo', NULL, NULL, 1),
(53, NULL, 'Dell Latitude 3420', 'HRV8FG3', 'Dersa Comercial', 41, 'Activo', NULL, NULL, 1),
(54, NULL, 'Dell Latitude 3440', '4LZBQ04', 'Dersa Comercial', 616, 'Activo', NULL, NULL, 1),
(55, NULL, 'Dell Latitude 3420', 'LDGARCIA', 'Dersa Comercial', 614, 'Activo', NULL, NULL, 1),
(56, NULL, 'Dell Latitude 3420', '65W8FG3', 'Dersa Gestion De Calidad', 635, 'Activo', NULL, NULL, 1),
(57, NULL, 'Dell Latitude 3420', 'D2WBFG3', 'Dersa Gestion De Calidad', 584, 'Activo', NULL, NULL, 1),
(58, NULL, 'Dell Latitude 3420', 'JK41DS3', 'Dersa Aseguramiento De Calidad', 234, 'Activo', NULL, NULL, 1),
(59, NULL, 'Dell Latitude 3420', 'H9WBFG3', 'Dersa Aseguramiento De Calidad', 494, 'Activo', NULL, NULL, 1),
(60, NULL, 'Dell Latitude 3420', '72WBFG3', 'Dersa Innovación', 109, 'Activo', NULL, NULL, 1),
(61, NULL, 'Dell Latitude 3420', 'FSV8FG3', 'Dersa Innovación', 37, 'Activo', NULL, NULL, 1),
(62, NULL, 'Dell Latitude 3410', 'JBLD863', 'Dersa Innovación', 72, 'Activo', NULL, NULL, 1),
(63, NULL, 'Dell Latitude 3420', '78W8FG3', 'Dersa Innovación', 15, 'Activo', NULL, NULL, 1),
(64, NULL, 'Dell Latitude 3420', '6QV8FG3', 'Dersa Innovación', 606, 'Activo', NULL, NULL, 1),
(65, NULL, 'Dell Latitude 3420', '2KFF2B3', 'Dersa Innovación', 42, 'Activo', NULL, NULL, 1),
(66, NULL, 'Dell Latitude 3420', '2BWBFG3', 'Dersa Innovación', 200, 'Activo', NULL, NULL, 1),
(67, NULL, 'Dell Latitude 3420', 'C5W8FG3', 'Dersa Mercadeo', 107, 'Activo', NULL, NULL, 1),
(68, NULL, 'Dell Latitude 3420', '4JFF283', 'Dersa Mercadeo', 231, 'Activo', NULL, NULL, 1),
(69, NULL, 'Dell Latitude 3420', '9JVBFG3', 'Dersa Mercadeo', 437, 'Activo', NULL, NULL, 1),
(70, NULL, 'Dell Latitude 7440', 'DLN4GY3', 'Dersa Mercadeo', 539, 'Activo', NULL, NULL, 1),
(71, NULL, 'Dell Latitude 3420', 'NO SE VE', 'Dersa Mercadeo', 71, 'Activo', NULL, NULL, 1),
(72, NULL, 'Dell Latitude 3420', '4KFF2B3', 'Dersa Papaleria', 80, 'Activo', NULL, NULL, 1),
(73, NULL, 'Dell Latitude 5480', 'DWOZ5H2', 'Dersa Papeleria', 514, 'Activo', NULL, NULL, 1),
(74, NULL, 'Dell Latitude 3410', 'D5LD863', 'Dersa Metrologia', 276, 'Activo', NULL, NULL, 1),
(75, NULL, 'Dell Latitude 3410', 'D5LD863', 'Dersa Metrologia', 187, 'Activo', NULL, NULL, 1),
(76, NULL, 'Dell Latitude 3420', 'FHFF2B3', 'Dersa Infraestructura', 563, 'Activo', NULL, NULL, 1),
(77, NULL, 'Dell Latitude 3420', '82WBFG3', 'Dersa Ingenieria Y Mantenimiento', 282, 'Activo', NULL, NULL, 1),
(78, NULL, 'Dell 3420', 'BSV8FG3', 'Dersa Planeación', 648, 'Activo', NULL, NULL, 1),
(79, NULL, 'Dell', 'EN CASA', 'Dersa Despachos', 263, 'Activo', NULL, NULL, 1),
(80, NULL, 'Dell', 'EN CASA', 'Dersa Despachos', 120, 'Activo', NULL, NULL, 1),
(81, NULL, 'Dell', 'EN CASA', 'Dersa Despachos', 66, 'Activo', NULL, NULL, 1),
(82, NULL, 'Dell 3420', '3QV8FG3', 'Dersa Despachos', 69, 'Activo', NULL, NULL, 1),
(83, NULL, 'Dell 3410', 'FBLD863', 'Dersa Supply Chain', 215, 'Activo', NULL, NULL, 1),
(84, NULL, 'Dell 7310', '349RW33', 'Dersa Supply Chain', 158, 'Activo', NULL, NULL, 1),
(85, NULL, 'Dell', 'EN CASA', 'Dersa Supply Chain', 58, 'Activo', NULL, NULL, 1),
(86, NULL, 'Dell 3420', '63WBFG3', 'Dersa Supply Chain', 154, 'Activo', NULL, NULL, 1),
(87, NULL, 'Dell 3420', 'H1WBFG3', 'Dersa Supply Chain', 138, 'Activo', NULL, NULL, 1),
(88, NULL, 'Dell 3420', '1NV8FG3', 'Dersa Supply Chain', 593, 'Activo', NULL, NULL, 1),
(89, NULL, 'Dell 3420', '9NV8FG3', 'Dersa Supply Chain', 579, 'Activo', NULL, NULL, 1),
(90, NULL, 'Dell 3420', '6PV8FG3', 'Dersa Supply Chain', 578, 'Activo', NULL, NULL, 1),
(91, NULL, 'Dell Latitude 3410', 'H3LD863', 'Dersa Seguridad Y Prevencion', 133, 'Activo', NULL, NULL, 1),
(92, NULL, 'Dell Latitude 3420', '35W8FG3', 'Grasco Contrtol', 59, 'Activo', NULL, NULL, 1),
(93, NULL, 'Dell Latitude 3420', 'GQV8FG3', 'Grasco Control', 491, 'Activo', NULL, NULL, 1),
(94, NULL, 'Dell Latitude 3420', 'B4W8FG3', 'Grasco Control', 50, 'Activo', NULL, NULL, 1),
(95, NULL, 'Dell Latitude 3420', '9JFF2B3', 'Grasco Abastecimiento', 151, 'Activo', NULL, NULL, 1),
(96, NULL, 'Dell Latitude 3420', '43WBFG3', 'Grasco Abastecimiento', 496, 'Activo', NULL, NULL, 1),
(97, NULL, 'Dell Latitude 3420', '92WBFG3', 'Grasco Abastecimiento', 76, 'Activo', NULL, NULL, 1),
(98, NULL, 'Dell Latitude 3420', 'F7W8FG3', 'Grasco Financiero', 583, 'Activo', NULL, NULL, 1),
(99, NULL, 'Dell Latitude 3420', '99WBFG3', 'Grasco Contabilidad', 104, 'Activo', NULL, NULL, 1),
(100, 'A', 'Dell Latitude 3420', '3RV8FG3', 'Grasco Compras', 611, 'Activo', '2026-03-10', NULL, 1),
(101, NULL, 'Dell Latitude 3420', 'C8W8FG3', 'Grasco Compras', 55, 'Activo', NULL, NULL, 1),
(102, NULL, 'Dell Latitude 3420', 'J1WBFG3', 'Grasco Abastecimiento', 242, 'Activo', NULL, NULL, 1),
(103, NULL, 'Dell Latitude 3420', 'GRV8FG3', 'Grasco Compras', 242, 'Activo', NULL, NULL, 1),
(104, NULL, 'Dell Latitude 3420', '1BWBFG3', 'Grasco Servicios Administrativos', 554, 'Activo', NULL, NULL, 1),
(105, NULL, 'Dell Latitude 3420', 'QV8FG3', 'Grasco Subgerencia De Control', 278, 'Activo', NULL, NULL, 1),
(106, NULL, 'Dell Latitude 3420', 'CYV8FG3', 'Grasco Subgerencia De Control', 561, 'Activo', NULL, NULL, 1),
(107, NULL, 'Dell Latitude 3420', 'FYV8FG3', 'Grasco Control Interno', 528, 'Activo', NULL, NULL, 1),
(108, NULL, 'Dell Latitude 3420', '75W8FG3', 'Grasco Control Interno', 179, 'Activo', NULL, NULL, 1),
(109, NULL, 'Dell Latitude 3420', '73WBFG3', 'Grasco Abastecimiento', 596, 'Activo', NULL, NULL, 1),
(110, NULL, 'Dell Latitude 3420', '89WBFG3', 'Grasco Subgerencia De Control', 171, 'Activo', NULL, NULL, 1),
(111, NULL, 'Dell Latitude 3420', 'CHFF2B3', 'Grasco Subgerencia De Control', 188, 'Activo', NULL, NULL, 1),
(112, NULL, 'Dell Latitude 3420', '4JVBFG3', 'Grasco Sistemas', 717, 'Activo', NULL, NULL, 1),
(113, NULL, 'Dell Latitude 3420', '5HFF2B3', 'Grasco Sistemas', 16, 'Activo', NULL, NULL, 1),
(114, NULL, 'Dell Latitude E7250', '5D05362', 'Grasco Sistemas', 717, 'Activo', NULL, NULL, 1),
(115, NULL, 'Dell Latitude 3420', '5SV8FG3', 'Grasco Sistemas', 38, 'Activo', NULL, NULL, 1),
(116, NULL, 'Dell Latitude 3420', '4PV8FG3', 'Grasco Cuentas Por Pagar', 212, 'Activo', NULL, NULL, 1),
(117, NULL, 'Dell Latitude 3420', '79WBFG3', 'Grasco Cuentas Por Pagar', 149, 'Activo', NULL, NULL, 1),
(118, NULL, 'Dell Latitude 3420', 'D5W8FG3', 'Grasco Cuentas Por Pagar', 73, 'Activo', NULL, NULL, 1),
(119, NULL, 'Dell Latitude 3420', '9ZV8FG3', 'Grasco Cuentas Por Pagar', 125, 'Activo', NULL, NULL, 1),
(120, NULL, 'Dell Latitude 3420', '29WBFG3', 'Grasco Cuentas Por Pagar', 506, 'Activo', NULL, NULL, 1),
(121, NULL, 'Dell Latitude 3420', '94W8FG3', 'Grasco Cuentas Por Pagar', 516, 'Activo', NULL, NULL, 1),
(122, NULL, 'Dell Latitude 3420', '4NV8FG3', 'Grasco Contabilidad', 54, 'Activo', NULL, NULL, 1),
(123, NULL, 'Dell Latitude 3420', 'F9WBFG3', 'Grasco Contabilidad', 14, 'Activo', NULL, NULL, 1),
(124, NULL, 'Dell Latitude 3420', '2JFF2B3', 'Grasco Contabilidad', 10, 'Activo', NULL, NULL, 1),
(125, NULL, 'Dell Latitude 3420', '4BWBFG3', 'Grasco Contabilidad', 44, 'Activo', NULL, NULL, 1),
(126, NULL, 'Dell Latitude 3420', '33WBFG3', 'Grasco Contabilidad', 199, 'Activo', NULL, NULL, 1),
(127, NULL, 'Dell Latitude 3420', '32WBFG3', 'Grasco Contabilidad', 148, 'Activo', NULL, NULL, 1),
(128, NULL, 'Dell Latitude 3420', 'G2WBFG3', 'Grasco Contabilidad', 607, 'Activo', NULL, NULL, 1),
(129, NULL, 'Dell Latitude 3420', 'CSV8FG3', 'Grasco Contabilidad', 137, 'Activo', NULL, NULL, 1),
(130, NULL, 'Dell Latitude 3420', '49WBFG3', 'Grasco Contabilidad', 272, 'Activo', NULL, NULL, 1),
(131, NULL, 'Dell Latitude 3420', 'G9WBFG3', 'Grasco Contabilidad', 507, 'Activo', NULL, NULL, 1),
(132, NULL, 'Dell Latitude 3420', '8BWBFG3', 'Grasco Contabilidad', 557, 'Activo', NULL, NULL, 1),
(133, NULL, 'Dell Latitude 3420', '28W8FG3', 'Grasco Revisoria Fiscal', 527, 'Activo', NULL, NULL, 1),
(134, NULL, 'Dell Latitude 3420', 'JNV8FG3', 'Grasco Revisoria Fiscal', 492, 'Activo', NULL, NULL, 1),
(135, NULL, 'Dell Optiplex3080', '6XHG2G3', 'Grasco Revisoria Fiscal', 497, 'Activo', NULL, NULL, 1),
(136, NULL, 'Dell Latitude 3420', '3NV8FG3', 'Grasco Revisoria Fiscal', 286, 'Activo', NULL, NULL, 1),
(137, NULL, 'Dell Latitude 3420', 'D9WBFG3', 'Grasco Revisoria Fiscal', 155, 'Activo', NULL, NULL, 1),
(138, NULL, 'Dell Latitude 3420', 'CRV8FG3', 'Grasco Revisoria Fiscal', 486, 'Activo', NULL, NULL, 1),
(139, NULL, 'Dell Latitude 3420', 'FRV8FG3', 'Grasco Revisoria Fiscal', 147, 'Activo', NULL, NULL, 1),
(140, NULL, 'Dell Latitude 3420', '98W8FG3', 'Grasco Revisoria Fiscal', 132, 'Activo', NULL, NULL, 1),
(141, NULL, 'Dell Latitude 3420', 'JQV8FG3', 'Grasco Revisoria Fiscal', 509, 'Activo', NULL, NULL, 1),
(142, NULL, 'Dell Latitude 3420', '6Q8Q824', 'Grasco Revisoria Fiscal', 622, 'Activo', NULL, NULL, 1),
(143, NULL, 'Dell Latitude 3420', 'HQV8FG3', 'Grasco Revisoria Fiscal', 526, 'Activo', NULL, NULL, 1),
(144, NULL, 'Dell Latitude 3420', '9T5TSG3', 'Grasco Revisoria Fiscal', 642, 'Activo', NULL, NULL, 1),
(145, NULL, 'Dell Latitude 3420', '4HFF2B3', 'Grasco Revisoria Fiscal', 470, 'Activo', NULL, NULL, 1),
(146, NULL, 'Dell Latitude 3420', '5NV8FG3', 'Grasco Revisoria Fiscal', 248, 'Activo', NULL, NULL, 1),
(147, NULL, 'Dell Latitude 3420', '9RV8FG3', 'Grasco Revisoria Fiscal', 107, 'Activo', NULL, NULL, 1),
(148, NULL, 'Dell Optiplex3080', '6XJD2G3', 'Grasco Caja - Tesoreria', 469, 'Activo', NULL, NULL, 1),
(149, NULL, 'Dell Latitude 3420', 'C9WBFG3', 'Grasco Comcercio Exterior', 238, 'Activo', NULL, NULL, 1),
(150, NULL, 'Dell Latitude 3420', 'CNV8FG3', 'Grasco Servicios Corporativos', 475, 'Activo', NULL, NULL, 1),
(151, NULL, 'Dell Latitude 3420', 'FQV8FG3', 'Grasco Tesoreria', 79, 'Activo', NULL, NULL, 1),
(152, NULL, 'Dell Optiplex3080', '68K9MH3', 'Grasco Tesoreria', 409, 'Activo', NULL, NULL, 1),
(153, NULL, 'Dell Latitude 3420', 'JPV8FG3', 'Grasco Sistemas', 569, 'Activo', NULL, NULL, 1),
(154, NULL, 'Dell Dell', 'JYU8842', 'Grasco Nomina', 99, 'Activo', NULL, NULL, 1),
(155, NULL, 'Dell Latitude 3420', 'C4W8FG3', 'Grasco Nomina', 126, 'Activo', NULL, NULL, 1),
(156, NULL, 'Dell Latitude 3420', '59WBFG3', 'Grasco Cuentas Por Pagar', 505, 'Activo', NULL, NULL, 1),
(157, NULL, 'Dell Latitude 3420', 'BHFF2B3', 'Grasco Cuentas Por Pagar', 501, 'Activo', NULL, NULL, 1),
(158, NULL, 'Dell Latitude 3420', 'G4W8FG3', 'Grasco Nomina', 150, 'Activo', NULL, NULL, 1),
(159, NULL, 'Dell Latitude 3420', 'GJFF2B3', 'Grasco Gth', 77, 'Activo', NULL, NULL, 1),
(160, NULL, 'Dell Optiplex3080', '4Q91KH2', 'Grasco Gth', 102, 'Activo', NULL, NULL, 1),
(161, NULL, 'Dell Optiplex3080', '53HJMH3', 'Grasco Seguridad', 189, 'Activo', NULL, NULL, 1),
(162, NULL, 'Dell Latitude 3420', 'D8W8FG3', 'Grasco Tesoreria', 153, 'Activo', NULL, NULL, 1),
(163, NULL, 'Dell Latitude 3420', 'DSV8FG3', 'Grasco Servicios Corporativos', 241, 'Activo', NULL, NULL, 1),
(164, NULL, 'Dell Latitude 3420', 'HJVBFG3', 'Grasco Tic', 581, 'Activo', NULL, NULL, 1),
(165, NULL, 'Dell Latitude 3420', 'C2WBFG3', 'Grasco Servicios Corporativos', 474, 'Activo', NULL, NULL, 1),
(166, NULL, 'Dell Latitude 3420', '7JFF2B3', 'Grasco Servicios Corporativos', 224, 'Activo', NULL, NULL, 1),
(167, NULL, 'Dell Latitude 3420', '1QV8FG3', 'Grasco Sistemas', 604, 'Activo', NULL, NULL, 1),
(168, NULL, 'Dell Latitude 3420', '7PV8FG3', 'Grasco Tic', 471, 'Activo', NULL, NULL, 1),
(169, NULL, 'Dell Latitude 3420', '4Q8FG3', 'Grasco Desarrollo', 146, 'Activo', NULL, NULL, 1),
(170, NULL, 'Dell Latitude 3420', 'J4W8FG3', 'Grasco Desarrollo', 219, 'Activo', NULL, NULL, 1),
(171, NULL, 'Dell Optiplex3080', '53GKMH3', 'Grasco Gestion Documental', 657, 'Activo', NULL, NULL, 1),
(172, NULL, 'Dell Latitude 3420', 'SYV3FG3', 'Grasco Cuentas Por Pagar', 61, 'Activo', NULL, NULL, 1),
(173, NULL, 'Dell Latitude 3420', '53WBFG3', 'Grasco Contabilidad', 517, 'Activo', NULL, NULL, 1),
(174, NULL, 'Dell Latitude 3420', 'H4W8FG3', 'Grasco Sistemas', 717, 'Activo', NULL, NULL, 1),
(175, NULL, 'Dell Optiplex3080', '6XG72G3', 'Grasco Enfermeria', 19, 'Activo', NULL, NULL, 1),
(176, NULL, 'Dell Latitude 5480', '35GV5H2', 'Grasco Enfermeria', 717, 'Activo', NULL, NULL, 1),
(177, NULL, 'Dell Latitude 3420', '6NV8FG3', 'Grasco Nomina', 586, 'Activo', NULL, NULL, 1),
(178, NULL, 'Dell Latitude 3420', '3BXM2J3', 'Grasco Tecnologia', 283, 'Activo', NULL, NULL, 1),
(179, NULL, 'Dell Latitude 3420', 'BT6TSG3', 'Grasco Desarrollo', 142, 'Activo', NULL, NULL, 1),
(180, NULL, 'Dell Apple', 'APPLE', 'Grasco Compras', 481, 'Activo', NULL, NULL, 1),
(181, NULL, 'Dell Latitude 3420', 'HHFF2B3', 'Grasco Abastecimiento', 587, 'Activo', NULL, NULL, 1),
(182, NULL, 'Dell Latitude 3420', 'B5W8FG3', 'Grasco Subgerencia De Control', 644, 'Activo', NULL, NULL, 1),
(183, NULL, 'Dell Latitude 3420', 'FPV8FG3', 'Grasco Subgerencia De Control', 568, 'Activo', NULL, NULL, 1),
(184, NULL, 'Dell Optiplex3080', '6XDC2G3', 'Grasco Bascula', 717, 'Activo', NULL, NULL, 1),
(185, NULL, 'Dell Dell', '0T938F', 'Grasco Bascula', 717, 'Activo', NULL, NULL, 1),
(186, NULL, 'Dell Optiplex3080', '6XJC2G3', 'Grasco Bascula', 717, 'Activo', NULL, NULL, 1),
(187, NULL, 'Dell Optiplex3080', '6YXHMH3', 'Grasco Cd7', 717, 'Activo', NULL, NULL, 1),
(188, NULL, 'Dell Optiplex3080', '68JGMH3', 'Grasco Cd7', 717, 'Activo', NULL, NULL, 1),
(189, NULL, 'Dell Optiplex3080', '6Z4CMH3', 'Grasco Cd7', 717, 'Activo', NULL, NULL, 1),
(190, NULL, 'Dell Optiplex3080', '6XFH2G3', 'Grasco Cd7', 717, 'Activo', NULL, NULL, 1),
(191, NULL, 'Dell Optiplex3080', '6Z4BMH3', 'Grasco Cdn', 717, 'Activo', NULL, NULL, 1),
(192, NULL, 'Dell Optiplex9020', 'GHLX282', 'Grasco Cdn', 717, 'Activo', NULL, NULL, 1),
(193, NULL, 'Dell Optiplex9020', '9DSDW52', 'Grasco Cdn', 717, 'Activo', NULL, NULL, 1),
(194, NULL, 'Dell Optiplex3080', '6XJ71G3', 'Grasco Cdn', 717, 'Activo', NULL, NULL, 1),
(195, NULL, 'Dell Optiplex9020', 'BRHRZ12', 'Grasco Cdn', 717, 'Activo', NULL, NULL, 1),
(196, NULL, 'Dell Optiplex3080', '6XBB2G3', 'Grasco Intermedias', 717, 'Activo', NULL, NULL, 1),
(197, NULL, 'Dell Optiplex3080', '6XNF2G3', 'Grasco Intermedias', 717, 'Activo', NULL, NULL, 1),
(198, NULL, 'Dell Optiplex3080', '6XMFG3', 'Grasco Raza Cdr Bogota', 523, 'Activo', NULL, NULL, 1),
(199, NULL, 'Dell Optiplex3080', '6XKG2G3', 'Grasco Esponjillas', 717, 'Activo', NULL, NULL, 1),
(200, NULL, 'Dell Optiplex3080', '67NDMH3', 'Grasco Esponjillas', 717, 'Activo', NULL, NULL, 1),
(201, NULL, 'Dell Optiplex3080', '68ZHMH3', 'Grasco Esponjillas', 717, 'Activo', NULL, NULL, 1),
(202, NULL, 'Dell Optiplex3080', '6XQC2G3', 'Grasco Produccion Y Calidad', 717, 'Activo', NULL, NULL, 1),
(203, NULL, 'Dell Optiplex3080', 'J2WBFG3', 'Grasco Seguridad Industrial', 88, 'Activo', NULL, NULL, 1),
(204, NULL, 'Dell Optiplex3080', '6XGH2G3', 'Grasco Produccion Y Calidad', 717, 'Activo', NULL, NULL, 1),
(205, NULL, 'Dell Optiplex3080', '6XNJ2G3', 'Grasco Produccion Y Calidad', 717, 'Activo', NULL, NULL, 1),
(206, NULL, 'Dell Optiplex3080', '6XCH2G3', 'Grasco Produccion Y Calidad', 717, 'Activo', NULL, NULL, 1),
(207, NULL, 'Dell Optiplex3080', '6XD92G3', 'Grasco Produccion Y Calidad', 717, 'Activo', NULL, NULL, 1),
(208, NULL, 'Dell Optiplex3080', '6XM82G3', 'Grasco Produccion Y Calidad', 717, 'Activo', NULL, NULL, 1),
(209, NULL, 'Dell Latitude 3420', '8T6TSG3', 'Grasco Produccion Y Calidad', 717, 'Activo', NULL, NULL, 1),
(210, NULL, 'Dell Optiplex3080', '6XH72G3', 'Grasco Ingenieria Y Mantenimiento', 564, 'Activo', NULL, NULL, 1),
(211, NULL, 'Dell Optiplex3080', '6XFB2G3', 'Grasco Ingenieria Y Mantenimiento', 612, 'Activo', NULL, NULL, 1),
(212, NULL, 'Dell Optiplex3080', '6XP72G3', 'Grasco Ingenieria Y Mantenimiento', 717, 'Activo', NULL, NULL, 1),
(213, NULL, 'Dell Optiplex3080', '6XH82G3', 'Grasco Ingenieria Y Mantenimiento', 717, 'Activo', NULL, NULL, 1),
(214, NULL, 'Dell Optiplex3080', '6XFC2G3', 'Grasco Ingenieria Y Mantenimiento', 717, 'Activo', NULL, NULL, 1),
(215, NULL, 'Dell Optiplex3080', '6XLG2G3', 'Grasco Ingenieria Y Mantenimiento', 717, 'Activo', NULL, NULL, 1),
(216, NULL, 'Dell Optiplex3080', '6XPH2G3', 'Grasco Ingenieria Y Mantenimiento', 717, 'Activo', NULL, NULL, 1),
(217, NULL, 'Dell Optiplex3080', '6XHC2G3', 'Grasco Ingenieria Y Mantenimiento', 717, 'Activo', NULL, NULL, 1),
(218, NULL, 'Dell Optiplex3080', '6XPF2G3', 'Grasco Ingenieria Y Mantenimiento', 717, 'Activo', NULL, NULL, 1),
(219, NULL, 'Dell Optiplex3080', '6XF72G3', 'Grasco Ingenieria Y Mantenimiento', 717, 'Activo', NULL, NULL, 1),
(220, NULL, 'Dell Optiplex9020', '3XVHXM2', 'Grasco Seguridad', 717, 'Activo', NULL, NULL, 1),
(221, NULL, 'Dell Optiplex3080', '6XGB2G3', 'Grasco Laboratorio', 717, 'Activo', NULL, NULL, 1),
(222, NULL, 'Dell Optiplex3080', '6XGC2G3', 'Grasco Laboratorio', 717, 'Activo', NULL, NULL, 1),
(223, NULL, 'Dell Optiplex3080', '6XLC2G3', 'Grasco Laboratorio', 717, 'Activo', NULL, NULL, 1),
(224, NULL, 'Dell Dell Precision Tower 3620', '7VF9DH2', 'Grasco Laboratorio', 717, 'Activo', NULL, NULL, 1),
(225, NULL, 'Dell Optiplex780', '7995JL1', 'Grasco Laboratorio', 717, 'Activo', NULL, NULL, 1),
(226, NULL, 'Dell Optiplex3080', '6XDH2G3', 'Grasco Laboratorio', 717, 'Activo', NULL, NULL, 1),
(227, NULL, 'Dell Optiplex3080', '6XJF2G3', 'Grasco Laboratorio', 717, 'Activo', NULL, NULL, 1),
(228, NULL, 'Dell Optiplex3080', '6XCC2G3', 'Grasco Laboratorio', 717, 'Activo', NULL, NULL, 1),
(229, NULL, 'Dell Optiplex3080', '6XGD2G3', 'Grasco Produccion Y Calidad', 717, 'Activo', NULL, NULL, 1),
(230, NULL, 'Dell Optiplex9020', '2DF7B42', 'Grasco Gestion', 717, 'Activo', NULL, NULL, 1),
(231, NULL, 'Dell Optiplex9020', 'GHL3382', 'Grasco Ambiental', 717, 'Activo', NULL, NULL, 1),
(232, NULL, 'Dell Optiplex3080', '67RGMH3', 'Grasco Ambiental', 87, 'Activo', NULL, NULL, 1),
(233, NULL, 'Dell Optiplex3080', '67NKMH3', 'Distritos Villavicencio', 369, 'Activo', NULL, NULL, 1),
(234, NULL, 'Dell Optiplex3080', '68JOMH3', 'Distritos Villavicencio', 375, 'Activo', NULL, NULL, 1),
(235, NULL, 'Dell Optiplex9020', 'GK6GTS2', 'Distritos Villavicencio', 318, 'Activo', NULL, NULL, 1),
(236, NULL, 'Dell Optiplex 3080', '6XBG2G3', 'Distritos Raza Neiva', NULL, 'Activo', NULL, NULL, 1),
(237, NULL, 'Dell Optiplex 3080', '6XN92G3', 'Distritos Raza Ibague', NULL, 'Activo', NULL, NULL, 1),
(238, NULL, 'Dell Optiplex 3080', '6XCJ2G3', 'Distritos Raza Duitama', NULL, 'Activo', NULL, NULL, 1),
(239, NULL, 'Dell Optiplex 3080', '6XD72G3', 'Distritos Raza Caqueza', NULL, 'Activo', NULL, NULL, 1),
(240, NULL, 'Dell Optiplex 3080', '68ZDMH3', 'Distritos Neiva', 406, 'Activo', NULL, NULL, 1),
(241, NULL, 'Dell Optiplex 3080', '67L9MH3', 'Distritos Neiva', 383, 'Activo', NULL, NULL, 1),
(242, NULL, 'Dell Optiplex 7040', '5MLVCH2', 'Distritos Neiva', 416, 'Activo', NULL, NULL, 1),
(243, NULL, 'Dell Optiplex 3080', '67M9MH3', 'Distritos Cali', NULL, 'Activo', NULL, NULL, 1),
(244, NULL, 'Dell Optiplex 3080', '67MJMH3', 'Distritos Cali', NULL, 'Activo', NULL, NULL, 1),
(245, NULL, 'Dell Optiplex 3080', '6YXJMH3', 'Distritos Cali', NULL, 'Activo', NULL, NULL, 1),
(246, NULL, 'Dell Optiplex 3080', '67QHMH3', 'Distritos Cali', NULL, 'Activo', NULL, NULL, 1),
(247, NULL, 'Dell Optiplex', 'JHQJFB2', 'Distritos Cali', NULL, 'Activo', NULL, NULL, 1),
(248, NULL, 'Dell Optiplex 3080', '67NFMH3', 'Distritos Cali', NULL, 'Activo', NULL, NULL, 1),
(249, NULL, 'Dell Optiplex 3080', '68Z8MH3', 'Distritos Medellin', 362, 'Activo', NULL, NULL, 1),
(250, NULL, 'Dell Optiplex 7050', 'JSS4LH2', 'Distritos Medellin', 418, 'Activo', NULL, NULL, 1),
(251, NULL, 'Dell Optiplex 3080', '67NHMH3', 'Distritos Medellin', 370, 'Activo', NULL, NULL, 1),
(252, NULL, 'Dell Optiplex 3080', '53HBMH3', 'Distritos Medellin', 401, 'Activo', NULL, NULL, 1),
(253, NULL, 'Dell Optiplex 3080', '6YXDMH3', 'Distritos Medellin', 391, 'Activo', NULL, NULL, 1),
(254, NULL, 'Dell Optiplex 9020', 'HQ0JS52', 'Distritos Medellin', 317, 'Activo', NULL, NULL, 1),
(255, NULL, 'Dell Optiplex 3080', '6YX8MH3', 'Distritos Medellin', 394, 'Activo', NULL, NULL, 1),
(256, NULL, 'Dell Optiplex 3080', '68YJMH3', 'Distritos Pereira', 363, 'Activo', NULL, NULL, 1),
(257, NULL, 'Dell Optiplex 3080', '69OHMH3', 'Distritos Pereira', 381, 'Activo', NULL, NULL, 1),
(258, NULL, 'Dell Optiplex 3080', '68JKMH3', 'Distritos Pereira', 702, 'Activo', NULL, NULL, 1),
(259, NULL, 'Dell Optiplex 7040', '29909938646.0', 'Distritos Pereira', 703, 'Activo', NULL, NULL, 1),
(260, NULL, 'Dell Optiplex 3080', '68HHMH3', 'Distritos Pereira', 701, 'Activo', NULL, NULL, 1),
(261, NULL, 'Dell Optiplex 3080', '67PDMH3', 'Distritos Bucaramanga', 367, 'Activo', NULL, NULL, 1),
(262, NULL, 'Dell Optiplex 3080', '67QFMH3', 'Distritos Bucaramanga', 403, 'Activo', NULL, NULL, 1),
(263, NULL, 'Dell Optiplex 3080', 'GNGFKH2', 'Distritos Bucaramanga', 704, 'Activo', NULL, NULL, 1),
(264, NULL, 'Dell Optiplex 3080', '6Z4DMH3', 'Distritos Bucaramanga', 388, 'Activo', NULL, NULL, 1),
(265, NULL, 'Dell Optiplex 3080', '67PKMH3', 'Distritos Bucaramanga', 359, 'Activo', NULL, NULL, 1),
(266, NULL, 'Dell Optiplex 7040', 'GHLPMD2', 'Distritos Bucaramanga', 322, 'Activo', NULL, NULL, 1),
(267, NULL, 'Dell Optiplex 7050', '1NX9JL2', 'Distritos Bucaramanga', 328, 'Activo', NULL, NULL, 1),
(268, NULL, 'Dell Optiplex 3080', '536BMH3', 'Distritos Ibague', 402, 'Activo', NULL, NULL, 1),
(269, NULL, 'Dell Optiplex 3080', '6919MH3', 'Distritos Ibague', 364, 'Activo', NULL, NULL, 1),
(270, NULL, 'Dell Optiplex 3080', '690 MH3', 'Distritos Ibague', 361, 'Activo', NULL, NULL, 1),
(271, NULL, 'Dell Optiplex 7060', 'ORJLDW2', 'Distritos Ibague', 335, 'Activo', NULL, NULL, 1),
(272, NULL, 'Dell Optiplex 3080', '67PGMH3', 'Distritos Barranquilla', 372, 'Activo', NULL, NULL, 1),
(273, NULL, 'Dell Optiplex 3080', '67R9MH3', 'Distritos Barranquilla', 382, 'Activo', NULL, NULL, 1),
(274, NULL, 'Dell Optiplex 3080', '68KBMH3', 'Distritos Barranquilla', 407, 'Activo', NULL, NULL, 1),
(275, NULL, 'Dell Optiplex 3080', '68JJMH3', 'Distritos Barranquilla', 374, 'Activo', NULL, NULL, 1),
(276, NULL, 'Dell Optiplex 3080', '67Q9MH3', 'Distritos Barranquilla', 365, 'Activo', NULL, NULL, 1),
(277, NULL, 'Dell Optiplex 3080', '67QBMH3', 'Distritos Barranquilla', 360, 'Activo', NULL, NULL, 1),
(278, NULL, 'Dell Optiplex 3080', '67QGMH3', 'Distritos Barranquilla', 384, 'Activo', NULL, NULL, 1),
(279, NULL, 'Dell Optiplex 3440', 'CJFF2B3', 'Distritos Barranquilla', NULL, 'Activo', NULL, NULL, 1),
(280, NULL, 'Dell Optiplex 3080', '6YWJMH3', 'Distritos Barranquilla', 390, 'Activo', NULL, NULL, 1),
(281, NULL, 'Dell Optiplex 3080', '53GKMH3', 'Distritos Duitama', 376, 'Activo', NULL, NULL, 1),
(282, NULL, 'Dell Optiplex3080', '53GFMH3', 'Distritos Duitama', 398, 'Activo', NULL, NULL, 1),
(283, NULL, 'Dell Optiplex3080', '67NCMH3', 'Distritos Duitama', 368, 'Activo', NULL, NULL, 1),
(284, NULL, 'Dell Optiplex 3080', '68J9MH3', 'Distritos Duitama', 405, 'Activo', NULL, NULL, 1),
(285, NULL, 'Dell Optln Productionlex 3080', '6XJG2G3', 'Barranquilla Almacen Y Papeleria', 679, 'Activo', NULL, NULL, 1),
(286, NULL, 'Dell Latitude 3420', '7HFF2B3', 'Barranquilla Auditoria', NULL, 'Activo', NULL, NULL, 1),
(287, NULL, 'Dell Optln Productionlex 3080', '6XF92G3', 'Barranquilla Bascula', 689, 'Activo', NULL, NULL, 1),
(288, NULL, 'Dell Optln Productionlex 3080', '6XKB2G3', 'Barranquilla Bodega Mezzanine', 684, 'Activo', NULL, NULL, 1),
(289, NULL, 'Dell Optln Productionlex 3080', '6XBC2G3', 'Barranquilla Caja', 691, 'Activo', NULL, NULL, 1),
(290, NULL, 'Dell Optiplex 7040', '1LX1P22', 'Barranquilla Capacitacion', 345, 'Activo', NULL, NULL, 1),
(291, NULL, 'Dell Optiplex 9020', '9SP1382', 'Barranquilla Capacitacion', 302, 'Activo', NULL, NULL, 1),
(292, NULL, 'Dell Optiplex 7040', 'GZKSJH2', 'Barranquilla Capacitacion', 306, 'Activo', NULL, NULL, 1),
(293, NULL, 'Dell Latitude 3420', 'BNV8FG3', 'Barranquilla Comercial', 420, 'Activo', NULL, NULL, 1),
(294, NULL, 'Dell Latitude 3420', '1KFF2B3', 'Barranquilla Compras', 663, 'Activo', NULL, NULL, 1),
(295, NULL, 'Dell Latitude 3420', '3SV8FG3', 'Barranquilla Contabilidad', 423, 'Activo', NULL, NULL, 1),
(296, NULL, 'Dell Optln Productionlex 3080', '6XC82G3', 'Barranquilla Cuarto De Control', NULL, 'Activo', NULL, NULL, 1),
(297, NULL, 'Dell Optln Productionlex 3080', '6XJB2G3', 'Barranquilla Cuarto De Control', NULL, 'Activo', NULL, NULL, 1),
(298, NULL, 'Dell Optln Productionlex 3080', '6XPD2G3', 'Barranquilla Cuarto De Control', 700, 'Activo', NULL, NULL, 1),
(299, NULL, 'Dell Optiplex 7050', 'FZ2ZKH2', 'Barranquilla Cuarto De Control', 307, 'Activo', NULL, NULL, 1),
(300, NULL, 'Dell Optiplex 7040', 'JGZT942', 'Barranquilla Cuarto De Control', 299, 'Activo', NULL, NULL, 1),
(301, NULL, 'Dell Latitude 3420', 'CQV8FG3', 'Barranquilla Cuentas Por Pagar', 424, 'Activo', NULL, NULL, 1),
(302, NULL, 'Dell Latitude 3420', '2ZV8FG3', 'Barranquilla Cuentas Por Pagar', 428, 'Activo', NULL, NULL, 1),
(303, NULL, 'Dell Optln Productionlex 3080', '6XBJ2G3', 'Barranquilla Despacho', 681, 'Activo', NULL, NULL, 1),
(304, NULL, 'Dell Optiplex 7040', '4NSKJB2', 'Barranquilla Despacho', 293, 'Activo', NULL, NULL, 1),
(305, NULL, 'Dell Latitude 3420', 'FJFF2B3', 'Barranquilla Despacho', 662, 'Activo', NULL, NULL, 1),
(306, NULL, 'Dell Latitude 3420', 'JHFF2B3', 'Barranquilla Gerencia', 661, 'Activo', NULL, NULL, 1),
(307, NULL, 'Dell Optln Productionlex 3080', '6XQB2G3', 'Barranquilla Gerencia', 678, 'Activo', NULL, NULL, 1),
(308, NULL, 'Dell Latitude 3420', 'GHFF2B3', 'Barranquilla Gestion Documental', 666, 'Activo', NULL, NULL, 1),
(309, NULL, 'Dell Optln Productionlex 3080', '6XL82G3', 'Barranquilla Gestion Humana', 680, 'Activo', NULL, NULL, 1),
(310, NULL, 'Dell Latitude 3420', '6HFF2B3', 'Barranquilla Gestion Humana', 667, 'Activo', NULL, NULL, 1),
(311, NULL, 'Dell Optiplex 9020', 'FKFST52', 'Barranquilla Gestion Humana', 319, 'Activo', NULL, NULL, 1),
(312, NULL, 'Dell Optln Productionlex 3080', '6XHJ2G3', 'Barranquilla Juridica', 685, 'Activo', NULL, NULL, 1),
(313, NULL, 'Dell Optiplex 7040', '2247CH2', 'Barranquilla Laboratorio', 310, 'Activo', NULL, NULL, 1),
(314, NULL, 'Dell Optln Productionlex 3080', '6XG82G3', 'Barranquilla Laboratorio', 686, 'Activo', NULL, NULL, 1),
(315, NULL, 'Dell Dell Precision T3400', 'FJZ9M4J', 'Barranquilla Laboratorio', 292, 'Activo', NULL, NULL, 1),
(316, NULL, 'Dell Optln Productionlex 3080', '6XK72G3', 'Barranquilla Laboratorio', 687, 'Activo', NULL, NULL, 1),
(317, NULL, 'Dell Optiplex 9020', 'H0RZZ12', 'Barranquilla Inspectores De Calidad', 298, 'Activo', NULL, NULL, 1),
(318, NULL, 'Dell Optiplex 7050', 'FZ2XKH2', 'Barranquilla Laboratorio', 309, 'Activo', NULL, NULL, 1),
(319, NULL, 'Dell Optiplex 7010', '83JVT12', 'Barranquilla Laboratorio', NULL, 'Activo', NULL, NULL, 1),
(320, NULL, 'Dell Optiplex 760', '65P2NK1', 'Barranquilla Llenado', NULL, 'Activo', NULL, NULL, 1),
(321, NULL, 'Dell Optln Productionlex 3080', '6XFD2G3', 'Barranquilla Llenado', 688, 'Activo', NULL, NULL, 1),
(322, NULL, 'Dell Optiplex 9020', 'DH4LM22', 'Barranquilla Llenado', NULL, 'Activo', NULL, NULL, 1),
(323, NULL, 'Dell Optln Productionlex 3080', '6XJ82G3', 'Barranquilla Mantenimiento', 671, 'Activo', NULL, NULL, 1),
(324, NULL, 'Dell Optln Productionlex 3080', '6XP82G3', 'Barranquilla Mantenimiento', 672, 'Activo', NULL, NULL, 1),
(325, NULL, 'Dell Optln Productionlex 3080', '6XNG2G3', 'Barranquilla Mantenimiento', 677, 'Activo', NULL, NULL, 1),
(326, NULL, 'Dell Optln Productionlex 3080', '6XNH2G3', 'Barranquilla Mantenimiento', 674, 'Activo', NULL, NULL, 1),
(327, NULL, 'Dell Optln Productionlex 3080', '6XDG2G3', 'Barranquilla Mantenimiento', 676, 'Activo', NULL, NULL, 1),
(328, NULL, 'Dell Optiplex 7050', 'JCMLHK2', 'Barranquilla Mantenimiento', 312, 'Activo', NULL, NULL, 1),
(329, NULL, 'Dell Optln Productionlex 3080', '6XK92G3', 'Barranquilla Mantenimiento', NULL, 'Activo', NULL, NULL, 1),
(330, NULL, 'Dell Optln Productionlex 3081', '6XPC2G3', 'Barranquilla Mantenimiento', 694, 'Activo', NULL, NULL, 1),
(331, NULL, 'Dell Optln Productionlex 3080', '6XND2G3', 'Barranquilla Mantenimiento', 673, 'Activo', NULL, NULL, 1),
(332, NULL, 'Dell Optiplex 9020', '9SP2382', 'Barranquilla Mantenimiento', 304, 'Activo', NULL, NULL, 1),
(333, NULL, 'Dell Optiplex 7040', '5MLWCH2', 'Barranquilla Nomina', 415, 'Activo', NULL, NULL, 1),
(334, NULL, 'Dell Optiplex 7050', '4JMWWK2', 'Barranquilla Porteria', 294, 'Activo', NULL, NULL, 1),
(335, NULL, 'Dell Optln Productionlex 3080', '6XG92G3', 'Barranquilla Produccion', 690, 'Activo', NULL, NULL, 1),
(336, NULL, 'Dell Optiplex 7040', '6TC5HH2', 'Barranquilla Produccion', NULL, 'Activo', NULL, NULL, 1),
(337, NULL, 'Dell Optiplex 9020', 'FVBJT52', 'Barranquilla Produccion', 300, 'Activo', NULL, NULL, 1),
(338, NULL, 'Dell Optiplex 9020', '5GJCX12', 'Barranquilla Produccion', 296, 'Activo', NULL, NULL, 1),
(339, NULL, 'Dell Optln Productionlex 3080', '6XQ92G3', 'Barranquilla Produccion', 692, 'Activo', NULL, NULL, 1),
(340, NULL, 'Dell Optiplex 9020', 'DH3MM22', 'Barranquilla Produccion', 297, 'Activo', NULL, NULL, 1),
(341, NULL, 'Dell Optln Productionlex 3080', '6XGG2G3', 'Barranquilla Produccion 2 Piso', 669, 'Activo', NULL, NULL, 1),
(342, NULL, 'Dell Optiplex 7050', 'JCMMHK2', 'Barranquilla Produccion 2 Piso', 311, 'Activo', NULL, NULL, 1),
(343, NULL, 'Dell Optln Productionlex 3080', '6XHB2G3', 'Barranquilla Produccion 2 Piso', 670, 'Activo', NULL, NULL, 1),
(344, NULL, 'Dell Optln Productionlex 3080', '6XB92G3', 'Barranquilla Pur', 693, 'Activo', NULL, NULL, 1),
(345, NULL, 'Dell Latitude 3420', 'H2WBFG3', 'Barranquilla Salud Ocupacional', 427, 'Activo', NULL, NULL, 1),
(346, NULL, 'Dell Optiplex 7040', '4MSJJB2', 'Barranquilla Seguridad Ocupacional', 305, 'Activo', NULL, NULL, 1),
(347, NULL, 'Dell Optln Productionlex 3080', '6XK82G3', 'Barranquilla Seguridad Ocupacional', 675, 'Activo', NULL, NULL, 1),
(348, NULL, 'Dell Hp Proliant Dl380p Gen 8', 'MXQ102PW', 'Barranquilla Servidores', 315, 'Activo', NULL, NULL, 1),
(349, NULL, 'Dell Hp Proliant Dl380p Gen 9', '2M24451QBJ', 'Barranquilla Servidores', 316, 'Activo', NULL, NULL, 1),
(350, NULL, 'Dell Latitude 3420', '9HFF2B3', 'Barranquilla Sistema De Gestion', 665, 'Activo', NULL, NULL, 1),
(351, NULL, 'Dell Optiplex 9020', '9S5H182', 'Barranquilla Sistema De Gestion', 301, 'Activo', NULL, NULL, 1),
(352, NULL, 'Dell Optiplex 7050', 'FZ33LH2', 'Barranquilla Sistemas', 308, 'Activo', NULL, NULL, 1),
(353, NULL, 'Dell Latitude 3420', '45W8FG3', 'Barranquilla Sistemas', 422, 'Activo', NULL, NULL, 1),
(354, NULL, 'Dell Optiplex 7050', 'G6T60M2', 'Barranquilla Sistemas', 313, 'Activo', NULL, NULL, 1),
(355, NULL, 'Dell Hpe Proliant Dl 380 Gen 10', '2M281201VK', 'Barranquilla Cuarto De Control', 699, 'Activo', NULL, NULL, 1),
(356, NULL, 'Dell Hpe Proliant Dl 360', 'MXQ308037R', 'Barranquilla Cuarto De Control', 291, 'Activo', NULL, NULL, 1),
(357, NULL, 'Dell Hpe Proliant Dl 380', 'MXQ51200MN', 'Barranquilla Cuarto De Control', 346, 'Activo', NULL, NULL, 1),
(358, NULL, 'Dell Proliant', 'USE935N761', 'Barranquilla Cuarto De Control', 698, 'Activo', NULL, NULL, 1),
(359, NULL, 'Dell Optln Productionlex 3080', '6XBF2G3', 'Barranquilla Seguridad Y Prevencion', 682, 'Activo', NULL, NULL, 1),
(360, NULL, 'Dell Latitude 3420', 'DHFF2B3', 'Barranquilla Gestión Humana', 664, 'Activo', NULL, NULL, 1),
(361, NULL, 'Dell Latitudex 3420', 'BJFF2B3', 'Barranquilla Produccion', 668, 'Activo', NULL, NULL, 1),
(362, NULL, 'Dell', '77', 'Barranquilla Total', NULL, 'Activo', NULL, NULL, 1),
(363, NULL, 'Dell 3000', 'D5X26S3', 'Oro Rojo', 763, 'Activo', NULL, NULL, 1),
(364, NULL, 'Dell 3420', '83YJXL3', 'Oro Rojo', 763, 'Activo', NULL, NULL, 1),
(365, NULL, 'Dell 3420', '3JFF2B3', 'Gradezco - Segmento Alimentos Selección Y Formación', 131, 'Activo', NULL, NULL, 1),
(366, NULL, 'Dell 3000', '86X26S3', 'Oro Rojo', 763, 'Activo', NULL, NULL, 1),
(367, NULL, 'Dell 3080', '6XQ72G3', 'Gradezco - Segmento Alimentos Mantenimiento', 36, 'Activo', NULL, NULL, 1),
(368, NULL, 'Dell 3080', '6YWHMH3', 'Gradezco - Segmento Aseo Tms', 204, 'Activo', NULL, NULL, 1),
(369, NULL, 'Dell 3450', 'BY0RG22', 'Indupalma', NULL, 'Activo', NULL, NULL, 1),
(370, NULL, 'Dell 3420', 'CPV8FG3', 'Agora Csc S.a.s', 763, 'Activo', NULL, NULL, 1),
(371, NULL, 'Dell 3080', '690KMH3', 'Gradezco - Segmento Aseo Inventarios', 630, 'Activo', NULL, NULL, 1),
(372, NULL, 'Dell 3420', '5QV8FG3', 'Agora Csc S.a.s 6 - Csc Tic - General', 159, 'Activo', NULL, NULL, 1),
(373, NULL, 'Dell Lenovo Thinkpad E15 Gen 4', 'EQCC000000036', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(374, NULL, 'Dell 3410', '1BLD863', 'Gradezco - Segmento Aseo Medellin', 96, 'Activo', NULL, NULL, 1),
(375, NULL, 'Dell 3440', '6YYBQ04', 'Gradezco - Segmento Aseo Medellin', 96, 'Activo', NULL, NULL, 1),
(376, NULL, 'Dell 3080', '67MBMH3', 'Gradezco - Segmento Aseo Tms', 66, 'Activo', NULL, NULL, 1),
(377, NULL, 'Dell 3420', 'B3YJXL3', 'Oro Rojo', 763, 'Activo', NULL, NULL, 1),
(378, NULL, 'Dell 3420', '73YJXL3', 'Oro Rojo', 763, 'Activo', NULL, NULL, 1),
(379, NULL, 'Dell Hp Zbook Firefly 14 G7', 'EQCC000000017', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(380, NULL, 'Dell 3080', '67MDMH3', 'Gradezco - Segmento Aseo Crm', 177, 'Activo', NULL, NULL, 1),
(381, NULL, 'Dell 3080', '67MHMH3', 'Gradezco - Segmento Aseo Seguridad Y Salud En El Trabajo', 117, 'Activo', NULL, NULL, 1),
(382, NULL, 'Dell 3080', '6XNB2G3', 'Gradezco - Segmento Nutricion Animal Nutricion Animal', 206, 'Activo', NULL, NULL, 1),
(383, NULL, 'Dell 3440', 'CGL8LY3', 'Aliatesp', NULL, 'Activo', NULL, NULL, 1),
(384, NULL, 'Dell 3440', 'DQHQ824', 'Gradezco - Segmento Aseo Sap Nova', 635, 'Activo', NULL, NULL, 1),
(385, NULL, 'Dell 3080', '6YYFMH3', 'Gradezco - Segmento Aseo Cartera', 237, 'Activo', NULL, NULL, 1),
(386, NULL, 'Dell 3410', '94LD863', 'Gradezco - Segmento Aseo Bucaramanga', 650, 'Activo', NULL, NULL, 1),
(387, NULL, 'Dell 7010', 'BGK8TW1', 'Gradezco - Segmento Alimentos Margarina Y Empaque', 558, 'Activo', NULL, NULL, 1),
(388, NULL, 'Dell 3080', '6XB72G3', 'Gradezco - Segmento Alimentos Almacen De Repuestos', 275, 'Activo', NULL, NULL, 1),
(389, NULL, 'Dell 3080', '67LKMH3', 'Gradezco - Segmento Aseo Planta Jaboneria', 572, 'Activo', NULL, NULL, 1),
(390, NULL, 'Dell 3080', '67P8MH3', 'Gradezco - Segmento Aseo Operaciones Y Logistica', 221, 'Activo', NULL, NULL, 1),
(391, NULL, 'Dell 3420', '8NV8FG3', 'Agora Csc S.a.s 6 - Csc Tic - General', 279, 'Activo', NULL, NULL, 1),
(392, NULL, 'Dell Hp Zbook Firefly 14 G8', 'EQCC000000021', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(393, NULL, 'Dell Lenovo Thinkpad E15 Gen 3', 'EQCC000000024', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(394, NULL, 'Dell 3581', '3D5Q114', 'Aliatesp', NULL, 'Activo', NULL, NULL, 1),
(395, NULL, 'Dell 3080', '6XFF2G3', 'Gradezco - Segmento Alimentos', 697, 'Activo', NULL, NULL, 1),
(396, NULL, 'Dell 9020', '44S4N22', 'Gradezco - Segmento Aseo', 314, 'Activo', NULL, NULL, 1),
(397, NULL, 'Dell Lenovo Torre P340 Thinkstation', 'EQCC000000027', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(398, NULL, 'Dell 3410', '5CLD863', 'Gradezco - Segmento Aseo Mesa De Ayuda', 180, 'Activo', NULL, NULL, 1),
(399, NULL, 'Dell 3080', '6XMB2G3', 'Gradezco - Segmento Nutricion Animal', 350, 'Activo', NULL, NULL, 1),
(400, NULL, 'Dell 3000', '16X26S3', 'Oro Rojo', 763, 'Activo', NULL, NULL, 1),
(401, NULL, 'Dell Micro 7010', 'DMY8FZ3', 'Oleariari', 763, 'Activo', NULL, NULL, 1),
(402, NULL, 'Dell 3080', '6XB82G3', 'Gradezco - Segmento Alimentos Relaciones Laborales', 8, 'Activo', NULL, NULL, 1),
(403, NULL, 'Dell 3420', '8HFF2B3', 'Gradezco - Segmento Alimentos Relaciones Laborales', 8, 'Activo', NULL, NULL, 1),
(404, NULL, 'Dell 3420', '8JFF2B3', 'Agora Csc S.a.s 6 - Csc Conciliaciones', 10, 'Activo', NULL, NULL, 1),
(405, NULL, 'Dell 3420', 'HCFF2B3', 'Gradezco - Segmento Alimentos Seguridad Y Salud En El Trabajo', 105, 'Activo', NULL, NULL, 1),
(406, NULL, 'Dell 9020', 'G90NB42', 'Gradezco - Segmento Alimentos Barranquilla', 304, 'Activo', NULL, NULL, 1),
(407, NULL, 'Dell 5480', 'BCZP4H2', 'Agora Csc S.a.s', 707, 'Activo', NULL, NULL, 1),
(408, NULL, 'Dell 3460', '1ZDDXB2', 'Indupalma 6 - Corporativos Indupalma - General', 235, 'Activo', NULL, NULL, 1),
(409, NULL, 'Dell Hallazgo', '67WVVV1', 'Gradezco - Segmento Alimentos', 413, 'Activo', NULL, NULL, 1),
(410, NULL, 'Dell 5480', '9TFLJM2', 'Gradezco - Segmento Aseo Sap Nova', 259, 'Activo', NULL, NULL, 1),
(411, NULL, 'Dell 7060', 'HW8QCP2', 'Gradezco - Segmento Aseo', 331, 'Activo', NULL, NULL, 1),
(412, NULL, 'Dell 3080', '53GBMH3', 'Gradezco - Segmento Aseo Ibague', 617, 'Activo', NULL, NULL, 1),
(413, NULL, 'Dell E5470', 'BNHK0G2', 'Gradezco - Segmento Aseo', NULL, 'Activo', NULL, NULL, 1),
(414, NULL, 'Dell 3080', '67RDMH3', 'Gradezco - Segmento Aseo', 386, 'Activo', NULL, NULL, 1),
(415, NULL, 'Dell 7050', '4Q8MJH2', 'Gradezco - Segmento Aseo', 429, 'Activo', NULL, NULL, 1),
(416, NULL, 'Dell 755', '7G2V4H1', 'Gradezco - Segmento Alimentos', NULL, 'Activo', NULL, NULL, 1),
(417, NULL, 'Dell 3080', '690FMH3', 'Gradezco - Segmento Aseo', 763, 'Activo', NULL, NULL, 1),
(418, NULL, 'Dell 3420', '2NV8FG3', 'Agora Csc S.a.s', 419, 'Activo', NULL, NULL, 1),
(419, NULL, 'Dell 3420', 'F5W8FG3', 'Agora Csc S.a.s 6 - Csc Tic - General', 4, 'Activo', NULL, NULL, 1),
(420, NULL, 'Dell 3080', '67NBMH3', 'Gradezco - Segmento Aseo Llenado', 602, 'Activo', NULL, NULL, 1),
(421, NULL, 'Dell 3080', '68JBMH3', 'Gradezco - Segmento Aseo Operaciones Y Logistica', 92, 'Activo', NULL, NULL, 1),
(422, NULL, 'Dell Asus Vivo Aio 24 V241', 'EQCC000000018', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(423, NULL, 'Dell 3080', '67RCMH3', 'Gradezco - Segmento Aseo Cartera', 473, 'Activo', NULL, NULL, 1),
(424, NULL, 'Dell 3420', '9PV8FG3', 'Agora Csc S.a.s 6 - Csc Cxp', 490, 'Activo', NULL, NULL, 1),
(425, NULL, 'Dell Lenovo Thinkpad T14 Gen 1', 'EQCC000000001', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(426, NULL, 'Dell 3420', 'DNV8FG3', 'Agora Csc S.a.s 6 - Csc Costos', 448, 'Activo', NULL, NULL, 1),
(427, NULL, 'Dell 3420', '4SV8FG3', 'Agora Csc S.a.s 6 - Csc Cxp', 520, 'Activo', NULL, NULL, 1),
(428, NULL, 'Dell Bogotá', 'JLZBQ04', 'Gradezco - Segmento Aseo Comercial', 608, 'Activo', NULL, NULL, 1),
(429, NULL, 'Dell Hp Zbook Firefly 14 G8', 'EQCC000000006', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(430, NULL, 'Dell Lenovo Thinkpad E14 Gen 2', 'EQCC000000003', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(431, NULL, 'Dell 3080', '6XM72G3', 'Gradezco - Segmento Alimentos Mantenimiento', 556, 'Activo', NULL, NULL, 1),
(432, NULL, 'Dell Hp All In One Elite One 800 G2', 'EQCC000000060', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(433, NULL, 'Dell 3420', '1DFF2B3', 'Gradezco - Segmento Alimentos Gerencia General', 280, 'Activo', NULL, NULL, 1),
(434, NULL, 'Dell 3080', '67MFMH3', 'Gradezco - Segmento Aseo Planta Detergentes', 580, 'Activo', NULL, NULL, 1),
(435, NULL, 'Dell 5490', '37PNLQ2', 'Agora Csc S.a.s', NULL, 'Activo', NULL, NULL, 1),
(436, NULL, 'Dell E5470', '4ZC7ZF2', 'Agora Csc S.a.s', 417, 'Activo', NULL, NULL, 1),
(437, NULL, 'Dell 7070', 'GBP4PY2', 'Gradezco - Segmento Nutricion Animal', 358, 'Activo', NULL, NULL, 1),
(438, NULL, 'Dell 3000', '46X26S3', 'Oro Rojo', 763, 'Activo', NULL, NULL, 1),
(439, NULL, 'Dell', 'G34CQ04', 'Gradezco - Segmento Nutricion Animal Agri', 560, 'Activo', NULL, NULL, 1),
(440, NULL, 'Dell 3440', 'HNX65Y3', 'Oleariari', 763, 'Activo', NULL, NULL, 1),
(441, NULL, 'Dell E5470', 'D6QGXF2', 'Gradezco - Segmento Alimentos 1 - Jefatura Juridica Comercial', 620, 'Activo', NULL, NULL, 1),
(442, NULL, 'Dell Hp Zbook Firefly 14 G10', 'EQCC000000098', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(443, NULL, 'Dell Lenovo Thinkpad X1 Carbon', 'EQCC000000063', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(444, NULL, 'Dell 3420', 'G7W8FG3', 'Gradezco - Segmento Aseo Supply Chain', 578, 'Activo', NULL, NULL, 1),
(445, NULL, 'Dell 7050', '3XVGXM2', 'Gradezco - Segmento Nutricion Animal', 410, 'Activo', NULL, NULL, 1),
(446, NULL, 'Dell 3080', '6XC92G3', 'Gradezco - Segmento Nutricion Animal', 348, 'Activo', NULL, NULL, 1),
(447, NULL, 'Dell 3420', '5YV8FG3', 'Gradezco - Segmento Aseo Mercadeo', 167, 'Activo', NULL, NULL, 1),
(448, NULL, 'Dell 3420', '1JFF2B3', 'Gradezco - Segmento Alimentos Trade', 618, 'Activo', NULL, NULL, 1),
(449, NULL, 'Dell 3440', 'H40CQ04', 'Gradezco - Segmento Aseo Cali', 226, 'Activo', NULL, NULL, 1),
(450, NULL, 'Dell 3420', 'BJVBFG3', 'Gradezco - Segmento Nutricion Animal Consumer', 645, 'Activo', NULL, NULL, 1),
(451, NULL, 'Dell 3420', '2KW8FG3', 'Agora Csc S.a.s', NULL, 'Activo', NULL, NULL, 1),
(452, NULL, 'Dell 3420', 'BZV8FG3', 'Gradezco - Segmento Nutricion Animal Control De Calidad', 166, 'Activo', NULL, NULL, 1),
(453, NULL, 'Dell 7040', 'JT7CJH2', 'Gradezco - Segmento Aseo', 327, 'Activo', NULL, NULL, 1),
(454, NULL, 'Dell 3080', '68JFMH3', 'Gradezco - Segmento Aseo', 373, 'Activo', NULL, NULL, 1),
(455, NULL, 'Dell 7060', '38W5XQ2', 'Gradezco - Segmento Aseo', 332, 'Activo', NULL, NULL, 1),
(456, NULL, 'Dell 9020', 'FHMHF42', 'Gradezco - Segmento Alimentos', 763, 'Activo', NULL, NULL, 1),
(457, NULL, 'Dell 3080', '67N9MH3', 'Gradezco - Segmento Aseo', 371, 'Activo', NULL, NULL, 1),
(458, NULL, 'Dell 3080', '6XKF2G3', 'Gradezco - Segmento Nutricion Animal', 351, 'Activo', NULL, NULL, 1),
(459, NULL, 'Dell 9020', '7T1X482', 'Gradezco - Segmento Aseo', 320, 'Activo', NULL, NULL, 1),
(460, NULL, 'Dell 3080', '67P9MH3', 'Gradezco - Segmento Aseo', NULL, 'Activo', NULL, NULL, 1),
(461, NULL, 'Dell 7040', 'H8C5HH2', 'Gradezco - Segmento Aseo', 324, 'Activo', NULL, NULL, 1),
(462, NULL, 'Dell 3080', '67LBMH3', 'Gradezco - Segmento Aseo', 379, 'Activo', NULL, NULL, 1),
(463, NULL, 'Dell 3080', '68JHMH3', 'Gradezco - Segmento Aseo Innovacion Y Desarrolllo', 11, 'Activo', NULL, NULL, 1),
(464, NULL, 'Dell 3080', '53HCMH3', 'Gradezco - Segmento Aseo', 399, 'Activo', NULL, NULL, 1),
(465, NULL, 'Dell 3080', '53GCMH3', 'Gradezco - Segmento Aseo Almacen De Repuestos', 462, 'Activo', NULL, NULL, 1),
(466, NULL, 'Dell 3000', '56X2GS3', 'Oro Rojo', 763, 'Activo', NULL, NULL, 1),
(467, NULL, 'Dell 990', 'BL791R1', 'Gradezco - Segmento Alimentos', 414, 'Activo', NULL, NULL, 1),
(468, NULL, 'Dell 7010', 'DXZPK02', 'Gradezco - Segmento Alimentos', 295, 'Activo', NULL, NULL, 1),
(469, NULL, 'Dell 3450', '2Z0RG22', 'Oro Rojo', 763, 'Activo', NULL, NULL, 1),
(470, NULL, 'Dell 3420', '7YV8FG3', 'Gradezco - Segmento Nutricion Animal Compras', 208, 'Activo', NULL, NULL, 1),
(471, NULL, 'Dell 3420', '9QV8FG3', 'Agora Csc S.a.s 6 - Csc Tic - General', 270, 'Activo', NULL, NULL, 1),
(472, NULL, 'Dell 3420', 'J8WBFG3', 'Gradezco - Segmento Nutricion Animal Consumer', 549, 'Activo', NULL, NULL, 1),
(473, NULL, 'Dell 3410', 'G6LD863', 'Gradezco - Segmento Aseo', 341, 'Activo', NULL, NULL, 1),
(474, NULL, 'Dell 3420', 'BQV8FG3', 'Gradezco - Segmento Aseo Ingenieria Y Mantenimiento', 615, 'Activo', NULL, NULL, 1),
(475, NULL, 'Dell 3420', '87W8FG3', 'Agora Csc S.a.s 6 - Csc Tic - General', 269, 'Activo', NULL, NULL, 1),
(476, NULL, 'Dell Lenovo Thinkpad E470', 'EQCC000000147', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(477, NULL, 'Dell 3410', 'FCLD863', 'Gradezco - Segmento Aseo', 342, 'Activo', NULL, NULL, 1),
(478, NULL, 'Dell 3440', '3DZBQ04', 'Gradezco - Segmento Aseo Ventas Tradicionales', 115, 'Activo', NULL, NULL, 1),
(479, NULL, 'Dell 3440', 'BNX65Y3', 'Oleariari', 763, 'Activo', NULL, NULL, 1),
(480, NULL, 'Dell 3420', '15W8FG3', 'Agora Csc S.a.s 7 - Oficina Calle 79', 566, 'Activo', NULL, NULL, 1),
(481, NULL, 'Dell 3420', '6ZV8FG3', 'Gradezco - Segmento Nutricion Animal Control De Calidad', 479, 'Activo', NULL, NULL, 1),
(482, NULL, 'Dell 3080', '53G9MH', 'Gradezco - Segmento Aseo Sabiz', 535, 'Activo', NULL, NULL, 1),
(483, NULL, 'Dell 3420', '8RV8FG3', 'Agora Csc S.a.s Lineas', 83, 'Activo', NULL, NULL, 1),
(484, NULL, 'Dell Lenovo Thinkpad X1 Extreme', 'EQCC000000207', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(485, NULL, 'Dell 7050', 'J43Y8M2', 'Gradezco - Segmento Nutricion Animal', 763, 'Activo', NULL, NULL, 1),
(486, NULL, 'Dell 7050', 'J43Y8N2', 'Gradezco - Segmento Nutricion Animal Bascula', 585, 'Activo', NULL, NULL, 1),
(487, NULL, 'Dell Bogotá', 'B7S7282', 'Gradezco - Segmento Aseo Liquidos', 27, 'Activo', NULL, NULL, 1),
(488, NULL, 'Dell 3000', '36X26S3', 'Oro Rojo', 763, 'Activo', NULL, NULL, 1),
(489, NULL, 'Dell Asus X415ea-ek566', 'EQCC000000059', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(490, NULL, 'Dell 3410', '9CLD863', 'Gradezco - Segmento Aseo Ventas Panaderia', 458, 'Activo', NULL, NULL, 1),
(491, NULL, 'Dell 3440', '8MZBQ04', 'Gradezco - Segmento Aseo Pereira', 457, 'Activo', NULL, NULL, 1),
(492, NULL, 'Dell 3080', '6XPG2G3', 'Gradezco - Segmento Alimentos Tesoreria', 522, 'Activo', NULL, NULL, 1),
(493, NULL, 'Dell 3420', '5ZV8FG3', 'Gradezco - Segmento Nutricion Animal Consumer', 268, 'Activo', NULL, NULL, 1),
(494, NULL, 'Dell 3440', '640CQ04', 'Gradezco - Segmento Aseo Ventas Cadenas', 64, 'Activo', NULL, NULL, 1),
(495, NULL, 'Dell 7050', '4JMXWK2', 'Gradezco - Segmento Aseo Operaciones Y Logistica', 118, 'Activo', NULL, NULL, 1),
(496, NULL, 'Dell 9020', '7T1W482', 'Gradezco - Segmento Aseo Operaciones Y Logistica', 118, 'Activo', NULL, NULL, 1),
(497, NULL, 'Dell Lenovo All In One V510z 23\"', 'EQCC000000146', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(498, NULL, 'Dell 3420', '6SV8FG3', 'Gradezco - Segmento Aseo Relaciones Laborales', 34, 'Activo', NULL, NULL, 1),
(499, NULL, 'Dell 7050', '674WKH2', 'Gradezco - Segmento Nutricion Animal', 763, 'Activo', NULL, NULL, 1),
(500, NULL, 'Dell 7050', '5FNZHN2', 'Gradezco - Segmento Aseo', 763, 'Activo', NULL, NULL, 1),
(501, NULL, 'Dell Lenovo Thinkpad E14', 'EQCC000000019', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(502, NULL, 'Dell Lenovo Thinkpad L14 Gen 3', 'EQCC000000035', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1);
INSERT INTO `tbl_equipos` (`Id_Equipo`, `Codigo_Inventario`, `Marca_Equipo`, `Numero_Serie`, `Ubicacion_Equipo`, `Propietario_Equipo`, `Estado_Equipo`, `Fecha_Ad_Equipo`, `Id_Archivo`, `Id_Tipo_Equipo`) VALUES
(503, NULL, 'Dell 3080', '67MGMH3', 'Gradezco - Segmento Aseo', 377, 'Activo', NULL, NULL, 1),
(504, NULL, 'Dell 7040', 'JT7DJH2', 'Gradezco - Segmento Aseo', 326, 'Activo', NULL, NULL, 1),
(505, NULL, 'Dell 3080', '53H8MH3', 'Gradezco - Segmento Aseo Gestion Documental', 249, 'Activo', NULL, NULL, 1),
(506, NULL, 'Dell 3410', '6BLD863', 'Gradezco - Segmento Aseo Gestion Documental', 249, 'Activo', NULL, NULL, 1),
(507, NULL, 'Dell 7440', 'HK0JRW3', 'Gradezco - Segmento Aseo Gerencia General', 658, 'Activo', NULL, NULL, 1),
(508, NULL, 'Dell 3440', 'GMZBQ04', 'Gradezco - Segmento Aseo Cali', 537, 'Activo', NULL, NULL, 1),
(509, NULL, 'Dell 7040', 'JT7CKH2', 'Gradezco - Segmento Aseo', 325, 'Activo', NULL, NULL, 1),
(510, NULL, 'Dell 3420', '84W8FG3', 'Gradezco - Segmento Nutricion Animal Mantenimiento', 67, 'Activo', NULL, NULL, 1),
(511, NULL, 'Dell 3080', '53GJMH3', 'Gradezco - Segmento Aseo 0', 533, 'Activo', NULL, NULL, 1),
(512, NULL, 'Dell 3420', '58W8FG3', 'Agora Csc S.a.s 7 - Oficina Cra 35', 486, 'Activo', NULL, NULL, 1),
(513, NULL, 'Dell Lenovo Thinkpad E480', 'EQCC000000186', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(514, NULL, 'Dell', '1CZBQ04', 'Gradezco - Segmento Aseo Medellin', 484, 'Activo', NULL, NULL, 1),
(515, NULL, 'Dell 3080', '67RBMH3', 'Gradezco - Segmento Aseo Relaciones Laborales', 468, 'Activo', NULL, NULL, 1),
(516, NULL, 'Dell 3080', '53HFMH3', 'Gradezco - Segmento Aseo Control De Calidad', 453, 'Activo', NULL, NULL, 1),
(517, NULL, 'Dell 7040', 'H8BBHH2', 'Gradezco - Segmento Aseo Control De Calidad', 453, 'Activo', NULL, NULL, 1),
(518, NULL, 'Dell 3420', '2QV8FG3', 'Agora Csc S.a.s 6 - Subgerencia De Control - General', 543, 'Activo', NULL, NULL, 1),
(519, NULL, 'Dell 3581', '4D5Q114', 'Aliatesp', NULL, 'Activo', NULL, NULL, 1),
(520, NULL, 'Dell 3080', '53G9MH3', 'Gradezco - Segmento Aseo Llenado', 436, 'Activo', NULL, NULL, 1),
(521, NULL, 'Dell 7050', '1NWCJL2', 'Gradezco - Segmento Aseo Control De Calidad', 494, 'Activo', NULL, NULL, 1),
(522, NULL, 'Dell 3410', '7DLD863', 'Gradezco - Segmento Aseo', 343, 'Activo', NULL, NULL, 1),
(523, NULL, 'Dell 3450', '5R0ZS34', 'Agora Csc S.a.s 6 - Dirección Financiera - General', 30, 'Activo', NULL, NULL, 1),
(524, NULL, 'Dell 3080', '6XMD2G3', 'Agora Csc S.a.s 6 - Csc Cxp', 222, 'Activo', NULL, NULL, 1),
(525, NULL, 'Dell 3080', '68J8MH3', 'Gradezco - Segmento Aseo', 136, 'Activo', NULL, NULL, 1),
(526, NULL, 'Dell 3080', '67M8MH3', 'Gradezco - Segmento Aseo Duitama', 455, 'Activo', NULL, NULL, 1),
(527, NULL, 'Dell 3080', '68ZBMH3', 'Gradezco - Segmento Aseo Tesoreria', 542, 'Activo', NULL, NULL, 1),
(528, NULL, 'Dell 3080', '68JCMH3', 'Gradezco - Segmento Aseo Control De Calidad', 98, 'Activo', NULL, NULL, 1),
(529, NULL, 'Dell 3080', '68JDMH3', 'Gradezco - Segmento Aseo Villavicencio', 544, 'Activo', NULL, NULL, 1),
(530, NULL, 'Dell 3080', '6XL92G3', 'Gradezco - Segmento Nutricion Animal Relaciones Laborales', 210, 'Activo', NULL, NULL, 1),
(531, NULL, 'Dell Hp Zbook Firefly 14 G7', 'EQCC000000037', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(532, NULL, 'Dell 3420', '1PV8FG3', 'Gradezco - Segmento Aseo Mercaderismo', 476, 'Activo', NULL, NULL, 1),
(533, NULL, 'Dell Lenovo Thinkpad E480', 'EQCC000000169', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(534, NULL, 'Dell 3420', '6RV8FG3', 'Agora Csc S.a.s 6 - Csc Nómina - General', 499, 'Activo', NULL, NULL, 1),
(535, NULL, 'Dell 3080', '68HFMH3', 'Gradezco - Segmento Aseo Pailas', 289, 'Activo', NULL, NULL, 1),
(536, NULL, 'Dell 3440', 'DNX65Y3', 'Oleariari', 763, 'Activo', NULL, NULL, 1),
(537, NULL, 'Dell 3420', 'GPV8FG3', 'Agora Csc S.a.s 6 - Corporativos Indupalma - General', 495, 'Activo', NULL, NULL, 1),
(538, NULL, 'Dell 3080', '67LCMH3', 'Gradezco - Segmento Aseo Tesoreria', 478, 'Activo', NULL, NULL, 1),
(539, NULL, 'Dell Lenovo Thinkbook 15 G4', 'EQCC000000034', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(540, NULL, 'Dell Lenovo Thinkpad E14 Gen 3', 'EQCC000000028', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(541, NULL, 'Dell 3080', '690BMH3', 'Gradezco - Segmento Aseo Operaciones Y Logistica', 489, 'Activo', NULL, NULL, 1),
(542, NULL, 'Dell 3080', '68KCMH3', 'Gradezco - Segmento Aseo Control De Calidad', 449, 'Activo', NULL, NULL, 1),
(543, NULL, 'Dell 3080', '690HMH3', 'Gradezco - Segmento Aseo Pereira', 198, 'Activo', NULL, NULL, 1),
(544, NULL, 'Dell 5490', '78X3JR2', 'Gradezco - Segmento Nutricion Animal', 763, 'Activo', NULL, NULL, 1),
(545, NULL, 'Dell 3080', '53GHMH3', 'Gradezco - Segmento Aseo', 395, 'Activo', NULL, NULL, 1),
(546, NULL, 'Dell 5480', '7ZPKJM2', 'Gradezco - Segmento Aseo Sap Nova', 288, 'Activo', NULL, NULL, 1),
(547, NULL, 'Dell 3080', '68ZFMH3', 'Gradezco - Segmento Aseo Bascula', 573, 'Activo', NULL, NULL, 1),
(548, NULL, 'Dell 3080', '6XKC2G3', 'Gradezco - Segmento Alimentos Seguridad Y Prevencion De Perdidas', 626, 'Activo', NULL, NULL, 1),
(549, NULL, 'Dell 3440', 'H24CQ04', 'Gradezco - Segmento Aseo Comercial', 205, 'Activo', NULL, NULL, 1),
(550, NULL, 'Dell 3440', 'C30CQ04', 'Gradezco - Segmento Aseo Pereira', 93, 'Activo', NULL, NULL, 1),
(551, NULL, 'Dell 3420', '6YV8FG3', 'Gradezco - Segmento Nutricion Animal Consumer', 631, 'Activo', NULL, NULL, 1),
(552, NULL, 'Dell 7320', '9MRMST3', 'Gradezco - Segmento Aseo Gerencia General', 266, 'Activo', NULL, NULL, 1),
(553, NULL, 'Dell 3420', '48W8FG3', 'Agora Csc S.a.s', 426, 'Activo', NULL, NULL, 1),
(554, NULL, 'Dell 3080', '53HDMH3', 'Gradezco - Segmento Aseo Mantenimiento', 654, 'Activo', NULL, NULL, 1),
(555, NULL, 'Dell 3581', '8C5Q114', 'Aliatesp', NULL, 'Activo', NULL, NULL, 1),
(556, NULL, 'Dell 3410', '3DLD863', 'Gradezco - Segmento Aseo Ventas Supermercados', 285, 'Activo', NULL, NULL, 1),
(557, NULL, 'Dell 3080', '67Q8MH3', 'Gradezco - Segmento Aseo Tms', 58, 'Activo', NULL, NULL, 1),
(558, NULL, 'Dell 790', '5BPLVV1', 'Gradezco - Segmento Alimentos', 411, 'Activo', NULL, NULL, 1),
(559, NULL, 'Dell 3420', '5BWBFG3', 'Agora Csc S.a.s 6 - Csc Conciliaciones', 144, 'Activo', NULL, NULL, 1),
(560, NULL, 'Dell 3080', '53HKMH3', 'Gradezco - Segmento Aseo Crm', 17, 'Activo', NULL, NULL, 1),
(561, NULL, 'Dell 3440', '340CQ04', 'Gradezco - Segmento Aseo Medellin', 444, 'Activo', NULL, NULL, 1),
(562, NULL, 'Dell 3420', '8SV8FG3', 'Gradezco - Segmento Aseo Mercadeo', 500, 'Activo', NULL, NULL, 1),
(563, NULL, 'Dell 3080', '690CMH3', 'Gradezco - Segmento Aseo Ibague', 243, 'Activo', NULL, NULL, 1),
(564, NULL, 'Dell 3440', '1MZBQ04', 'Gradezco - Segmento Aseo Ibague', 431, 'Activo', NULL, NULL, 1),
(565, NULL, 'Dell 3440', 'JKZBQ04', 'Gradezco - Segmento Aseo Duitama', 463, 'Activo', NULL, NULL, 1),
(566, NULL, 'Dell 3420', 'C7W8FG3', 'Agora Csc S.a.s 6 - Csc Conciliaciones', 124, 'Activo', NULL, NULL, 1),
(567, NULL, 'Dell Lenovo Thinkpad E14 Gen 5', 'EQCC000000039', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(568, NULL, 'Dell 3080', '6YXCMH3', 'Gradezco - Segmento Aseo Liquidos', 640, 'Activo', NULL, NULL, 1),
(569, NULL, 'Dell 3440', 'CNX65Y3', 'Oleariari', 763, 'Activo', NULL, NULL, 1),
(570, NULL, 'Dell 3080', '6XLD2G3', 'Agora Csc S.a.s 6 - Csc Cxp', 505, 'Activo', NULL, NULL, 1),
(571, NULL, 'Dell 3420', 'FCFF2B3', 'Gradezco - Segmento Alimentos Mercadeo', 538, 'Activo', NULL, NULL, 1),
(572, NULL, 'Dell 3420', '3BWBFG3', 'Agora Csc S.a.s 6 - Csc Estados Financieros Y Reportes', 194, 'Activo', NULL, NULL, 1),
(573, NULL, 'Dell 3420', '6K41DS3', 'Agora Csc S.a.s 6 - Dirección Financiera - General', 63, 'Activo', NULL, NULL, 1),
(574, NULL, 'Dell 3420', '6JVBFG3', 'Gradezco - Segmento Aseo Cartera', 513, 'Activo', NULL, NULL, 1),
(575, NULL, 'Dell 3420', '5RV8FG3', 'Agora Csc S.a.s 6 - Csc Nómina - General', 53, 'Activo', NULL, NULL, 1),
(576, NULL, 'Dell 3080', '6Z48MH3', 'Gradezco - Segmento Aseo Tms', 523, 'Activo', NULL, NULL, 1),
(577, NULL, 'Dell 3410', 'DCLD863', 'Gradezco - Segmento Aseo Ventas Supermercados', 157, 'Activo', NULL, NULL, 1),
(578, NULL, 'Dell 3080', '6XKJ2G3', 'Gradezco - Segmento Nutricion Animal', 354, 'Activo', NULL, NULL, 1),
(579, NULL, 'Dell 760', 'G3LW0L1', 'Gradezco - Segmento Alimentos', NULL, 'Activo', NULL, NULL, 1),
(580, NULL, 'Dell 3420', '9YV8FG3', 'Agora Csc S.a.s 6 - Csc Cxp', 61, 'Activo', NULL, NULL, 1),
(581, NULL, 'Dell 3420', '23WBFG3', 'Agora Csc S.a.s 6 - Csc Impuestos', 90, 'Activo', NULL, NULL, 1),
(582, NULL, 'Dell E5470', '7JCCVF2', 'Gradezco - Segmento Aseo Selección Y Formación', 21, 'Activo', NULL, NULL, 1),
(583, NULL, 'Dell 3080', '67RFMH3', 'Gradezco - Segmento Aseo Ambiental E Inocuidad', 87, 'Activo', NULL, NULL, 1),
(584, NULL, 'Dell 3410', '96LD863', 'Gradezco - Segmento Aseo', 344, 'Activo', NULL, NULL, 1),
(585, NULL, 'Dell Lenovo All In One V510z 23\"', 'EQCC000000181', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(586, NULL, 'Dell 3420', '2L24SG3', 'Gradezco - Segmento Aseo Ventas Cadenas', 74, 'Activo', NULL, NULL, 1),
(587, NULL, 'Dell 3080', '6XCD2G3', 'Gradezco - Segmento Alimentos Control De Calidad', 652, 'Activo', NULL, NULL, 1),
(588, NULL, 'Dell 3080', '6XD82G3', 'Gradezco - Segmento Nutricion Animal Innovacion Y Desarrolllo', 186, 'Activo', NULL, NULL, 1),
(589, NULL, 'Dell 3420', '7JVBFG3', 'Gradezco - Segmento Nutricion Animal 4 - Investigacion Y Desarrollo', 447, 'Activo', NULL, NULL, 1),
(590, NULL, 'Dell 3420', '93YJXL3', 'Oro Rojo', 763, 'Activo', NULL, NULL, 1),
(591, NULL, 'Dell 3420', '7ZV8FG3', 'Gradezco - Segmento Aseo Agri', 202, 'Activo', NULL, NULL, 1),
(592, NULL, 'Dell 3420', '9SV8FG3', 'Gradezco - Segmento Aseo Ventas Internacionales', 89, 'Activo', NULL, NULL, 1),
(593, NULL, 'Dell 9020', '7ZWPX12', 'Gradezco - Segmento Alimentos Barranquilla', 646, 'Activo', NULL, NULL, 1),
(594, NULL, 'Dell 3420', '5JFF2B3', 'Gradezco - Segmento Alimentos Gerencia General', 621, 'Activo', NULL, NULL, 1),
(595, NULL, 'Dell Prob760m', 'MS7D99', 'Gradezco - Segmento Alimentos Mercadeo', 6, 'Activo', NULL, NULL, 1),
(596, NULL, 'Dell 3080', '67LGMH3', 'Gradezco - Segmento Aseo Sap Nova', 548, 'Activo', NULL, NULL, 1),
(597, NULL, 'Dell 5480', 'BRWKJM2', 'Gradezco - Segmento Aseo Sap Nova', 548, 'Activo', NULL, NULL, 1),
(598, NULL, 'Dell 7040', 'DQNKSD2', 'Gradezco - Segmento Aseo', 763, 'Activo', NULL, NULL, 1),
(599, NULL, 'Dell 7050', 'HXRYB62', 'Gradezco - Segmento Aseo', 763, 'Activo', NULL, NULL, 1),
(600, NULL, 'Dell 3420', '25W8FG3', 'Gradezco - Segmento Aseo Mantenimiento', 284, 'Activo', NULL, NULL, 1),
(601, NULL, 'Dell 5480', '77TY5M2', 'Gradezco - Segmento Aseo Mantenimiento', 284, 'Activo', NULL, NULL, 1),
(602, NULL, 'Dell 3420', '9L41DS3', 'Agora Csc S.a.s 6 - Csc Tic - General', 628, 'Activo', NULL, NULL, 1),
(603, NULL, 'Dell Lenovo Thinkpad E14 G5', 'PF52LTSS', 'Gradezco - Segmento Aseo 6 - Csc Tic - General', 649, 'Activo', NULL, NULL, 1),
(604, NULL, 'Dell Hp Zbook Firefly 16 G10', 'EQCC000000042', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(605, NULL, 'Dell 3080', '53HHMH3', 'Gradezco - Segmento Aseo Operaciones Y Logistica', 49, 'Activo', NULL, NULL, 1),
(606, NULL, 'Dell 3080', '6Z4FMH3', 'Gradezco - Segmento Aseo', 387, 'Activo', NULL, NULL, 1),
(607, NULL, 'Dell 3420', 'FNV8FG3', 'Gradezco - Segmento Aseo 2 - Ventas Tradicionales', 46, 'Activo', NULL, NULL, 1),
(608, NULL, 'Dell 3080', '6XMF2G3', 'Gradezco - Segmento Nutricion Animal 2 - Subgerencia Administrativa', 609, 'Activo', NULL, NULL, 1),
(609, NULL, 'Dell', '8CLD863', 'Gradezco - Segmento Alimentos', 340, 'Activo', NULL, NULL, 1),
(610, NULL, 'Dell 3420', '4KW8FG3', 'Agora Csc S.a.s 6 - Csc Tic - General', 547, 'Activo', NULL, NULL, 1),
(611, NULL, 'Dell 3581', '7FL8LY3', 'Aliatesp', NULL, 'Activo', NULL, NULL, 1),
(612, NULL, 'Dell 3440', '530CQ04', 'Gradezco - Segmento Aseo Ibague', 656, 'Activo', NULL, NULL, 1),
(613, NULL, 'Dell 3080', '6XF82G3', 'Gradezco - Segmento Nutricion Animal Mantenimiento', 223, 'Activo', NULL, NULL, 1),
(614, NULL, 'Dell 3080', '68HJMH3', 'Gradezco - Segmento Aseo Operaciones Y Logistica', 161, 'Activo', NULL, NULL, 1),
(615, NULL, 'Dell E5470', '9PJGXF2', 'Gradezco - Segmento Aseo Selección Y Formación', 23, 'Activo', NULL, NULL, 1),
(616, NULL, 'Dell 7050', '1NWBJL2', 'Gradezco - Segmento Aseo', 329, 'Activo', NULL, NULL, 1),
(617, NULL, 'Dell 9020', 'HPYJS52', 'Gradezco - Segmento Aseo', 763, 'Activo', NULL, NULL, 1),
(618, NULL, 'Dell 3440', '1LZBQ04', 'Gradezco - Segmento Aseo Cali', 273, 'Activo', NULL, NULL, 1),
(619, NULL, 'Dell 3080', '6XCG2G3', 'Gradezco - Segmento Nutricion Animal Inventarios', 207, 'Activo', NULL, NULL, 1),
(620, NULL, 'Dell 7050', '3C7VGM2', 'Gradezco - Segmento Aseo Tensoactivos', 623, 'Activo', NULL, NULL, 1),
(621, NULL, 'Dell 7050', 'DKSTBM2', 'Gradezco - Segmento Aseo Tensoactivos', 623, 'Activo', NULL, NULL, 1),
(622, NULL, 'Dell 3420', 'C3YJXL3', 'Oro Rojo', 763, 'Activo', NULL, NULL, 1),
(623, NULL, 'Dell 7320', '4CMM1J3', 'Agora Csc S.a.s 6 - Dirección - General', 570, 'Activo', NULL, NULL, 1),
(624, NULL, 'Dell 3080', '6XP92G3', 'Gradezco - Segmento Alimentos', NULL, 'Activo', NULL, NULL, 1),
(625, NULL, 'Dell 3420', 'GNV8FG3', 'Agora Csc S.a.s 0', 571, 'Activo', NULL, NULL, 1),
(626, NULL, 'Dell 3080', '6YXFMH3', 'Gradezco - Segmento Aseo Planta Liquidos', 592, 'Activo', NULL, NULL, 1),
(627, NULL, 'Dell 7040', 'J04MCH2', 'Gradezco - Segmento Aseo Planta Liquidos', 592, 'Activo', NULL, NULL, 1),
(628, NULL, 'Dell 3080', '67PJMH3', 'Gradezco - Segmento Aseo Tensoactivos', 81, 'Activo', NULL, NULL, 1),
(629, NULL, 'Dell 3420', 'BT5TSG3', 'Agora Csc S.a.s 6 - Csc Tic - General', 142, 'Activo', NULL, NULL, 1),
(630, NULL, 'Dell E5450', '97FXN32', 'Gradezco - Segmento Alimentos Mesa De Ayuda', 591, 'Activo', NULL, NULL, 1),
(631, NULL, 'Dell 3420', '43YJXL3', 'Oro Rojo', 763, 'Activo', NULL, NULL, 1),
(632, NULL, 'Dell 3581', 'JC5Q114', 'Aliatesp', NULL, 'Activo', NULL, NULL, 1),
(633, NULL, 'Dell 3080', '6Z4JMH3', 'Gradezco - Segmento Aseo Relaciones Laborales', 182, 'Activo', NULL, NULL, 1),
(634, NULL, 'Dell 3581', '7ML8LY3', 'Aliatesp', NULL, 'Activo', NULL, NULL, 1),
(635, NULL, 'Dell 7040', 'JT78JH2', 'Gradezco - Segmento Aseo Esponjillas', 546, 'Activo', NULL, NULL, 1),
(636, NULL, 'Dell 3420', '69WBFG3', 'Gradezco - Segmento Aseo', 347, 'Activo', NULL, NULL, 1),
(637, NULL, 'Dell Micro 7010', 'GMY8FZ3', 'Oleariari', 763, 'Activo', NULL, NULL, 1),
(638, NULL, 'Dell 3420', '18W8FG3', 'Agora Csc S.a.s 6 - Csc Tic - General', 128, 'Activo', NULL, NULL, 1),
(639, NULL, 'Dell 3581', '5D5Q114', 'Aliatesp', NULL, 'Activo', NULL, NULL, 1),
(640, NULL, 'Dell 3440', 'GNX65Y3', 'Oleariari', 763, 'Activo', NULL, NULL, 1),
(641, NULL, 'Dell 3080', '6XKD2G3', 'Gradezco - Segmento Nutricion Animal Operaciones Y Logistica', 601, 'Activo', NULL, NULL, 1),
(642, NULL, 'Dell 3000', '76X26S3', 'Oro Rojo', 763, 'Activo', NULL, NULL, 1),
(643, NULL, 'Dell 3420', '55W8FG3', 'Agora Csc S.a.s 6 - Csc Costos', 250, 'Activo', NULL, NULL, 1),
(644, NULL, 'Dell 3080', '67LDMH3', 'Gradezco - Segmento Aseo Mantenimiento', 196, 'Activo', NULL, NULL, 1),
(645, NULL, 'Dell 3420', '8YV8FG3', 'Gradezco - Segmento Nutricion Animal Gerencia General', 562, 'Activo', NULL, NULL, 1),
(646, NULL, 'Dell 3080', '67NJMH3', 'Gradezco - Segmento Aseo Tesoreria', 216, 'Activo', NULL, NULL, 1),
(647, NULL, 'Dell Lenovo Thinkpad E14 Gen 5', 'EQCC000000050', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(648, NULL, 'Dell 3080', '6YYBMH3', 'Gradezco - Segmento Aseo Operaciones Y Logistica', 258, 'Activo', NULL, NULL, 1),
(649, NULL, 'Dell 3420', '42WBFG3', 'Gradezco - Segmento Aseo Tms', 263, 'Activo', NULL, NULL, 1),
(650, NULL, 'Dell 7320', 'CZPQTT2', 'Agora Csc S.a.s Tms', 247, 'Activo', NULL, NULL, 1),
(651, NULL, 'Dell 7050', 'HXRDXH2', 'Gradezco - Segmento Aseo', NULL, 'Activo', NULL, NULL, 1),
(652, NULL, 'Dell 3080', '6XNC2G3', 'Gradezco - Segmento Nutricion Animal', 356, 'Activo', NULL, NULL, 1),
(653, NULL, 'Dell 3080', '53GDMH3', 'Gradezco - Segmento Aseo Tesoreria', 230, 'Activo', NULL, NULL, 1),
(654, NULL, 'Dell 3420', 'HPV8FG3', 'Agora Csc S.a.s 6 - Csc Tic - General', 233, 'Activo', NULL, NULL, 1),
(655, NULL, 'Dell 3000', 'J5X26S3', 'Oro Rojo', 763, 'Activo', NULL, NULL, 1),
(656, NULL, 'Dell 3080', '6YY9MH3', 'Gradezco - Segmento Aseo 2 - Distribucion', 466, 'Activo', NULL, NULL, 1),
(657, NULL, 'Dell Macbook Air', 'KCD21436KT', 'Gradezco - Segmento Alimentos Compras', 481, 'Activo', NULL, NULL, 1),
(658, NULL, 'Dell 3080', '6XDB2G3', 'Gradezco - Segmento Nutricion Animal', 352, 'Activo', NULL, NULL, 1),
(659, NULL, 'Dell 3080', '6YY8MH3', 'Gradezco - Segmento Aseo Planta Detergentes', 552, 'Activo', NULL, NULL, 1),
(660, NULL, 'Dell 3080', '6XDF2G3', 'Gradezco - Segmento Alimentos 1 - Superintendencia De Ingenieria Y Mantenimiento', 287, 'Activo', NULL, NULL, 1),
(661, NULL, 'Dell 3420', '7NV8FG3', 'Agora Csc S.a.s 6 - Csc Tic - General', 225, 'Activo', NULL, NULL, 1),
(662, NULL, 'Dell 3080', '67LJMH3', 'Gradezco - Segmento Aseo Servicios Administrativos', 26, 'Activo', NULL, NULL, 1),
(663, NULL, 'Dell 3080', '6YYHMH3', 'Gradezco - Segmento Aseo Mantenimiento', 599, 'Activo', NULL, NULL, 1),
(664, NULL, 'Dell 3080', '67PHMH3', 'Gradezco - Segmento Aseo Lineas', 641, 'Activo', NULL, NULL, 1),
(665, NULL, 'Dell 7040', 'C9CMJH2', 'Gradezco - Segmento Aseo Lineas', 641, 'Activo', NULL, NULL, 1),
(666, NULL, 'Dell 5400', '8MQJP13', 'Gradezco - Segmento Aseo', 763, 'Activo', NULL, NULL, 1),
(667, NULL, 'Dell 3420', '3KW8FG3', 'Gradezco - Segmento Aseo Subgerencia Administrativa', 439, 'Activo', NULL, NULL, 1),
(668, NULL, 'Dell 3080', '68HKMH3', 'Gradezco - Segmento Aseo Tms', 120, 'Activo', NULL, NULL, 1),
(669, NULL, 'Dell E5450', '16SRH72', 'Gradezco - Segmento Aseo Tms', 120, 'Activo', NULL, NULL, 1),
(670, NULL, 'Dell Lenovo Thinkbook 15 Gen 4', 'EQCC000000029', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(671, NULL, 'Dell 3080', '6XDJ2G3', 'Agora Csc S.a.s 6 - Csc Cxp', 460, 'Activo', NULL, NULL, 1),
(672, NULL, 'Dell 3080', '6XLJ2G3', 'Gradezco - Segmento Nutricion Animal', 355, 'Activo', NULL, NULL, 1),
(673, NULL, 'Dell 3080', '46ZPNK3', 'Gradezco - Segmento Aseo', 408, 'Activo', NULL, NULL, 1),
(674, NULL, 'Dell 3420', '7SV8FG3', 'Gradezco - Segmento Aseo Mesa De Ayuda', 261, 'Activo', NULL, NULL, 1),
(675, NULL, 'Dell 7060', '52Q01T2', 'Gradezco - Segmento Aseo Mesa De Ayuda', 261, 'Activo', NULL, NULL, 1),
(676, NULL, 'Dell 3420', 'D7W8FG3', 'Gradezco - Segmento Aseo', 349, 'Activo', NULL, NULL, 1),
(677, NULL, 'Dell 7040', '3YB8082', 'Gradezco - Segmento Aseo Liquidos', 253, 'Activo', NULL, NULL, 1),
(678, NULL, 'Dell 3080', '6XH92G3', 'Gradezco - Segmento Alimentos Tesoreria', 433, 'Activo', NULL, NULL, 1),
(679, NULL, 'Dell 3080', '6YX9MH3', 'Gradezco - Segmento Aseo Mantenimiento', 173, 'Activo', NULL, NULL, 1),
(680, NULL, 'Dell 3420', '4QV8FG3', 'Agora Csc S.a.s 6 - Csc Tic - General', 146, 'Activo', NULL, NULL, 1),
(681, NULL, 'Dell Micro 7010', 'FN19FZ3', 'Oleariari', 763, 'Activo', NULL, NULL, 1),
(682, NULL, 'Dell 3440', '2YYBQ04', 'Gradezco - Segmento Aseo Barranquilla', 553, 'Activo', NULL, NULL, 1),
(683, NULL, 'Dell 3420', 'DJVBFG3', 'Agora Csc S.a.s', 421, 'Activo', NULL, NULL, 1),
(684, NULL, 'Dell 3420', '4RV8FG3', 'Gradezco - Segmento Nutricion Animal Auditoria', 13, 'Activo', NULL, NULL, 1),
(685, NULL, 'Dell 3080', '6XM92G3', 'Gradezco - Segmento Alimentos Almacen De Repuestos', 597, 'Activo', NULL, NULL, 1),
(686, NULL, 'Dell 3080', '6Z49MH3', 'Gradezco - Segmento Aseo Cartera', 28, 'Activo', NULL, NULL, 1),
(687, NULL, 'Dell 3080', '67LFMH3', 'Gradezco - Segmento Aseo Innovacion Y Desarrolllo', 111, 'Activo', NULL, NULL, 1),
(688, NULL, 'Dell 3420', 'BPV8FG3', 'Agora Csc S.a.s 6 - Dirección Financiera - General', 178, 'Activo', NULL, NULL, 1),
(689, NULL, 'Dell 3440', '620CQ04', 'Gradezco - Segmento Aseo Barranquilla', 440, 'Activo', NULL, NULL, 1),
(690, NULL, 'Dell 3440', '7XYBQ04', 'Gradezco - Segmento Aseo Villavicencio', 647, 'Activo', NULL, NULL, 1),
(691, NULL, 'Dell Lenovo Thinkpad E14', 'EQCC000000020', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(692, NULL, 'Dell Lenovo Thinkpad T14s Gen 2', 'EQCC000000047', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(693, NULL, 'Dell 3080', '67PFMH3', 'Gradezco - Segmento Aseo Nutricion Animal', 254, 'Activo', NULL, NULL, 1),
(694, NULL, 'Dell 7060', '92JLDW2', 'Gradezco - Segmento Aseo Ibague', 655, 'Activo', NULL, NULL, 1),
(695, NULL, 'Dell Tower 5810', 'GZBRB42', 'Gradezco - Segmento Alimentos Mantenimiento', 624, 'Activo', NULL, NULL, 1),
(696, NULL, 'Dell 3080', '6XPB2G3', 'Gradezco - Segmento Alimentos Jurïdico', 201, 'Activo', NULL, NULL, 1),
(697, NULL, 'Dell', '50SMX14', 'Gradezco - Segmento Alimentos Jurïdico', 201, 'Activo', NULL, NULL, 1),
(698, NULL, 'Dell 3440', 'CJZBQ04', 'Aliatesp', NULL, 'Activo', NULL, NULL, 1),
(699, NULL, 'Dell 3420', '62WBFG3', 'Gradezco - Segmento Aseo Contraloria', 482, 'Activo', NULL, NULL, 1),
(700, NULL, 'Dell 3080', '6XHF2G3', 'Gradezco - Segmento Nutricion Animal Seguridad Y Salud En El Trabajo', 536, 'Activo', NULL, NULL, 1),
(701, NULL, 'Dell 3440', 'F20CQ04', 'Gradezco - Segmento Nutricion Animal Seguridad Y Salud En El Trabajo', 536, 'Activo', NULL, NULL, 1),
(702, NULL, 'Dell 3420', '6JFF2B3', 'Gradezco - Segmento Alimentos Ventas Detallistas', 614, 'Activo', NULL, NULL, 1),
(703, NULL, 'Dell 3080', '67PBMH3', 'Gradezco - Segmento Aseo Materiales', 575, 'Activo', NULL, NULL, 1),
(704, NULL, 'Dell 3080', '6XJH2G3', 'Gradezco - Segmento Alimentos Corporativos', 432, 'Activo', NULL, NULL, 1),
(705, NULL, 'Dell 3420', 'GYV8FG3', 'Gradezco - Segmento Nutricion Animal Consumer', 600, 'Activo', NULL, NULL, 1),
(706, NULL, 'Dell 3420', 'FJVBFG3', 'Gradezco - Segmento Nutricion Animal Agri', 610, 'Activo', NULL, NULL, 1),
(707, NULL, 'Dell 3080', '6XBH2G3', 'Gradezco - Segmento Alimentos 0', 56, 'Activo', NULL, NULL, 1),
(708, NULL, 'Dell 3420', '5JVBFG3', 'Agora Csc S.a.s', 707, 'Activo', NULL, NULL, 1),
(709, NULL, 'Dell Lenovo Thinkbook 14 G6', 'PW0BNVJH', 'Agora Csc S.a.s 6 - Csc Tic - General', 255, 'Activo', NULL, NULL, 1),
(710, NULL, 'Dell 3080', '6Z4GMH3', 'Gradezco - Segmento Aseo', NULL, 'Activo', NULL, NULL, 1),
(711, NULL, 'Dell 7060', '92SSDW2', 'Gradezco - Segmento Aseo', NULL, 'Activo', NULL, NULL, 1),
(712, NULL, 'Dell', '4KZBQ04', 'Gradezco - Segmento Aseo Ventas Cadenas', 483, 'Activo', NULL, NULL, 1),
(713, NULL, 'Dell 3410', '93LD863', 'Gradezco - Segmento Aseo', 338, 'Activo', NULL, NULL, 1),
(714, NULL, 'Dell 3420', '8ZV8FG3', 'Gradezco - Segmento Nutricion Animal Comercial', 603, 'Activo', NULL, NULL, 1),
(715, NULL, 'Dell 5480', 'DW0Z5H2', 'Gradezco - Segmento Alimentos Mercaderismo', 450, 'Activo', NULL, NULL, 1),
(716, NULL, 'Dell 3420', 'DRV8FG3', 'Agora Csc S.a.s 6 - Subgerencia De Control - General', 278, 'Activo', NULL, NULL, 1),
(717, NULL, 'Dell 3420', '68W8FG3', 'Gradezco - Segmento Aseo Sap Nova', 518, 'Activo', NULL, NULL, 1),
(718, NULL, 'Dell 7060', '2PMF0Q2', 'Gradezco - Segmento Aseo Sap Nova', 518, 'Activo', NULL, NULL, 1),
(719, NULL, 'Dell 7040', '9RHSND2', 'Gradezco - Segmento Alimentos Ubicacion Especifica', 240, 'Activo', NULL, NULL, 1),
(720, NULL, 'Dell Lenovo Thinkpad E14 Gen 5', 'EQCC000000049', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(721, NULL, 'Dell Hp Zbook Firefly 14 Gen 10', 'EQCC000000089', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(722, NULL, 'Dell 7040', '7D28XG2', 'Gradezco - Segmento Aseo Control De Calidad', 652, 'Activo', NULL, NULL, 1),
(723, NULL, 'Dell 3420', '8T5TSG3', 'Gradezco - Segmento Alimentos Planta Alimentos', 256, 'Activo', NULL, NULL, 1),
(724, NULL, 'Dell Bogotá', '5H70JN2', 'Gradezco - Segmento Aseo Planta Alimentos', 218, 'Activo', NULL, NULL, 1),
(725, NULL, 'Dell 3080', '6XQ82G3', 'Gradezco - Segmento Alimentos Gestion Documental', 590, 'Activo', NULL, NULL, 1),
(726, NULL, 'Dell 3080', '67NGMH3', 'Gradezco - Segmento Aseo Infraestructura Fisica', 252, 'Activo', NULL, NULL, 1),
(727, NULL, 'Dell 3420', '63YJXL3', 'Oro Rojo', 763, 'Activo', NULL, NULL, 1),
(728, NULL, 'Dell 3420', 'JCFF2B3', 'Agora Csc S.a.s 6 - Jurídico - General', 465, 'Activo', NULL, NULL, 1),
(729, NULL, 'Dell Lenovo Thinkbook Plus 2da Gen', 'EQCC000000033', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(730, NULL, 'Dell', '86LD863', 'Gradezco - Segmento Aseo', 339, 'Activo', NULL, NULL, 1),
(731, NULL, 'Dell 3080', '6X9J2G3', 'Agora Csc S.a.s 1 - Importaciones Y Exportaciones', 464, 'Activo', NULL, NULL, 1),
(732, NULL, 'Dell', '67R8MH3', 'Gradezco - Segmento Aseo', 385, 'Activo', NULL, NULL, 1),
(733, NULL, 'Dell 3420', '13WBFG3', 'Agora Csc S.a.s 6 - Csc Tic - General', 16, 'Activo', NULL, NULL, 1),
(734, NULL, 'Dell Micro 7010', 'DN19FZ3', 'Oleariari', 763, 'Activo', NULL, NULL, 1),
(735, NULL, 'Dell 3080', '6XDD2G3', 'Gradezco - Segmento Nutricion Animal', 353, 'Activo', NULL, NULL, 1),
(736, NULL, 'Dell 3440', 'FNX65Y3', 'Oleariari', 763, 'Activo', NULL, NULL, 1),
(737, NULL, 'Dell 3420', 'GJ41DS3', 'Gradezco - Segmento Aseo', 763, 'Activo', NULL, NULL, 1),
(738, NULL, 'Dell 5490', '7J4BMQ2', 'Gradezco - Segmento Alimentos Mesa De Ayuda', 101, 'Activo', NULL, NULL, 1),
(739, NULL, 'Dell 3410', '6CLD863', 'Agora Csc S.a.s Ambiental E Inocuidad', 164, 'Activo', NULL, NULL, 1),
(740, NULL, 'Dell 7060', '81JBDV2', 'Gradezco - Segmento Nutricion Animal Proyectos', 633, 'Activo', NULL, NULL, 1),
(741, NULL, 'Dell', 'F5ZBQ04', 'Gradezco - Segmento Nutricion Animal Proyectos', 633, 'Activo', NULL, NULL, 1),
(742, NULL, 'Dell 5450', 'D44T162', 'Gradezco - Segmento Aseo Tms', 43, 'Activo', NULL, NULL, 1),
(743, NULL, 'Dell 3080', '53GGMH3', 'Gradezco - Segmento Aseo', 396, 'Activo', NULL, NULL, 1),
(744, NULL, 'Dell 3420', 'B9WBFG3', 'Agora Csc S.a.s 6 - Csc Conciliaciones', 195, 'Activo', NULL, NULL, 1),
(745, NULL, 'Dell 3410', '66LD863', 'Gradezco - Segmento Aseo Ventas Cadenas', 502, 'Activo', NULL, NULL, 1),
(746, NULL, 'Dell 3420', '7RV8FG3', 'Agora Csc S.a.s 6 - Jurídico - General', 531, 'Activo', NULL, NULL, 1),
(747, NULL, 'Dell 3080', '690JMH3', 'Gradezco - Segmento Aseo Mesa De Ayuda', 123, 'Activo', NULL, NULL, 1),
(748, NULL, 'Dell 3420', 'B7W8FG3', 'Agora Csc S.a.s 6 - Csc Estados Financieros Y Reportes', 160, 'Activo', NULL, NULL, 1),
(749, NULL, 'Dell 3420', 'J9WBFG3', 'Gradezco - Segmento Aseo Mercadeo', 508, 'Activo', NULL, NULL, 1),
(750, NULL, 'Dell 3080', '67PCMH3', 'Gradezco - Segmento Aseo Innovacion Y Desarrolllo', 170, 'Activo', NULL, NULL, 1),
(751, NULL, 'Dell 3080', '67QKMH3', 'Gradezco - Segmento Aseo Operaciones Y Logistica', 51, 'Activo', NULL, NULL, 1),
(752, NULL, 'Dell 3440', 'BDL8LY3', 'Aliatesp', NULL, 'Activo', NULL, NULL, 1),
(753, NULL, 'Dell 3410', '4DLD863', 'Gradezco - Segmento Aseo Comercial', 446, 'Activo', NULL, NULL, 1),
(754, NULL, 'Dell 3080', '6XLF2G3', 'Gradezco - Segmento Nutricion Animal Villavicencio', 456, 'Activo', NULL, NULL, 1),
(755, NULL, 'Dell 3080', '6YXBMH3', 'Gradezco - Segmento Aseo Medellin', 636, 'Activo', NULL, NULL, 1),
(756, NULL, 'Dell 3420', 'D4W8FG3', 'Agora Csc S.a.s', 425, 'Activo', NULL, NULL, 1),
(757, NULL, 'Dell 3080', '6XMC2G3', 'Gradezco - Segmento Alimentos', 683, 'Activo', NULL, NULL, 1),
(758, NULL, 'Dell 7050', '5HZXHN2', 'Gradezco - Segmento Nutricion Animal', 333, 'Activo', NULL, NULL, 1),
(759, NULL, 'Dell Lenovo Thinkpad E480', 'EQCC000000090', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(760, NULL, 'Dell 3080', '68HDMH3', 'Gradezco - Segmento Aseo Servicios Administrativos', 84, 'Activo', NULL, NULL, 1),
(761, NULL, 'Dell 3420', '1ZV8FG3', 'Agora Csc S.a.s Supply Chain', 82, 'Activo', NULL, NULL, 1),
(762, NULL, 'Dell Lenovo Thinkpad T1', 'PF4PVFQ8', 'Gradezco - Segmento Aseo 6 - Csc Tic - General', 638, 'Activo', NULL, NULL, 1),
(763, NULL, 'Dell 5410', '95V1N53', 'Gradezco - Segmento Aseo Seguridad Y Salud En El Trabajo', 193, 'Activo', NULL, NULL, 1),
(764, NULL, 'Dell 3420', '3KFF2B3', 'Gradezco - Segmento Alimentos Tesoreria', 47, 'Activo', NULL, NULL, 1),
(765, NULL, 'Dell 3080', '6XJ72G3', 'Gradezco - Segmento Alimentos', NULL, 'Activo', NULL, NULL, 1),
(766, NULL, 'Dell 7050', '3BSLGM2', 'Gradezco - Segmento Alimentos', NULL, 'Activo', NULL, NULL, 1),
(767, NULL, 'Dell', '6XMNW14', 'Gradezco - Segmento Nutricion Animal', NULL, 'Activo', NULL, NULL, 1),
(768, NULL, 'Dell 3080', '6Z4HMH3', 'Gradezco - Segmento Aseo Operaciones Y Logistica', 129, 'Activo', NULL, NULL, 1),
(769, NULL, 'Dell Micro 7010', 'FMY8FZ3', 'Oleariari', 763, 'Activo', NULL, NULL, 1),
(770, NULL, 'Dell 7040', 'DQNLSD2', 'Gradezco - Segmento Aseo Pereira', 227, 'Activo', NULL, NULL, 1),
(771, NULL, 'Dell 3080', '67KJMH3', 'Gradezco - Segmento Aseo Materiales', 215, 'Activo', NULL, NULL, 1),
(772, NULL, 'Dell 3420', 'G1WBFG3', 'Gradezco - Segmento Aseo Produccion', 545, 'Activo', NULL, NULL, 1),
(773, NULL, 'Dell 3080', '67QCMH3', 'Gradezco - Segmento Aseo Operaciones Y Logistica', 236, 'Activo', NULL, NULL, 1),
(774, NULL, 'Dell 3080', '6YYGMH3', 'Gradezco - Segmento Aseo Operaciones Y Logistica', 236, 'Activo', NULL, NULL, 1),
(775, NULL, 'Dell 3440', 'H20CQ04', 'Gradezco - Segmento Aseo Ventas Tradicionales', 565, 'Activo', NULL, NULL, 1),
(776, NULL, 'Dell 3420', '53YJXL3', 'Oro Rojo', 763, 'Activo', NULL, NULL, 1),
(777, NULL, 'Dell E7240', 'G21LYZ1', 'Gradezco - Segmento Aseo', 763, 'Activo', NULL, NULL, 1),
(778, NULL, 'Dell 3080', '67QJMH3', 'Gradezco - Segmento Aseo Relaciones Laborales', 40, 'Activo', NULL, NULL, 1),
(779, NULL, 'Dell Macbook Air', 'LJ24F3G6KR', 'Agora Csc S.a.s 6 - Dirección Corporativa - General', 461, 'Activo', NULL, NULL, 1),
(780, NULL, 'Dell 3420', '5PV8FG3', 'Agora Csc S.a.s 6 - Csc Tic - General', 68, 'Activo', NULL, NULL, 1),
(781, NULL, 'Dell 3420', '22WBFG3', 'Gradezco - Segmento Aseo Relaciones Laborales', 100, 'Activo', NULL, NULL, 1),
(782, NULL, 'Dell 7050', 'FZ2YKH2', 'Gradezco - Segmento Aseo Relaciones Laborales', 100, 'Activo', NULL, NULL, 1),
(783, NULL, 'Dell Hp Zbook Firefly 14 G8', 'EQCC000000023', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(784, NULL, 'Dell 3420', 'HNV8FG3', 'Agora Csc S.a.s Comercial', 659, 'Activo', NULL, NULL, 1),
(785, NULL, 'Dell 3080', '67QDMH3', 'Gradezco - Segmento Aseo Pailas', 574, 'Activo', NULL, NULL, 1),
(786, NULL, 'Dell 5480', 'CHTV5H2', 'Gradezco - Segmento Alimentos 0', 564, 'Activo', NULL, NULL, 1),
(787, NULL, 'Dell 3410', '4GS4G63', 'Gradezco - Segmento Aseo Sap Nova', 114, 'Activo', NULL, NULL, 1),
(788, NULL, 'Dell 3440', '130CQ04', 'Gradezco - Segmento Aseo Medellin', 643, 'Activo', NULL, NULL, 1),
(789, NULL, 'Dell 3440', '920CQ04', 'Gradezco - Segmento Aseo Cali', 271, 'Activo', NULL, NULL, 1),
(790, NULL, 'Dell 7050', '1Z73XM2', 'Gradezco - Segmento Aseo', NULL, 'Activo', NULL, NULL, 1),
(791, NULL, 'Dell 7050', '1Z72XM2', 'Gradezco - Segmento Aseo', NULL, 'Activo', NULL, NULL, 1),
(792, NULL, 'Dell 7050', '1Z64XM3', 'Gradezco - Segmento Aseo', NULL, 'Activo', NULL, NULL, 1),
(793, NULL, 'Dell 7040', '53K7D92', 'Gradezco - Segmento Aseo', 321, 'Activo', NULL, NULL, 1),
(794, NULL, 'Dell 5490', 'F5FQPQ2', 'Agora Csc S.a.s', 334, 'Activo', NULL, NULL, 1),
(795, NULL, 'Dell 7070', 'GBQ2PY2', 'Gradezco - Segmento Nutricion Animal', 763, 'Activo', NULL, NULL, 1),
(796, NULL, 'Dell 7320', '9M9L2J3', 'Gradezco - Segmento Alimentos 0', 582, 'Activo', NULL, NULL, 1),
(797, NULL, 'Dell Lenovo Thinkpad E480', 'EQCC000000187', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(798, NULL, 'Dell 3080', '68K8MH3', 'Gradezco - Segmento Aseo', 404, 'Activo', NULL, NULL, 1),
(799, NULL, 'Dell 3080', '6YWGMH3', 'Gradezco - Segmento Aseo Tesoreria', 86, 'Activo', NULL, NULL, 1),
(800, NULL, 'Dell 3080', '6XHD2G3', 'Gradezco - Segmento Nutricion Animal Tesoreria', 86, 'Activo', NULL, NULL, 1),
(801, NULL, 'Dell 3420', 'J7W8FG3', 'Agora Csc S.a.s 6 - Tesorería - General', 140, 'Activo', NULL, NULL, 1),
(802, NULL, 'Dell 3420', 'DPV8FG3', 'Agora Csc S.a.s 6 - Csc Tic - General', 511, 'Activo', NULL, NULL, 1),
(803, NULL, 'Dell 3000', '66X26S3', 'Oro Rojo', 763, 'Activo', NULL, NULL, 1),
(804, NULL, 'Dell 780', '4DZD5L1', 'Gradezco - Segmento Alimentos', 660, 'Activo', NULL, NULL, 1),
(805, NULL, 'Dell 3080', '53J8MH3', 'Gradezco - Segmento Aseo', 400, 'Activo', NULL, NULL, 1),
(806, NULL, 'Dell 3080', '68ZCMH3', 'Gradezco - Segmento Aseo', 366, 'Activo', NULL, NULL, 1),
(807, NULL, 'Dell 3080', '6YYDMH3', 'Gradezco - Segmento Aseo', 393, 'Activo', NULL, NULL, 1),
(808, NULL, 'Dell 3410', '85LD863', 'Gradezco - Segmento Aseo', 336, 'Activo', NULL, NULL, 1),
(809, NULL, 'Dell 3080', '53HGMH3', 'Gradezco - Segmento Aseo', 397, 'Activo', NULL, NULL, 1),
(810, NULL, 'Dell', '9R0ZS34', 'Agora Csc S.a.s', NULL, 'Activo', NULL, NULL, 1),
(811, NULL, 'Dell 3080', '6XC72G3', 'Gradezco - Segmento Nutricion Animal Nutricion Animal', 524, 'Activo', NULL, NULL, 1),
(812, NULL, 'Dell 7050', 'DMN2GK2', 'Gradezco - Segmento Nutricion Animal', 357, 'Activo', NULL, NULL, 1),
(813, NULL, 'Dell 3000', 'G5X26S3', 'Oro Rojo', 763, 'Activo', NULL, NULL, 1),
(814, NULL, 'Dell 3020', '3N9W382', 'Oro Rojo', NULL, 'Activo', NULL, NULL, 1),
(815, NULL, 'Dell 3440', '6WYBQ04', 'Gradezco - Segmento Aseo Medellin', 438, 'Activo', NULL, NULL, 1),
(816, NULL, 'Dell 3080', '6XHH2G3', 'Gradezco - Segmento Alimentos', 695, 'Activo', NULL, NULL, 1),
(817, NULL, 'Dell Macbook Air', 'KVD21436KT', 'Agora Csc S.a.s 6 - Dirección Financiera - General', 595, 'Activo', NULL, NULL, 1),
(818, NULL, 'Dell Micro 7010', 'CN19FZ3', 'Oleariari', 763, 'Activo', NULL, NULL, 1),
(819, NULL, 'Dell 3420', 'GJVBFG3', 'Gradezco - Segmento Aseo Aseguramiento De Calidad', 550, 'Activo', NULL, NULL, 1),
(820, NULL, 'Dell 7050', 'J44ZSM2', 'Gradezco - Segmento Nutricion Animal', 763, 'Activo', NULL, NULL, 1),
(821, NULL, 'Dell 7010', 'CT9WM02', 'Gradezco - Segmento Alimentos', 707, 'Activo', NULL, NULL, 1),
(822, NULL, 'Dell 7050', '4Q8HJH2', 'Gradezco - Segmento Alimentos', NULL, 'Activo', NULL, NULL, 1),
(823, NULL, 'Dell 3450', 'DZ0RG22', 'Indupalma', NULL, 'Activo', NULL, NULL, 1),
(824, NULL, 'Dell 3080', '68Z9MH3', 'Gradezco - Segmento Aseo 2 - Crm', 3, 'Activo', NULL, NULL, 1),
(825, NULL, 'Dell 3080', '6XMJ2G3', 'Agora Csc S.a.s Selección Y Formación', 45, 'Activo', NULL, NULL, 1),
(826, NULL, 'Dell 7320', '74GN2J3', 'Agora Csc S.a.s 2 - Comision', 567, 'Activo', NULL, NULL, 1),
(827, NULL, 'Dell 3420', 'DYV8FG3', 'Gradezco - Segmento Nutricion Animal 6 - Tesorería - General', 153, 'Activo', NULL, NULL, 1),
(828, NULL, 'Dell 3420', '52WBFG3', 'Gradezco - Segmento Aseo Sap Nova', 108, 'Activo', NULL, NULL, 1),
(829, NULL, 'Dell 3080', '6YYCMH3', 'Agora Csc S.a.s', 392, 'Activo', NULL, NULL, 1),
(830, NULL, 'Dell 3420', '4JFF2B3', 'Gradezco - Segmento Alimentos Mercadeo', 232, 'Activo', NULL, NULL, 1),
(831, NULL, 'Dell 3080', '6909MH3', 'Gradezco - Segmento Aseo Control De Calidad', 530, 'Activo', NULL, NULL, 1),
(832, NULL, 'Dell Lenovo Thinkpad T14s Gen 2', 'EQCC000000031', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(833, NULL, 'Dell 3410', 'DDLD863', 'Gradezco - Segmento Aseo', 337, 'Activo', NULL, NULL, 1),
(834, NULL, 'Dell 3080', '6XFG2G3', 'Gradezco - Segmento Alimentos', 696, 'Activo', NULL, NULL, 1),
(835, NULL, 'Dell 3080', '68ZJMH3', 'Gradezco - Segmento Aseo', 378, 'Activo', NULL, NULL, 1),
(836, NULL, 'Dell 7040', 'JG8SCH2', 'Gradezco - Segmento Aseo', 323, 'Activo', NULL, NULL, 1),
(837, NULL, 'Dell 3080', '6YXGMH3', 'Gradezco - Segmento Aseo', 389, 'Activo', NULL, NULL, 1),
(838, NULL, 'Dell 3420', 'BRV8FG3', 'Gradezco - Segmento Aseo Sap Nova', 445, 'Activo', NULL, NULL, 1),
(839, NULL, 'Dell 3440', 'CXYBQ04', 'Gradezco - Segmento Aseo Pereira', 228, 'Activo', NULL, NULL, 1),
(840, NULL, 'Dell 3080', '53H9MH3', 'Gradezco - Segmento Aseo Liquidos', 245, 'Activo', NULL, NULL, 1),
(841, NULL, 'Dell 3420', 'HYV8FG3', 'Agora Csc S.a.s 6 - Csc Cxp', 525, 'Activo', NULL, NULL, 1),
(842, NULL, 'Dell 3080', '6XGJ2G3', 'Gradezco - Segmento Alimentos 2 - Llenado', 184, 'Activo', NULL, NULL, 1),
(843, NULL, 'Dell 3080', '690DMH3', 'Gradezco - Segmento Aseo Control De Calidad', 540, 'Activo', NULL, NULL, 1),
(844, NULL, 'Dell 3080', '67L8MH3', 'Gradezco - Segmento Aseo Control De Calidad', 443, 'Activo', NULL, NULL, 1),
(845, NULL, 'Dell 3420', '2SV8FG3', 'Agora Csc S.a.s', NULL, 'Activo', NULL, NULL, 1),
(846, NULL, 'Dell 9020', '51BVW12', 'Gradezco - Segmento Alimentos', NULL, 'Activo', NULL, NULL, 1),
(847, NULL, 'Dell Lenovo Thinkpad T14s Gen 2', 'EQCC000000032', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(848, NULL, 'Dell 3080', '690GMH3', 'Gradezco - Segmento Aseo', 380, 'Activo', NULL, NULL, 1),
(849, NULL, 'Dell Lenovo Thinkpad E14 Gen 2', 'EQCC000000014', 'Novus Civitas', NULL, 'Activo', NULL, NULL, 1),
(850, NULL, 'Dell 5480', '2VYB0N2', 'Gradezco - Segmento Aseo', 265, 'Activo', NULL, NULL, 1),
(851, NULL, 'Dell 3420', '19WBFG3', 'Gradezco - Segmento Aseo Sap Nova', 555, 'Activo', NULL, NULL, 1),
(852, NULL, 'Dell 7050', '9XHX0MZ', 'Gradezco - Segmento Nutricion Animal', 763, 'Activo', NULL, NULL, 1),
(853, NULL, 'Dell 7050', 'JSS3LH2', 'Gradezco - Segmento Alimentos', 430, 'Activo', NULL, NULL, 1),
(854, NULL, 'Dell 7050', 'GQ630M2', 'Gradezco - Segmento Alimentos', 330, 'Activo', NULL, NULL, 1),
(855, NULL, 'Dell 7010', '8WQSFX1', 'Gradezco - Segmento Alimentos', 412, 'Activo', NULL, NULL, 1),
(856, NULL, 'Dell 3000', 'F5X26S3', 'Oro Rojo', NULL, 'Activo', NULL, NULL, 1),
(857, NULL, 'Dell 3080', '68HGMH3', 'Gradezco - Segmento Aseo Tms', 588, 'Activo', NULL, NULL, 1),
(858, NULL, 'Dell 3420', '12WBFG3', 'Agora Csc S.a.s Sap Nova', 534, 'Activo', NULL, NULL, 1),
(859, NULL, 'Dell 3440', '720CQ04', 'Gradezco - Segmento Aseo Barranquilla', 551, 'Activo', NULL, NULL, 1),
(860, NULL, 'Dell 3080', '6XCF2G3', 'Gradezco - Segmento Nutricion Animal 0', 18, 'Activo', NULL, NULL, 1),
(861, NULL, 'Dell 3440', 'CHZBQ04', 'Agora Csc S.a.s 6 - Dirección Gth - General', 441, 'Activo', NULL, NULL, 1),
(862, NULL, 'Dell 3080', '6XBD2G3', 'Gradezco - Segmento Alimentos', NULL, 'Activo', NULL, NULL, 1),
(863, NULL, 'Dell 3080', '6XGF2G3', 'Gradezco - Segmento Alimentos', NULL, 'Activo', NULL, NULL, 1),
(864, NULL, 'Dell 9020', '1BYFP22', 'Gradezco - Segmento Alimentos Margarina Y Empaque', 632, 'Activo', NULL, NULL, 1),
(865, NULL, 'Dell', 'CN-0FP04F-72872-3BE-CE4M', 'Dersa Cartera', 513, 'Activo', NULL, NULL, 2),
(866, NULL, 'Dell', 'CN-04D4T1-QDC00-15C0DDI-A14', 'Dersa Cartera', 7, 'Activo', NULL, NULL, 2),
(867, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-0DJI-A14', 'Dersa Cartera', 290, 'Activo', NULL, NULL, 2),
(868, NULL, 'Dell', 'CN-0KW14V-74261-449-97TB', 'Dersa Cartera', 12, 'Activo', NULL, NULL, 2),
(869, NULL, 'Dell', 'CN-04D9T1-QDC00-16C-5WOB-A14', 'Dersa Cartera', 31, 'Activo', NULL, NULL, 2),
(870, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-0DPI-A14', 'Dersa Cartera', 86, 'Activo', NULL, NULL, 2),
(871, NULL, 'Dell', 'CN-04D9T1-QDC00-15C00MIA14', 'Dersa Cartera', 473, 'Activo', NULL, NULL, 2),
(872, NULL, 'Dell', 'CN-04D9T1- QDC00-15C-0D41-A14', 'Dersa Tesoreria', 140, 'Activo', NULL, NULL, 2),
(873, NULL, 'Dell', 'CN-04D9T1-QDC00-16D-1P3B-A14', 'Dersa Tesoreria', 478, 'Activo', NULL, NULL, 2),
(874, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-OMII-A14', 'Dersa', 217, 'Activo', NULL, NULL, 2),
(875, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-0KGI-A14', 'Dersa Tesoreria', NULL, 'Activo', NULL, NULL, 2),
(876, NULL, 'Dell', 'CN-04D9T1-QDC00-16D-1P3B-A14', 'Dersa Tesoreria', 230, 'Activo', NULL, NULL, 2),
(877, NULL, 'Dell', 'CN-04D9T1-QDC00-16D-10ZB-A14', 'Dersa Tesoreria', 29, 'Activo', NULL, NULL, 2),
(878, NULL, 'Dell', 'CN-04D9T1-QDC00-15C0KLI-A14', 'Dersa Recepción', 264, 'Activo', NULL, NULL, 2),
(879, NULL, 'Dell', 'CN-03GJ21-74261-68T34US-A00', 'Dersa Gestion Humana', 168, 'Activo', NULL, NULL, 2),
(880, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-ORJI-A14', 'Dersa Gestion Humana', 468, 'Activo', NULL, NULL, 2),
(881, NULL, 'Dell', 'CN-03GJ21-74261-6C5-43KB-A00', 'Dersa Gestion Humana', 143, 'Activo', NULL, NULL, 2),
(882, NULL, 'Dell', 'CN-07R1K3-74445-61B-A01', 'Dersa Gestion Humana', 172, 'Activo', NULL, NULL, 2),
(883, NULL, 'Dell', 'CN-03GJ21-74261-64G-0J7B-A00', 'Dersa Gestion Humana', 156, 'Activo', NULL, NULL, 2),
(884, NULL, 'Dell', 'CN-07R1K3-74445-48T-AFWL', 'Dersa Gestion Humana', 134, 'Activo', NULL, NULL, 2),
(885, NULL, 'Dell', 'CN-07R1K3-74445-48T003L', 'Dersa Gestion Humana', 112, 'Activo', NULL, NULL, 2),
(886, NULL, 'Dell', 'CN-VN-01TND1-WS700-46A-226B-A01', 'Dersa Gestion Humana', 532, 'Activo', NULL, NULL, 2),
(887, NULL, 'Dell', 'CN-07R1K3-74445-54T-ACQS', 'Dersa Rhh', 34, 'Activo', NULL, NULL, 2),
(888, NULL, 'Dell', 'CN-04GJ21-QDC00-869-1231-A06', 'Dersa Rhh Selección', 244, 'Activo', NULL, NULL, 2),
(889, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-0LMI-A14', 'Dersa Rhh', 267, 'Activo', NULL, NULL, 2),
(890, NULL, 'Dell', 'CN-OFMXNR-64180-730-39KB', 'Dersa Rhh', 62, 'Activo', NULL, NULL, 2),
(891, NULL, 'Dell', 'CN-07R1K3-7445-5AD-BPBS-A01', 'Dersa Rhh', 193, 'Activo', NULL, NULL, 2),
(892, NULL, 'Dell', 'CN-07R1K3-7445-45N462L', 'Dersa Rhh', 498, 'Activo', NULL, NULL, 2),
(893, NULL, 'Dell', 'CN-03GJ21-74261-71C-38TL-A00', 'Dersa Rhh', 21, 'Activo', NULL, NULL, 2),
(894, NULL, 'Dell', 'CN-OM67RH-TV200-95C-OLPB-A04', 'Dersa Rhh', 209, 'Activo', NULL, NULL, 2),
(895, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-OKBI-A14', 'Dersa Crm', 177, 'Activo', NULL, NULL, 2),
(896, NULL, 'Dell', 'CN-061KWX-64180-61N-1L3L-A01', 'Dersa Pur', 459, 'Activo', NULL, NULL, 2),
(897, NULL, 'Dell', 'CN-04D9T1-QDC00-16C-6YEB-A14', 'Dersa Pur', NULL, 'Activo', NULL, NULL, 2),
(898, NULL, 'Dell', 'CN-04D9T1-QDC00-16C-5XQB-A14', 'Dersa Pur', 459, 'Activo', NULL, NULL, 2),
(899, NULL, 'Dell', 'CN-04D9T1-QDC00-16C-5VKB-A14', 'Dersa Pur', NULL, 'Activo', NULL, NULL, 2),
(900, NULL, 'Dell', 'CN-04D9T1-QDC00-16D-1P6B-A14', 'Dersa Pur', 451, 'Activo', NULL, NULL, 2),
(901, NULL, 'Dell', 'CN-04-D9T1-QDC00-16C-5Y2B-A14', 'Dersa Seguridad', 625, 'Activo', NULL, NULL, 2),
(902, NULL, 'Dell', 'CN-07R1K3-74445-44L-E59L', 'Dersa Seguridad', 625, 'Activo', NULL, NULL, 2),
(903, NULL, 'Dell', 'CN-3R4Z9F3', 'Dersa Tic', 94, 'Activo', NULL, NULL, 2),
(904, NULL, 'Dell', 'CN-07R1K3-74445-58P-058B', 'Dersa Tic', 130, 'Activo', NULL, NULL, 2),
(905, NULL, 'Dell', 'CN-63XCD93', 'Dersa Tic', 70, 'Activo', NULL, NULL, 2),
(906, NULL, 'Dell', 'CN-OM2GCR-74261-22R-157L', 'Dersa Tic', 175, 'Activo', NULL, NULL, 2),
(907, NULL, 'Dell', 'CN-03GJ21-74261-71G-38LL-A00', 'Dersa Tic', 1, 'Activo', NULL, NULL, 2),
(908, NULL, 'Dell', 'CN-03GJ21-73261-71G-389L-A00', 'Dersa Tic', 211, 'Activo', NULL, NULL, 2),
(909, NULL, 'Dell', 'CN-03HJ21-74261-71G-38PL-A00', 'Dersa Tic', 128, 'Activo', NULL, NULL, 2),
(910, NULL, 'Dell', 'CN-07R1K3-74445-484-A4RS', 'Dersa Tic', 103, 'Activo', NULL, NULL, 2),
(911, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-DKJI-A14', 'Dersa Tic', NULL, 'Activo', NULL, NULL, 2),
(912, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-00CI-A14', 'Dersa Ventas Internacionales', 113, 'Activo', NULL, NULL, 2),
(913, NULL, 'Dell', 'CN- 03GJ21-QDC00-7BF-21DS-A03', 'Dersa Infraestructura', 638, 'Activo', NULL, NULL, 2),
(914, NULL, 'Dell', 'CN-07R1K3-74445-4BL-3931', 'Dersa Infraestructura', 121, 'Activo', NULL, NULL, 2),
(915, NULL, 'Dell', 'CN-03GJ21-74261-6CS-437B-A00', 'Dersa Infraestructura', 165, 'Activo', NULL, NULL, 2),
(916, NULL, 'Dell', 'CN-0V8JY2-74261-393-1Y8M', 'Dersa Tic', 511, 'Activo', NULL, NULL, 2),
(917, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-0LFI-A14', 'Dersa Tesoreria', 594, 'Activo', NULL, NULL, 2),
(918, NULL, 'Dell', 'CN-03GJ21-QDC00-7CL-5321-A05', 'Dersa Comercial', 183, 'Activo', NULL, NULL, 2),
(919, NULL, 'Dell', 'NO SE ENCONTRO', 'Dersa Comercial', 605, 'Activo', NULL, NULL, 2),
(920, NULL, 'Dell', 'CN-07R1K3-74445-49TA1GL', 'Dersa Comercial', 274, 'Activo', NULL, NULL, 2),
(921, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-0KVI-A14', 'Dersa Comercial', 123, 'Activo', NULL, NULL, 2),
(922, NULL, 'Dell', 'CN-0FDV8Y-72872-6AQ-CF9L-A00', 'Dersa Comercial', 454, 'Activo', NULL, NULL, 2),
(923, NULL, 'Dell', 'CN- OKHONG-QDC00-74H-OEDB-A00', 'Dersa Comercial', 515, 'Activo', NULL, NULL, 2),
(924, NULL, 'Dell', 'OFPO4F-72872-393-AYMKM', 'Dersa Comercial', 639, 'Activo', NULL, NULL, 2),
(925, NULL, 'Dell', 'CN-03GJ21-QDC00-88T-OGHL-A06', 'Dersa Comercial', 162, 'Activo', NULL, NULL, 2),
(926, NULL, 'Dell', 'CN-04D9T1-QDC00-16C-5WOB-A14', 'Dersa Comercial', 181, 'Activo', NULL, NULL, 2),
(927, NULL, 'Dell', 'CN-07R1K3-74445-4BR-5015-', 'Dersa Comercial', 519, 'Activo', NULL, NULL, 2),
(928, NULL, 'Dell', 'CN-03GJ21-74261-71G-37WL-AOO', 'Dersa Comercial', 487, 'Activo', NULL, NULL, 2),
(929, NULL, 'Dell', 'CN-0KHONG-QDC00-75D-2985-A00', 'Dersa Comercial', 576, 'Activo', NULL, NULL, 2),
(930, NULL, 'Dell', 'CN-OV8JY2-74261-2B8-1GOL', 'Dersa Comercial', 35, 'Activo', NULL, NULL, 2),
(931, NULL, 'Dell', 'CN-OVYTW5-72872-420-CKDL', 'Dersa Comercial', 41, 'Activo', NULL, NULL, 2),
(932, NULL, 'Dell', 'NO TIENE SERIE', 'Dersa Comercial', 614, 'Activo', NULL, NULL, 2),
(933, NULL, 'Dell', 'CN-OYKNFG-WS200-83D-B6US-A05', 'Dersa Comercial', 261, 'Activo', NULL, NULL, 2),
(934, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-0RKI-A14', 'Dersa Producción', 2, 'Activo', NULL, NULL, 2),
(935, NULL, 'Dell', 'CN- OV8JY2-74261-2AG-19TB', 'Dersa Gestion De Calidad', 635, 'Activo', NULL, NULL, 2),
(936, NULL, 'Dell', 'CN-061KWX-0418062F-1JVB-A01', 'Dersa Gestion De Calidad', 584, 'Activo', NULL, NULL, 2),
(937, NULL, 'Dell', 'CN-OV8JY2-74261-393-1NKM', 'Dersa Aseguramiento De Calidad', 234, 'Activo', NULL, NULL, 2),
(938, NULL, 'Dell', 'CN-061KWX-64180-62F-1K6B-A01', 'Dersa Aseguramiento De Calidad', 494, 'Activo', NULL, NULL, 2),
(939, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-0L61-A14', 'Dersa Aseguramiento De Calidad', 163, 'Activo', NULL, NULL, 2),
(940, NULL, 'Dell', 'CN-O4D9T1-QDC00-15C-0LDI-A14', 'Dersa Aseguramiento De Calidad', 530, 'Activo', NULL, NULL, 2),
(941, NULL, 'Dell', 'CN-03GGJ21-QDC00-741-47GL-A01', 'Dersa Aseguramiento De Calidad', 453, 'Activo', NULL, NULL, 2),
(942, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-OCYI-A14', 'Dersa Aseguramiento De Calidad', NULL, 'Activo', NULL, NULL, 2),
(943, NULL, 'Dell', 'CN-OWKFYR74261-11E1GLL', 'Dersa Aseguramiento De Calidad', NULL, 'Activo', NULL, NULL, 2),
(944, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-OCWI-A14', 'Dersa Aseguramiento De Calidad', 443, 'Activo', NULL, NULL, 2),
(945, NULL, 'Dell', 'CN-03G-J21-QDC00-86C-1FNI-A06', 'Dersa Innovación', 109, 'Activo', NULL, NULL, 2),
(946, NULL, 'Dell', 'CN-0VYTW5-72872-44N-DOAS', 'Dersa Innovación', 37, 'Activo', NULL, NULL, 2),
(947, NULL, 'Dell', 'CN-04JCCP-74261-21J-07GS', 'Dersa Innovación', 197, 'Activo', NULL, NULL, 2),
(948, NULL, 'Dell', 'CN-0V8JY2-74261-35B-1GDB', 'Dersa Innovación', 98, 'Activo', NULL, NULL, 2),
(949, NULL, 'Dell', 'CN-0V8JY2-74261-393-1P5M', 'Dersa Innovación', 24, 'Activo', NULL, NULL, 2),
(950, NULL, 'Dell', 'CN-03GJ21-74261-3M7B-A00', 'Dersa Innovación', 72, 'Activo', NULL, NULL, 2),
(951, NULL, 'Dell', 'CN-03GJ21-74261-725-OEYM-A00', 'Dersa Innovación', 15, 'Activo', NULL, NULL, 2),
(952, NULL, 'Dell', 'CN-03GJ21-74261-68J-30AL-A00', 'Dersa Innovación', 606, 'Activo', NULL, NULL, 2),
(953, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-OLOI-A14', 'Dersa Innovación', 170, 'Activo', NULL, NULL, 2),
(954, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-OL7|-A14', 'Dersa Innovación', 22, 'Activo', NULL, NULL, 2),
(955, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-OL7|-A14', 'Dersa Innovación', 75, 'Activo', NULL, NULL, 2),
(956, NULL, 'Dell', 'CN-04D9T1-QDC00-16D-10YB-A14', 'Dersa Innovación', 111, 'Activo', NULL, NULL, 2),
(957, NULL, 'Dell', 'CN-07R1K3-74445-459-FVRS', 'Dersa Innovación', 42, 'Activo', NULL, NULL, 2),
(958, NULL, 'Dell', 'CN-07R1K3-74445-430-B6NS', 'Dersa Innovación', 200, 'Activo', NULL, NULL, 2),
(959, NULL, 'Dell', 'CN-07R1K3-74445-570-616B', 'Dersa Mercadeo', 107, 'Activo', NULL, NULL, 2),
(960, NULL, 'Dell', 'CN0CNTHCJW200046H', 'Dersa Mercadeo', 6, 'Activo', NULL, NULL, 2),
(961, NULL, 'Dell', 'CN-07R1K3-74445-59N-BZYS-A01', 'Dersa Mercadeo', 231, 'Activo', NULL, NULL, 2),
(962, NULL, 'Dell', 'CN-07R1K3-74445-570-AAJB', 'Dersa Mercadeo', 437, 'Activo', NULL, NULL, 2),
(963, NULL, 'Dell', 'NO TIENE SERIE', 'Dersa Mercadeo', 539, 'Activo', NULL, NULL, 2),
(964, NULL, 'Dell', 'CN-03GJ21-74261-68T-OCLS-A00', 'Dersa Mercadeo', 71, 'Activo', NULL, NULL, 2),
(965, NULL, 'Dell', 'CN-07R1K3-74445-570-ACCB', 'Dersa Papaleria', 185, 'Activo', NULL, NULL, 2),
(966, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-OL1I-A14', 'Dersa Papeleria', 117, 'Activo', NULL, NULL, 2),
(967, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-0D21-A14', 'Dersa Metrologia', 599, 'Activo', NULL, NULL, 2),
(968, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-OLQI-A14', 'Dersa Infraestructura', 252, 'Activo', NULL, NULL, 2),
(969, NULL, 'Dell', 'CN-07R1K3-74445-535-CG5B', 'Dersa Infraestructura', 563, 'Activo', NULL, NULL, 2),
(970, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-00QI-A14', 'Dersa Ingenieria Y Mantenimiento', 174, 'Activo', NULL, NULL, 2),
(971, NULL, 'Dell', 'CN-OCG1G3-WS200-789-865B-A01', 'Dersa Ingenieria Y Mantenimiento', 282, 'Activo', NULL, NULL, 2),
(972, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-OBLI-A14', 'Dersa Ingenieria Y Mantenimiento', 239, 'Activo', NULL, NULL, 2),
(973, NULL, 'Dell', 'CN-04D9T1-QDC00-15H-186B-A14', 'Dersa Ingenieria Y Mantenimiento', 654, 'Activo', NULL, NULL, 2),
(974, NULL, 'Dell', 'CN-0ASVHCNN800695K', 'Dersa Capacitaciones Mantenimiento 3', NULL, 'Activo', NULL, NULL, 2),
(975, NULL, 'Dell', 'CN-0V8JY2-74261-358-18MB', 'Dersa Capacitaciones Mantenimiento 2', NULL, 'Activo', NULL, NULL, 2),
(976, NULL, 'Dell', 'NO TIENE SERIE', 'Dersa Capacitaciones Mantenimiento 1', NULL, 'Activo', NULL, NULL, 2),
(977, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-OKFI-A14', 'Dersa Devoluciones', 630, 'Activo', NULL, NULL, 2),
(978, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-0KII-A14', 'Dersa Devoluciones', 630, 'Activo', NULL, NULL, 2),
(979, NULL, 'Dell', 'CN-07R1K3-74445-59N-COVS-A01', 'Dersa Planeación', 648, 'Activo', NULL, NULL, 2),
(980, NULL, 'Dell', 'CN-07R1K3-74445-5CP-32OL-A01', 'Dersa Planeación', 49, 'Activo', NULL, NULL, 2),
(981, NULL, 'Dell', 'CN-OCG1G3-WS200-789-870B-A01', 'Dersa Despachos', 619, 'Activo', NULL, NULL, 2),
(982, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-0D61-A14', 'Dersa Despachos', 263, 'Activo', NULL, NULL, 2),
(983, NULL, 'Dell', 'CN- 04D9T1-QDC00-15C-0DO1-A14', 'Dersa Despachos', 120, 'Activo', NULL, NULL, 2),
(984, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-ORII-A14', 'Dersa Despachos', 489, 'Activo', NULL, NULL, 2),
(985, NULL, 'Dell', 'CN-04D9T1-QDC00-19J-14WB.A15', 'Dersa Despachos', 32, 'Activo', NULL, NULL, 2),
(986, NULL, 'Dell', 'CN-04D9T1-QDC00-19J-14WB.A15', 'Dersa Despachos', 204, 'Activo', NULL, NULL, 2),
(987, NULL, 'Dell', 'CN-O4D9T1-QDC00-15C-OTCI-A14', 'Dersa Despachos', 589, 'Activo', NULL, NULL, 2);
INSERT INTO `tbl_equipos` (`Id_Equipo`, `Codigo_Inventario`, `Marca_Equipo`, `Numero_Serie`, `Ubicacion_Equipo`, `Propietario_Equipo`, `Estado_Equipo`, `Fecha_Ad_Equipo`, `Id_Archivo`, `Id_Tipo_Equipo`) VALUES
(988, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-ODLI-A14', 'Dersa Despachos', 246, 'Activo', NULL, NULL, 2),
(989, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-OK1I-A14', 'Dersa Despachos', 66, 'Activo', NULL, NULL, 2),
(990, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-0D81-A14', 'Dersa Despachos', 92, 'Activo', NULL, NULL, 2),
(991, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-0CA1-A14', 'Dersa Caja', 542, 'Activo', NULL, NULL, 2),
(992, NULL, 'Dell', 'CN-07R1K3-74445-570-ANFD', 'Dersa Supply Chain', 215, 'Activo', NULL, NULL, 2),
(993, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-OLKI-A14', 'Dersa Supply Chain', 221, 'Activo', NULL, NULL, 2),
(994, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-OLOI-A14', 'Dersa Supply Chain', 58, 'Activo', NULL, NULL, 2),
(995, NULL, 'Dell', 'CN-07R1K3-74445-570-ACHB', 'Dersa Supply Chain', 154, 'Activo', NULL, NULL, 2),
(996, NULL, 'Dell', 'CN-O4D9T1-QDC00-15C-0D71-A14', 'Dersa Supply Chain', 258, 'Activo', NULL, NULL, 2),
(997, NULL, 'Dell', 'CN-OKHONG-74261-73H-6Y8B-A00', 'Dersa Supply Chain', 593, 'Activo', NULL, NULL, 2),
(998, NULL, 'Dell', 'CN-04D9T1-QDC00-16D-10MB-A14', 'Dersa Supply Chain', 579, 'Activo', NULL, NULL, 2),
(999, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-0KPI-A14', 'Dersa Supply Chain', 26, 'Activo', NULL, NULL, 2),
(1000, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-OLEI-A14', 'Dersa Supply Chain', 435, 'Activo', NULL, NULL, 2),
(1001, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-OM21-A14', 'Dersa Seguridad', 78, 'Activo', NULL, NULL, 2),
(1002, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-OM71-A14', 'Dersa Seguridad Y Prevencion', 627, 'Activo', NULL, NULL, 2),
(1003, NULL, 'Dell', 'CN-OCDV-1K-64180-51J-050B', 'Dersa Seguridad Y Prevencion', 559, 'Activo', NULL, NULL, 2),
(1004, NULL, 'Dell', 'CN-04D9T1-QDC00-15C-OK61-A14', 'Dersa Seguridad Y Prevencion', 133, 'Activo', NULL, NULL, 2),
(1005, NULL, 'Dell', 'CN-07R1K3-74445-5CJ-ABGL-A01', 'Dersa Seguridad', 190, 'Activo', NULL, NULL, 2),
(1006, NULL, 'Dell', 'CN-07R1K3-74445-5AQ-773L-A01', 'Dersa Seguridad', 52, 'Activo', NULL, NULL, 2),
(1007, NULL, 'Dell', 'CN-07R1K3-74445-56N-335L-', 'Dersa Segurad', NULL, 'Activo', NULL, NULL, 2),
(1008, NULL, 'Dell', '501NDAYST416', 'Dersa Bascula', 435, 'Activo', NULL, NULL, 2),
(1009, NULL, 'Dell', 'GR74472', 'Grasco Contrtol', 59, 'Activo', NULL, NULL, 2),
(1010, NULL, 'Dell', 'JWFL1J2', 'Grasco Abastecimiento', 151, 'Activo', NULL, NULL, 2),
(1011, NULL, 'Dell', '1Y4Z9F3', 'Grasco Abastecimiento', 496, 'Activo', NULL, NULL, 2),
(1012, NULL, 'Dell', 'S/N: CN-07R1K3-74445-57H-BU9B', 'Grasco Abastecimiento', 76, 'Activo', NULL, NULL, 2),
(1013, NULL, 'Dell', 'NO APLICA', 'Grasco Financiero', 583, 'Activo', NULL, NULL, 2),
(1014, NULL, 'Dell', 'NO APLICA', 'Grasco Contabilidad', 104, 'Activo', NULL, NULL, 2),
(1015, NULL, 'Dell', 'S/N: CN-07R1K3-74445-58P-126B', 'Grasco Compras', 611, 'Activo', NULL, NULL, 2),
(1016, NULL, 'Dell', 'S/N: CN-07N012-64180-28T-1AKU', 'Grasco Compras', 55, 'Activo', NULL, NULL, 2),
(1017, NULL, 'Dell', 'S/N: CN-ONDMRP-74261-28D-160U', 'Grasco Abastecimiento', 242, 'Activo', NULL, NULL, 2),
(1018, NULL, 'Dell', 'DOS PORTATILES', 'Grasco Compras', 242, 'Activo', NULL, NULL, 2),
(1019, NULL, 'Dell', 'NO APLICA', 'Grasco Servicios Administrativos', 554, 'Activo', NULL, NULL, 2),
(1020, NULL, 'Dell', 'HWFL1J2', 'Grasco Subgerencia De Control', 278, 'Activo', NULL, NULL, 2),
(1021, NULL, 'Dell', 'J74Z9F3', 'Grasco Subgerencia De Control', 561, 'Activo', NULL, NULL, 2),
(1022, NULL, 'Dell', 'JTXCD93', 'Grasco Control Interno', 528, 'Activo', NULL, NULL, 2),
(1023, NULL, 'Dell', '5LZDD93', 'Grasco Control Interno', 179, 'Activo', NULL, NULL, 2),
(1024, NULL, 'Dell', '34HCPB2', 'Grasco Abastecimiento', 596, 'Activo', NULL, NULL, 2),
(1025, NULL, 'Dell', 'S/N: CN-07R1K3-74445-570-ACUB', 'Grasco Subgerencia De Control', 171, 'Activo', NULL, NULL, 2),
(1026, NULL, 'Dell', 'S/N: CN-008MT5-64180-582-0NRB', 'Grasco Subgerencia De Control', 188, 'Activo', NULL, NULL, 2),
(1027, NULL, 'Dell', 'NO APLICA', 'Grasco Sistemas', 717, 'Activo', NULL, NULL, 2),
(1028, NULL, 'Dell', 'S/N: CN-07R1K3-74445-4BL-396L', 'Grasco Sistemas', 38, 'Activo', NULL, NULL, 2),
(1029, NULL, 'Dell', 'S/N: CN-0V8JY2-74261-358-1FUB', 'Grasco Contabilidad', 14, 'Activo', NULL, NULL, 2),
(1030, NULL, 'Dell', 'GCO-A-2188', 'Grasco Contabilidad', 10, 'Activo', NULL, NULL, 2),
(1031, NULL, 'Dell', 'S/N: CN-0VYTW5-72872-420-A2CL', 'Grasco Contabilidad', 44, 'Activo', NULL, NULL, 2),
(1032, NULL, 'Dell', 'S/N: CN-07R1K3-74445-570-AFJB', 'Grasco Contabilidad', 199, 'Activo', NULL, NULL, 2),
(1033, NULL, 'Dell', 'S/N: CN-07R1K3-74445-SAQ-808L-A01', 'Grasco Contabilidad', 607, 'Activo', NULL, NULL, 2),
(1034, NULL, 'Dell', 'NO APLICA', 'Grasco Contabilidad', 137, 'Activo', NULL, NULL, 2),
(1035, NULL, 'Dell', 'NO APLICA', 'Grasco Contabilidad', 272, 'Activo', NULL, NULL, 2),
(1036, NULL, 'Dell', 'NO APLICA', 'Grasco Contabilidad', 507, 'Activo', NULL, NULL, 2),
(1037, NULL, 'Dell', 'NO APLICA', 'Grasco Contabilidad', 557, 'Activo', NULL, NULL, 2),
(1038, NULL, 'Dell', 'FS4Z9F3', 'Grasco Revisoria Fiscal', 497, 'Activo', NULL, NULL, 2),
(1039, NULL, 'Dell', 'NO APLICA', 'Grasco Revisoria Fiscal', 286, 'Activo', NULL, NULL, 2),
(1040, NULL, 'Dell', 'NO APLICA', 'Grasco Revisoria Fiscal', 155, 'Activo', NULL, NULL, 2),
(1041, NULL, 'Dell', 'S/N: CN-0V8JY2-74261-34Q-5RPM', 'Grasco Revisoria Fiscal', 486, 'Activo', NULL, NULL, 2),
(1042, NULL, 'Dell', 'NO APLICA', 'Grasco Revisoria Fiscal', 132, 'Activo', NULL, NULL, 2),
(1043, NULL, 'Dell', 'NO APLICA', 'Grasco Revisoria Fiscal', 509, 'Activo', NULL, NULL, 2),
(1044, NULL, 'Dell', 'S/N: CN-0VYTW5-72872-420-CJNL', 'Grasco Revisoria Fiscal', 622, 'Activo', NULL, NULL, 2),
(1045, NULL, 'Dell', 'GCO-A-2266', 'Grasco Revisoria Fiscal', 526, 'Activo', NULL, NULL, 2),
(1046, NULL, 'Dell', 'S/N: CN-0U853F-72872-973-28WI', 'Grasco Revisoria Fiscal', 642, 'Activo', NULL, NULL, 2),
(1047, NULL, 'Dell', 'MX-OG324H-74262-98A-10RL', 'Grasco Revisoria Fiscal', 470, 'Activo', NULL, NULL, 2),
(1048, NULL, 'Dell', 'GCO-A-1766', 'Grasco Revisoria Fiscal', 248, 'Activo', NULL, NULL, 2),
(1049, NULL, 'Dell', 'NO APLICA', 'Grasco Revisoria Fiscal', 107, 'Activo', NULL, NULL, 2),
(1050, NULL, 'Dell', 'BY4Z9F3', 'Grasco Caja - Tesoreria', 469, 'Activo', NULL, NULL, 2),
(1051, NULL, 'Dell', 'S/N: CN-ONDMRP-74261-1CG-067M', 'Grasco Comcercio Exterior', 238, 'Activo', NULL, NULL, 2),
(1052, NULL, 'Dell', '98TTQ62', 'Grasco Servicios Corporativos', 475, 'Activo', NULL, NULL, 2),
(1053, NULL, 'Dell', 'NO APLICA', 'Grasco Tesoreria', 79, 'Activo', NULL, NULL, 2),
(1054, NULL, 'Dell', '323Z9F3', 'Grasco Tesoreria', 409, 'Activo', NULL, NULL, 2),
(1055, NULL, 'Dell', 'GCO-A-0975', 'Grasco Sistemas', 569, 'Activo', NULL, NULL, 2),
(1056, NULL, 'Dell', '5JD6X42', 'Grasco Nomina', 99, 'Activo', NULL, NULL, 2),
(1057, NULL, 'Dell', 'NO APLICA', 'Grasco Nomina', 126, 'Activo', NULL, NULL, 2),
(1058, NULL, 'Dell', '3QB8092', 'Grasco Cuentas Por Pagar', 505, 'Activo', NULL, NULL, 2),
(1059, NULL, 'Dell', 'S/N: CN-07R1K3-74445-48T-716L', 'Grasco Cuentas Por Pagar', 501, 'Activo', NULL, NULL, 2),
(1060, NULL, 'Dell', 'NO APLICA', 'Grasco Nomina', 150, 'Activo', NULL, NULL, 2),
(1061, NULL, 'Dell', 'GCO-A-2098', 'Grasco Gth', 77, 'Activo', NULL, NULL, 2),
(1062, NULL, 'Dell', 'S/N: CN-0V8JY2-74261-34Q-5F8M', 'Grasco Gth', 102, 'Activo', NULL, NULL, 2),
(1063, NULL, 'Dell', 'BNCZ9F3', 'Grasco Seguridad', 189, 'Activo', NULL, NULL, 2),
(1064, NULL, 'Dell', 'GCO-A-2102', 'Grasco Tesoreria', 153, 'Activo', NULL, NULL, 2),
(1065, NULL, 'Dell', 'S/N: CN-0NDMRP-74261-21D-1575', 'Grasco Servicios Corporativos', 241, 'Activo', NULL, NULL, 2),
(1066, NULL, 'Dell', 'S/N: CN-0WKFYR-74261-09O-0GPL', 'Grasco Tic', 581, 'Activo', NULL, NULL, 2),
(1067, NULL, 'Dell', '8R4Z9F3', 'Grasco Servicios Corporativos', 474, 'Activo', NULL, NULL, 2),
(1068, NULL, 'Dell', 'S/C: CN-07R1K3-74445-4BR-5395', 'Grasco Servicios Corporativos', 224, 'Activo', NULL, NULL, 2),
(1069, NULL, 'Dell', 'S/N: CN-0XPG0H-74445-52R-DAQU', 'Grasco Sistemas', 604, 'Activo', NULL, NULL, 2),
(1070, NULL, 'Dell', 'NO APLICA', 'Grasco Tic', 471, 'Activo', NULL, NULL, 2),
(1071, NULL, 'Dell', 'BXFL1J2', 'Grasco Desarrollo', 146, 'Activo', NULL, NULL, 2),
(1072, NULL, 'Dell', 'GCO-A-2606', 'Grasco Gestion Documental', 657, 'Activo', NULL, NULL, 2),
(1073, NULL, 'Dell', 'GCO-A-2081', 'Grasco Cuentas Por Pagar', 61, 'Activo', NULL, NULL, 2),
(1074, NULL, 'Dell', 'S/N: CN-07R1K3-74445-48T-A0CL', 'Grasco Contabilidad', 517, 'Activo', NULL, NULL, 2),
(1075, NULL, 'Dell', 'GQ4Z9F3', 'Grasco Enfermeria', 19, 'Activo', NULL, NULL, 2),
(1076, NULL, 'Dell', 'GCO-A-2107', 'Grasco Nomina', 586, 'Activo', NULL, NULL, 2),
(1077, NULL, 'Dell', '414KZK2', 'Grasco Tecnologia', 283, 'Activo', NULL, NULL, 2),
(1078, NULL, 'Dell', 'S/N: CN-0524N3-74261-51F-3THB', 'Grasco Desarrollo', 142, 'Activo', NULL, NULL, 2),
(1079, NULL, 'Dell', 'GCO-A-2276', 'Grasco Compras', 481, 'Activo', NULL, NULL, 2),
(1080, NULL, 'Dell', 'FWFL1J2', 'Grasco Abastecimiento', 587, 'Activo', NULL, NULL, 2),
(1081, NULL, 'Dell', '25KKNB2', 'Grasco Subgerencia De Control', 644, 'Activo', NULL, NULL, 2),
(1082, NULL, 'Dell', 'S/N: CN-07R1K3-74445-44L-E5AL', 'Grasco Subgerencia De Control', 568, 'Activo', NULL, NULL, 2),
(1083, NULL, 'Dell', 'JR4Z9F3', 'Grasco Bascula', 717, 'Activo', NULL, NULL, 2),
(1084, NULL, 'Dell', '1X4Z9F3', 'Grasco Bascula', 717, 'Activo', NULL, NULL, 2),
(1085, NULL, 'Dell', '4HBZ9F3', 'Grasco Cd7', 717, 'Activo', NULL, NULL, 2),
(1086, NULL, 'Dell', 'S/N: CN-07R1K3-74445-49T-A1DL', 'Grasco Cd7', 717, 'Activo', NULL, NULL, 2),
(1087, NULL, 'Dell', '7KXCD93', 'Grasco Cd7', 717, 'Activo', NULL, NULL, 2),
(1088, NULL, 'Dell', '154Z9F3', 'Grasco Cd7', 717, 'Activo', NULL, NULL, 2),
(1089, NULL, 'Dell', 'B1YCD93', 'Grasco Cdn', 717, 'Activo', NULL, NULL, 2),
(1090, NULL, 'Dell', 'S/N: CN-07R1K3-74445-57F-819B', 'Grasco Cdn', 717, 'Activo', NULL, NULL, 2),
(1091, NULL, 'Dell', 'DLTO392', 'Grasco Cdn', 717, 'Activo', NULL, NULL, 2),
(1092, NULL, 'Dell', 'H08FQG2', 'Grasco Cdn', 717, 'Activo', NULL, NULL, 2),
(1093, NULL, 'Dell', '9R4Z9F3', 'Grasco Intermedias', 717, 'Activo', NULL, NULL, 2),
(1094, NULL, 'Dell', '313Z9F3', 'Grasco Intermedias', 717, 'Activo', NULL, NULL, 2),
(1095, NULL, 'Dell', '3T4Z9F3', 'Grasco Raza Cdr Bogota', 523, 'Activo', NULL, NULL, 2),
(1096, NULL, 'Dell', '292YQ62', 'Grasco Esponjillas', 717, 'Activo', NULL, NULL, 2),
(1097, NULL, 'Dell', '2SXCD93', 'Grasco Esponjillas', 717, 'Activo', NULL, NULL, 2),
(1098, NULL, 'Dell', 'FPXCD93', 'Grasco Esponjillas', 717, 'Activo', NULL, NULL, 2),
(1099, NULL, 'Dell', '4N4Z9F3', 'Grasco Produccion Y Calidad', 717, 'Activo', NULL, NULL, 2),
(1100, NULL, 'Dell', '9G4Z9F3', 'Grasco Produccion Y Calidad', 717, 'Activo', NULL, NULL, 2),
(1101, NULL, 'Dell', '6F4Z9F3', 'Grasco Produccion Y Calidad', 717, 'Activo', NULL, NULL, 2),
(1102, NULL, 'Dell', 'CF3Z9F3', 'Grasco Produccion Y Calidad', 717, 'Activo', NULL, NULL, 2),
(1103, NULL, 'Dell', '914Z9F3', 'Grasco Produccion Y Calidad', 717, 'Activo', NULL, NULL, 2),
(1104, NULL, 'Dell', 'S/N: CN-07R1K3-74445-49T-A1EL', 'Grasco Produccion Y Calidad', 717, 'Activo', NULL, NULL, 2),
(1105, NULL, 'Dell', 'S/N: CN-0WKFYR-74261-09O-29RS', 'Grasco Produccion Y Calidad', 717, 'Activo', NULL, NULL, 2),
(1106, NULL, 'Dell', '9Z4Z9F3', 'Grasco Ingenieria Y Mantenimiento', 564, 'Activo', NULL, NULL, 2),
(1107, NULL, 'Dell', '334Z9F3', 'Grasco Ingenieria Y Mantenimiento', 612, 'Activo', NULL, NULL, 2),
(1108, NULL, 'Dell', 'GF3Z9F3', 'Grasco Ingenieria Y Mantenimiento', 717, 'Activo', NULL, NULL, 2),
(1109, NULL, 'Dell', '8N3Z9F3', 'Grasco Ingenieria Y Mantenimiento', 717, 'Activo', NULL, NULL, 2),
(1110, NULL, 'Dell', 'S/N: CN-07R1K3-74445-54T-ADAS', 'Grasco Ingenieria Y Mantenimiento', 717, 'Activo', NULL, NULL, 2),
(1111, NULL, 'Dell', 'S/N: CN-0F8NDP-74261-176-0MLU', 'Grasco Ingenieria Y Mantenimiento', 717, 'Activo', NULL, NULL, 2),
(1112, NULL, 'Dell', 'FY2Z9F3', 'Grasco Ingenieria Y Mantenimiento', 717, 'Activo', NULL, NULL, 2),
(1113, NULL, 'Dell', 'D24Z9F3', 'Grasco Ingenieria Y Mantenimiento', 717, 'Activo', NULL, NULL, 2),
(1114, NULL, 'Dell', 'JZ2Z9F3', 'Grasco Ingenieria Y Mantenimiento', 717, 'Activo', NULL, NULL, 2),
(1115, NULL, 'Dell', '8S3Z9F3', 'Grasco Ingenieria Y Mantenimiento', 717, 'Activo', NULL, NULL, 2),
(1116, NULL, 'Dell', 'S/N: CN-008MT5-64180-51S-0KWB', 'Grasco Seguridad', 717, 'Activo', NULL, NULL, 2),
(1117, NULL, 'Dell', 'GCO-A-2618', 'Grasco Laboratorio', 717, 'Activo', NULL, NULL, 2),
(1118, NULL, 'Dell', 'CL4Z9F3', 'Grasco Laboratorio', 717, 'Activo', NULL, NULL, 2),
(1119, NULL, 'Dell', 'DX4Z9F3', 'Grasco Laboratorio', 717, 'Activo', NULL, NULL, 2),
(1120, NULL, 'Dell', '1KMNNG2', 'Grasco Laboratorio', 717, 'Activo', NULL, NULL, 2),
(1121, NULL, 'Dell', 'S/N: CN-0C553H-74445-95C-A842', 'Grasco Laboratorio', 717, 'Activo', NULL, NULL, 2),
(1122, NULL, 'Dell', 'DP4Z9F3', 'Grasco Laboratorio', 717, 'Activo', NULL, NULL, 2),
(1123, NULL, 'Dell', 'D05Z9F3', 'Grasco Laboratorio', 717, 'Activo', NULL, NULL, 2),
(1124, NULL, 'Dell', '3Z4Z9F3', 'Grasco Laboratorio', 717, 'Activo', NULL, NULL, 2),
(1125, NULL, 'Dell', 'DY4Z9F3', 'Grasco Produccion Y Calidad', 717, 'Activo', NULL, NULL, 2),
(1126, NULL, 'Dell', 'S/N: CN-0WKFYR-74261-116-110L', 'Grasco Gestion', 717, 'Activo', NULL, NULL, 2),
(1127, NULL, 'Dell', '1192', 'Grasco Ambiental', 717, 'Activo', NULL, NULL, 2),
(1128, NULL, 'Dell', 'S/N: CN-07RIK3-74445-4BR-153S', 'Grasco Ambiental', 87, 'Activo', NULL, NULL, 2),
(1129, NULL, 'Dell', 'COORDINADOR DE FORMACIÓN Y DESARROLLO', 'Gradezco - Segmento Alimentos Selección Y Formación', 131, 'Activo', NULL, NULL, 2),
(1130, NULL, 'Dell', 'METROLOGO', 'Gradezco - Segmento Alimentos Mantenimiento', 36, 'Activo', NULL, NULL, 2),
(1131, NULL, 'Dell', 'AUXILIAR CONTROL TOWER', 'Gradezco - Segmento Aseo Tms', 204, 'Activo', NULL, NULL, 2),
(1132, NULL, 'Dell', 'SUPERVISOR II CDN', 'Gradezco - Segmento Aseo Inventarios', 630, 'Activo', NULL, NULL, 2),
(1133, NULL, 'Dell', 'ADMINISTRADOR DE INFRAESTRUCTURA Y COMUN', 'Agora Csc S.a.s 6 - Csc Tic - General', 159, 'Activo', NULL, NULL, 2),
(1134, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR', 'Gradezco - Segmento Aseo Medellin', 96, 'Activo', NULL, NULL, 2),
(1135, NULL, 'Dell', 'ANALISTA DE CUENTAS TMS', 'Gradezco - Segmento Aseo Tms', 66, 'Activo', NULL, NULL, 2),
(1136, NULL, 'Dell', 'OPERADOR CRM', 'Gradezco - Segmento Aseo Crm', 177, 'Activo', NULL, NULL, 2),
(1137, NULL, 'Dell', 'INSPECTOR SST', 'Gradezco - Segmento Aseo Seguridad Y Salud En El Trabajo', 117, 'Activo', NULL, NULL, 2),
(1138, NULL, 'Dell', 'INGENIERO JUNIOR DE PLANTA', 'Gradezco - Segmento Nutricion Animal Nutricion Animal', 206, 'Activo', NULL, NULL, 2),
(1139, NULL, 'Dell', 'COORDINADOR GESTION DE CALIDAD', 'Gradezco - Segmento Aseo Sap Nova', 635, 'Activo', NULL, NULL, 2),
(1140, NULL, 'Dell', 'AUXILIAR DE CARTERA', 'Gradezco - Segmento Aseo Cartera', 237, 'Activo', NULL, NULL, 2),
(1141, NULL, 'Dell', 'JEFE REGIONAL DE VENTAS', 'Gradezco - Segmento Aseo Bucaramanga', 650, 'Activo', NULL, NULL, 2),
(1142, NULL, 'Dell', 'OPERARIO DE MEZCLAS', 'Gradezco - Segmento Alimentos Margarina Y Empaque', 558, 'Activo', NULL, NULL, 2),
(1143, NULL, 'Dell', 'ALMACENISTA', 'Gradezco - Segmento Alimentos Almacen De Repuestos', 275, 'Activo', NULL, NULL, 2),
(1144, NULL, 'Dell', 'GERENTE DE PLANTA', 'Gradezco - Segmento Aseo Planta Jaboneria', 572, 'Activo', NULL, NULL, 2),
(1145, NULL, 'Dell', 'COORDINADOR GESTION INTEGRAL', 'Gradezco - Segmento Aseo Operaciones Y Logistica', 221, 'Activo', NULL, NULL, 2),
(1146, NULL, 'Dell', 'JEFE DE PROCESOS Y APLICACIONES', 'Agora Csc S.a.s 6 - Csc Tic - General', 279, 'Activo', NULL, NULL, 2),
(1147, NULL, 'Dell', 'ANALISTA ADMINISTRATIVO DE VENTAS', 'Gradezco - Segmento Aseo Mesa De Ayuda', 180, 'Activo', NULL, NULL, 2),
(1148, NULL, 'Dell', 'AUXILIAR DE COMPENSACION Y BENEFICIOS', 'Gradezco - Segmento Alimentos Relaciones Laborales', 8, 'Activo', NULL, NULL, 2),
(1149, NULL, 'Dell', 'ANALISTA CONTABLE', 'Agora Csc S.a.s 6 - Csc Conciliaciones', 10, 'Activo', NULL, NULL, 2),
(1150, NULL, 'Dell', 'JEFE DE SEGURIDAD INDUSTRIAL', 'Gradezco - Segmento Alimentos Seguridad Y Salud En El Trabajo', 105, 'Activo', NULL, NULL, 2),
(1151, NULL, 'Dell', 'ESPECIALISTA DE COMPENSACION Y BENEFICIO', 'Indupalma 6 - Corporativos Indupalma - General', 235, 'Activo', NULL, NULL, 2),
(1152, NULL, 'Dell', 'ASISTENTE DE CARTERA', 'Gradezco - Segmento Aseo Sap Nova', 259, 'Activo', NULL, NULL, 2),
(1153, NULL, 'Dell', 'ADMINISTRADOR DISTRITO', 'Gradezco - Segmento Aseo Ibague', 617, 'Activo', NULL, NULL, 2),
(1154, NULL, 'Dell', 'ANALISTA DE SOPORTE, OPERACIÓN Y OFIMÁTI', 'Agora Csc S.a.s 6 - Csc Tic - General', 4, 'Activo', NULL, NULL, 2),
(1155, NULL, 'Dell', 'ANALISTA DE PROCESOS', 'Gradezco - Segmento Aseo Llenado', 602, 'Activo', NULL, NULL, 2),
(1156, NULL, 'Dell', 'AUXILIAR I CDN', 'Gradezco - Segmento Aseo Operaciones Y Logistica', 92, 'Activo', NULL, NULL, 2),
(1157, NULL, 'Dell', 'ASISTENTE DE CARTERA', 'Gradezco - Segmento Aseo Cartera', 473, 'Activo', NULL, NULL, 2),
(1158, NULL, 'Dell', 'SUBDIRECTOR CXP', 'Agora Csc S.a.s 6 - Csc Cxp', 490, 'Activo', NULL, NULL, 2),
(1159, NULL, 'Dell', 'SUBDIRECTOR DE CONTABILIDAD', 'Agora Csc S.a.s 6 - Csc Costos', 448, 'Activo', NULL, NULL, 2),
(1160, NULL, 'Dell', 'ANALISTA DE CUENTAS POR PAGAR', 'Agora Csc S.a.s 6 - Csc Cxp', 520, 'Activo', NULL, NULL, 2),
(1161, NULL, 'Dell', 'GERENTE DE VENTAS TRADICIONALES', 'Gradezco - Segmento Aseo Comercial', 608, 'Activo', NULL, NULL, 2),
(1162, NULL, 'Dell', 'INGENIERO DE MANTENIMIENTO', 'Gradezco - Segmento Alimentos Mantenimiento', 556, 'Activo', NULL, NULL, 2),
(1163, NULL, 'Dell', 'COMISION', 'Gradezco - Segmento Alimentos Gerencia General', 280, 'Activo', NULL, NULL, 2),
(1164, NULL, 'Dell', 'GERENTE DE PLANTA', 'Gradezco - Segmento Aseo Planta Detergentes', 580, 'Activo', NULL, NULL, 2),
(1165, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR', 'Gradezco - Segmento Nutricion Animal Agri', 560, 'Activo', NULL, NULL, 2),
(1166, NULL, 'Dell', 'ABOGADO SENIOR', 'Gradezco - Segmento Alimentos 1 - Jefatura Juridica Comercial', 620, 'Activo', NULL, NULL, 2),
(1167, NULL, 'Dell', 'DIRECTOR DE SUPPLY CHAIN', 'Gradezco - Segmento Aseo Supply Chain', 578, 'Activo', NULL, NULL, 2),
(1168, NULL, 'Dell', 'JEFE DE PRODUCTO', 'Gradezco - Segmento Aseo Mercadeo', 167, 'Activo', NULL, NULL, 2),
(1169, NULL, 'Dell', 'GERENTE DE TRADE MARKETING', 'Gradezco - Segmento Alimentos Trade', 618, 'Activo', NULL, NULL, 2),
(1170, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR', 'Gradezco - Segmento Aseo Cali', 226, 'Activo', NULL, NULL, 2),
(1171, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR', 'Gradezco - Segmento Nutricion Animal Consumer', 645, 'Activo', NULL, NULL, 2),
(1172, NULL, 'Dell', 'COORDINADOR SISTEMA GESTION CALIDAD', 'Gradezco - Segmento Nutricion Animal Control De Calidad', 166, 'Activo', NULL, NULL, 2),
(1173, NULL, 'Dell', 'PROFESIONAL DE DESARROLLO', 'Gradezco - Segmento Aseo Innovacion Y Desarrolllo', 11, 'Activo', NULL, NULL, 2),
(1174, NULL, 'Dell', 'ALMACENISTA', 'Gradezco - Segmento Aseo Almacen De Repuestos', 462, 'Activo', NULL, NULL, 2),
(1175, NULL, 'Dell', 'COMPRADOR', 'Gradezco - Segmento Nutricion Animal Compras', 208, 'Activo', NULL, NULL, 2),
(1176, NULL, 'Dell', 'ARQUITECTO IMPLEMENTADOR SOLUCIONES WEB', 'Agora Csc S.a.s 6 - Csc Tic - General', 270, 'Activo', NULL, NULL, 2),
(1177, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR', 'Gradezco - Segmento Nutricion Animal Consumer', 549, 'Activo', NULL, NULL, 2),
(1178, NULL, 'Dell', 'GERENTE DE INGENIERIA Y MANTENIMIENTO', 'Gradezco - Segmento Aseo Ingenieria Y Mantenimiento', 615, 'Activo', NULL, NULL, 2),
(1179, NULL, 'Dell', 'COORDINADOR DE PROCESOS CORE', 'Agora Csc S.a.s 6 - Csc Tic - General', 269, 'Activo', NULL, NULL, 2),
(1180, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR ESPECIAL', 'Gradezco - Segmento Aseo Ventas Tradicionales', 115, 'Activo', NULL, NULL, 2),
(1181, NULL, 'Dell', 'GERENTE GENERAL', 'Agora Csc S.a.s 7 - Oficina Calle 79', 566, 'Activo', NULL, NULL, 2),
(1182, NULL, 'Dell', 'JEFE CONTROL DE CALIDAD', 'Gradezco - Segmento Nutricion Animal Control De Calidad', 479, 'Activo', NULL, NULL, 2),
(1183, NULL, 'Dell', 'JEFE DE TURNO I - SABIZ', 'Gradezco - Segmento Aseo Sabiz', 535, 'Activo', NULL, NULL, 2),
(1184, NULL, 'Dell', 'INGENIERO DE PLANTA', 'Agora Csc S.a.s Lineas', 83, 'Activo', NULL, NULL, 2),
(1185, NULL, 'Dell', 'ASISTENTE DE BASCULA', 'Gradezco - Segmento Nutricion Animal Bascula', 585, 'Activo', NULL, NULL, 2),
(1186, NULL, 'Dell', 'AYUDANTE OFICIOS VARIOS', 'Gradezco - Segmento Aseo Liquidos', 27, 'Activo', NULL, NULL, 2),
(1187, NULL, 'Dell', 'SUPERVISOR DE VENTAS', 'Gradezco - Segmento Aseo Ventas Panaderia', 458, 'Activo', NULL, NULL, 2),
(1188, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR', 'Gradezco - Segmento Aseo Pereira', 457, 'Activo', NULL, NULL, 2),
(1189, NULL, 'Dell', 'ANALISTA DE TESORERIA', 'Gradezco - Segmento Alimentos Tesoreria', 522, 'Activo', NULL, NULL, 2),
(1190, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR', 'Gradezco - Segmento Nutricion Animal Consumer', 268, 'Activo', NULL, NULL, 2),
(1191, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR ESPECIAL', 'Gradezco - Segmento Aseo Ventas Cadenas', 64, 'Activo', NULL, NULL, 2),
(1192, NULL, 'Dell', 'AUXILIAR CONTROL TOWER', 'Gradezco - Segmento Aseo Operaciones Y Logistica', 118, 'Activo', NULL, NULL, 2),
(1193, NULL, 'Dell', 'AUXILIAR DE GESTION HUMANA', 'Gradezco - Segmento Aseo Relaciones Laborales', 34, 'Activo', NULL, NULL, 2),
(1194, NULL, 'Dell', 'AUX GESTIÓN DOCUMENTAL ARCHIVO Y CORRESP', 'Gradezco - Segmento Aseo Gestion Documental', 249, 'Activo', NULL, NULL, 2),
(1195, NULL, 'Dell', 'GERENTE GENERAL', 'Gradezco - Segmento Aseo Gerencia General', 658, 'Activo', NULL, NULL, 2),
(1196, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR ESPECIAL', 'Gradezco - Segmento Aseo Cali', 537, 'Activo', NULL, NULL, 2),
(1197, NULL, 'Dell', 'INGENIERO DE MANTENIMIENTO', 'Gradezco - Segmento Nutricion Animal Mantenimiento', 67, 'Activo', NULL, NULL, 2),
(1198, NULL, 'Dell', 'TECNICO ANALISTA DE LABORATORIO', 'Gradezco - Segmento Aseo 0', 533, 'Activo', NULL, NULL, 2),
(1199, NULL, 'Dell', 'AUDITOR FINANCIERO', 'Agora Csc S.a.s 7 - Oficina Cra 35', 486, 'Activo', NULL, NULL, 2),
(1200, NULL, 'Dell', 'LIDER AUTOSERVICIO INDEPENDIENTE', 'Gradezco - Segmento Aseo Medellin', 484, 'Activo', NULL, NULL, 2),
(1201, NULL, 'Dell', 'ASISTENTE DE GESTION HUMANA', 'Gradezco - Segmento Aseo Relaciones Laborales', 468, 'Activo', NULL, NULL, 2),
(1202, NULL, 'Dell', 'TECNICO ANALISTA DE LABORATORIO', 'Gradezco - Segmento Aseo Control De Calidad', 453, 'Activo', NULL, NULL, 2),
(1203, NULL, 'Dell', 'SUBGERENTE DE CONTROL', 'Agora Csc S.a.s 6 - Subgerencia De Control - General', 543, 'Activo', NULL, NULL, 2),
(1204, NULL, 'Dell', 'JEFE DE TURNO I - LLENADO', 'Gradezco - Segmento Aseo Llenado', 436, 'Activo', NULL, NULL, 2),
(1205, NULL, 'Dell', 'JEFE CONTROL DE CALIDAD', 'Gradezco - Segmento Aseo Control De Calidad', 494, 'Activo', NULL, NULL, 2),
(1206, NULL, 'Dell', 'ANALISTA FINANCIERO', 'Agora Csc S.a.s 6 - Dirección Financiera - General', 30, 'Activo', NULL, NULL, 2),
(1207, NULL, 'Dell', 'AUXILIAR GESTIÓN DOCUMENTAL', 'Agora Csc S.a.s 6 - Csc Cxp', 222, 'Activo', NULL, NULL, 2),
(1208, NULL, 'Dell', 'ADMINISTRADOR DISTRITO', 'Gradezco - Segmento Aseo Duitama', 455, 'Activo', NULL, NULL, 2),
(1209, NULL, 'Dell', 'AUXILIAR DE TESORERIA', 'Gradezco - Segmento Aseo Tesoreria', 542, 'Activo', NULL, NULL, 2),
(1210, NULL, 'Dell', 'ANALISTA QUIMICO', 'Gradezco - Segmento Aseo Control De Calidad', 98, 'Activo', NULL, NULL, 2),
(1211, NULL, 'Dell', 'CAJERO', 'Gradezco - Segmento Aseo Villavicencio', 544, 'Activo', NULL, NULL, 2),
(1212, NULL, 'Dell', 'ASISTENTE DE GESTION HUMANA', 'Gradezco - Segmento Nutricion Animal Relaciones Laborales', 210, 'Activo', NULL, NULL, 2),
(1213, NULL, 'Dell', 'JEFE DE MERCADERISTAS', 'Gradezco - Segmento Aseo Mercaderismo', 476, 'Activo', NULL, NULL, 2),
(1214, NULL, 'Dell', 'COORDINADOR DE NOMINA', 'Agora Csc S.a.s 6 - Csc Nómina - General', 499, 'Activo', NULL, NULL, 2),
(1215, NULL, 'Dell', 'ANALISTA DE PROCESOS', 'Gradezco - Segmento Aseo Pailas', 289, 'Activo', NULL, NULL, 2),
(1216, NULL, 'Dell', 'DIRECTOR GESTIÓN INTEGRAL DE PROCESOS', 'Agora Csc S.a.s 6 - Corporativos Indupalma - General', 495, 'Activo', NULL, NULL, 2),
(1217, NULL, 'Dell', 'AUXILIAR DE TESORERIA', 'Gradezco - Segmento Aseo Tesoreria', 478, 'Activo', NULL, NULL, 2),
(1218, NULL, 'Dell', 'AUXILIAR DE DISTRIBUCION Y LOGISTICA', 'Gradezco - Segmento Aseo Operaciones Y Logistica', 489, 'Activo', NULL, NULL, 2),
(1219, NULL, 'Dell', 'ANALISTA QUIMICO', 'Gradezco - Segmento Aseo Control De Calidad', 449, 'Activo', NULL, NULL, 2),
(1220, NULL, 'Dell', 'CAJERO', 'Gradezco - Segmento Aseo Pereira', 198, 'Activo', NULL, NULL, 2),
(1221, NULL, 'Dell', 'COORDINADOR CONTROL DE CALIDAD', 'Gradezco - Segmento Aseo Sap Nova', 288, 'Activo', NULL, NULL, 2),
(1222, NULL, 'Dell', 'JEFE DE BASCULA', 'Gradezco - Segmento Aseo Bascula', 573, 'Activo', NULL, NULL, 2),
(1223, NULL, 'Dell', 'ANALISTA DE RIESGOS', 'Gradezco - Segmento Alimentos Seguridad Y Prevencion De Perdidas', 626, 'Activo', NULL, NULL, 2),
(1224, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR', 'Gradezco - Segmento Aseo Comercial', 205, 'Activo', NULL, NULL, 2),
(1225, NULL, 'Dell', 'JEFE REGIONAL DE VENTAS', 'Gradezco - Segmento Aseo Pereira', 93, 'Activo', NULL, NULL, 2),
(1226, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR', 'Gradezco - Segmento Nutricion Animal Consumer', 631, 'Activo', NULL, NULL, 2),
(1227, NULL, 'Dell', 'GERENTE GENERAL', 'Gradezco - Segmento Aseo Gerencia General', 266, 'Activo', NULL, NULL, 2),
(1228, NULL, 'Dell', 'JEFE DE INGENIERIA Y MANTENIMIENTO', 'Gradezco - Segmento Aseo Mantenimiento', 654, 'Activo', NULL, NULL, 2),
(1229, NULL, 'Dell', 'JEFE REGIONAL DE VENTAS', 'Gradezco - Segmento Aseo Ventas Supermercados', 285, 'Activo', NULL, NULL, 2),
(1230, NULL, 'Dell', 'ANALISTA CONTROL TOWER', 'Gradezco - Segmento Aseo Tms', 58, 'Activo', NULL, NULL, 2),
(1231, NULL, 'Dell', 'ANALISTA CONTABLE', 'Agora Csc S.a.s 6 - Csc Conciliaciones', 144, 'Activo', NULL, NULL, 2),
(1232, NULL, 'Dell', 'OPERADOR CRM', 'Gradezco - Segmento Aseo Crm', 17, 'Activo', NULL, NULL, 2),
(1233, NULL, 'Dell', 'JEFE REGIONAL DE VENTAS', 'Gradezco - Segmento Aseo Medellin', 444, 'Activo', NULL, NULL, 2),
(1234, NULL, 'Dell', 'GERENTE DE CATEGORIA', 'Gradezco - Segmento Aseo Mercadeo', 500, 'Activo', NULL, NULL, 2),
(1235, NULL, 'Dell', 'AUXILIAR ADMINISTRATIVO DISTRITO', 'Gradezco - Segmento Aseo Ibague', 243, 'Activo', NULL, NULL, 2),
(1236, NULL, 'Dell', 'JEFE REGIONAL DE VENTAS', 'Gradezco - Segmento Aseo Ibague', 431, 'Activo', NULL, NULL, 2),
(1237, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR', 'Gradezco - Segmento Aseo Duitama', 463, 'Activo', NULL, NULL, 2),
(1238, NULL, 'Dell', 'ANALISTA CONTABLE', 'Agora Csc S.a.s 6 - Csc Conciliaciones', 124, 'Activo', NULL, NULL, 2),
(1239, NULL, 'Dell', 'JEFE DE TURNO I - PLANTA LIQUIDOS', 'Gradezco - Segmento Aseo Liquidos', 640, 'Activo', NULL, NULL, 2),
(1240, NULL, 'Dell', 'AUXILIAR DE RADICACIÓN', 'Agora Csc S.a.s 6 - Csc Cxp', 505, 'Activo', NULL, NULL, 2),
(1241, NULL, 'Dell', 'GERENTE DE CATEGORIA', 'Gradezco - Segmento Alimentos Mercadeo', 538, 'Activo', NULL, NULL, 2),
(1242, NULL, 'Dell', 'ANALISTA SENIOR DE ESTADOS FINANCIEROS', 'Agora Csc S.a.s 6 - Csc Estados Financieros Y Reportes', 194, 'Activo', NULL, NULL, 2),
(1243, NULL, 'Dell', 'ASISTENTE DE DIRECCIÓN FINANCIERA', 'Agora Csc S.a.s 6 - Dirección Financiera - General', 63, 'Activo', NULL, NULL, 2),
(1244, NULL, 'Dell', 'JEFE DE CARTERA', 'Gradezco - Segmento Aseo Cartera', 513, 'Activo', NULL, NULL, 2),
(1245, NULL, 'Dell', 'ANALISTA DE NÓMINA', 'Agora Csc S.a.s 6 - Csc Nómina - General', 53, 'Activo', NULL, NULL, 2),
(1246, NULL, 'Dell', 'SUPERVISOR DE CENTRO LOGISTICO', 'Gradezco - Segmento Aseo Tms', 523, 'Activo', NULL, NULL, 2),
(1247, NULL, 'Dell', 'JEFE REGIONAL DE VENTAS', 'Gradezco - Segmento Aseo Ventas Supermercados', 157, 'Activo', NULL, NULL, 2),
(1248, NULL, 'Dell', 'ANALISTA DE CUENTAS POR PAGAR', 'Agora Csc S.a.s 6 - Csc Cxp', 61, 'Activo', NULL, NULL, 2),
(1249, NULL, 'Dell', 'ANALISTA SENIOR DE IMPUESTOS', 'Agora Csc S.a.s 6 - Csc Impuestos', 90, 'Activo', NULL, NULL, 2),
(1250, NULL, 'Dell', 'ASISTENTE DESARROLLO HUMANO', 'Gradezco - Segmento Aseo Selección Y Formación', 21, 'Activo', NULL, NULL, 2),
(1251, NULL, 'Dell', 'AUXILIAR GESTION AMBIENTAL', 'Gradezco - Segmento Aseo Ambiental E Inocuidad', 87, 'Activo', NULL, NULL, 2),
(1252, NULL, 'Dell', 'GERENTE DE VENTAS CADENAS', 'Gradezco - Segmento Aseo Ventas Cadenas', 74, 'Activo', NULL, NULL, 2),
(1253, NULL, 'Dell', 'JEFE CONTROL DE CALIDAD', 'Gradezco - Segmento Alimentos Control De Calidad', 652, 'Activo', NULL, NULL, 2),
(1254, NULL, 'Dell', 'JEFE DE INVESTIGACION Y DESARROLLO', 'Gradezco - Segmento Nutricion Animal Innovacion Y Desarrolllo', 186, 'Activo', NULL, NULL, 2),
(1255, NULL, 'Dell', 'JEFE FORMULACION R&D', 'Gradezco - Segmento Nutricion Animal 4 - Investigacion Y Desarrollo', 447, 'Activo', NULL, NULL, 2),
(1256, NULL, 'Dell', 'JEFE DE ZONA', 'Gradezco - Segmento Aseo Agri', 202, 'Activo', NULL, NULL, 2),
(1257, NULL, 'Dell', 'DIRECTOR VENTAS INTERNACIONALES', 'Gradezco - Segmento Aseo Ventas Internacionales', 89, 'Activo', NULL, NULL, 2),
(1258, NULL, 'Dell', 'AUXILIAR DE GESTIÓN DOCUMENTAL', 'Gradezco - Segmento Alimentos Barranquilla', 646, 'Activo', NULL, NULL, 2),
(1259, NULL, 'Dell', 'GERENTE DE SOPORTE OPERATIVO', 'Gradezco - Segmento Alimentos Gerencia General', 621, 'Activo', NULL, NULL, 2),
(1260, NULL, 'Dell', 'DISEÑADOR GRAFICO', 'Gradezco - Segmento Alimentos Mercadeo', 6, 'Activo', NULL, NULL, 2),
(1261, NULL, 'Dell', 'INGENIERO DE MANTENIMIENTO', 'Gradezco - Segmento Aseo Sap Nova', 548, 'Activo', NULL, NULL, 2),
(1262, NULL, 'Dell', 'INGENIERO DE AUTOMATIZACION Y CONTROL', 'Gradezco - Segmento Aseo Mantenimiento', 284, 'Activo', NULL, NULL, 2),
(1263, NULL, 'Dell', 'COORDINADOR DE PROCESOS CORE', 'Agora Csc S.a.s 6 - Csc Tic - General', 628, 'Activo', NULL, NULL, 2),
(1264, NULL, 'Dell', 'JEFE INTELIGENCIA INFORMÁTICA DE NEGOCIO', 'Gradezco - Segmento Aseo 6 - Csc Tic - General', 649, 'Activo', NULL, NULL, 2),
(1265, NULL, 'Dell', 'ANALISTA DE PLANEACION', 'Gradezco - Segmento Aseo Operaciones Y Logistica', 49, 'Activo', NULL, NULL, 2),
(1266, NULL, 'Dell', 'ASISTENTE CANAL TRADICIONAL', 'Gradezco - Segmento Aseo 2 - Ventas Tradicionales', 46, 'Activo', NULL, NULL, 2),
(1267, NULL, 'Dell', 'ASISTENTE ADMINISTRATIVO', 'Gradezco - Segmento Nutricion Animal 2 - Subgerencia Administrativa', 609, 'Activo', NULL, NULL, 2),
(1268, NULL, 'Dell', 'ARQUITECTO IMPLEMENTADOR SOLUCIONES WEB', 'Agora Csc S.a.s 6 - Csc Tic - General', 547, 'Activo', NULL, NULL, 2),
(1269, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR', 'Gradezco - Segmento Aseo Ibague', 656, 'Activo', NULL, NULL, 2),
(1270, NULL, 'Dell', 'PRACTICANTE UNIVERSITARIO', 'Gradezco - Segmento Nutricion Animal Mantenimiento', 223, 'Activo', NULL, NULL, 2),
(1271, NULL, 'Dell', 'AUXILIAR VERIFICADOR', 'Gradezco - Segmento Aseo Operaciones Y Logistica', 161, 'Activo', NULL, NULL, 2),
(1272, NULL, 'Dell', 'COORDINADORA DE BIENESTAR, COMUNICACIONE', 'Gradezco - Segmento Aseo Selección Y Formación', 23, 'Activo', NULL, NULL, 2),
(1273, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR', 'Gradezco - Segmento Aseo Cali', 273, 'Activo', NULL, NULL, 2),
(1274, NULL, 'Dell', 'SUPERVISOR I CDN', 'Gradezco - Segmento Nutricion Animal Inventarios', 207, 'Activo', NULL, NULL, 2),
(1275, NULL, 'Dell', 'GERENTE DE PLANTA', 'Gradezco - Segmento Aseo Tensoactivos', 623, 'Activo', NULL, NULL, 2),
(1276, NULL, 'Dell', 'DIRECTOR CSC', 'Agora Csc S.a.s 6 - Dirección - General', 570, 'Activo', NULL, NULL, 2),
(1277, NULL, 'Dell', 'GERENTE DE PLANTA', 'Gradezco - Segmento Aseo Planta Liquidos', 592, 'Activo', NULL, NULL, 2),
(1278, NULL, 'Dell', 'INGENIERO JUNIOR DE PLANTA', 'Gradezco - Segmento Aseo Tensoactivos', 81, 'Activo', NULL, NULL, 2),
(1279, NULL, 'Dell', 'DESARROLLADOR WEB JUNIOR', 'Agora Csc S.a.s 6 - Csc Tic - General', 142, 'Activo', NULL, NULL, 2),
(1280, NULL, 'Dell', 'ASESOR TECNICO DE PANADERIA', 'Gradezco - Segmento Alimentos Mesa De Ayuda', 591, 'Activo', NULL, NULL, 2),
(1281, NULL, 'Dell', 'AUXILIAR DE COMPENSACION Y BENEFICIOS', 'Gradezco - Segmento Aseo Relaciones Laborales', 182, 'Activo', NULL, NULL, 2),
(1282, NULL, 'Dell', 'AYUDANTE OFICIOS VARIOS', 'Gradezco - Segmento Aseo Esponjillas', 546, 'Activo', NULL, NULL, 2),
(1283, NULL, 'Dell', 'ANALISTA DE SOPORTE, OPERACIÓN Y OFIMÁTI', 'Agora Csc S.a.s 6 - Csc Tic - General', 128, 'Activo', NULL, NULL, 2),
(1284, NULL, 'Dell', 'COORDINADOR LOGISTICO', 'Gradezco - Segmento Nutricion Animal Operaciones Y Logistica', 601, 'Activo', NULL, NULL, 2),
(1285, NULL, 'Dell', 'COORDINADOR DE COSTOS', 'Agora Csc S.a.s 6 - Csc Costos', 250, 'Activo', NULL, NULL, 2),
(1286, NULL, 'Dell', 'INGENIERO DE MANTENIMIENTO', 'Gradezco - Segmento Aseo Mantenimiento', 196, 'Activo', NULL, NULL, 2),
(1287, NULL, 'Dell', 'GERENTE DE SOPORTE OPERATIVO', 'Gradezco - Segmento Nutricion Animal Gerencia General', 562, 'Activo', NULL, NULL, 2),
(1288, NULL, 'Dell', 'JEFE DE TESORERIA', 'Gradezco - Segmento Aseo Tesoreria', 216, 'Activo', NULL, NULL, 2),
(1289, NULL, 'Dell', 'AUXILIAR DE DISTRIBUCION Y LOGISTICA', 'Gradezco - Segmento Aseo Operaciones Y Logistica', 258, 'Activo', NULL, NULL, 2),
(1290, NULL, 'Dell', 'ANALISTA CONTROL TOWER', 'Gradezco - Segmento Aseo Tms', 263, 'Activo', NULL, NULL, 2),
(1291, NULL, 'Dell', 'AUXILIAR CONTROL TOWER', 'Agora Csc S.a.s Tms', 247, 'Activo', NULL, NULL, 2),
(1292, NULL, 'Dell', 'ASISTENTE DE TESORERIA', 'Gradezco - Segmento Aseo Tesoreria', 230, 'Activo', NULL, NULL, 2),
(1293, NULL, 'Dell', 'ADMINISTRADOR DE BASE DE DATOS', 'Agora Csc S.a.s 6 - Csc Tic - General', 233, 'Activo', NULL, NULL, 2),
(1294, NULL, 'Dell', 'AUXILIAR DE DISTRIBUCION', 'Gradezco - Segmento Aseo 2 - Distribucion', 466, 'Activo', NULL, NULL, 2),
(1295, NULL, 'Dell', 'GERENTE DE COMPRAS', 'Gradezco - Segmento Alimentos Compras', 481, 'Activo', NULL, NULL, 2),
(1296, NULL, 'Dell', 'INGENIERO DE PLANTA', 'Gradezco - Segmento Aseo Planta Detergentes', 552, 'Activo', NULL, NULL, 2),
(1297, NULL, 'Dell', 'MECANICO I', 'Gradezco - Segmento Alimentos 1 - Superintendencia De Ingenieria Y Mantenimiento', 287, 'Activo', NULL, NULL, 2),
(1298, NULL, 'Dell', 'ADMINISTRADOR DE BASE DE DATOS', 'Agora Csc S.a.s 6 - Csc Tic - General', 225, 'Activo', NULL, NULL, 2),
(1299, NULL, 'Dell', 'ASISTENTE DE SERVICIOS ADMINISTRATIVOS', 'Gradezco - Segmento Aseo Servicios Administrativos', 26, 'Activo', NULL, NULL, 2),
(1300, NULL, 'Dell', 'COORDINADOR DE METROLOGIA', 'Gradezco - Segmento Aseo Mantenimiento', 599, 'Activo', NULL, NULL, 2),
(1301, NULL, 'Dell', 'INGENIERO JUNIOR DE PLANTA', 'Gradezco - Segmento Aseo Lineas', 641, 'Activo', NULL, NULL, 2),
(1302, NULL, 'Dell', 'SUBGERENTE ADMINISTRATIVO', 'Gradezco - Segmento Aseo Subgerencia Administrativa', 439, 'Activo', NULL, NULL, 2),
(1303, NULL, 'Dell', 'COORDINADOR DE TRANSPORTE', 'Gradezco - Segmento Aseo Tms', 120, 'Activo', NULL, NULL, 2),
(1304, NULL, 'Dell', 'AUXILIAR GESTIÓN DOCUMENTAL', 'Agora Csc S.a.s 6 - Csc Cxp', 460, 'Activo', NULL, NULL, 2),
(1305, NULL, 'Dell', 'ASISTENTE CONTROL DE EJECUCION', 'Gradezco - Segmento Aseo Mesa De Ayuda', 261, 'Activo', NULL, NULL, 2),
(1306, NULL, 'Dell', 'ANALISTA DE PROCESOS', 'Gradezco - Segmento Aseo Liquidos', 253, 'Activo', NULL, NULL, 2),
(1307, NULL, 'Dell', 'AUXILIAR DE TESORERIA', 'Gradezco - Segmento Alimentos Tesoreria', 433, 'Activo', NULL, NULL, 2),
(1308, NULL, 'Dell', 'ANALISTA DE INGENIERIA Y MANTENIMIENTO', 'Gradezco - Segmento Aseo Mantenimiento', 173, 'Activo', NULL, NULL, 2),
(1309, NULL, 'Dell', 'DESARROLLADOR WEB SENIOR', 'Agora Csc S.a.s 6 - Csc Tic - General', 146, 'Activo', NULL, NULL, 2),
(1310, NULL, 'Dell', 'JEFE REGIONAL DE VENTAS', 'Gradezco - Segmento Aseo Barranquilla', 553, 'Activo', NULL, NULL, 2),
(1311, NULL, 'Dell', 'SUPERVISOR DE AUDITORIA', 'Gradezco - Segmento Nutricion Animal Auditoria', 13, 'Activo', NULL, NULL, 2),
(1312, NULL, 'Dell', 'AUXILIAR DE ALMACEN', 'Gradezco - Segmento Alimentos Almacen De Repuestos', 597, 'Activo', NULL, NULL, 2),
(1313, NULL, 'Dell', 'ASISTENTE DE CARTERA', 'Gradezco - Segmento Aseo Cartera', 28, 'Activo', NULL, NULL, 2),
(1314, NULL, 'Dell', 'ANALISTA DE LABORATORIO', 'Gradezco - Segmento Aseo Innovacion Y Desarrolllo', 111, 'Activo', NULL, NULL, 2),
(1315, NULL, 'Dell', 'SUBDIRECTOR DE PLANEACION Y CONTROL FINA', 'Agora Csc S.a.s 6 - Dirección Financiera - General', 178, 'Activo', NULL, NULL, 2),
(1316, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR', 'Gradezco - Segmento Aseo Barranquilla', 440, 'Activo', NULL, NULL, 2),
(1317, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR', 'Gradezco - Segmento Aseo Villavicencio', 647, 'Activo', NULL, NULL, 2),
(1318, NULL, 'Dell', 'GERENTE DE PLANTA', 'Gradezco - Segmento Aseo Nutricion Animal', 254, 'Activo', NULL, NULL, 2),
(1319, NULL, 'Dell', 'AUXILIAR II CDN', 'Gradezco - Segmento Aseo Ibague', 655, 'Activo', NULL, NULL, 2),
(1320, NULL, 'Dell', 'INGENIERO DE MANTENIMIENTO', 'Gradezco - Segmento Alimentos Mantenimiento', 624, 'Activo', NULL, NULL, 2),
(1321, NULL, 'Dell', 'ASISTENTE COMERCIAL DPTO. JURIDICO', 'Gradezco - Segmento Alimentos Jurïdico', 201, 'Activo', NULL, NULL, 2),
(1322, NULL, 'Dell', 'JEFE DE CONTRALORÍA', 'Gradezco - Segmento Aseo Contraloria', 482, 'Activo', NULL, NULL, 2),
(1323, NULL, 'Dell', 'COORDINADOR DE SEGURIDAD INDUSTRIAL', 'Gradezco - Segmento Nutricion Animal Seguridad Y Salud En El Trabajo', 536, 'Activo', NULL, NULL, 2),
(1324, NULL, 'Dell', 'GERENTE DE VENTAS DETALLISTAS', 'Gradezco - Segmento Alimentos Ventas Detallistas', 614, 'Activo', NULL, NULL, 2),
(1325, NULL, 'Dell', 'SUPERVISOR DE MATERIALES', 'Gradezco - Segmento Aseo Materiales', 575, 'Activo', NULL, NULL, 2),
(1326, NULL, 'Dell', 'ASISTENTE ADMINISTRACION DE PLANTA II', 'Gradezco - Segmento Alimentos Corporativos', 432, 'Activo', NULL, NULL, 2),
(1327, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR', 'Gradezco - Segmento Nutricion Animal Consumer', 600, 'Activo', NULL, NULL, 2),
(1328, NULL, 'Dell', 'JEFE DE ZONA', 'Gradezco - Segmento Nutricion Animal Agri', 610, 'Activo', NULL, NULL, 2),
(1329, NULL, 'Dell', 'SUPERVISOR LOGISTICO', 'Gradezco - Segmento Alimentos 0', 56, 'Activo', NULL, NULL, 2),
(1330, NULL, 'Dell', 'JEFE DE INVESTIGACIÓN, SOLUCIONES WEB -', 'Agora Csc S.a.s 6 - Csc Tic - General', 255, 'Activo', NULL, NULL, 2),
(1331, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR ESPECIAL', 'Gradezco - Segmento Aseo Ventas Cadenas', 483, 'Activo', NULL, NULL, 2),
(1332, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR ESPECIAL', 'Gradezco - Segmento Nutricion Animal Comercial', 603, 'Activo', NULL, NULL, 2),
(1333, NULL, 'Dell', 'MERCADERISTA', 'Gradezco - Segmento Alimentos Mercaderismo', 450, 'Activo', NULL, NULL, 2),
(1334, NULL, 'Dell', 'JEFE DE GOBIERNO, RIESGO Y CUMPLIMIENTO', 'Agora Csc S.a.s 6 - Subgerencia De Control - General', 278, 'Activo', NULL, NULL, 2),
(1335, NULL, 'Dell', 'COORDINADOR CRM', 'Gradezco - Segmento Aseo Sap Nova', 518, 'Activo', NULL, NULL, 2),
(1336, NULL, 'Dell', 'APRENDIZ SENA', 'Gradezco - Segmento Alimentos Ubicacion Especifica', 240, 'Activo', NULL, NULL, 2),
(1337, NULL, 'Dell', 'GERENTE DE PLANTA', 'Gradezco - Segmento Alimentos Planta Alimentos', 256, 'Activo', NULL, NULL, 2),
(1338, NULL, 'Dell', 'INGENIERO DE PROCESOS', 'Gradezco - Segmento Aseo Planta Alimentos', 218, 'Activo', NULL, NULL, 2),
(1339, NULL, 'Dell', 'AUXILIAR DE GESTIÓN DOCUMENTAL', 'Gradezco - Segmento Alimentos Gestion Documental', 590, 'Activo', NULL, NULL, 2),
(1340, NULL, 'Dell', 'JEFE DE INFRAESTRUCTURA', 'Gradezco - Segmento Aseo Infraestructura Fisica', 252, 'Activo', NULL, NULL, 2),
(1341, NULL, 'Dell', 'DIRECTOR JURIDICO CORPORATIVO', 'Agora Csc S.a.s 6 - Jurídico - General', 465, 'Activo', NULL, NULL, 2),
(1342, NULL, 'Dell', 'SECRETARIO(A)', 'Agora Csc S.a.s 1 - Importaciones Y Exportaciones', 464, 'Activo', NULL, NULL, 2),
(1343, NULL, 'Dell', 'APRENDIZ SENA', 'Agora Csc S.a.s 6 - Csc Tic - General', 16, 'Activo', NULL, NULL, 2),
(1344, NULL, 'Dell', 'ASESOR TECNICO DE PANADERIA', 'Gradezco - Segmento Alimentos Mesa De Ayuda', 101, 'Activo', NULL, NULL, 2),
(1345, NULL, 'Dell', 'COORDINADOR DE GESTIÓN AMBIENTAL', 'Agora Csc S.a.s Ambiental E Inocuidad', 164, 'Activo', NULL, NULL, 2),
(1346, NULL, 'Dell', 'INGENIERO DE PROYECTOS', 'Gradezco - Segmento Nutricion Animal Proyectos', 633, 'Activo', NULL, NULL, 2),
(1347, NULL, 'Dell', 'ANALISTA DE PLANEACIÓN', 'Gradezco - Segmento Aseo Tms', 43, 'Activo', NULL, NULL, 2),
(1348, NULL, 'Dell', 'ANALISTA CONTABLE', 'Agora Csc S.a.s 6 - Csc Conciliaciones', 195, 'Activo', NULL, NULL, 2),
(1349, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR', 'Gradezco - Segmento Aseo Ventas Cadenas', 502, 'Activo', NULL, NULL, 2),
(1350, NULL, 'Dell', 'ASISTENTE ADMINISTRATIVO DPTO. JURIDICO', 'Agora Csc S.a.s 6 - Jurídico - General', 531, 'Activo', NULL, NULL, 2),
(1351, NULL, 'Dell', 'ASISTENTE WEB COMERCIAL', 'Gradezco - Segmento Aseo Mesa De Ayuda', 123, 'Activo', NULL, NULL, 2),
(1352, NULL, 'Dell', 'ANALISTA SENIOR DE ESTADOS FINANCIEROS', 'Agora Csc S.a.s 6 - Csc Estados Financieros Y Reportes', 160, 'Activo', NULL, NULL, 2),
(1353, NULL, 'Dell', 'GERENTE DE CATEGORIA', 'Gradezco - Segmento Aseo Mercadeo', 508, 'Activo', NULL, NULL, 2),
(1354, NULL, 'Dell', 'ANALISTA DE LABORATORIO', 'Gradezco - Segmento Aseo Innovacion Y Desarrolllo', 170, 'Activo', NULL, NULL, 2),
(1355, NULL, 'Dell', 'SUPERVISOR II CDN', 'Gradezco - Segmento Aseo Operaciones Y Logistica', 51, 'Activo', NULL, NULL, 2),
(1356, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR', 'Gradezco - Segmento Aseo Comercial', 446, 'Activo', NULL, NULL, 2),
(1357, NULL, 'Dell', 'SUPERVISOR DE CENTRO LOGISTICO', 'Gradezco - Segmento Nutricion Animal Villavicencio', 456, 'Activo', NULL, NULL, 2),
(1358, NULL, 'Dell', 'ADMINISTRADOR DISTRITO', 'Gradezco - Segmento Aseo Medellin', 636, 'Activo', NULL, NULL, 2),
(1359, NULL, 'Dell', 'ASISTENTE DE SERVICIOS ADMINISTRATIVOS', 'Gradezco - Segmento Aseo Servicios Administrativos', 84, 'Activo', NULL, NULL, 2),
(1360, NULL, 'Dell', 'JEFE DE COMERCIO EXTERIOR Y COMMODITIES', 'Agora Csc S.a.s Supply Chain', 82, 'Activo', NULL, NULL, 2),
(1361, NULL, 'Dell', 'JEFE DE INFRAESTRUCTURA Y SEG DE LA INFO', 'Gradezco - Segmento Aseo 6 - Csc Tic - General', 638, 'Activo', NULL, NULL, 2),
(1362, NULL, 'Dell', 'JEFE DE SEGURIDAD Y SALUD EN EL TRABAJO', 'Gradezco - Segmento Aseo Seguridad Y Salud En El Trabajo', 193, 'Activo', NULL, NULL, 2),
(1363, NULL, 'Dell', 'ANALISTA DE TESORERIA', 'Gradezco - Segmento Alimentos Tesoreria', 47, 'Activo', NULL, NULL, 2),
(1364, NULL, 'Dell', 'SUPERVISOR III CDN', 'Gradezco - Segmento Aseo Operaciones Y Logistica', 129, 'Activo', NULL, NULL, 2),
(1365, NULL, 'Dell', 'SUPERVISOR I CDN', 'Gradezco - Segmento Aseo Pereira', 227, 'Activo', NULL, NULL, 2),
(1366, NULL, 'Dell', 'COORDINADOR DE MATERIALES', 'Gradezco - Segmento Aseo Materiales', 215, 'Activo', NULL, NULL, 2),
(1367, NULL, 'Dell', 'DIRECTOR DE PRODUCCIÓN', 'Gradezco - Segmento Aseo Produccion', 545, 'Activo', NULL, NULL, 2),
(1368, NULL, 'Dell', 'SUPERVISOR I CDN', 'Gradezco - Segmento Aseo Operaciones Y Logistica', 236, 'Activo', NULL, NULL, 2),
(1369, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR ESPECIAL', 'Gradezco - Segmento Aseo Ventas Tradicionales', 565, 'Activo', NULL, NULL, 2),
(1370, NULL, 'Dell', 'APRENDIZ SENA', 'Gradezco - Segmento Aseo Relaciones Laborales', 40, 'Activo', NULL, NULL, 2),
(1371, NULL, 'Dell', 'DIRECTORA DE DESARROLLO DE NEGOCIOS E IN', 'Agora Csc S.a.s 6 - Dirección Corporativa - General', 461, 'Activo', NULL, NULL, 2),
(1372, NULL, 'Dell', 'ADMINISTRADOR DE CUMPLIMIENTO DE CIBERSE', 'Agora Csc S.a.s 6 - Csc Tic - General', 68, 'Activo', NULL, NULL, 2),
(1373, NULL, 'Dell', 'ASISTENTE DE GESTION HUMANA', 'Gradezco - Segmento Aseo Relaciones Laborales', 100, 'Activo', NULL, NULL, 2),
(1374, NULL, 'Dell', 'GERENTE COMERCIAL B2C', 'Agora Csc S.a.s Comercial', 659, 'Activo', NULL, NULL, 2),
(1375, NULL, 'Dell', 'ANALISTA DE PROCESOS', 'Gradezco - Segmento Aseo Pailas', 574, 'Activo', NULL, NULL, 2),
(1376, NULL, 'Dell', 'ASISTENTE INGENIERIA Y MANTENIMIENTO', 'Gradezco - Segmento Alimentos 0', 564, 'Activo', NULL, NULL, 2),
(1377, NULL, 'Dell', 'INGENIERO SOPORTE DE PROYECTOS', 'Gradezco - Segmento Aseo Sap Nova', 114, 'Activo', NULL, NULL, 2),
(1378, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR ESPECIAL', 'Gradezco - Segmento Aseo Medellin', 643, 'Activo', NULL, NULL, 2),
(1379, NULL, 'Dell', 'JEFE REGIONAL DE VENTAS', 'Gradezco - Segmento Aseo Cali', 271, 'Activo', NULL, NULL, 2),
(1380, NULL, 'Dell', 'CAJERO', 'Gradezco - Segmento Aseo Tesoreria', 86, 'Activo', NULL, NULL, 2),
(1381, NULL, 'Dell', 'ASISTENTE DE TESORERIA', 'Agora Csc S.a.s 6 - Tesorería - General', 140, 'Activo', NULL, NULL, 2),
(1382, NULL, 'Dell', 'CONSULTOR DE PROCESOS DE TECNOLOGÍA', 'Agora Csc S.a.s 6 - Csc Tic - General', 511, 'Activo', NULL, NULL, 2),
(1383, NULL, 'Dell', 'ANALISTA DE PRODUCCION', 'Gradezco - Segmento Nutricion Animal Nutricion Animal', 524, 'Activo', NULL, NULL, 2),
(1384, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR', 'Gradezco - Segmento Aseo Medellin', 438, 'Activo', NULL, NULL, 2),
(1385, NULL, 'Dell', 'DIRECTOR FINANCIERO CORPORATIVO', 'Agora Csc S.a.s 6 - Dirección Financiera - General', 595, 'Activo', NULL, NULL, 2),
(1386, NULL, 'Dell', 'DIRECTOR ASEGURAMIENTO DE CALIDAD', 'Gradezco - Segmento Aseo Aseguramiento De Calidad', 550, 'Activo', NULL, NULL, 2),
(1387, NULL, 'Dell', 'APRENDIZ SENA', 'Gradezco - Segmento Aseo 2 - Crm', 3, 'Activo', NULL, NULL, 2),
(1388, NULL, 'Dell', 'ANALISTA DE ATRACCION Y SELECCIÓN', 'Agora Csc S.a.s Selección Y Formación', 45, 'Activo', NULL, NULL, 2),
(1389, NULL, 'Dell', 'GERENTE GENERAL', 'Agora Csc S.a.s 2 - Comision', 567, 'Activo', NULL, NULL, 2),
(1390, NULL, 'Dell', 'JEFE DE TESORERIA', 'Gradezco - Segmento Nutricion Animal 6 - Tesorería - General', 153, 'Activo', NULL, NULL, 2),
(1391, NULL, 'Dell', 'JEFE ADMINISTRACION COMERCIAL', 'Gradezco - Segmento Aseo Sap Nova', 108, 'Activo', NULL, NULL, 2),
(1392, NULL, 'Dell', 'COORDINADOR DE MEDIOS Y DIGITAL', 'Gradezco - Segmento Alimentos Mercadeo', 232, 'Activo', NULL, NULL, 2),
(1393, NULL, 'Dell', 'ANALISTA QUIMICO', 'Gradezco - Segmento Aseo Control De Calidad', 530, 'Activo', NULL, NULL, 2),
(1394, NULL, 'Dell', 'JEFE DE COMPRAS', 'Gradezco - Segmento Aseo Sap Nova', 445, 'Activo', NULL, NULL, 2),
(1395, NULL, 'Dell', 'REPRESENTANTE DE VENTAS JUNIOR', 'Gradezco - Segmento Aseo Pereira', 228, 'Activo', NULL, NULL, 2),
(1396, NULL, 'Dell', 'JEFE DE TURNO I - PLANTA LIQUIDOS', 'Gradezco - Segmento Aseo Liquidos', 245, 'Activo', NULL, NULL, 2),
(1397, NULL, 'Dell', 'AUXILIAR DE CUENTAS POR PAGAR', 'Agora Csc S.a.s 6 - Csc Cxp', 525, 'Activo', NULL, NULL, 2),
(1398, NULL, 'Dell', 'APRENDIZ SENA', 'Gradezco - Segmento Alimentos 2 - Llenado', 184, 'Activo', NULL, NULL, 2),
(1399, NULL, 'Dell', 'INSPECTOR CONTROL DE CALIDAD', 'Gradezco - Segmento Aseo Control De Calidad', 540, 'Activo', NULL, NULL, 2),
(1400, NULL, 'Dell', 'TECNICO ANALISTA DE LABORATORIO', 'Gradezco - Segmento Aseo Control De Calidad', 443, 'Activo', NULL, NULL, 2),
(1401, NULL, 'Dell', 'JEFE OPERATIVO DISTRITOS', 'Gradezco - Segmento Aseo Sap Nova', 555, 'Activo', NULL, NULL, 2),
(1402, NULL, 'Dell', 'AUXILIAR CONTROL TOWER', 'Gradezco - Segmento Aseo Tms', 588, 'Activo', NULL, NULL, 2),
(1403, NULL, 'Dell', 'INGENIERO LÍDER DE MEJORA DE PROCESOS', 'Agora Csc S.a.s Sap Nova', 534, 'Activo', NULL, NULL, 2),
(1404, NULL, 'Dell', 'REPRESENTANTE DE VENTAS SENIOR', 'Gradezco - Segmento Aseo Barranquilla', 551, 'Activo', NULL, NULL, 2),
(1405, NULL, 'Dell', '0', 'Gradezco - Segmento Nutricion Animal 0', 18, 'Activo', NULL, NULL, 2),
(1406, NULL, 'Dell', 'GERENTE PROYECTOS ESPECIALES', 'Agora Csc S.a.s 6 - Dirección Gth - General', 441, 'Activo', NULL, NULL, 2),
(1407, NULL, 'Dell', 'JEFE DE TURNO', 'Gradezco - Segmento Alimentos Margarina Y Empaque', 632, 'Activo', NULL, NULL, 2);

--
-- Triggers `tbl_equipos`
--
DELIMITER //
CREATE TRIGGER `trg_equipos_bi` BEFORE INSERT ON `tbl_equipos` FOR EACH ROW BEGIN
    SET NEW.Marca_Equipo     = CapitalizarPalabras(NEW.Marca_Equipo);
    SET NEW.Ubicacion_Equipo = CapitalizarPalabras(NEW.Ubicacion_Equipo);
    SET NEW.Numero_Serie = UPPER(NEW.Numero_Serie);
END
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER `trg_equipos_bu` BEFORE UPDATE ON `tbl_equipos` FOR EACH ROW BEGIN
    SET NEW.Marca_Equipo     = CapitalizarPalabras(NEW.Marca_Equipo);
    SET NEW.Ubicacion_Equipo = CapitalizarPalabras(NEW.Ubicacion_Equipo);
    SET NEW.Numero_Serie = UPPER(NEW.Numero_Serie);
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_historial`
--

CREATE TABLE `tbl_historial` (
  `Id_Historial` int(11) NOT NULL,
  `Id_Equipo` int(11) DEFAULT NULL,
  `Tipo_Entidad` enum('Equipo','Mantenimiento') NOT NULL DEFAULT 'Equipo',
  `Campo_Cambiado` varchar(255) DEFAULT NULL,
  `Valor_Anterior` varchar(255) DEFAULT NULL,
  `Descripcion_Historial` varchar(255) DEFAULT NULL,
  `Valor_Nuevo` varchar(255) DEFAULT NULL,
  `Fecha_Cambio` date DEFAULT NULL,
  `Id_Empleado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `tbl_historial`
--
DELIMITER //
CREATE TRIGGER `trg_historial_bi` BEFORE INSERT ON `tbl_historial` FOR EACH ROW BEGIN
    SET NEW.Valor_Anterior = CapitalizarPalabras(NEW.Valor_Anterior);
    SET NEW.Descripcion_Historial = CapitalizarPalabras(NEW.Descripcion_Historial);
    SET NEW.Valor_Nuevo = CapitalizarPalabras(NEW.Valor_Nuevo);
END
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER `trg_historial_bu` BEFORE UPDATE ON `tbl_historial` FOR EACH ROW BEGIN
    SET NEW.Valor_Anterior = CapitalizarPalabras(NEW.Valor_Anterior);
    SET NEW.Descripcion_Historial = CapitalizarPalabras(NEW.Descripcion_Historial);
    SET NEW.Valor_Nuevo = CapitalizarPalabras(NEW.Valor_Nuevo);
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_mantenimiento`
--

CREATE TABLE `tbl_mantenimiento` (
  `Id_Mantenimiento` int(11) NOT NULL,
  `Id_Equipo` int(11) DEFAULT NULL,
  `Id_Empleado` int(11) DEFAULT NULL,
  `Fecha_Mantenimiento` date DEFAULT NULL,
  `Descripcion_Mantenimiento` varchar(255) DEFAULT NULL,
  `Estado_Mantenimiento` enum('Activo','Inactivo','Mantenimiento','Dado de Baja') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `tbl_mantenimiento`
--
DELIMITER //
CREATE TRIGGER `trg_mantenimiento_bi` BEFORE INSERT ON `tbl_mantenimiento` FOR EACH ROW BEGIN
    SET NEW.Descripcion_Mantenimiento = CapitalizarPalabras(NEW.Descripcion_Mantenimiento);
END
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER `trg_mantenimiento_bu` BEFORE UPDATE ON `tbl_mantenimiento` FOR EACH ROW BEGIN
    SET NEW.Descripcion_Mantenimiento = CapitalizarPalabras(NEW.Descripcion_Mantenimiento);
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_rol`
--

CREATE TABLE `tbl_rol` (
  `Id_Rol` int(11) NOT NULL,
  `Nombre_Rol` varchar(255) DEFAULT NULL,
  `Descripcion_Rol` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_rol`
--

INSERT INTO `tbl_rol` (`Id_Rol`, `Nombre_Rol`, `Descripcion_Rol`) VALUES
(1, 'Administrador', 'Acceso Total Al Sistema'),
(2, 'Usuario', 'Acceso Básico Al Sistema'),
(3, 'Supervisor', 'Supervisión De Inventario'),
(4, 'Técnico', 'Técnico De Mantenimiento');

--
-- Triggers `tbl_rol`
--
DELIMITER //
CREATE TRIGGER `trg_rol_bi` BEFORE INSERT ON `tbl_rol` FOR EACH ROW BEGIN
    SET NEW.Nombre_Rol = CapitalizarPalabras(NEW.Nombre_Rol);
    SET NEW.Descripcion_Rol = CapitalizarPalabras(NEW.Descripcion_Rol);
END
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER `trg_rol_bu` BEFORE UPDATE ON `tbl_rol` FOR EACH ROW BEGIN
    SET NEW.Nombre_Rol = CapitalizarPalabras(NEW.Nombre_Rol);
    SET NEW.Descripcion_Rol = CapitalizarPalabras(NEW.Descripcion_Rol);
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_tipo_equipo`
--

CREATE TABLE `tbl_tipo_equipo` (
  `Id_Tipo_Equipo` int(11) NOT NULL,
  `Nombre_Tipo_Equipo` varchar(255) DEFAULT NULL,
  `Descripcion_Tipo_Equipo` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_tipo_equipo`
--

INSERT INTO `tbl_tipo_equipo` (`Id_Tipo_Equipo`, `Nombre_Tipo_Equipo`, `Descripcion_Tipo_Equipo`) VALUES
(1, 'Computadora', 'Equipos De Cómputo De Escritorio Y Portátiles'),
(2, 'Monitor', 'Monitores Para Visualización'),
(3, 'Impresora', 'Impresoras Y Multifuncionales'),
(4, 'Router', 'Equipos De Red'),
(5, 'Escáner', 'Equipos De Escaneo De Documentos'),
(6, 'Teléfono', 'Teléfonos Y Equipos De Comunicación'),
(7, 'Servidor', 'Servidores De Red');

--
-- Triggers `tbl_tipo_equipo`
--
DELIMITER //
CREATE TRIGGER `trg_tipo_equipo_bi` BEFORE INSERT ON `tbl_tipo_equipo` FOR EACH ROW BEGIN
    SET NEW.Nombre_Tipo_Equipo = CapitalizarPalabras(NEW.Nombre_Tipo_Equipo);
    SET NEW.Descripcion_Tipo_Equipo = CapitalizarPalabras(NEW.Descripcion_Tipo_Equipo);
END
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER `trg_tipo_equipo_bu` BEFORE UPDATE ON `tbl_tipo_equipo` FOR EACH ROW BEGIN
    SET NEW.Nombre_Tipo_Equipo = CapitalizarPalabras(NEW.Nombre_Tipo_Equipo);
    SET NEW.Descripcion_Tipo_Equipo = CapitalizarPalabras(NEW.Descripcion_Tipo_Equipo);
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_usuario`
--

CREATE TABLE `tbl_usuario` (
  `Id_Usuario` int(11) NOT NULL,
  `documento_Usuario` varchar(50) NOT NULL,
  `Nombre_Usuario` varchar(255) NOT NULL,
  `Password_Usuario` varchar(255) NOT NULL,
  `Id_Empleado` int(11) DEFAULT NULL,
  `Id_Rol` int(11) NOT NULL,
  `Token_Recuperacion` varchar(255) DEFAULT NULL,
  `Token_Expira` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `tbl_usuario`
--
DELIMITER //
CREATE TRIGGER `trg_usuario_set_empleado` BEFORE INSERT ON `tbl_usuario` FOR EACH ROW BEGIN
    DECLARE v_id_empleado INT;

    -- Buscar empleado con el mismo documento
    SELECT Id_Empleado INTO v_id_empleado
    FROM tbl_empleado
    WHERE documento_Empleado = NEW.documento_Usuario
    LIMIT 1;

    -- Si existe, asignar el Id_Empleado al usuario
    SET NEW.Id_Empleado = v_id_empleado;
END
//
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_archivo`
--
ALTER TABLE `tbl_archivo`
  ADD PRIMARY KEY (`Id_Archivo`);

--
-- Indexes for table `tbl_cargo`
--
ALTER TABLE `tbl_cargo`
  ADD PRIMARY KEY (`Id_Cargo`),
  ADD UNIQUE KEY `Nombre_Cargo` (`Nombre_Cargo`);

--
-- Indexes for table `tbl_empleado`
--
ALTER TABLE `tbl_empleado`
  ADD PRIMARY KEY (`Id_Empleado`),
  ADD KEY `Id_Cargo` (`Id_Cargo`);

--
-- Indexes for table `tbl_equipos`
--
ALTER TABLE `tbl_equipos`
  ADD PRIMARY KEY (`Id_Equipo`),
  ADD KEY `Propietario_Equipo` (`Propietario_Equipo`),
  ADD KEY `Id_Archivo` (`Id_Archivo`),
  ADD KEY `Id_Tipo_Equipo` (`Id_Tipo_Equipo`);

--
-- Indexes for table `tbl_historial`
--
ALTER TABLE `tbl_historial`
  ADD PRIMARY KEY (`Id_Historial`),
  ADD KEY `Id_Equipo` (`Id_Equipo`),
  ADD KEY `Id_Empleado` (`Id_Empleado`);

--
-- Indexes for table `tbl_mantenimiento`
--
ALTER TABLE `tbl_mantenimiento`
  ADD PRIMARY KEY (`Id_Mantenimiento`),
  ADD KEY `Id_Equipo` (`Id_Equipo`),
  ADD KEY `Id_Empleado` (`Id_Empleado`);

--
-- Indexes for table `tbl_rol`
--
ALTER TABLE `tbl_rol`
  ADD PRIMARY KEY (`Id_Rol`),
  ADD UNIQUE KEY `Nombre_Rol` (`Nombre_Rol`);

--
-- Indexes for table `tbl_tipo_equipo`
--
ALTER TABLE `tbl_tipo_equipo`
  ADD PRIMARY KEY (`Id_Tipo_Equipo`),
  ADD UNIQUE KEY `Nombre_Tipo_Equipo` (`Nombre_Tipo_Equipo`);

--
-- Indexes for table `tbl_usuario`
--
ALTER TABLE `tbl_usuario`
  ADD PRIMARY KEY (`Id_Usuario`),
  ADD UNIQUE KEY `documento_Usuario` (`documento_Usuario`),
  ADD UNIQUE KEY `Nombre_Usuario` (`Nombre_Usuario`),
  ADD KEY `Id_Empleado` (`Id_Empleado`),
  ADD KEY `Id_Rol` (`Id_Rol`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_archivo`
--
ALTER TABLE `tbl_archivo`
  MODIFY `Id_Archivo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_cargo`
--
ALTER TABLE `tbl_cargo`
  MODIFY `Id_Cargo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_empleado`
--
ALTER TABLE `tbl_empleado`
  MODIFY `Id_Empleado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=764;

--
-- AUTO_INCREMENT for table `tbl_equipos`
--
ALTER TABLE `tbl_equipos`
  MODIFY `Id_Equipo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1408;

--
-- AUTO_INCREMENT for table `tbl_historial`
--
ALTER TABLE `tbl_historial`
  MODIFY `Id_Historial` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_mantenimiento`
--
ALTER TABLE `tbl_mantenimiento`
  MODIFY `Id_Mantenimiento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_rol`
--
ALTER TABLE `tbl_rol`
  MODIFY `Id_Rol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_tipo_equipo`
--
ALTER TABLE `tbl_tipo_equipo`
  MODIFY `Id_Tipo_Equipo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tbl_usuario`
--
ALTER TABLE `tbl_usuario`
  MODIFY `Id_Usuario` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_empleado`
--
ALTER TABLE `tbl_empleado`
  ADD CONSTRAINT `tbl_empleado_ibfk_1` FOREIGN KEY (`Id_Cargo`) REFERENCES `tbl_cargo` (`Id_Cargo`);

--
-- Constraints for table `tbl_equipos`
--
ALTER TABLE `tbl_equipos`
  ADD CONSTRAINT `tbl_equipos_ibfk_1` FOREIGN KEY (`Propietario_Equipo`) REFERENCES `tbl_empleado` (`Id_Empleado`),
  ADD CONSTRAINT `tbl_equipos_ibfk_2` FOREIGN KEY (`Id_Archivo`) REFERENCES `tbl_archivo` (`Id_Archivo`),
  ADD CONSTRAINT `tbl_equipos_ibfk_3` FOREIGN KEY (`Id_Tipo_Equipo`) REFERENCES `tbl_tipo_equipo` (`Id_Tipo_Equipo`);

--
-- Constraints for table `tbl_historial`
--
ALTER TABLE `tbl_historial`
  ADD CONSTRAINT `tbl_historial_ibfk_1` FOREIGN KEY (`Id_Equipo`) REFERENCES `tbl_equipos` (`Id_Equipo`),
  ADD CONSTRAINT `tbl_historial_ibfk_2` FOREIGN KEY (`Id_Empleado`) REFERENCES `tbl_empleado` (`Id_Empleado`);

--
-- Constraints for table `tbl_mantenimiento`
--
ALTER TABLE `tbl_mantenimiento`
  ADD CONSTRAINT `tbl_mantenimiento_ibfk_1` FOREIGN KEY (`Id_Equipo`) REFERENCES `tbl_equipos` (`Id_Equipo`),
  ADD CONSTRAINT `tbl_mantenimiento_ibfk_2` FOREIGN KEY (`Id_Empleado`) REFERENCES `tbl_empleado` (`Id_Empleado`);

--
-- Constraints for table `tbl_usuario`
--
ALTER TABLE `tbl_usuario`
  ADD CONSTRAINT `tbl_usuario_ibfk_1` FOREIGN KEY (`Id_Empleado`) REFERENCES `tbl_empleado` (`Id_Empleado`),
  ADD CONSTRAINT `tbl_usuario_ibfk_2` FOREIGN KEY (`Id_Rol`) REFERENCES `tbl_rol` (`Id_Rol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- Triggers de auditoría adicionales
DELIMITER //

-- Triggers para equipos
CREATE TRIGGER `trg_equipos_auditoria` AFTER UPDATE ON `tbl_equipos` FOR EACH ROW BEGIN
    IF OLD.Marca_Equipo != NEW.Marca_Equipo THEN
        INSERT INTO tbl_historial (Id_Equipo, Tipo_Entidad, Campo_Cambiado, Valor_Anterior, Valor_Nuevo, Descripcion_Historial, Fecha_Cambio, Id_Empleado)
        VALUES (NEW.Id_Equipo, 'Equipo', 'Marca_Equipo', OLD.Marca_Equipo, NEW.Marca_Equipo, CONCAT('Cambio de marca'), CURDATE(), NEW.Propietario_Equipo);
    END IF;
    IF OLD.Numero_Serie != NEW.Numero_Serie THEN
        INSERT INTO tbl_historial (Id_Equipo, Tipo_Entidad, Campo_Cambiado, Valor_Anterior, Valor_Nuevo, Descripcion_Historial, Fecha_Cambio, Id_Empleado)
        VALUES (NEW.Id_Equipo, 'Equipo', 'Numero_Serie', OLD.Numero_Serie, NEW.Numero_Serie, CONCAT('Cambio de serie'), CURDATE(), NEW.Propietario_Equipo);
    END IF;
    IF OLD.Ubicacion_Equipo != NEW.Ubicacion_Equipo THEN
        INSERT INTO tbl_historial (Id_Equipo, Tipo_Entidad, Campo_Cambiado, Valor_Anterior, Valor_Nuevo, Descripcion_Historial, Fecha_Cambio, Id_Empleado)
        VALUES (NEW.Id_Equipo, 'Equipo', 'Ubicacion_Equipo', OLD.Ubicacion_Equipo, NEW.Ubicacion_Equipo, CONCAT('Cambio de ubicación'), CURDATE(), NEW.Propietario_Equipo);
    END IF;
    IF OLD.Propietario_Equipo != NEW.Propietario_Equipo THEN
        INSERT INTO tbl_historial (Id_Equipo, Tipo_Entidad, Campo_Cambiado, Valor_Anterior, Valor_Nuevo, Descripcion_Historial, Fecha_Cambio, Id_Empleado)
        VALUES (NEW.Id_Equipo, 'Equipo', 'Propietario_Equipo', OLD.Propietario_Equipo, NEW.Propietario_Equipo, CONCAT('Cambio de propietario'), CURDATE(), NEW.Propietario_Equipo);
    END IF;
    IF OLD.Estado_Equipo != NEW.Estado_Equipo THEN
        INSERT INTO tbl_historial (Id_Equipo, Tipo_Entidad, Campo_Cambiado, Valor_Anterior, Valor_Nuevo, Descripcion_Historial, Fecha_Cambio, Id_Empleado)
        VALUES (NEW.Id_Equipo, 'Equipo', 'Estado_Equipo', OLD.Estado_Equipo, NEW.Estado_Equipo, CONCAT('Cambio de estado'), CURDATE(), NEW.Propietario_Equipo);
    END IF;
    IF OLD.Id_Tipo_Equipo != NEW.Id_Tipo_Equipo THEN
        INSERT INTO tbl_historial (Id_Equipo, Tipo_Entidad, Campo_Cambiado, Valor_Anterior, Valor_Nuevo, Descripcion_Historial, Fecha_Cambio, Id_Empleado)
        VALUES (NEW.Id_Equipo, 'Equipo', 'Id_Tipo_Equipo', OLD.Id_Tipo_Equipo, NEW.Id_Tipo_Equipo, CONCAT('Cambio de tipo'), CURDATE(), NEW.Propietario_Equipo);
    END IF;
END//

-- Triggers para mantenimiento
CREATE TRIGGER `trg_mantenimiento_auditoria_insert` AFTER INSERT ON `tbl_mantenimiento` FOR EACH ROW
BEGIN
    INSERT INTO tbl_historial (Id_Equipo, Tipo_Entidad, Campo_Cambiado, Valor_Anterior, Valor_Nuevo, Descripcion_Historial, Fecha_Cambio, Id_Empleado)
    VALUES (NEW.Id_Equipo, 'Mantenimiento', 'Nuevo_Mantenimiento', NULL, NEW.Id_Mantenimiento, CONCAT('Nuevo mantenimiento: ', NEW.Descripcion_Mantenimiento), NEW.Fecha_Mantenimiento, NEW.Id_Empleado);
END//

CREATE TRIGGER `trg_mantenimiento_auditoria_update` AFTER UPDATE ON `tbl_mantenimiento` FOR EACH ROW
BEGIN
    IF OLD.Descripcion_Mantenimiento != NEW.Descripcion_Mantenimiento THEN
        INSERT INTO tbl_historial (Id_Equipo, Tipo_Entidad, Campo_Cambiado, Valor_Anterior, Valor_Nuevo, Descripcion_Historial, Fecha_Cambio, Id_Empleado)
        VALUES (NEW.Id_Equipo, 'Mantenimiento', 'Descripcion_Mantenimiento', OLD.Descripcion_Mantenimiento, NEW.Descripcion_Mantenimiento, CONCAT('Cambio en descripción de mantenimiento'), CURDATE(), NEW.Id_Empleado);
    END IF;
    IF OLD.Estado_Mantenimiento != NEW.Estado_Mantenimiento THEN
        INSERT INTO tbl_historial (Id_Equipo, Tipo_Entidad, Campo_Cambiado, Valor_Anterior, Valor_Nuevo, Descripcion_Historial, Fecha_Cambio, Id_Empleado)
        VALUES (NEW.Id_Equipo, 'Mantenimiento', 'Estado_Mantenimiento', OLD.Estado_Mantenimiento, NEW.Estado_Mantenimiento, CONCAT('Cambio en estado de mantenimiento'), CURDATE(), NEW.Id_Empleado);
    END IF;
END//

DELIMITER ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;



