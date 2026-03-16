<?php
if (session_status() === PHP_SESSION_NONE) session_start();
require_once __DIR__ . '/../app/protecciones.php';
protegerPagina();

// Inicializar variables
if (!isset($mensaje)) $mensaje = '';
if (!isset($tipo_mensaje)) $tipo_mensaje = 'info';
if (!isset($historial)) $historial = [];
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Historial de Cambios - Inventario</title>
  <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" />
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
    <h2>Historial de Cambios</h2>

    <?php if ($mensaje): ?>
      <div class="alert alert-<?php echo htmlspecialchars($tipo_mensaje); ?>"><?php echo htmlspecialchars($mensaje); ?></div>
    <?php endif; ?>

    <p style="display:flex; gap:10px; align-items:center;">
      <a class="btn btn-secondary" href="/inventario_equipos/view/dashboard.php">Volver al Dashboard</a>
    </p>

    <?php if (empty($historial)): ?>
      <p style="text-align: center;">No hay registros en el historial.</p>
    <?php else: ?>

    <table id="historialTable" class="table table-striped">
      <thead>
        <tr>
          <th>ID Equipo</th>
          <th>Marca</th>
          <th>Serie</th>
          <th>Tipo Entidad</th>
          <th>Campo Cambiado</th>
          <th>Valor Anterior</th>
          <th>Valor Nuevo</th>
          <th>Descripción</th>
          <th>Fecha</th>
          <th>Empleado</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($historial as $h): ?>
          <tr>
            <td><?php echo htmlspecialchars($h['Id_Equipo'] ?? 'N/A'); ?></td>
            <td><?php echo htmlspecialchars($h['Marca_Equipo'] ?? 'N/A'); ?></td>
            <td><?php echo htmlspecialchars($h['Numero_Serie'] ?? 'N/A'); ?></td>
            <td><?php echo htmlspecialchars($h['Tipo_Entidad']); ?></td>
            <td><?php echo htmlspecialchars($h['Campo_Cambiado'] ?? 'N/A'); ?></td>
            <td><?php echo htmlspecialchars($h['Valor_Anterior'] ?? 'N/A'); ?></td>
            <td><?php echo htmlspecialchars($h['Valor_Nuevo'] ?? 'N/A'); ?></td>
            <td><?php echo htmlspecialchars($h['Descripcion_Historial'] ?? 'N/A'); ?></td>
            <td><?php echo htmlspecialchars($h['Fecha_Cambio'] ?? 'N/A'); ?></td>
            <td><?php echo htmlspecialchars($h['Empleado_Nombre'] ?? 'N/A'); ?></td>
          </tr>
        <?php endforeach; ?>
      </tbody>
    </table>

    <?php endif; ?>
  </main>

  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      if (window.jQuery && $.fn.dataTable && document.getElementById('historialTable')) {
        $('#historialTable').DataTable({
          pageLength: 25,
          lengthMenu: [[25, 50, 100], [25, 50, 100]],
          language: {
            url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json'
          },
          columnDefs: [
            { orderable: false, targets: -1 } // No ordenar empleado si es necesario
          ]
        });
      }
    });
  </script>
</body>
</html>