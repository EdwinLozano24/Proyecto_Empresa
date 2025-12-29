<?php
/**
 * Archivo: protecciones.php
 * Proporciona funciones para proteger páginas que requieren autenticación
 */

 // Inicia sesión solo si no está activa
 if (session_status() === PHP_SESSION_NONE) {
     session_start();
 }

require_once __DIR__ . '/conexion.php';
require_once __DIR__ . '/../controller/usuarioController.php';

/**
 * Verifica si el usuario está autenticado
 * Si no está autenticado, redirige a login
 */
function protegerPagina() {
    if (!UsuarioController::usuarioAutenticado()) {
        header('Location: /inventario_equipos/view/loginRegister.php');
        exit();
    }
}

/**
 * Verifica si el usuario tiene un rol específico
 * @param string|array $rolesPermitidos
 */
function verificarRol($rolesPermitidos) {
    if (!is_array($rolesPermitidos)) {
        $rolesPermitidos = [$rolesPermitidos];
    }

    $usuario = UsuarioController::obtenerUsuarioActual();
    
    if (!$usuario || !in_array($usuario['rol'], $rolesPermitidos)) {
        die('Acceso denegado: No tienes permisos para acceder a esta página');
    }
}

/**
 * Cierra la sesión del usuario
 */
function cerrarSesion() {
    session_destroy();
    header('Location: /inventario_equipos/view/loginRegister.php');
    exit();
}
?>
