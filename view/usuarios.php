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
  } catch (Exception $e) {
    $usuarios = [];
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
    </p>

    <table class="table table-striped">
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
        <?php if (!empty($usuarios)): ?>
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
        <?php else: ?>
          <tr><td colspan="5">No hay usuarios registrados.</td></tr>
        <?php endif; ?>
      </tbody>
    </table>
  </main>
</body>
</html>
