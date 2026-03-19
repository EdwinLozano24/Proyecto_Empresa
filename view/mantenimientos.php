<?php
if (session_status() === PHP_SESSION_NONE) session_start();
require_once __DIR__ . '/../app/protecciones.php';
protegerPagina();

// Obtener datos del usuario actual
$usuario = UsuarioController::obtenerUsuarioActual();

// Variables para el header
$pageTitle = 'Mantenimientos';
$activeTab = 'Mantenimiento';
$cssUrl = '/inventario_equipos/assets/css/Usuarios.css';

// Incluir el header común
require_once 'header.php';

// Enlaces CSS adicionales para mantenimientos
?>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/choices.js/public/assets/styles/choices.min.css" />
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" />
<?php

// Variables predeterminadas
if (!isset($mensaje)) $mensaje = '';
if (!isset($tipo_mensaje)) $tipo_mensaje = 'info';
if (!isset($equipos)) $equipos = [];
?>

  <main>
    <h2>Equipos en mantenimiento</h2>

    <?php if ($mensaje): ?>
      <div class="alert alert-<?php echo htmlspecialchars($tipo_mensaje); ?>">
        <?php echo htmlspecialchars($mensaje); ?>
      </div>
    <?php endif; ?>

    <p style="display:flex; gap:10px; align-items:center;">
      <a class="btn btn-secondary" href="/inventario_equipos/view/dashboard.php">Volver al Dashboard</a>
      <a class="btn btn-primary" href="/inventario_equipos/controller/equipoController.php?accion=listar">Ver todos los equipos</a>
      <a class="btn btn-primary" href="/inventario_equipos/controller/mantenimientoController.php?accion=agregar">Registrar Mantenimiento</a>
    </p>

    <?php if (empty($equipos)): ?>
      <p style="text-align: center;">No hay equipos en estado "Mantenimiento".</p>
    <?php else: ?>

    <table id="mantenimientosTable" class="table table-striped">
      <thead>
        <tr>
          <th>ID</th>
          <th>Marca</th>
          <th>Número de Serie</th>
          <th>Ubicación</th>
          <th>Propietario</th>
          <th>Tipo</th>
          <th>Estado</th>
          <th>Fecha Adquisición</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($equipos as $equipo): ?>
          <tr>
            <td><?php echo htmlspecialchars($equipo['Id_Equipo']); ?></td>
            <td><?php echo htmlspecialchars($equipo['Marca_Equipo'] ?? 'N/A'); ?></td>
            <td><?php echo htmlspecialchars($equipo['Numero_Serie'] ?? 'N/A'); ?></td>
            <td><?php echo htmlspecialchars($equipo['Ubicacion_Equipo'] ?? 'N/A'); ?></td>
            <td><?php echo htmlspecialchars($equipo['Propietario_Nombre'] ?? 'Sin propietario'); ?></td>
            <td><?php echo htmlspecialchars($equipo['Nombre_Tipo_Equipo'] ?? 'N/A'); ?></td>
            <td>
              <span class="badge estado-<?php echo strtolower(str_replace(' ', '-', $equipo['Estado_Equipo'])); ?>">
                <?php echo htmlspecialchars($equipo['Estado_Equipo']); ?>
              </span>
            </td>
            <td><?php echo htmlspecialchars($equipo['Fecha_Ad_Equipo'] ?? 'N/A'); ?></td>
            <td>
              <a class="btn btn-sm btn-secondary" href="/inventario_equipos/controller/equipoController.php?accion=editar&id=<?php echo $equipo['Id_Equipo']; ?>">Editar</a>
              <a class="btn btn-sm btn-info" href="/inventario_equipos/controller/mantenimientoController.php?accion=ver&id_equipo=<?php echo $equipo['Id_Equipo']; ?>">Ver Mantenimientos</a>
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
          lengthMenu: [[25, 50, 100], [25, 50, 100]],
          language: {
            url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json'
          },
          columnDefs: [
            { orderable: false, targets: -1 } // No ordenar acciones
          ]
        });
      }
    });
  </script>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
