<?php
session_start();

// Proteger ruta usando helper común
require_once __DIR__ . '/../app/protecciones.php';
protegerPagina();

require_once '../app/conexion.php';
require_once '../model/historialModel.php';

$conexion = conectar();
$historialModel = new HistorialModel($conexion);

$accion = isset($_GET['accion']) ? $_GET['accion'] : 'listar';
$mensaje = '';
$tipo_mensaje = '';

// Permitir mensajes flash
if (isset($_GET['mensaje']) && $_GET['mensaje'] !== '') {
    $mensaje = $_GET['mensaje'];
}
if (isset($_GET['tipo_mensaje']) && $_GET['tipo_mensaje'] !== '') {
    $tipo_mensaje = $_GET['tipo_mensaje'];
}

$historial = [];

if ($accion == 'listar') {
    $historial = $historialModel->obtenerTodos();
} elseif ($accion == 'equipo' && isset($_GET['id'])) {
    $idEquipo = $_GET['id'];
    $historial = $historialModel->obtenerPorEquipo($idEquipo);
}

// Incluir la vista
require_once '../view/historial.php';
?>