<?php
// controller/dashboardController.php

include_once 'models/DashboardModel.php';

class DashboardController {
    private $model;

    public function __construct($conexion) {
        $this->model = new DashboardModel($conexion);
    }

    public function index() {
        $equiposActivos = $this->model->contarEquiposActivos();
        include 'views/dashboard.php';
    }
}
