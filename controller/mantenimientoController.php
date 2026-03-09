<?php
session_start();

require_once __DIR__ . '/../app/protecciones.php';
protegerPagina();

require_once __DIR__ . '/../app/conexion.php';
require_once __DIR__ . '/../model/equipoModel.php';

$conexion = conectar();
$equipoModel = new EquipoModel($conexion);

$accion = isset($_GET['accion']) ? $_GET['accion'] : 'listar';

$mensaje = '';
$tipo_mensaje = '';

if (isset($_GET['mensaje']) && $_GET['mensaje'] !== '') {
    $mensaje = $_GET['mensaje'];
}
if (isset($_GET['tipo_mensaje']) && $_GET['tipo_mensaje'] !== '') {
    $tipo_mensaje = $_GET['tipo_mensaje'];
}

$equipos = [];

if ($accion === 'listar') {
    // Mostrar únicamente equipos con estado "Mantenimiento"
    $equipos = $equipoModel->obtenerPorEstado('Mantenimiento');
}

include __DIR__ . '/../view/mantenimientos.php';
