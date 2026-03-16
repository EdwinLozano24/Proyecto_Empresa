<?php
if (session_status() === PHP_SESSION_NONE) session_start();
require_once __DIR__ . '/../app/protecciones.php';
protegerPagina();
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Empleados - Inventario</title>
    <?php
    // Usar el CSS estilizado
    $cssPath = $_SERVER['DOCUMENT_ROOT'] . '/inventario_equipos/assets/css/Usuarios.css';
    $cssUrl = '/inventario_equipos/assets/css/Usuarios.css';
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
    <h2>Empleados</h2>

    <?php if (isset($_SESSION['exito_empleado'])): ?>
      <div class="alert alert-success"><?php echo htmlspecialchars($_SESSION['exito_empleado']); unset($_SESSION['exito_empleado']); ?></div>
    <?php endif; ?>
    <?php if (isset($_SESSION['error_empleado'])): ?>
      <div class="alert alert-danger"><?php echo htmlspecialchars($_SESSION['error_empleado']); unset($_SESSION['error_empleado']); ?></div>
    <?php endif; ?>

    <p style="display:flex; gap:10px; align-items:center;">
      <a class="btn btn-secondary" href="/inventario_equipos/view/dashboard.php">Volver al Dashboard</a>
      <a class="btn btn-primary" href="/inventario_equipos/controller/empleadoController.php?accion=nuevo">Nuevo Empleado</a>
      <?php if ($filtros_activos ?? false): ?>
        <a class="btn btn-warning" href="/inventario_equipos/controller/empleadoController.php?accion=listar">Limpiar Filtros</a>
      <?php endif; ?>
    </p>

    <!-- FORMULARIO DE BÚSQUEDA/FILTRADO -->
    <div class="search-filter-container">
      <div class="search-toggle">
        <h4>🔍 Búsqueda Avanzada</h4>
        <button type="button" class="btn-toggle-filter" onclick="toggleSearchForm()">↓ Expandir</button>
      </div>
      
      <form id="searchForm" class="search-form" method="GET" action="/inventario_equipos/controller/empleadoController.php" style="display: none;">
        <input type="hidden" name="accion" value="listar">
        <input type="hidden" name="filtrar" value="1">
        
        <div class="filter-grid">
          <div class="filter-group">
            <label for="documento">Documento</label>
            <input type="text" id="documento" name="documento" placeholder="Ej: 1234567890" value="<?php echo htmlspecialchars($filtros['documento'] ?? ''); ?>">
          </div>

          <div class="filter-group">
            <label for="nombre">Nombre o Apellido</label>
            <input type="text" id="nombre" name="nombre" placeholder="Ej: Juan" value="<?php echo htmlspecialchars($filtros['nombre'] ?? ''); ?>">
          </div>

          <div class="filter-group">
            <label for="correo">Correo Electrónico</label>
            <input type="email" id="correo" name="correo" placeholder="Ej: juan@example.com" value="<?php echo htmlspecialchars($filtros['correo'] ?? ''); ?>">
          </div>

          <div class="filter-group">
            <label for="telefono">Teléfono</label>
            <input type="text" id="telefono" name="telefono" placeholder="Ej: 3001234567" value="<?php echo htmlspecialchars($filtros['telefono'] ?? ''); ?>">
          </div>

          <div class="filter-group">
            <label for="cargo">Cargo</label>
            <select id="cargo" name="cargo">
              <option value="">-- Todos --</option>
              <?php 
                $cargos = [];
                try {
                    $pdo = conectar();
                    $stmt = $pdo->query("SELECT Id_Cargo, Nombre_Cargo FROM tbl_cargo ORDER BY Nombre_Cargo");
                    $cargos = $stmt->fetchAll(PDO::FETCH_ASSOC);
                } catch (Exception $e) {}
              ?>
              <?php foreach ($cargos as $cargo): ?>
                <option value="<?php echo $cargo['Id_Cargo']; ?>" <?php echo ($filtros['cargo'] ?? '') == $cargo['Id_Cargo'] ? 'selected' : ''; ?>>
                  <?php echo htmlspecialchars($cargo['Nombre_Cargo']); ?>
                </option>
              <?php endforeach; ?>
            </select>
          </div>
        </div>

        <div class="filter-actions">
          <button type="submit" class="btn btn-primary">🔎 Buscar</button>
          <button type="reset" class="btn btn-secondary">Limpiar Campos</button>
        </div>
      </form>
    </div>

    <table id="empleadosTable" class="table table-striped">
      <thead>
        <tr>
          <th>ID</th>
          <th>Documento</th>
          <th>Nombre</th>
          <th>Teléfono</th>
          <th>Correo</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        <?php if (!empty($empleados)): ?>
          <?php foreach ($empleados as $emp): ?>
            <tr>
              <td><?php echo htmlspecialchars($emp['Id_Empleado']); ?></td>
              <td><?php echo htmlspecialchars($emp['documento_Empleado']); ?></td>
              <td><?php echo htmlspecialchars($emp['Nombre_Empleado'] . ' ' . $emp['Apellido_Empleado']); ?></td>
              <td><?php echo htmlspecialchars($emp['Num_Telefono']); ?></td>
              <td><?php echo htmlspecialchars($emp['Correo_Electronico']); ?></td>
              <td>
                <a class="btn btn-sm btn-secondary" href="/inventario_equipos/controller/empleadoController.php?accion=editar&id=<?php echo $emp['Id_Empleado']; ?>">Editar</a>
                <a class="btn btn-sm btn-danger" href="/inventario_equipos/controller/empleadoController.php?accion=eliminar&id=<?php echo $emp['Id_Empleado']; ?>" onclick="return confirm('Eliminar empleado?');">Eliminar</a>
              </td>
            </tr>
          <?php endforeach; ?>
        <?php else: ?>
          <tr><td colspan="6">No hay empleados registrados.</td></tr>
        <?php endif; ?>
      </tbody>
    </table>
  </main>
  
  <script>
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
      <?php if ($filtros_activos ?? false): ?>
        document.getElementById('searchForm').style.display = 'grid';
        document.querySelector('.btn-toggle-filter').textContent = '↑ Contraer';
      <?php endif; ?>
    });
  </script>

  <script src="https://cdn.jsdelivr.net/npm/choices.js/public/assets/scripts/choices.min.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      var cargoSelect = document.getElementById('cargo');
      if (cargoSelect) {
        new Choices(cargoSelect, {
          searchEnabled: true,
          shouldSort: false,
          itemSelectText: '',
          placeholder: true,
          placeholderValue: cargoSelect.querySelector('option[value=""]')?.textContent || 'Buscar...'
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
        $('#empleadosTable').DataTable({
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
