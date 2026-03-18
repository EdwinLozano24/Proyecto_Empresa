<?php
class MantenimientoModel {
    private $conexion;

    public function __construct($conexion) {
        $this->conexion = $conexion;
    }

    public function insertar($idEquipo, $idEmpleado, $fecha, $descripcion, $estado) {
        $sql = "INSERT INTO tbl_mantenimiento (Id_Equipo, Id_Empleado, Fecha_Mantenimiento, Descripcion_Mantenimiento, Estado_Mantenimiento) VALUES (?, ?, ?, ?, ?)";
        $stmt = $this->conexion->prepare($sql);
        return $stmt->execute([$idEquipo, $idEmpleado, $fecha, $descripcion, $estado]);
    }

    public function obtenerPorEquipo($idEquipo) {
        $sql = "SELECT m.*, e.Nombre_Empleado, e.Apellido_Empleado FROM tbl_mantenimiento m LEFT JOIN tbl_empleado e ON m.Id_Empleado = e.Id_Empleado WHERE m.Id_Equipo = ? ORDER BY m.Fecha_Mantenimiento DESC";
        $stmt = $this->conexion->prepare($sql);
        $stmt->execute([$idEquipo]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function obtenerTodos() {
        $sql = "SELECT m.*, eq.Marca_Equipo, eq.Numero_Serie, e.Nombre_Empleado, e.Apellido_Empleado FROM tbl_mantenimiento m JOIN tbl_equipos eq ON m.Id_Equipo = eq.Id_Equipo LEFT JOIN tbl_empleado e ON m.Id_Empleado = e.Id_Empleado ORDER BY m.Fecha_Mantenimiento DESC";
        $stmt = $this->conexion->prepare($sql);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function actualizar($idMantenimiento, $descripcion, $estado) {
        $sql = "UPDATE tbl_mantenimiento SET Descripcion_Mantenimiento = ?, Estado_Mantenimiento = ? WHERE Id_Mantenimiento = ?";
        $stmt = $this->conexion->prepare($sql);
        return $stmt->execute([$descripcion, $estado, $idMantenimiento]);
    }
}
?>