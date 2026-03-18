<?php
session_start();

require_once __DIR__ . '/../app/protecciones.php';
protegerPagina();

require_once __DIR__ . '/../app/conexion.php';
require_once __DIR__ . '/../model/equipoModel.php';
require_once __DIR__ . '/../model/mantenimientoModel.php';

$conexion = conectar();
$equipoModel = new EquipoModel($conexion);
$mantenimientoModel = new MantenimientoModel($conexion);

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
$mantenimientos = [];

if ($accion === 'listar') {
    // Mostrar únicamente equipos con estado "Mantenimiento"
    $equipos = $equipoModel->obtenerPorEstado('Mantenimiento');
} elseif ($accion === 'agregar') {
    $idEquipoPreseleccionado = $_GET['id_equipo'] ?? null;
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $idEquipo = $_POST['id_equipo'] ?? '';
        $procedimiento = $_POST['procedimiento'] ?? '';
        $estado = $_POST['estado'] ?? 'Activo';

        if (empty($idEquipo) || empty($procedimiento)) {
            $mensaje = 'Todos los campos son obligatorios.';
            $tipo_mensaje = 'danger';
        } else {
            $idEmpleado = $_SESSION['usuario_empleado_id'] ?? null;
            $fecha = date('Y-m-d');
            if ($mantenimientoModel->insertar($idEquipo, $idEmpleado, $fecha, $procedimiento, $estado)) {
                $mensaje = 'Mantenimiento registrado exitosamente.';
                $tipo_mensaje = 'success';
                // Si vino desde un equipo específico, redirigir al detalle de ese equipo
                if ($idEquipoPreseleccionado) {
                    header('Location: ' . $_SERVER['PHP_SELF'] . '?accion=ver&id_equipo=' . $idEquipo . '&mensaje=' . urlencode($mensaje) . '&tipo_mensaje=' . $tipo_mensaje);
                } else {
                    header('Location: ' . $_SERVER['PHP_SELF'] . '?accion=listar&mensaje=' . urlencode($mensaje) . '&tipo_mensaje=' . $tipo_mensaje);
                }
                exit;
            } else {
                $mensaje = 'Error al registrar el mantenimiento.';
                $tipo_mensaje = 'danger';
            }
        }
    }
    // Obtener equipos para el select
    if ($idEquipoPreseleccionado) {
        // Si hay un equipo preseleccionado, obtener solo ese
        $equipos = [$equipoModel->obtenerPorId($idEquipoPreseleccionado)];
    } else {
        $equipos = $equipoModel->obtenerTodos();
    }
    include __DIR__ . '/../view/mantenimientoForm.php';
    exit;
} elseif ($accion === 'ver') {
    $idEquipo = $_GET['id_equipo'] ?? '';
    if ($idEquipo) {
        $mantenimientos = $mantenimientoModel->obtenerPorEquipo($idEquipo);
        $equipo = $equipoModel->obtenerPorId($idEquipo);
    }
    include __DIR__ . '/../view/mantenimientoDetalle.php';
    exit;
}

include __DIR__ . '/../view/mantenimientos.php';
