<?php
// model/dashboardModel.php
class DashboardModel {
    private $conexion;

    public function __construct($conexion) {
        $this->conexion = $conexion;
    }

    public function contarEquiposActivos() {
        $query = "SELECT COUNT(*) AS total FROM tbl_equipos WHERE Estado_Equipo='Activo'";
        $result = $this->conexion->query($query);
        return $result->fetch_assoc()['total'];
    }
}
