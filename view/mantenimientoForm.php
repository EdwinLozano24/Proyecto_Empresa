<?php
if (session_status() === PHP_SESSION_NONE) session_start();
require_once __DIR__ . '/../app/protecciones.php';
protegerPagina();

// Variables predeterminadas
if (!isset($mensaje)) $mensaje = '';
if (!isset($tipo_mensaje)) $tipo_mensaje = 'info';
if (!isset($equipos)) $equipos = [];
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Registrar Mantenimiento - Inventario</title>
    <?php
    // Usar el CSS estilizado
    $cssPath = $_SERVER['DOCUMENT_ROOT'] . '/inventario_equipos/assets/css/Equipos.css';
    $cssUrl = '/inventario_equipos/assets/css/Equipos.css';
    if (file_exists($cssPath)) {
        echo '<link rel="stylesheet" href="' . $cssUrl . '">';
    } else {
        echo '<!-- CSS File not found at: ' . $cssPath . ' -->';
    }
    ?>
</head>
<body>
  <main>
    <h2>Registrar Mantenimiento de Equipo</h2>

    <?php if ($mensaje): ?>
      <div class="alert alert-<?php echo htmlspecialchars($tipo_mensaje); ?>">
        <?php echo htmlspecialchars($mensaje); ?>
      </div>
    <?php endif; ?>

    <form method="POST" action="">
      <div class="form-group">
        <label for="id_equipo">Equipo:</label>
        <select name="id_equipo" id="id_equipo" required>
          <option value="">Seleccione un equipo</option>
          <?php foreach ($equipos as $equipo): ?>
            <option value="<?php echo htmlspecialchars($equipo['Id_Equipo']); ?>">
              <?php echo htmlspecialchars($equipo['Marca_Equipo'] . ' - ' . $equipo['Numero_Serie'] . ' (' . $equipo['Ubicacion_Equipo'] . ')'); ?>
            </option>
          <?php endforeach; ?>
        </select>
      </div>

      <div class="form-group">
        <label for="procedimiento">Procedimiento Realizado:</label>
        <textarea name="procedimiento" id="procedimiento" rows="4" required placeholder="Describa el procedimiento realizado al equipo..."></textarea>
      </div>

      <div class="form-group">
        <label for="estado">Estado del Mantenimiento:</label>
        <select name="estado" id="estado" required>
          <option value="Activo">Activo</option>
          <option value="Inactivo">Inactivo</option>
          <option value="Mantenimiento">Mantenimiento</option>
          <option value="Dado de Baja">Dado de Baja</option>
        </select>
      </div>

      <button type="submit" class="btn btn-primary">Registrar Mantenimiento</button>
      <a href="/inventario_equipos/controller/mantenimientoController.php?accion=listar" class="btn btn-secondary">Cancelar</a>
    </form>
  </main>
</body>
</html>