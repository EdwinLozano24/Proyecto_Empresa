<?php
/**
 * Controlador: EmpleadoController
 * Gestiona CRUD de empleados
 */

// Asegurar sesión
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

require_once __DIR__ . '/../app/conexion.php';
require_once __DIR__ . '/../model/empleadoModel.php';

class EmpleadoController {
    private $model;
    private $conexion;

    public function __construct() {
        $this->conexion = conectar();
        $this->model = new EmpleadoModel($this->conexion);
    }

    public function procesarSolicitud() {
        // Manejo POST para crear/actualizar
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $origen = $_POST['origen_formulario'] ?? '';
            if ($origen === 'Empleado') {
                if (isset($_POST['crearEmpleado'])) {
                    $this->crearEmpleado();
                    return;
                }
                if (isset($_POST['actualizarEmpleado'])) {
                    $this->actualizarEmpleado();
                    return;
                }
            }
        }

        // Manejo GET para listar/mostrar formulario/ eliminar
        $accion = $_GET['accion'] ?? 'listar';
        if ($accion === 'listar') {
            $this->listar();
        } elseif ($accion === 'nuevo') {
            $this->mostrarFormulario();
        } elseif ($accion === 'editar') {
            $id = intval($_GET['id'] ?? 0);
            $this->mostrarFormulario($id);
        } elseif ($accion === 'eliminar') {
            $id = intval($_GET['id'] ?? 0);
            $this->eliminarEmpleado($id);
        } else {
            $this->listar();
        }
    }

    public function listar() {
        $empleados = $this->model->obtenerTodos();
        include __DIR__ . '/../view/empleados.php';
    }

    public function mostrarFormulario($id = null) {
        $empleado = null;
        if (!empty($id)) {
            $empleado = $this->model->obtenerPorId($id);
        }
        include __DIR__ . '/../view/empleadoForm.php';
    }

    private function crearEmpleado() {
        $documento = trim($_POST['documento_Empleado'] ?? '');
        $nombre = trim($_POST['Nombre_Empleado'] ?? '');
        $apellido = trim($_POST['Apellido_Empleado'] ?? '');
        $telefono = trim($_POST['Num_Telefono'] ?? '');
        $correo = trim($_POST['Correo_Electronico'] ?? '');
        $id_cargo = !empty($_POST['Id_Cargo']) ? intval($_POST['Id_Cargo']) : null;

        $res = $this->model->crearEmpleado($documento, $nombre, $apellido, $telefono, $correo, $id_cargo);
        if ($res['success']) {
            $_SESSION['exito_empleado'] = $res['mensaje'];
        } else {
            $_SESSION['error_empleado'] = $res['mensaje'];
        }
        header('Location: /inventario_equipos/controller/empleadoController.php?accion=listar');
        exit();
    }

    private function actualizarEmpleado() {
        $id = intval($_POST['Id_Empleado'] ?? 0);
        $documento = trim($_POST['documento_Empleado'] ?? '');
        $nombre = trim($_POST['Nombre_Empleado'] ?? '');
        $apellido = trim($_POST['Apellido_Empleado'] ?? '');
        $telefono = trim($_POST['Num_Telefono'] ?? '');
        $correo = trim($_POST['Correo_Electronico'] ?? '');
        $id_cargo = !empty($_POST['Id_Cargo']) ? intval($_POST['Id_Cargo']) : null;

        $res = $this->model->actualizarEmpleado($id, $documento, $nombre, $apellido, $telefono, $correo, $id_cargo);
        if ($res['success']) {
            $_SESSION['exito_empleado'] = $res['mensaje'];
        } else {
            $_SESSION['error_empleado'] = $res['mensaje'];
        }
        header('Location: /inventario_equipos/controller/empleadoController.php?accion=listar');
        exit();
    }

    private function eliminarEmpleado($id) {
        $res = $this->model->eliminarEmpleado($id);
        if ($res['success']) {
            $_SESSION['exito_empleado'] = $res['mensaje'];
        } else {
            $_SESSION['error_empleado'] = $res['mensaje'];
        }
        header('Location: /inventario_equipos/controller/empleadoController.php?accion=listar');
        exit();
    }
}

// Ejecutar controlador
try {
    $controller = new EmpleadoController();
    $controller->procesarSolicitud();
} catch (Exception $e) {
    if (session_status() === PHP_SESSION_NONE) session_start();
    $_SESSION['error_empleado'] = 'Error inesperado: ' . $e->getMessage();
    header('Location: /inventario_equipos/controller/empleadoController.php?accion=listar');
    exit();
}

?>
