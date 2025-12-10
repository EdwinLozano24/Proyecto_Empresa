<?php
/**
 * Controlador: UsuarioController
 * Gestiona la lógica de autenticación, registro y gestión de usuarios
 */

// Inicia sesión solo si no está activa
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

require_once __DIR__ . '/../app/conexion.php';
require_once __DIR__ . '/../model/usuarioModel.php';

class UsuarioController {
    private $model;
    private $conexion;

    public function __construct() {
        $this->conexion = conectar();
        $this->model = new UsuarioModel($this->conexion);
    }

    /**
     * Maneja solicitudes POST (login, registro, etc.)
     */
    public function procesarSolicitud() {
        // Verificar si es una solicitud POST
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        // Obtener el origen del formulario
        $origen_formulario = $_POST['origen_formulario'] ?? '';

        // Routing según origen del formulario
        if ($origen_formulario === 'Usuario') {
            if (isset($_POST['loginUsuario'])) {
                $this->iniciarSesion();
            } elseif (isset($_POST['registrarUsuario'])) {
                $this->registrarUsuario();
            }
        }
    }

    /**
     * Autentica un usuario (login)
     */
    private function iniciarSesion() {
        $nombre_usuario = trim($_POST['Nombre_Usuario'] ?? '');
        $password = trim($_POST['Password_Usuario'] ?? '');

        // Validaciones básicas
        if (empty($nombre_usuario) || empty($password)) {
            $_SESSION['error_login'] = 'Por favor completa todos los campos';
            return;
        }

        // Validar credenciales
        $usuario = $this->model->validarCredenciales($nombre_usuario, $password);

        if ($usuario) {
            // Credenciales válidas - crear sesión
            $_SESSION['usuario_id'] = $usuario['Id_Usuario'];
            $_SESSION['usuario_nombre'] = $usuario['Nombre_Usuario'];
            $_SESSION['usuario_documento'] = $usuario['documento_Usuario'];
            $_SESSION['usuario_empleado_id'] = $usuario['Id_Empleado'];
            $_SESSION['usuario_rol'] = $usuario['Nombre_Rol'];
            $_SESSION['usuario_email'] = $usuario['Correo_Electronico'];
            $_SESSION['autenticado'] = true;

            // Redirigir al dashboard
            header('Location: /inventario_equipos/view/dashboard.php');
            exit();
        } else {
            // Credenciales inválidas
            $_SESSION['error_login'] = 'Nombre de usuario o contraseña incorrectos';
            header('Location: /inventario_equipos/view/loginRegister.php');
            exit();
        }
    }

    /**
     * Registra un nuevo usuario
        */
    private function registrarUsuario() {
        $nombre_usuario = trim($_POST['Nombre_Usuario'] ?? '');
        $password = trim($_POST['Password_Usuario'] ?? '');
        $documento = trim($_POST['documento_Usuario'] ?? '');

        // Validaciones básicas
        if (empty($nombre_usuario) || empty($password) || empty($documento)) {
            $_SESSION['error_registro'] = 'Por favor completa todos los campos requeridos';
            header('Location: /inventario_equipos/view/loginRegister.php');
            exit();
        }

        // Llamar al modelo para registrar
        $resultado = $this->model->registrarUsuario($nombre_usuario, $password, $documento);

        if ($resultado['success']) {
            $_SESSION['exito_registro'] = $resultado['mensaje'];
            $_SESSION['usuario_registrado'] = $nombre_usuario;
            header('Location: /inventario_equipos/view/loginRegister.php');
            exit();
        } else {
            $_SESSION['error_registro'] = $resultado['mensaje'];
            header('Location: /inventario_equipos/view/loginRegister.php');
            exit();
        }
    }

    /**
     * Cierra la sesión del usuario
     */
    public function cerrarSesion() {
        session_destroy();
        header('Location: /inventario_equipos/view/loginRegister.php');
        exit();
    }

    /**
     * Verifica si el usuario está autenticado
     * @return bool
     */
    public static function usuarioAutenticado() {
        return isset($_SESSION['autenticado']) && $_SESSION['autenticado'] === true;
    }

    /**
     * Obtiene los datos del usuario actual
     * @return array|null
     */
    public static function obtenerUsuarioActual() {
        if (self::usuarioAutenticado()) {
            return [
                'id' => $_SESSION['usuario_id'],
                'nombre' => $_SESSION['usuario_nombre'],
                'documento' => $_SESSION['usuario_documento'],
                'empleado_id' => $_SESSION['usuario_empleado_id'],
                'rol' => $_SESSION['usuario_rol'],
                'email' => $_SESSION['usuario_email']
            ];
        }
        return null;
    }

    /**
     * Renderiza la vista de login/registro
     */
    public function mostrarLogin() {
        include __DIR__ . '/../view/loginRegister.php';
    }
}

// ===================================
// PROCESAR SOLICITUDES (EJECUCIÓN)
// ===================================

// Crear instancia del controlador y procesar solicitud
try {
    $controller = new UsuarioController();
    $controller->procesarSolicitud();
} catch (Exception $e) {
    // Capturar cualquier error no previsto
    $_SESSION['error_general'] = 'Error inesperado: ' . $e->getMessage();
    header('Location: /inventario_equipos/view/loginRegister.php');
    exit();
}
?>
