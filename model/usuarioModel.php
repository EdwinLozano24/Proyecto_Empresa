<?php
/**
 * Modelo: UsuarioModel
 * Gestiona todas las operaciones de base de datos relacionadas con usuarios
 * Interactúa con: tbl_usuario, tbl_empleado, tbl_rol
 */
class UsuarioModel {
    private $conexion;

    public function __construct($conexion) {
        $this->conexion = $conexion;
    }

    /**
     * Obtiene un usuario por nombre de usuario
     * @param string $nombre_usuario
     * @return array|null Datos del usuario o null si no existe
     */
    public function obtenerUsuarioPorNombre($nombre_usuario) {
        $query = "
            SELECT 
                u.Id_Usuario,
                u.Nombre_Usuario,
                u.Password_Usuario,
                u.documento_Usuario,
                u.Id_Empleado,
                u.Id_Rol,
                e.Nombre_Empleado,
                e.Apellido_Empleado,
                e.Correo_Electronico,
                r.Nombre_Rol
            FROM tbl_usuario u
            LEFT JOIN tbl_empleado e ON u.Id_Empleado = e.Id_Empleado
            LEFT JOIN tbl_rol r ON u.Id_Rol = r.Id_Rol
            WHERE u.Nombre_Usuario = :nombre_usuario
            LIMIT 1
        ";

        try {
            $stmt = $this->conexion->prepare($query);
            $stmt->bindParam(':nombre_usuario', $nombre_usuario, PDO::PARAM_STR);
            $stmt->execute();
            return $stmt->fetch();
        } catch (PDOException $e) {
            return null;
        }
    }

    /**
     * Obtiene un usuario por documento
     * @param string $documento
     * @return array|null Datos del usuario o null si no existe
     */
    public function obtenerUsuarioPorDocumento($documento) {
        $query = "
            SELECT 
                u.Id_Usuario,
                u.Nombre_Usuario,
                u.Password_Usuario,
                u.documento_Usuario,
                u.Id_Empleado,
                u.Id_Rol,
                e.Nombre_Empleado,
                e.Apellido_Empleado,
                e.Correo_Electronico,
                r.Nombre_Rol
            FROM tbl_usuario u
            LEFT JOIN tbl_empleado e ON u.Id_Empleado = e.Id_Empleado
            LEFT JOIN tbl_rol r ON u.Id_Rol = r.Id_Rol
            WHERE u.documento_Usuario = :documento
            LIMIT 1
        ";

        try {
            $stmt = $this->conexion->prepare($query);
            $stmt->bindParam(':documento', $documento, PDO::PARAM_STR);
            $stmt->execute();
            return $stmt->fetch();
        } catch (PDOException $e) {
            return null;
        }
    }

    /**
     * Valida credenciales de usuario (login)
     * @param string $nombre_usuario
     * @param string $password
     * @return array|false Datos del usuario si es válido, false si no
     */
    public function validarCredenciales($nombre_usuario, $password) {
        $usuario = $this->obtenerUsuarioPorNombre($nombre_usuario);

        if ($usuario && password_verify($password, $usuario['Password_Usuario'])) {
            return $usuario;
        }

        return false;
    }

    /**
     * Verifica si el nombre de usuario ya existe
     * @param string $nombre_usuario
     * @return bool true si existe, false si no
     */
    public function usuarioExiste($nombre_usuario) {
        $query = "SELECT COUNT(*) AS total FROM tbl_usuario WHERE Nombre_Usuario = :nombre_usuario";

        try {
            $stmt = $this->conexion->prepare($query);
            $stmt->bindParam(':nombre_usuario', $nombre_usuario, PDO::PARAM_STR);
            $stmt->execute();
            $resultado = $stmt->fetch();
            return $resultado['total'] > 0;
        } catch (PDOException $e) {
            return false;
        }
    }

    /**
     * Verifica si el documento ya existe
     * @param string $documento
     * @return bool true si existe, false si no
     */
    public function documentoExiste($documento) {
        $query = "SELECT COUNT(*) AS total FROM tbl_usuario WHERE documento_Usuario = :documento";

        try {
            $stmt = $this->conexion->prepare($query);
            $stmt->bindParam(':documento', $documento, PDO::PARAM_STR);
            $stmt->execute();
            $resultado = $stmt->fetch();
            return $resultado['total'] > 0;
        } catch (PDOException $e) {
            return false;
        }
    }

    /**
     * Registra un nuevo usuario
     * @param string $nombre_usuario
     * @param string $password
     * @param string $documento
     * @param int $id_rol
     * @return array ['success' => bool, 'mensaje' => string, 'id_usuario' => int|null]
     */
    public function registrarUsuario($nombre_usuario, $password, $documento, $id_rol = null) {
        // Si no se proporciona id_rol, buscar el rol 'Usuario' por defecto
        if ($id_rol === null) {
            $stmt = $this->conexion->prepare("SELECT Id_Rol FROM tbl_rol WHERE Nombre_Rol = 'Usuario' LIMIT 1");
            $stmt->execute();
            $rol_result = $stmt->fetch();
            
            if ($rol_result) {
                $id_rol = $rol_result['Id_Rol'];
            } else {
                // Si no existe, tomar el primer rol disponible
                $stmt = $this->conexion->prepare("SELECT Id_Rol FROM tbl_rol ORDER BY Id_Rol ASC LIMIT 1");
                $stmt->execute();
                $rol_result = $stmt->fetch();
                
                if ($rol_result) {
                    $id_rol = $rol_result['Id_Rol'];
                } else {
                    return [
                        'success' => false,
                        'mensaje' => 'No hay roles disponibles en el sistema. Contacte al administrador.'
                    ];
                }
            }
        }

        // Validaciones básicas
        if (empty($nombre_usuario) || empty($password) || empty($documento)) {
            return [
                'success' => false,
                'mensaje' => 'Todos los campos son requeridos'
            ];
        }

        if (strlen($password) < 6) {
            return [
                'success' => false,
                'mensaje' => 'La contraseña debe tener mínimo 6 caracteres'
            ];
        }

        if ($this->usuarioExiste($nombre_usuario)) {
            return [
                'success' => false,
                'mensaje' => 'El nombre de usuario ya está registrado'
            ];
        }

        if ($this->documentoExiste($documento)) {
            return [
                'success' => false,
                'mensaje' => 'El documento ya está asociado a una cuenta'
            ];
        }

        // Hashear contraseña
        $password_hash = password_hash($password, PASSWORD_BCRYPT);

        $query = "
            INSERT INTO tbl_usuario (
                documento_Usuario,
                Nombre_Usuario,
                Password_Usuario,
                Id_Rol
            ) VALUES (
                :documento,
                :nombre_usuario,
                :password,
                :id_rol
            )
        ";

        try {
            $stmt = $this->conexion->prepare($query);
            $stmt->bindParam(':documento', $documento, PDO::PARAM_STR);
            $stmt->bindParam(':nombre_usuario', $nombre_usuario, PDO::PARAM_STR);
            $stmt->bindParam(':password', $password_hash, PDO::PARAM_STR);
            $stmt->bindParam(':id_rol', $id_rol, PDO::PARAM_INT);
            
            if ($stmt->execute()) {
                return [
                    'success' => true,
                    'mensaje' => 'Usuario registrado exitosamente',
                    'id_usuario' => $this->conexion->lastInsertId()
                ];
            } else {
                return [
                    'success' => false,
                    'mensaje' => 'Error al registrar el usuario'
                ];
            }
        } catch (PDOException $e) {
            return [
                'success' => false,
                'mensaje' => 'Error en la base de datos: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Obtiene todos los usuarios (solo para administración)
     * @return array Lista de usuarios
     */
    public function obtenerTodosLosUsuarios() {
        $query = "
            SELECT 
                u.Id_Usuario,
                u.Nombre_Usuario,
                u.documento_Usuario,
                u.Id_Empleado,
                e.Nombre_Empleado,
                e.Apellido_Empleado,
                r.Nombre_Rol
            FROM tbl_usuario u
            LEFT JOIN tbl_empleado e ON u.Id_Empleado = e.Id_Empleado
            LEFT JOIN tbl_rol r ON u.Id_Rol = r.Id_Rol
            ORDER BY u.Nombre_Usuario ASC
        ";

        try {
            $stmt = $this->conexion->prepare($query);
            $stmt->execute();
            return $stmt->fetchAll();
        } catch (PDOException $e) {
            return [];
        }
    }

    /**
     * Actualiza la contraseña de un usuario
     * @param int $id_usuario
     * @param string $nueva_password
     * @return array ['success' => bool, 'mensaje' => string]
     */
    public function actualizarPassword($id_usuario, $nueva_password) {
        if (strlen($nueva_password) < 6) {
            return [
                'success' => false,
                'mensaje' => 'La contraseña debe tener mínimo 6 caracteres'
            ];
        }

        $password_hash = password_hash($nueva_password, PASSWORD_BCRYPT);

        $query = "UPDATE tbl_usuario SET Password_Usuario = :password WHERE Id_Usuario = :id_usuario";

        try {
            $stmt = $this->conexion->prepare($query);
            $stmt->bindParam(':password', $password_hash, PDO::PARAM_STR);
            $stmt->bindParam(':id_usuario', $id_usuario, PDO::PARAM_INT);

            if ($stmt->execute()) {
                return [
                    'success' => true,
                    'mensaje' => 'Contraseña actualizada exitosamente'
                ];
            } else {
                return [
                    'success' => false,
                    'mensaje' => 'Error al actualizar la contraseña'
                ];
            }
        } catch (PDOException $e) {
            return [
                'success' => false,
                'mensaje' => 'Error en la base de datos: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Elimina un usuario
     * @param int $id_usuario
     * @return array ['success' => bool, 'mensaje' => string]
     */
    public function eliminarUsuario($id_usuario) {
        $query = "DELETE FROM tbl_usuario WHERE Id_Usuario = :id_usuario";

        try {
            $stmt = $this->conexion->prepare($query);
            $stmt->bindParam(':id_usuario', $id_usuario, PDO::PARAM_INT);

            if ($stmt->execute()) {
                return [
                    'success' => true,
                    'mensaje' => 'Usuario eliminado exitosamente'
                ];
            } else {
                return [
                    'success' => false,
                    'mensaje' => 'Error al eliminar el usuario'
                ];
            }
        } catch (PDOException $e) {
            return [
                'success' => false,
                'mensaje' => 'Error en la base de datos: ' . $e->getMessage()
            ];
        }
    }
}
?>
