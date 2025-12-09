<?php
/**
 * Archivo: cerrarSesion.php
 * Maneja el cierre de sesión del usuario
 */

session_start();
session_destroy();
header('Location: /inventario_equipos/view/loginRegister.php');
exit();
?>
