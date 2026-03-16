<?php

class HistorialModel {
    private $conexion;

    public function __construct($conexion) {
        $this->conexion = $conexion;
    }

    /**
     * Obtiene todos los registros del historial con información relacionada
     */
    public function obtenerTodos() {
        $sql = "SELECT
                    h.Id_Historial,
                    h.Id_Equipo,
                    e.Marca_Equipo,
                    e.Numero_Serie,
                    h.Tipo_Entidad,
                    h.Campo_Cambiado,
                    h.Valor_Anterior,
                    h.Valor_Nuevo,
                    h.Descripcion_Historial,
                    h.Fecha_Cambio,
                    h.Id_Empleado,
                    CONCAT(emp.Nombre_Empleado, ' ', IFNULL(emp.Apellido_Empleado, '')) AS Empleado_Nombre
                FROM tbl_historial h
                LEFT JOIN tbl_equipos e ON h.Id_Equipo = e.Id_Equipo
                LEFT JOIN tbl_empleado emp ON h.Id_Empleado = emp.Id_Empleado
                ORDER BY h.Fecha_Cambio DESC, h.Id_Historial DESC";

        $resultado = $this->conexion->query($sql);
        return $resultado->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * Obtiene el historial de un equipo específico
     */
    public function obtenerPorEquipo($idEquipo) {
        $sql = "SELECT
                    h.Id_Historial,
                    h.Id_Equipo,
                    e.Marca_Equipo,
                    e.Numero_Serie,
                    h.Tipo_Entidad,
                    h.Campo_Cambiado,
                    h.Valor_Anterior,
                    h.Valor_Nuevo,
                    h.Descripcion_Historial,
                    h.Fecha_Cambio,
                    h.Id_Empleado,
                    CONCAT(emp.Nombre_Empleado, ' ', IFNULL(emp.Apellido_Empleado, '')) AS Empleado_Nombre
                FROM tbl_historial h
                LEFT JOIN tbl_equipos e ON h.Id_Equipo = e.Id_Equipo
                LEFT JOIN tbl_empleado emp ON h.Id_Empleado = emp.Id_Empleado
                WHERE h.Id_Equipo = ?
                ORDER BY h.Fecha_Cambio DESC, h.Id_Historial DESC";

        $stmt = $this->conexion->prepare($sql);
        $stmt->execute([$idEquipo]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}