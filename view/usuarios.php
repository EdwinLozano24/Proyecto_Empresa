<?php
if (session_status() === PHP_SESSION_NONE) session_start();
require_once __DIR__ . '/../app/protecciones.php';
protegerPagina();
verificarRol('Administrador');

// Si la vista se abre directamente y no viene del controlador, cargar usuarios
if (!isset($usuarios)) {
  require_once __DIR__ . '/../app/conexion.php';
  require_once __DIR__ . '/../model/usuarioModel.php';
  try {
    $conexion = conectar();
    $usuarioModel = new UsuarioModel($conexion);
    $usuarios = $usuarioModel->obtenerTodosLosUsuarios();
    $filtros_activos = false;
    $filtros = [];
  } catch (Exception $e) {
    $usuarios = [];
    $filtros_activos = false;
    $filtros = [];
  }
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Usuarios - Administración</title>
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
    <h2>Usuarios</h2>
    <?php if (isset($_SESSION['exito_usuario'])): ?>
      <div class="alert alert-success"><?php echo htmlspecialchars($_SESSION['exito_usuario']); unset($_SESSION['exito_usuario']); ?></div>
    <?php endif; ?>
    <?php if (isset($_SESSION['error_usuario'])): ?>
      <div class="alert alert-danger"><?php echo htmlspecialchars($_SESSION['error_usuario']); unset($_SESSION['error_usuario']); ?></div>
    <?php endif; ?>

    <p style="display:flex; gap:10px;">
      <a class="btn btn-secondary" href="/inventario_equipos/view/dashboard.php">Volver al Dashboard</a>
      <a class="btn btn-primary" href="/inventario_equipos/controller/usuarioAdminController.php?accion=nuevo">Nuevo Usuario</a>
      <a class="btn btn-info" href="/inventario_equipos/controller/usuarioAdminController.php?accion=roles">Gestionar Permisos por Rol</a>
      <?php if ($filtros_activos ?? false): ?>
        <a class="btn btn-warning" href="/inventario_equipos/controller/usuarioAdminController.php?accion=listar">Limpiar Filtros</a>
      <?php endif; ?>
    </p>

    <!-- FORMULARIO DE BÚSQUEDA/FILTRADO -->
    <div class="search-filter-container">
      <div class="search-toggle">
        <h4>🔍 Búsqueda Avanzada</h4>
        <button type="button" class="btn-toggle-filter" onclick="toggleSearchForm()">↓ Expandir</button>
      </div>
      
      <form id="searchForm" class="search-form" method="GET" action="/inventario_equipos/controller/usuarioAdminController.php" style="display: none;">
        <input type="hidden" name="accion" value="listar">
        <input type="hidden" name="filtrar" value="1">
        
        <div class="filter-grid">
          <div class="filter-group">
            <label for="documento">Documento</label>
            <input type="text" id="documento" name="documento" placeholder="Ej: 1234567890" value="<?php echo htmlspecialchars($filtros['documento'] ?? ''); ?>">
          </div>

          <div class="filter-group">
            <label for="nombre_usuario">Nombre de Usuario</label>
            <input type="text" id="nombre_usuario" name="nombre_usuario" placeholder="Ej: juan.perez" value="<?php echo htmlspecialchars($filtros['nombre_usuario'] ?? ''); ?>">
          </div>

          <div class="filter-group">
            <label for="nombre_empleado">Nombre del Empleado</label>
            <input type="text" id="nombre_empleado" name="nombre_empleado" placeholder="Ej: Juan" value="<?php echo htmlspecialchars($filtros['nombre_empleado'] ?? ''); ?>">
          </div>

          <div class="filter-group">
            <label for="correo">Correo Electrónico</label>
            <input type="email" id="correo" name="correo" placeholder="Ej: juan@example.com" value="<?php echo htmlspecialchars($filtros['correo'] ?? ''); ?>">
          </div>

          <div class="filter-group">
            <label for="rol">Rol</label>
            <select id="rol" name="rol">
              <option value="">-- Todos --</option>
              <?php 
                $roles = [];
                try {
                    $pdo = conectar();
                    $stmt = $pdo->query("SELECT Id_Rol, Nombre_Rol FROM tbl_rol ORDER BY Nombre_Rol");
                    $roles = $stmt->fetchAll(PDO::FETCH_ASSOC);
                } catch (Exception $e) {}
              ?>
              <?php foreach ($roles as $role): ?>
                <option value="<?php echo $role['Id_Rol']; ?>" <?php echo ($filtros['rol'] ?? '') == $role['Id_Rol'] ? 'selected' : ''; ?>>
                  <?php echo htmlspecialchars($role['Nombre_Rol']); ?>
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

    <?php if (empty($usuarios)): ?>
      <p style="text-align: center;">No hay usuarios registrados.</p>
    <?php else: ?>

    <table id="usuariosTable" class="table table-striped">
      <thead>
        <tr>
          <th>ID</th>
          <th>Documento</th>
          <th>Nombre Usuario</th>
          <th>Rol</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($usuarios as $u): ?>
          <tr>
            <td><?php echo htmlspecialchars($u['Id_Usuario']); ?></td>
            <td><?php echo htmlspecialchars($u['documento_Usuario']); ?></td>
            <td><?php echo htmlspecialchars($u['Nombre_Usuario']); ?></td>
            <td><?php echo htmlspecialchars($u['Nombre_Rol'] ?? ''); ?></td>
            <td>
              <a class="btn btn-sm btn-secondary" href="/inventario_equipos/controller/usuarioAdminController.php?accion=editar&id=<?php echo $u['Id_Usuario']; ?>">Editar</a>
              <a class="btn btn-sm btn-danger" href="/inventario_equipos/controller/usuarioAdminController.php?accion=eliminar&id=<?php echo $u['Id_Usuario']; ?>" onclick="return confirm('Eliminar usuario?');">Eliminar</a>
            </td>
          </tr>
        <?php endforeach; ?>
      </tbody>
    </table>

    <?php endif; ?>
  </main>

  <script src="https://cdn.jsdelivr.net/npm/choices.js/public/assets/scripts/choices.min.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      var rolSelect = document.getElementById('rol');
      if (rolSelect) {
        new Choices(rolSelect, {
          searchEnabled: true,
          shouldSort: false,
          itemSelectText: '',
          placeholder: true,
          placeholderValue: rolSelect.querySelector('option[value=""]')?.textContent || 'Buscar...'
        });
      }
    });
  </script>

  <!-- jQuery + DataTables -->
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      if (window.jQuery && $.fn.dataTable && document.getElementById('usuariosTable')) {
        $('#usuariosTable').DataTable({
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
</body>
</html>
