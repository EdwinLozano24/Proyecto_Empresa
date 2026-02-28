<?php
session_start();

// Proteger ruta usando helper común (verifica flag 'autenticado')
require_once __DIR__ . '/../app/protecciones.php';
protegerPagina();

// nota: ya no comprobamos "Id_Usuario" directamente, el helper se encarga de validar la sesión

require_once '../app/conexion.php';
require_once '../model/equipoModel.php';

$conexion = conectar();
$equipoModel = new EquipoModel($conexion);

$accion = isset($_GET['accion']) ? $_GET['accion'] : 'listar';
$mensaje = '';
$tipo_mensaje = '';

// Permitir mensajes flash enviados por redirección (PRG)
if (isset($_GET['mensaje']) && $_GET['mensaje'] !== '') {
    $mensaje = $_GET['mensaje'];
}
if (isset($_GET['tipo_mensaje']) && $_GET['tipo_mensaje'] !== '') {
    $tipo_mensaje = $_GET['tipo_mensaje'];
}
$filtros_activos = false;
$filtros = [];

// Procesar filtros desde GET o POST
if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['filtrar'])) {
    $filtros = [
        'codigo' => $_GET['codigo'] ?? '',
        'marca' => $_GET['marca'] ?? '',
        'serie' => $_GET['serie'] ?? '',
        'ubicacion' => $_GET['ubicacion'] ?? '',
        'estado' => $_GET['estado'] ?? '',
        'tipo' => $_GET['tipo'] ?? '',
        'propietario' => $_GET['propietario'] ?? '',
        'fecha_desde' => $_GET['fecha_desde'] ?? '',
        'fecha_hasta' => $_GET['fecha_hasta'] ?? ''
    ];
    $filtros_activos = !empty(array_filter($filtros));
}

// PROCESAR FORMULARIO
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $origen = $_POST['origen_formulario'] ?? '';

    if ($origen == 'crear' || $origen == 'editar') {
        $datos = [
            'Codigo_Inventario' => $_POST['Codigo_Inventario'] ?? '',
            'Marca_Equipo' => $_POST['Marca_Equipo'] ?? '',
            'Numero_Serie' => $_POST['Numero_Serie'] ?? '',
            'Ubicacion_Equipo' => $_POST['Ubicacion_Equipo'] ?? '',
            'Propietario_Equipo' => $_POST['Propietario_Equipo'] ?? '',
            'Estado_Equipo' => $_POST['Estado_Equipo'] ?? 'Activo',
            'Fecha_Ad_Equipo' => $_POST['Fecha_Ad_Equipo'] ?? date('Y-m-d'),
            'Id_Tipo_Equipo' => $_POST['Id_Tipo_Equipo'] ?? ''
        ];

        try {
            if ($origen == 'crear') {
                if ($equipoModel->crear($datos)) {
                    $mensaje = 'Equipo creado correctamente';
                    $tipo_mensaje = 'success';
                    $accion = 'listar';
                } else {
                    $mensaje = 'Error al crear el equipo';
                    $tipo_mensaje = 'danger';
                }
            } elseif ($origen == 'editar') {
                $id = $_POST['Id_Equipo'] ?? '';
                if ($equipoModel->actualizar($id, $datos)) {
                    $mensaje = 'Equipo actualizado correctamente';
                    $tipo_mensaje = 'success';
                    $accion = 'listar';
                } else {
                    $mensaje = 'Error al actualizar el equipo';
                    $tipo_mensaje = 'danger';
                }
            }
        } catch (Exception $e) {
            $mensaje = 'Error: ' . $e->getMessage();
            $tipo_mensaje = 'danger';
        }
    } elseif ($origen == 'eliminar') {
        try {
            $id = $_POST['Id_Equipo'] ?? '';
            if ($equipoModel->eliminar($id)) {
                $mensaje = 'Equipo eliminado correctamente';
                $tipo_mensaje = 'success';
            } else {
                $mensaje = 'Error al eliminar el equipo';
                $tipo_mensaje = 'danger';
            }
            $accion = 'listar';
        } catch (Exception $e) {
            $mensaje = 'Error: ' . $e->getMessage();
            $tipo_mensaje = 'danger';
        }
    }

    // Evitar reenvío del formulario al recargar (Post-Redirect-Get)
    $params = ['accion' => 'listar'];
    if (!empty($mensaje)) $params['mensaje'] = $mensaje;
    if (!empty($tipo_mensaje)) $params['tipo_mensaje'] = $tipo_mensaje;
    header('Location: /inventario_equipos/controller/equipoController.php?' . http_build_query($params));
    exit;
}

// CARGAR DATOS SEGÚN ACCIÓN
$equipos = [];
$tiposEquipo = $equipoModel->obtenerTiposEquipo();
$empleados = $equipoModel->obtenerEmpleados();
$equipo = null;

if ($accion == 'listar') {
    if ($filtros_activos) {
        $equipos = $equipoModel->buscar($filtros);
    } else {
        $equipos = $equipoModel->obtenerTodos();
    }
} elseif ($accion == 'editar') {
    $id = $_GET['id'] ?? '';
    $equipo = $equipoModel->obtenerPorId($id);
    if (!$equipo) {
        $mensaje = 'Equipo no encontrado';
        $tipo_mensaje = 'danger';
        $accion = 'listar';
    }
} elseif ($accion == 'crear') {
    $equipo = null;
}

// Incluir la vista correspondiente
if ($accion == 'listar') {
    include '../view/equipos.php';
} elseif ($accion == 'crear' || $accion == 'editar') {
    include '../view/equipoForm.php';
}
?>
