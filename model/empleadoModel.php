<?php
/**
 * Modelo: EmpleadoModel
 * CRUD para la tabla tbl_empleado
 */
class EmpleadoModel {
    private $conexion;

    public function __construct($conexion) {
        $this->conexion = $conexion;
    }

    public function obtenerTodos() {
        $query = "SELECT Id_Empleado, documento_Empleado, Nombre_Empleado, Apellido_Empleado, Num_Telefono, Correo_Electronico, Id_Cargo FROM tbl_empleado ORDER BY Nombre_Empleado ASC";
        try {
            $stmt = $this->conexion->prepare($query);
            $stmt->execute();
            return $stmt->fetchAll();
        } catch (PDOException $e) {
            @file_put_contents(__DIR__ . '/../app/error.log', date('c') . " | obtenerTodosEmpleado | " . $e->getMessage() . PHP_EOL, FILE_APPEND | LOCK_EX);
            return [];
        }
    }

    public function obtenerPorId($id) {
        $query = "SELECT Id_Empleado, documento_Empleado, Nombre_Empleado, Apellido_Empleado, Num_Telefono, Correo_Electronico, Id_Cargo FROM tbl_empleado WHERE Id_Empleado = :id LIMIT 1";
        try {
            $stmt = $this->conexion->prepare($query);
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            $stmt->execute();
            return $stmt->fetch();
        } catch (PDOException $e) {
            @file_put_contents(__DIR__ . '/../app/error.log', date('c') . " | obtenerEmpleadoPorId | id:" . $id . " | " . $e->getMessage() . PHP_EOL, FILE_APPEND | LOCK_EX);
            return null;
        }
    }

    public function crearEmpleado($documento, $nombre, $apellido, $telefono = null, $correo = null, $id_cargo = null) {
        // Validaciones mínimas
        if (empty($documento) || empty($nombre)) {
            return ['success' => false, 'mensaje' => 'Documento y nombre son obligatorios'];
        }

        $query = "INSERT INTO tbl_empleado (documento_Empleado, Nombre_Empleado, Apellido_Empleado, Num_Telefono, Correo_Electronico, Id_Cargo) VALUES (:documento, :nombre, :apellido, :telefono, :correo, :id_cargo)";
        try {
            $stmt = $this->conexion->prepare($query);
            $stmt->bindParam(':documento', $documento, PDO::PARAM_STR);
            $stmt->bindParam(':nombre', $nombre, PDO::PARAM_STR);
            $stmt->bindParam(':apellido', $apellido, PDO::PARAM_STR);
            $stmt->bindParam(':telefono', $telefono, PDO::PARAM_STR);
            $stmt->bindParam(':correo', $correo, PDO::PARAM_STR);
            $stmt->bindParam(':id_cargo', $id_cargo, PDO::PARAM_INT);
            if ($stmt->execute()) {
                return ['success' => true, 'mensaje' => 'Empleado creado', 'id' => $this->conexion->lastInsertId()];
            }
            return ['success' => false, 'mensaje' => 'No se pudo crear el empleado'];
        } catch (PDOException $e) {
            @file_put_contents(__DIR__ . '/../app/error.log', date('c') . " | crearEmpleado | documento:" . $documento . " | " . $e->getMessage() . PHP_EOL, FILE_APPEND | LOCK_EX);
            return ['success' => false, 'mensaje' => 'Error en la base de datos'];
        }
    }

    public function actualizarEmpleado($id, $documento, $nombre, $apellido, $telefono = null, $correo = null, $id_cargo = null) {
        if (empty($id) || empty($documento) || empty($nombre)) {
            return ['success' => false, 'mensaje' => 'ID, documento y nombre son requeridos'];
        }

        $query = "UPDATE tbl_empleado SET documento_Empleado = :documento, Nombre_Empleado = :nombre, Apellido_Empleado = :apellido, Num_Telefono = :telefono, Correo_Electronico = :correo, Id_Cargo = :id_cargo WHERE Id_Empleado = :id";
        try {
            $stmt = $this->conexion->prepare($query);
            $stmt->bindParam(':documento', $documento, PDO::PARAM_STR);
            $stmt->bindParam(':nombre', $nombre, PDO::PARAM_STR);
            $stmt->bindParam(':apellido', $apellido, PDO::PARAM_STR);
            $stmt->bindParam(':telefono', $telefono, PDO::PARAM_STR);
            $stmt->bindParam(':correo', $correo, PDO::PARAM_STR);
            $stmt->bindParam(':id_cargo', $id_cargo, PDO::PARAM_INT);
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            if ($stmt->execute()) {
                return ['success' => true, 'mensaje' => 'Empleado actualizado'];
            }
            return ['success' => false, 'mensaje' => 'No se pudo actualizar el empleado'];
        } catch (PDOException $e) {
            @file_put_contents(__DIR__ . '/../app/error.log', date('c') . " | actualizarEmpleado | id:" . $id . " | " . $e->getMessage() . PHP_EOL, FILE_APPEND | LOCK_EX);
            return ['success' => false, 'mensaje' => 'Error en la base de datos'];
        }
    }

    public function eliminarEmpleado($id) {
        if (empty($id)) {
            return ['success' => false, 'mensaje' => 'ID requerido'];
        }
        $query = "DELETE FROM tbl_empleado WHERE Id_Empleado = :id";
        try {
            $stmt = $this->conexion->prepare($query);
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            if ($stmt->execute()) {
                return ['success' => true, 'mensaje' => 'Empleado eliminado'];
            }
            return ['success' => false, 'mensaje' => 'No se pudo eliminar el empleado'];
        } catch (PDOException $e) {
            @file_put_contents(__DIR__ . '/../app/error.log', date('c') . " | eliminarEmpleado | id:" . $id . " | " . $e->getMessage() . PHP_EOL, FILE_APPEND | LOCK_EX);
            return ['success' => false, 'mensaje' => 'Error en la base de datos'];
        }
    }
}
?>
