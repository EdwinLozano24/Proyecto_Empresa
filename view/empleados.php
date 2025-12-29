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
    $cssPath = $_SERVER['DOCUMENT_ROOT'] . '/inventario_equipos/assets/css/Empleados.css';
    $cssUrl = '/inventario_equipos/assets/css/Empleados.css';
    if (file_exists($cssPath)) {
        echo '<link rel="stylesheet" href="' . $cssUrl . '">';
    } else {
        echo '<!-- CSS File not found at: ' . $cssPath . ' -->';
    }
    ?>
  
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

    <p><a class="btn btn-primary" href="/inventario_equipos/controller/empleadoController.php?accion=nuevo">Nuevo Empleado</a></p>

    <table class="table table-striped">
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
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
