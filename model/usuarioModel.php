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
     * Registra excepciones en un archivo de log para depuración
     * No incluye contraseñas en los datos registrados
     * @param string $context - Nombre del método o contexto
     * @param \Exception $e - Excepción capturada
     * @param array $extra - Datos adicionales a registrar (serán convertidos a JSON)
     */
    private function logException($context, $e, $extra = []) {
        try {
            $logFile = __DIR__ . '/../app/error.log';
            $entry = [
                'timestamp' => date('c'),
                'context' => $context,
                'message' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
                'trace' => $e->getTraceAsString(),
                'extra' => $extra
            ];
            @file_put_contents($logFile, json_encode($entry, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE) . PHP_EOL, FILE_APPEND | LOCK_EX);
        } catch (Exception $ex) {
            // No interrumpir la ejecución por fallos en el logging
        }
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
            $this->logException('obtenerUsuarioPorNombre', $e, ['nombre_usuario' => $nombre_usuario]);
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
            $this->logException('obtenerUsuarioPorDocumento', $e, ['documento' => $documento]);
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
            $this->logException('usuarioExiste', $e, ['nombre_usuario' => $nombre_usuario]);
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
            $this->logException('documentoExiste', $e, ['documento' => $documento]);
            return false;
        }
    }

    /**
     * Verifica si el nombre de usuario existe excluyendo un id específico
     */
    public function usuarioExisteExcepto($nombre_usuario, $id_excluir) {
        $query = "SELECT COUNT(*) AS total FROM tbl_usuario WHERE Nombre_Usuario = :nombre_usuario AND Id_Usuario != :id_excluir";
        try {
            $stmt = $this->conexion->prepare($query);
            $stmt->bindParam(':nombre_usuario', $nombre_usuario, PDO::PARAM_STR);
            $stmt->bindParam(':id_excluir', $id_excluir, PDO::PARAM_INT);
            $stmt->execute();
            $resultado = $stmt->fetch();
            return $resultado['total'] > 0;
        } catch (PDOException $e) {
            $this->logException('usuarioExisteExcepto', $e, ['nombre_usuario' => $nombre_usuario, 'id_excluir' => $id_excluir]);
            return false;
        }
    }

    /**
     * Verifica si el documento existe excluyendo un id específico
     */
    public function documentoExisteExcepto($documento, $id_excluir) {
        $query = "SELECT COUNT(*) AS total FROM tbl_usuario WHERE documento_Usuario = :documento AND Id_Usuario != :id_excluir";
        try {
            $stmt = $this->conexion->prepare($query);
            $stmt->bindParam(':documento', $documento, PDO::PARAM_STR);
            $stmt->bindParam(':id_excluir', $id_excluir, PDO::PARAM_INT);
            $stmt->execute();
            $resultado = $stmt->fetch();
            return $resultado['total'] > 0;
        } catch (PDOException $e) {
            $this->logException('documentoExisteExcepto', $e, ['documento' => $documento, 'id_excluir' => $id_excluir]);
            return false;
        }
    }

    /**
     * Actualiza datos de usuario (nombre, documento, rol)
     */
    public function actualizarUsuario($id_usuario, $nombre_usuario, $documento, $id_rol) {
        // Validaciones
        if (empty($id_usuario) || empty($nombre_usuario) || empty($documento)) {
            return ['success' => false, 'mensaje' => 'ID, nombre y documento son requeridos'];
        }

        // Verificar unicidad
        if ($this->usuarioExisteExcepto($nombre_usuario, $id_usuario)) {
            return ['success' => false, 'mensaje' => 'El nombre de usuario ya está en uso por otro registro'];
        }
        if ($this->documentoExisteExcepto($documento, $id_usuario)) {
            return ['success' => false, 'mensaje' => 'El documento ya está asociado a otra cuenta'];
        }

        $query = "UPDATE tbl_usuario SET Nombre_Usuario = :nombre_usuario, documento_Usuario = :documento, Id_Rol = :id_rol WHERE Id_Usuario = :id_usuario";
        try {
            $stmt = $this->conexion->prepare($query);
            $stmt->bindParam(':nombre_usuario', $nombre_usuario, PDO::PARAM_STR);
            $stmt->bindParam(':documento', $documento, PDO::PARAM_STR);
            $stmt->bindParam(':id_rol', $id_rol, PDO::PARAM_INT);
            $stmt->bindParam(':id_usuario', $id_usuario, PDO::PARAM_INT);
            if ($stmt->execute()) {
                return ['success' => true, 'mensaje' => 'Usuario actualizado'];
            }
            return ['success' => false, 'mensaje' => 'No se pudo actualizar el usuario'];
        } catch (PDOException $e) {
            $this->logException('actualizarUsuario', $e, ['id_usuario' => $id_usuario]);
            return ['success' => false, 'mensaje' => 'Error en la base de datos'];
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
        // Si no se proporciona id_rol, buscar el rol 'Administrador' por defecto
        if ($id_rol === null) {
            $stmt = $this->conexion->prepare("SELECT Id_Rol FROM tbl_rol WHERE Nombre_Rol = 'Administrador' LIMIT 1");
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
            // Log completo para depuración (no incluir contraseña)
            $this->logException('registrarUsuario', $e, ['nombre_usuario' => $nombre_usuario, 'documento' => $documento, 'id_rol' => $id_rol]);
            return [
                'success' => false,
                'mensaje' => 'Error en la base de datos. Contacte al administrador.'
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
            $this->logException('obtenerTodosLosUsuarios', $e, []);
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
            $this->logException('actualizarPassword', $e, ['id_usuario' => $id_usuario]);
            return [
                'success' => false,
                'mensaje' => 'Error en la base de datos. Contacte al administrador.'
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
            $this->logException('eliminarUsuario', $e, ['id_usuario' => $id_usuario]);
            return [
                'success' => false,
                'mensaje' => 'Error en la base de datos. Contacte al administrador.'
            ];
        }
    }

    /**
     * Búsqueda avanzada de usuarios con múltiples filtros
     */
    public function buscar($filtros) {
        $query = "SELECT 
                    u.Id_Usuario,
                    u.Nombre_Usuario,
                    u.documento_Usuario,
                    u.Id_Empleado,
                    u.Id_Rol,
                    CONCAT(e.Nombre_Empleado, ' ', e.Apellido_Empleado) AS Nombre_Empleado,
                    e.Correo_Electronico,
                    r.Nombre_Rol
                FROM tbl_usuario u
                LEFT JOIN tbl_empleado e ON u.Id_Empleado = e.Id_Empleado
                LEFT JOIN tbl_rol r ON u.Id_Rol = r.Id_Rol
                WHERE 1=1";
        
        $parametros = [];
        
        if (!empty($filtros['documento'])) {
            $query .= " AND u.documento_Usuario LIKE ?";
            $parametros[] = '%' . $filtros['documento'] . '%';
        }
        
        if (!empty($filtros['nombre_usuario'])) {
            $query .= " AND u.Nombre_Usuario LIKE ?";
            $parametros[] = '%' . $filtros['nombre_usuario'] . '%';
        }
        
        if (!empty($filtros['nombre_empleado'])) {
            $query .= " AND (e.Nombre_Empleado LIKE ? OR e.Apellido_Empleado LIKE ?)";
            $parametros[] = '%' . $filtros['nombre_empleado'] . '%';
            $parametros[] = '%' . $filtros['nombre_empleado'] . '%';
        }
        
        if (!empty($filtros['correo'])) {
            $query .= " AND e.Correo_Electronico LIKE ?";
            $parametros[] = '%' . $filtros['correo'] . '%';
        }
        
        if (!empty($filtros['rol'])) {
            $query .= " AND u.Id_Rol = ?";
            $parametros[] = $filtros['rol'];
        }
        
        $query .= " ORDER BY u.Nombre_Usuario ASC";
        
        try {
            $stmt = $this->conexion->prepare($query);
            $stmt->execute($parametros);
            return $stmt->fetchAll();
        } catch (PDOException $e) {
            $this->logException('buscarUsuarios', $e);
            return [];
        }
    }

    /**
     * Obtiene todos los usuarios con información completa
     */
    public function obtenerTodos() {
        $query = "SELECT 
                    u.Id_Usuario,
                    u.Nombre_Usuario,
                    u.documento_Usuario,
                    u.Id_Empleado,
                    u.Id_Rol,
                    CONCAT(e.Nombre_Empleado, ' ', e.Apellido_Empleado) AS Nombre_Empleado,
                    e.Correo_Electronico,
                    r.Nombre_Rol
                FROM tbl_usuario u
                LEFT JOIN tbl_empleado e ON u.Id_Empleado = e.Id_Empleado
                LEFT JOIN tbl_rol r ON u.Id_Rol = r.Id_Rol
                ORDER BY u.Nombre_Usuario ASC";
        
        try {
            $stmt = $this->conexion->prepare($query);
            $stmt->execute();
            return $stmt->fetchAll();
        } catch (PDOException $e) {
            $this->logException('obtenerTodos', $e);
            return [];
        }
    }
}
?>
