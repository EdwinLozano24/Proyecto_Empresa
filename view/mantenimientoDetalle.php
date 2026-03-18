<?php
if (session_status() === PHP_SESSION_NONE) session_start();
require_once __DIR__ . '/../app/protecciones.php';
protegerPagina();

// Variables predeterminadas
if (!isset($mensaje)) $mensaje = '';
if (!isset($tipo_mensaje)) $tipo_mensaje = 'info';
if (!isset($mantenimientos)) $mantenimientos = [];
if (!isset($equipo)) $equipo = null;
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Historial de Mantenimientos - Inventario</title>
    <?php
    // Usar el CSS estilizado
    $cssPath = $_SERVER['DOCUMENT_ROOT'] . '/inventario_equipos/assets/css/Equipoform.css';
    $cssUrl = '/inventario_equipos/assets/css/Equipoform.css';
    if (file_exists($cssPath)) {
        echo '<link rel="stylesheet" href="' . $cssUrl . '">';
    } else {
        echo '<!-- CSS File not found at: ' . $cssPath . ' -->';
    }
    ?>
    <!-- DataTables -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" />
</head>
<body>
  <main>
    <h2>Historial de Mantenimientos</h2>

    <?php if ($equipo): ?>
      <h3>Equipo: <?php echo htmlspecialchars($equipo['Marca_Equipo'] . ' - ' . $equipo['Numero_Serie']); ?></h3>
    <?php endif; ?>

    <?php if ($mensaje): ?>
      <div class="alert alert-<?php echo htmlspecialchars($tipo_mensaje); ?>">
        <?php echo htmlspecialchars($mensaje); ?>
      </div>
    <?php endif; ?>

    <p style="display:flex; gap:10px; align-items:center;">
      <a class="btn btn-secondary" href="/inventario_equipos/controller/mantenimientoController.php?accion=listar">Volver a Mantenimientos</a>
      <a class="btn btn-success" href="/inventario_equipos/controller/mantenimientoController.php?accion=agregar&id_equipo=<?php echo $equipo['Id_Equipo']; ?>">Registrar Nuevo Mantenimiento</a>
    </p>

    <?php if (empty($mantenimientos)): ?>
      <p style="text-align: center;">No hay mantenimientos registrados para este equipo.</p>
    <?php else: ?>
      <table id="mantenimientosTable" class="table table-striped">
        <thead>
          <tr>
            <th>ID</th>
            <th>Fecha</th>
            <th>Empleado</th>
            <th>Procedimiento Realizado</th>
            <th>Estado</th>
          </tr>
        </thead>
        <tbody>
          <?php foreach ($mantenimientos as $mantenimiento): ?>
            <tr>
              <td><?php echo htmlspecialchars($mantenimiento['Id_Mantenimiento']); ?></td>
              <td><?php echo htmlspecialchars($mantenimiento['Fecha_Mantenimiento']); ?></td>
              <td><?php echo htmlspecialchars(($mantenimiento['Nombre_Empleado'] ?? 'Sistema') . ' ' . ($mantenimiento['Apellido_Empleado'] ?? '')); ?></td>
              <td><?php echo htmlspecialchars($mantenimiento['Descripcion_Mantenimiento']); ?></td>
              <td>
                <span class="badge estado-<?php echo strtolower(str_replace(' ', '-', $mantenimiento['Estado_Mantenimiento'])); ?>">
                  <?php echo htmlspecialchars($mantenimiento['Estado_Mantenimiento']); ?>
                </span>
              </td>
            </tr>
          <?php endforeach; ?>
        </tbody>
      </table>
    <?php endif; ?>
  </main>

  <!-- jQuery + DataTables -->
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      if (window.jQuery && $.fn.dataTable && document.getElementById('mantenimientosTable')) {
        $('#mantenimientosTable').DataTable({
          pageLength: 25,
          language: {
            url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json'
          }
        });
      }
    });
  </script>
</body>
</html>