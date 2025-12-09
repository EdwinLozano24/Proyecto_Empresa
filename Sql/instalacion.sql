-- ==========================================
-- SCRIPT DE INSTALACIÓN RÁPIDA
-- Inventario de Equipos - Base de Datos
-- ==========================================

-- 1. CREAR BASE DE DATOS
CREATE DATABASE IF NOT EXISTS inventario_equipos_gradezco 
DEFAULT CHARACTER SET utf8mb4 
DEFAULT COLLATE utf8mb4_unicode_ci;

-- 2. USAR LA BASE DE DATOS
USE inventario_equipos_gradezco;

-- 3. MOSTRAR ESTADO
-- SELECT 'Base de datos creada correctamente' as estado;

-- NOTAS:
-- - Si recibe un error de permisos, intente con:
--   mysql -u root -p < instalacion.sql
-- 
-- - Después de crear la BD, ejecute el archivo: Sql/Codigo.sql
--   para crear todas las tablas y triggers
--
-- - Acceda a phpMyAdmin: http://localhost/phpmyadmin
--   para importar Sql/Codigo.sql manualmente
