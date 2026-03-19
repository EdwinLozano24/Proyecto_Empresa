<?php
// Asumir que $pageTitle, $usuario, $activeTab están definidos antes de incluir este archivo
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
  <meta http-equiv="Pragma" content="no-cache">
  <meta http-equiv="Expires" content="0">
  <title><?php echo htmlspecialchars($pageTitle); ?> - Gradezco</title>
  <style>
    header {
      background: linear-gradient(135deg, #1e3a8a 0%, #1d4ed8 60%, #2563eb 100%);
      border-bottom: 3px solid #b91c1c;
      position: sticky;
      top: 0;
      z-index: 100;
      box-shadow: 0 2px 16px rgba(29,78,216,0.3);
      color: white;
    }
    .header-container {
      max-width: 1280px;
      margin: 0 auto;
      padding: 0 24px;
      display: flex;
      align-items: center;
      gap: 20px;
      flex-wrap: wrap;
      min-height: 64px;
    }
    .logo-info h1, .logo-info p, .user-info p {
      color: white;
    }
    .nav-tab {
      color: white;
      text-decoration: none;
      padding: 7px 16px;
      border-radius: 8px;
    }
    .nav-tab.active {
      background: rgba(255,255,255,0.2);
    }
  </style>
  <?php
    // Headers para evitar caché del navegador
    header('Cache-Control: no-cache, no-store, must-revalidate');
    header('Pragma: no-cache');
    header('Expires: 0');
    
    // Incluir CSS del header (Dashboard.css)
    echo '<link rel="stylesheet" href="/inventario_equipos/assets/css/Dashboard.css">';
    
    // Usar el CSS correspondiente adicional (asumir que se define en cada vista)
    if (isset($cssUrl)) {
        echo '<link rel="stylesheet" href="' . $cssUrl . '">';
    }
  ?>
</head>

<body>
  <header>
    <div class="header-container">
      <div class="logo-section">
        <div class="logo-icon">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2">
            <rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect>
            <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path>
          </svg>
        </div>
        <div class="logo-info">
          <h1>Gradezco</h1>
          <p>Sistema de Inventario de Equipos</p>
        </div>
      </div>
      
      <!-- Usuario autenticado -->
      <div class="user-info" style="display: flex; align-items: center; gap: 15px;">
        <div style="text-align: right; color: white;">
          <p style="margin: 0; font-weight: 600;"><?php echo htmlspecialchars($usuario['nombre']); ?></p>
          <p style="margin: 0; font-size: 12px; opacity: 0.9;"><?php echo htmlspecialchars($usuario['rol'] ?? 'Usuario'); ?></p>
        </div>
        <a href="/inventario_equipos/controller/cerrarSesion.php" style="color: white; text-decoration: none; padding: 8px 15px; background: rgba(255,255,255,0.2); border-radius: 4px; font-size: 14px;">
          Cerrar Sesión
        </a>
      </div>

      <nav class="nav-tabs">
        <a href="/inventario_equipos/view/dashboard.php" class="nav-tab <?php echo $activeTab === 'Dashboard' ? 'active' : ''; ?>">Dashboard</a>
        <a href="/inventario_equipos/controller/equipoController.php?accion=listar" class="nav-tab <?php echo $activeTab === 'Equipos' ? 'active' : ''; ?>">Equipos</a>
        <a href="/inventario_equipos/controller/mantenimientoController.php?accion=listar" class="nav-tab <?php echo $activeTab === 'Mantenimiento' ? 'active' : ''; ?>">Mantenimiento</a>
        <a href="/inventario_equipos/controller/usuarioAdminController.php?accion=listar" class="nav-tab <?php echo $activeTab === 'Usuarios' ? 'active' : ''; ?>">Usuarios</a>
        <a href="/inventario_equipos/controller/empleadoController.php?accion=listar" class="nav-tab <?php echo $activeTab === 'Empleados' ? 'active' : ''; ?>">Empleados</a>
        <a href="/inventario_equipos/controller/historialController.php?accion=listar" class="nav-tab <?php echo $activeTab === 'Historial' ? 'active' : ''; ?>">Historial</a>
      </nav>
    </div>
  </header>