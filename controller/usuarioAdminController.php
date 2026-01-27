<?php
/**
 * Controlador: UsuarioAdminController
 * CRUD para administrar usuarios y asignar roles
 */

if (session_status() === PHP_SESSION_NONE) session_start();

require_once __DIR__ . '/../app/conexion.php';
require_once __DIR__ . '/../model/usuarioModel.php';
require_once __DIR__ . '/../app/protecciones.php';

protegerPagina();
verificarRol('Administrador');

class UsuarioAdminController {
    private $model;
    private $conexion;

    public function __construct() {
        $this->conexion = conectar();
        $this->model = new UsuarioModel($this->conexion);
    }

    public function procesar() {
        $accion = $_GET['accion'] ?? 'listar';
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $accion = $_POST['accion'] ?? $accion;
        }

        if ($accion === 'listar') {
            $this->listar();
        } elseif ($accion === 'nuevo') {
            $this->form();
        } elseif ($accion === 'editar') {
            $id = intval($_GET['id'] ?? 0);
            $this->form($id);
        } elseif ($accion === 'guardar') {
            $this->guardar();
        } elseif ($accion === 'eliminar') {
            $id = intval($_GET['id'] ?? 0);
            $this->eliminar($id);
        } elseif ($accion === 'roles') {
            $this->roles();
        } elseif ($accion === 'guardar_roles') {
            $this->guardarRoles();
        } else {
            $this->listar();
        }
    }

    public function listar() {
        $filtros_activos = false;
        $filtros = [];
        
        // Procesar filtros desde GET
        if (isset($_GET['filtrar'])) {
            $filtros = [
                'documento' => $_GET['documento'] ?? '',
                'nombre_usuario' => $_GET['nombre_usuario'] ?? '',
                'nombre_empleado' => $_GET['nombre_empleado'] ?? '',
                'correo' => $_GET['correo'] ?? '',
                'rol' => $_GET['rol'] ?? ''
            ];
            $filtros_activos = !empty(array_filter($filtros));
        }
        
        if ($filtros_activos) {
            $usuarios = $this->model->buscar($filtros);
        } else {
            $usuarios = $this->model->obtenerTodosLosUsuarios();
        }
        
        include __DIR__ . '/../view/usuarios.php';
    }

    public function form($id = null) {
        $usuario = null;
        if (!empty($id)) {
            // Reutilizar obtenerUsuarioPorNombre por now: query by id
            $stmt = $this->conexion->prepare("SELECT * FROM tbl_usuario WHERE Id_Usuario = :id LIMIT 1");
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            $stmt->execute();
            $usuario = $stmt->fetch();
        }

        // Obtener roles
        $roles = [];
        try {
            $rstmt = $this->conexion->query("SELECT Id_Rol, Nombre_Rol FROM tbl_rol ORDER BY Nombre_Rol ASC");
            $roles = $rstmt->fetchAll();
        } catch (PDOException $e) {
            $roles = [];
        }

        // Permisos disponibles (misma lista usada en roles)
        $permissions = ['ver_equipos','editar_equipos','ver_empleados','editar_empleados','administrar_usuarios'];

        // Cargar permisos del usuario (si existe)
        $userPerms = [];
        $permUserFile = __DIR__ . '/../app/user_permissions.json';
        if (file_exists($permUserFile)) {
            $allUserPerms = json_decode(file_get_contents($permUserFile), true) ?? [];
            if (!empty($usuario) && !empty($usuario['Id_Usuario'])) {
                $userPerms = $allUserPerms[$usuario['Id_Usuario']] ?? [];
            }
        }

        include __DIR__ . '/../view/usuarioForm.php';
    }

    public function guardar() {
        $id = intval($_POST['Id_Usuario'] ?? 0);
        $nombre = trim($_POST['Nombre_Usuario'] ?? '');
        $documento = trim($_POST['documento_Usuario'] ?? '');
        $id_rol = intval($_POST['Id_Rol'] ?? 0);

        if ($id > 0) {
            $res = $this->model->actualizarUsuario($id, $nombre, $documento, $id_rol);

            // Guardar permisos por usuario si vienen
            $permisosUsuario = $_POST['permisos_usuario'] ?? [];
            $permUserFile = __DIR__ . '/../app/user_permissions.json';
            $allUserPerms = file_exists($permUserFile) ? (json_decode(file_get_contents($permUserFile), true) ?? []) : [];
            $allUserPerms[$id] = $permisosUsuario;
            file_put_contents($permUserFile, json_encode($allUserPerms, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));

        } else {
            // Crear nuevo usuario usando registrarUsuario (contraseña temporal)
            $password = bin2hex(random_bytes(4));
            $res = $this->model->registrarUsuario($nombre, $password, $documento, $id_rol);

            // Si se creó correctamente, guardar permisos y notificar por correo si hay email
            if (!empty($res['success']) && $res['success'] === true) {
                $newId = $res['id_usuario'] ?? null;

                // Guardar permisos por usuario
                $permisosUsuario = $_POST['permisos_usuario'] ?? [];
                $permUserFile = __DIR__ . '/../app/user_permissions.json';
                $allUserPerms = file_exists($permUserFile) ? (json_decode(file_get_contents($permUserFile), true) ?? []) : [];
                if ($newId) {
                    $allUserPerms[$newId] = $permisosUsuario;
                    file_put_contents($permUserFile, json_encode($allUserPerms, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
                }

                // Intentar obtener email desde tbl_empleado por documento
                try {
                    $stmt = $this->conexion->prepare("SELECT Correo_Electronico FROM tbl_empleado WHERE documento_Empleado = :doc LIMIT 1");
                    $stmt->bindParam(':doc', $documento, PDO::PARAM_STR);
                    $stmt->execute();
                    $row = $stmt->fetch();
                    $email = $row['Correo_Electronico'] ?? null;
                } catch (PDOException $e) {
                    $email = null;
                }

                if (!empty($email)) {
                    // Preparar mensaje
                    $subject = 'Cuenta creada - Inventario';
                    $body = "Su cuenta ha sido creada:\nUsuario: " . $nombre . "\nContraseña temporal: " . $password . "\nPor favor cambie su contraseña al iniciar sesión.";

                    // Intentar usar PHPMailer si está disponible
                    try {
                        if (file_exists(__DIR__ . '/../vendor/autoload.php')) {
                            require_once __DIR__ . '/../vendor/autoload.php';
                            // Verificar que la clase exista antes de instanciar
                            if (class_exists('PHPMailer\\PHPMailer\\PHPMailer')) {
                                $mailClass = 'PHPMailer\\PHPMailer\\PHPMailer';
                                $mail = new $mailClass(true);
                                // Usar mail() transport por defecto (evita configuraciones SMTP aquí)
                                $mail->isMail();
                                $mail->setFrom('no-reply@inventario.local', 'Inventario');
                                $mail->addAddress($email);
                                $mail->Subject = $subject;
                                $mail->Body = $body;
                                $mail->send();
                            } else {
                                // PHPMailer no está instalado, usar mail() como fallback
                                @mail($email, $subject, $body, "From: no-reply@inventario.local\r\n");
                            }
                        } else {
                            // Fallback a mail() si no hay autoload
                            @mail($email, $subject, $body, "From: no-reply@inventario.local\r\n");
                        }
                    } catch (Throwable $e) {
                        // Registrar intento de envío en log (captura Exception y Error)
                        @file_put_contents(__DIR__ . '/../app/registro.log', date('c') . " | email_error | usuario:" . $nombre . " | email:" . $email . " | " . $e->getMessage() . PHP_EOL, FILE_APPEND | LOCK_EX);
                    }
                }
            }
        }

        if (!empty($res['success']) && $res['success'] === true) {
            $_SESSION['exito_usuario'] = $res['mensaje'];
        } else {
            $_SESSION['error_usuario'] = $res['mensaje'] ?? 'No se pudo completar la operación';
        }

        header('Location: /inventario_equipos/controller/usuarioAdminController.php?accion=listar');
        exit();
    }

    public function eliminar($id) {
        $res = $this->model->eliminarUsuario($id);
        if ($res['success']) {
            $_SESSION['exito_usuario'] = $res['mensaje'];
        } else {
            $_SESSION['error_usuario'] = $res['mensaje'];
        }
        header('Location: /inventario_equipos/controller/usuarioAdminController.php?accion=listar');
        exit();
    }

    // Gestión simple de permisos por rol usando archivo JSON
    public function roles() {
        $roles = [];
        try {
            $rstmt = $this->conexion->query("SELECT Id_Rol, Nombre_Rol FROM tbl_rol ORDER BY Nombre_Rol ASC");
            $roles = $rstmt->fetchAll();
        } catch (PDOException $e) {
            $roles = [];
        }

        $permFile = __DIR__ . '/../app/role_permissions.json';
        $permissions = ['ver_equipos','editar_equipos','ver_empleados','editar_empleados','administrar_usuarios'];
        $rolePerms = [];
        if (file_exists($permFile)) {
            $rolePerms = json_decode(file_get_contents($permFile), true) ?? [];
        }

        include __DIR__ . '/../view/roles_permissions.php';
    }

    public function guardarRoles() {
        $data = $_POST['permisos'] ?? [];
        $permFile = __DIR__ . '/../app/role_permissions.json';
        file_put_contents($permFile, json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
        $_SESSION['exito_usuario'] = 'Permisos guardados';
        header('Location: /inventario_equipos/controller/usuarioAdminController.php?accion=roles');
        exit();
    }
}

$ctrl = new UsuarioAdminController();
$ctrl->procesar();
