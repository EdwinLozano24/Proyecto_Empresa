<?php

class EquipoModel {
    private $conexion;

    public function __construct($conexion) {
        $this->conexion = $conexion;
    }

    /**
     * Obtiene todos los equipos con información relacionada
     */
    public function obtenerTodos() {
        $sql = "SELECT 
                    e.Id_Equipo,
                    e.Marca_Equipo,
                    e.Numero_Serie,
                    e.Ubicacion_Equipo,
                    e.Propietario_Equipo,
                    CONCAT(emp.Nombre_Empleado, ' ', IFNULL(emp.Apellido_Empleado, '')) AS Propietario_Nombre,
                    e.Estado_Equipo,
                    e.Fecha_Ad_Equipo,
                    te.Nombre_Tipo_Equipo,
                    e.Id_Tipo_Equipo
                FROM tbl_equipos e
                LEFT JOIN tbl_empleado emp ON e.Propietario_Equipo = emp.Id_Empleado
                LEFT JOIN tbl_tipo_equipo te ON e.Id_Tipo_Equipo = te.Id_Tipo_Equipo
                ORDER BY e.Id_Equipo DESC";
        
        $resultado = $this->conexion->query($sql);
        return $resultado->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * Obtiene un equipo por ID
     */
    public function obtenerPorId($id) {
        $sql = "SELECT 
                    e.Id_Equipo,
                    e.Marca_Equipo,
                    e.Numero_Serie,
                    e.Ubicacion_Equipo,
                    e.Propietario_Equipo,
                    CONCAT(IFNULL(emp.Nombre_Empleado, ''), ' ', IFNULL(emp.Apellido_Empleado, '')) AS Propietario_Nombre,
                    e.Estado_Equipo,
                    e.Fecha_Ad_Equipo,
                    e.Id_Tipo_Equipo,
                    te.Nombre_Tipo_Equipo
                FROM tbl_equipos e
                LEFT JOIN tbl_empleado emp ON e.Propietario_Equipo = emp.Id_Empleado
                LEFT JOIN tbl_tipo_equipo te ON e.Id_Tipo_Equipo = te.Id_Tipo_Equipo
                WHERE e.Id_Equipo = ?";
        
        $stmt = $this->conexion->prepare($sql);
        $stmt->execute([$id]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    /**
     * Obtiene todos los tipos de equipo
     */
    public function obtenerTiposEquipo() {
        $sql = "SELECT Id_Tipo_Equipo, Nombre_Tipo_Equipo FROM tbl_tipo_equipo ORDER BY Nombre_Tipo_Equipo";
        $resultado = $this->conexion->query($sql);
        return $resultado->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * Obtiene todos los empleados (para propietarios)
     */
    public function obtenerEmpleados() {
        // Si Apellido_Empleado es NULL, el CONCAT en MySQL devuelve NULL.
        // Usamos IFNULL para evitar filas sin texto en el <select> de propietario.
        $sql = "SELECT Id_Empleado, CONCAT(Nombre_Empleado, ' ', IFNULL(Apellido_Empleado, '')) AS Nombre FROM tbl_empleado ORDER BY Nombre_Empleado";
        $resultado = $this->conexion->query($sql);
        return $resultado->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * Crea un nuevo equipo
     */
    public function crear($datos) {
        $sql = "INSERT INTO tbl_equipos (
                    Marca_Equipo,
                    Numero_Serie,
                    Ubicacion_Equipo,
                    Propietario_Equipo,
                    Estado_Equipo,
                    Fecha_Ad_Equipo,
                    Id_Tipo_Equipo
                ) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        $stmt = $this->conexion->prepare($sql);
        
        $propietario = !empty($datos['Propietario_Equipo']) ? $datos['Propietario_Equipo'] : NULL;
        $tipoEquipo = !empty($datos['Id_Tipo_Equipo']) ? $datos['Id_Tipo_Equipo'] : NULL;
        
        return $stmt->execute([
            $datos['Marca_Equipo'],
            $datos['Numero_Serie'],
            $datos['Ubicacion_Equipo'],
            $propietario,
            $datos['Estado_Equipo'],
            $datos['Fecha_Ad_Equipo'],
            $tipoEquipo
        ]);
    }

    /**
     * Actualiza un equipo
     */
    public function actualizar($id, $datos) {
        $sql = "UPDATE tbl_equipos SET
                    Marca_Equipo = ?,
                    Numero_Serie = ?,
                    Ubicacion_Equipo = ?,
                    Propietario_Equipo = ?,
                    Estado_Equipo = ?,
                    Fecha_Ad_Equipo = ?,
                    Id_Tipo_Equipo = ?
                WHERE Id_Equipo = ?";
        
        $stmt = $this->conexion->prepare($sql);
        
        $propietario = !empty($datos['Propietario_Equipo']) ? $datos['Propietario_Equipo'] : NULL;
        $tipoEquipo = !empty($datos['Id_Tipo_Equipo']) ? $datos['Id_Tipo_Equipo'] : NULL;
        
        return $stmt->execute([
            $datos['Marca_Equipo'],
            $datos['Numero_Serie'],
            $datos['Ubicacion_Equipo'],
            $propietario,
            $datos['Estado_Equipo'],
            $datos['Fecha_Ad_Equipo'],
            $tipoEquipo,
            $id
        ]);
    }

    /**
     * Elimina un equipo
     */
    public function eliminar($id) {
        $sql = "DELETE FROM tbl_equipos WHERE Id_Equipo = ?";
        $stmt = $this->conexion->prepare($sql);
        return $stmt->execute([$id]);
    }

    /**
     * Cuenta total de equipos
     */
    public function contarTotal() {
        $sql = "SELECT COUNT(*) as total FROM tbl_equipos";
        $resultado = $this->conexion->query($sql);
        $fila = $resultado->fetch(PDO::FETCH_ASSOC);
        return $fila['total'];
    }

    /**
     * Cuenta equipos por estado
     */
    public function contarPorEstado($estado) {
        $sql = "SELECT COUNT(*) as total FROM tbl_equipos WHERE Estado_Equipo = ?";
        $stmt = $this->conexion->prepare($sql);
        $stmt->execute([$estado]);
        $fila = $stmt->fetch(PDO::FETCH_ASSOC);
        return $fila['total'];
    }

    /**
     * Obtiene equipos filtrados por estado
     */
    public function obtenerPorEstado($estado) {
        $sql = "SELECT 
                    e.Id_Equipo,
                    e.Marca_Equipo,
                    e.Numero_Serie,
                    e.Ubicacion_Equipo,
                    e.Propietario_Equipo,
                    CONCAT(emp.Nombre_Empleado, ' ', IFNULL(emp.Apellido_Empleado, '')) AS Propietario_Nombre,
                    e.Estado_Equipo,
                    e.Fecha_Ad_Equipo,
                    te.Nombre_Tipo_Equipo,
                    e.Id_Tipo_Equipo
                FROM tbl_equipos e
                LEFT JOIN tbl_empleado emp ON e.Propietario_Equipo = emp.Id_Empleado
                LEFT JOIN tbl_tipo_equipo te ON e.Id_Tipo_Equipo = te.Id_Tipo_Equipo
                WHERE e.Estado_Equipo = ?
                ORDER BY e.Id_Equipo DESC";
        
        $stmt = $this->conexion->prepare($sql);
        $stmt->execute([$estado]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * Búsqueda avanzada de equipos con múltiples filtros
     */
    public function buscar($filtros) {
        $sql = "SELECT 
                    e.Id_Equipo,
                    e.Marca_Equipo,
                    e.Numero_Serie,
                    e.Ubicacion_Equipo,
                    e.Propietario_Equipo,
                    CONCAT(emp.Nombre_Empleado, ' ', IFNULL(emp.Apellido_Empleado, '')) AS Propietario_Nombre,
                    e.Estado_Equipo,
                    e.Fecha_Ad_Equipo,
                    te.Nombre_Tipo_Equipo,
                    e.Id_Tipo_Equipo
                FROM tbl_equipos e
                LEFT JOIN tbl_empleado emp ON e.Propietario_Equipo = emp.Id_Empleado
                LEFT JOIN tbl_tipo_equipo te ON e.Id_Tipo_Equipo = te.Id_Tipo_Equipo
                WHERE 1=1";
        
        $parametros = [];
    
        
        if (!empty($filtros['marca'])) {
            $sql .= " AND e.Marca_Equipo LIKE ?";
            $parametros[] = '%' . $filtros['marca'] . '%';
        }
        
        if (!empty($filtros['serie'])) {
            $sql .= " AND e.Numero_Serie LIKE ?";
            $parametros[] = '%' . $filtros['serie'] . '%';
        }
        
        if (!empty($filtros['ubicacion'])) {
            $sql .= " AND e.Ubicacion_Equipo LIKE ?";
            $parametros[] = '%' . $filtros['ubicacion'] . '%';
        }
        
        if (!empty($filtros['estado'])) {
            $sql .= " AND e.Estado_Equipo = ?";
            $parametros[] = $filtros['estado'];
        }
        
        if (!empty($filtros['tipo'])) {
            $sql .= " AND e.Id_Tipo_Equipo = ?";
            $parametros[] = $filtros['tipo'];
        }
        
        if (!empty($filtros['propietario'])) {
            $sql .= " AND e.Propietario_Equipo = ?";
            $parametros[] = $filtros['propietario'];
        }
        
        if (!empty($filtros['fecha_desde'])) {
            $sql .= " AND e.Fecha_Ad_Equipo >= ?";
            $parametros[] = $filtros['fecha_desde'];
        }
        
        if (!empty($filtros['fecha_hasta'])) {
            $sql .= " AND e.Fecha_Ad_Equipo <= ?";
            $parametros[] = $filtros['fecha_hasta'];
        }
        
        $sql .= " ORDER BY e.Id_Equipo DESC";
        
        $stmt = $this->conexion->prepare($sql);
        $stmt->execute($parametros);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}
