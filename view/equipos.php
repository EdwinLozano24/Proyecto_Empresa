<?php
if (session_status() === PHP_SESSION_NONE) session_start();
require_once __DIR__ . '/../app/protecciones.php';
protegerPagina();

// Inicializar variables esperadas por la vista para evitar warnings
if (!isset($mensaje)) $mensaje = '';
if (!isset($tipo_mensaje)) $tipo_mensaje = 'info';
if (!isset($filtros_activos)) $filtros_activos = false;
if (!isset($filtros)) $filtros = [];
if (!isset($tiposEquipo)) $tiposEquipo = [];
if (!isset($empleados)) $empleados = [];
if (!isset($equipos)) $equipos = [];
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Equipos - Inventario</title>
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
    <!-- Choices.js para select buscable -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/choices.js/public/assets/styles/choices.min.css" />

    <!-- DataTables -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" />
  
</head>
<body>
  <main>
    <h2>Equipos</h2>

    <?php if ($mensaje): ?>
      <div class="alert alert-<?php echo htmlspecialchars($tipo_mensaje); ?>"><?php echo htmlspecialchars($mensaje); ?></div>
    <?php endif; ?>

    <p style="display:flex; gap:10px; align-items:center;">
      <a class="btn btn-secondary" href="/inventario_equipos/view/dashboard.php">Volver al Dashboard</a>
      <a class="btn btn-primary" href="/inventario_equipos/controller/equipoController.php?accion=crear">Nuevo Equipo</a>
      <?php if ($filtros_activos): ?>
        <a class="btn btn-warning" href="/inventario_equipos/controller/equipoController.php?accion=listar">Limpiar Filtros</a>
      <?php endif; ?>
    </p>

    <!-- FORMULARIO DE BÚSQUEDA/FILTRADO -->
    <div class="search-filter-container">
      <div class="search-toggle">
        <h4>🔍 Búsqueda Avanzada</h4>
        <button type="button" class="btn-toggle-filter" onclick="toggleSearchForm()">↓ Expandir</button>
      </div>
      
      <form id="searchForm" class="search-form" method="GET" action="/inventario_equipos/controller/equipoController.php" style="display: none;">
        <input type="hidden" name="accion" value="listar">
        <input type="hidden" name="filtrar" value="1">
        

          <div class="filter-group">
            <label for="marca">Marca</label>
            <input type="text" id="marca" name="marca" placeholder="Ej: HP, Dell" value="<?php echo htmlspecialchars($filtros['marca'] ?? ''); ?>">
          </div>

          <div class="filter-group">
            <label for="serie">Número de Serie</label>
            <input type="text" id="serie" name="serie" placeholder="Ej: SN123456" value="<?php echo htmlspecialchars($filtros['serie'] ?? ''); ?>">
          </div>

          <div class="filter-group">
            <label for="ubicacion">Ubicación</label>
            <input type="text" id="ubicacion" name="ubicacion" placeholder="Ej: Oficina 1" value="<?php echo htmlspecialchars($filtros['ubicacion'] ?? ''); ?>">
          </div>

          <div class="filter-group">
            <label for="estado">Estado</label>
            <select id="estado" name="estado">
              <option value="">-- Todos --</option>
              <option value="Activo" <?php echo ($filtros['estado'] ?? '') === 'Activo' ? 'selected' : ''; ?>>Activo</option>
              <option value="Inactivo" <?php echo ($filtros['estado'] ?? '') === 'Inactivo' ? 'selected' : ''; ?>>Inactivo</option>
              <option value="Mantenimiento" <?php echo ($filtros['estado'] ?? '') === 'Mantenimiento' ? 'selected' : ''; ?>>Mantenimiento</option>
              <option value="Dado de Baja" <?php echo ($filtros['estado'] ?? '') === 'Dado de Baja' ? 'selected' : ''; ?>>Dado de Baja</option>
            </select>
          </div>

          <div class="filter-group">
            <label for="tipo">Tipo de Equipo</label>
            <select id="tipo" name="tipo">
              <option value="">-- Todos --</option>
              <?php foreach ($tiposEquipo as $tipo): ?>
                <option value="<?php echo $tipo['Id_Tipo_Equipo']; ?>" <?php echo ($filtros['tipo'] ?? '') == $tipo['Id_Tipo_Equipo'] ? 'selected' : ''; ?>>
                  <?php echo htmlspecialchars($tipo['Nombre_Tipo_Equipo']); ?>
                </option>
              <?php endforeach; ?>
            </select>
          </div>

          <div class="filter-group">
            <label for="propietario">Propietario</label>
            <select id="propietario" name="propietario">
              <option value="">-- Todos --</option>
              <?php foreach ($empleados as $emp): ?>
                <option value="<?php echo $emp['Id_Empleado']; ?>" <?php echo ($filtros['propietario'] ?? '') == $emp['Id_Empleado'] ? 'selected' : ''; ?>>
                  <?php echo htmlspecialchars($emp['Nombre']); ?>
                </option>
              <?php endforeach; ?>
            </select>
          </div>

          <div class="filter-group">
            <label for="fecha_desde">Fecha Desde</label>
            <input type="date" id="fecha_desde" name="fecha_desde" value="<?php echo htmlspecialchars($filtros['fecha_desde'] ?? ''); ?>">
          </div>

          <div class="filter-group">
            <label for="fecha_hasta">Fecha Hasta</label>
            <input type="date" id="fecha_hasta" name="fecha_hasta" value="<?php echo htmlspecialchars($filtros['fecha_hasta'] ?? ''); ?>">
          </div>
        </div>

        <div class="filter-actions">
          <button type="submit" class="btn btn-primary">🔎 Buscar</button>
          <button type="reset" class="btn btn-secondary">Limpiar Campos</button>
        </div>
      </form>
    </div>

    <?php
    // Asegurar que exista una instancia de EquipoModel cuando la vista se carga directamente
    if (!isset($equipoModel) || $equipoModel === null) {
        require_once __DIR__ . '/../app/conexion.php';
        require_once __DIR__ . '/../model/equipoModel.php';
        try {
            $pdo_tmp = conectar();
            $equipoModel = new EquipoModel($pdo_tmp);
        } catch (Throwable $e) {
            // Si no se logra conectar/instanciar, dejamos $equipoModel en null
            $equipoModel = null;
        }
    }
    ?>

    <div class="stats">
      <div class="stat-card">
        <h5>Total Equipos</h5>
        <p><?php echo $equipoModel ? $equipoModel->contarTotal() : '0'; ?></p>
      </div>
      <div class="stat-card">
        <h5>Activos</h5>
        <p><?php echo $equipoModel ? $equipoModel->contarPorEstado('Activo') : '0'; ?></p>
      </div>
      <div class="stat-card">
        <h5>Inactivos</h5>
        <p><?php echo $equipoModel ? $equipoModel->contarPorEstado('Inactivo') : '0'; ?></p>
      </div>
      <div class="stat-card">
        <h5>En Mantenimiento</h5>
        <p><?php echo $equipoModel ? $equipoModel->contarPorEstado('Mantenimiento') : '0'; ?></p>
      </div>
      <div class="stat-card">
        <h5>Dado de Baja</h5>
        <p><?php echo $equipoModel ? $equipoModel->contarPorEstado('Dado de Baja') : '0'; ?></p>
      </div>
    </div>

    <table id="equiposTable" class="table table-striped">
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
        <?php if (!empty($equipos)): ?>
          <?php foreach ($equipos as $equipo): ?>
            <tr>
              <td><?php echo htmlspecialchars($equipo['Id_Equipo']); ?></td>
              <td><?php echo htmlspecialchars($equipo['Marca_Equipo'] ?? 'N/A'); ?></td>
              <td><?php echo htmlspecialchars($equipo['Numero_Serie'] ?? 'N/A'); ?></td>
              <td><?php echo htmlspecialchars($equipo['Ubicacion_Equipo'] ?? 'N/A'); ?></td>
              <td><?php $propNombre = trim($equipo['Propietario_Nombre'] ?? ''); echo htmlspecialchars($propNombre ?: 'Sin propietario'); ?></td>
              <td><?php echo htmlspecialchars($equipo['Nombre_Tipo_Equipo'] ?? 'N/A'); ?></td>
              <td>
                <span class="badge estado-<?php echo strtolower(str_replace(' ', '-', $equipo['Estado_Equipo'])); ?>">
                  <?php echo htmlspecialchars($equipo['Estado_Equipo']); ?>
                </span>
              </td>
              <td><?php echo htmlspecialchars($equipo['Fecha_Ad_Equipo'] ?? 'N/A'); ?></td>
              <td>
                <a class="btn btn-sm btn-secondary" href="/inventario_equipos/controller/equipoController.php?accion=editar&id=<?php echo $equipo['Id_Equipo']; ?>">Editar</a>
                <a class="btn btn-sm btn-info" href="/inventario_equipos/controller/historialController.php?accion=equipo&id=<?php echo $equipo['Id_Equipo']; ?>">Historial</a>
                <button class="btn btn-sm btn-danger" onclick="eliminarEquipo(<?php echo $equipo['Id_Equipo']; ?>)">Eliminar</button>
              </td>
            </tr>
          <?php endforeach; ?>
        <?php else: ?>
          <tr><td colspan="9" style="text-align: center;">No hay equipos registrados.</td></tr>
        <?php endif; ?>
      </tbody>
    </table>
  </main>

  <!-- Modal para eliminar -->
  <div id="modalEliminar" class="modal">
    <div class="modal-content">
      <h3>Confirmar Eliminación</h3>
      <p>¿Estás seguro de que deseas eliminar este equipo?</p>
      <form method="POST" style="display: inline;">
        <input type="hidden" name="origen_formulario" value="eliminar">
        <input type="hidden" id="IdEquipoEliminar" name="Id_Equipo" value="">
        <button type="submit" class="btn btn-danger">Eliminar</button>
        <button type="button" class="btn btn-secondary" onclick="cerrarModal()">Cancelar</button>
      </form>
    </div>
  </div>

  <script>
    function eliminarEquipo(id) {
      document.getElementById('IdEquipoEliminar').value = id;
      document.getElementById('modalEliminar').style.display = 'block';
    }

    function cerrarModal() {
      document.getElementById('modalEliminar').style.display = 'none';
    }

    function toggleSearchForm() {
      const form = document.getElementById('searchForm');
      const btn = document.querySelector('.btn-toggle-filter');
      if (form.style.display === 'none') {
        form.style.display = 'grid';
        btn.textContent = '↑ Contraer';
      } else {
        form.style.display = 'none';
        btn.textContent = '↓ Expandir';
      }
    }

    // Mostrar formulario si hay filtros activos
    window.addEventListener('DOMContentLoaded', function() {
      <?php if ($filtros_activos): ?>
        document.getElementById('searchForm').style.display = 'grid';
        document.querySelector('.btn-toggle-filter').textContent = '↑ Contraer';
      <?php endif; ?>
    });

    window.onclick = function(event) {
      const modal = document.getElementById('modalEliminar');
      if (event.target == modal) {
        modal.style.display = 'none';
      }
    }
  </script>

  <script src="https://cdn.jsdelivr.net/npm/choices.js/public/assets/scripts/choices.min.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      var propietarioSelect = document.getElementById('propietario');
      if (propietarioSelect) {
        new Choices(propietarioSelect, {
          searchEnabled: true,
          shouldSort: false,
          itemSelectText: '',
          placeholder: true,
          placeholderValue: propietarioSelect.querySelector('option[value=""]')?.textContent || 'Buscar...'
        });
      }
    });
  </script>

  <!-- jQuery + DataTables -->
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      if (window.jQuery && $.fn.dataTable) {
        $('#equiposTable').DataTable({
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
