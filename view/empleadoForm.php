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
  <title><?php echo !empty($empleado) ? 'Editar Empleado' : 'Nuevo Empleado'; ?></title>
    <?php
    // Usar el CSS estilizado
    $cssPath = $_SERVER['DOCUMENT_ROOT'] . '/inventario_equipos/assets/css/EmpleadoForm.css';
    $cssUrl = '/inventario_equipos/assets/css/EmpleadoForm.css';
    if (file_exists($cssPath)) {
        echo '<link rel="stylesheet" href="' . $cssUrl . '">';
    } else {
        echo '<!-- CSS File not found at: ' . $cssPath . ' -->';
    }
    ?>
</head>
<body>
  <main>
    <h2><?php echo !empty($empleado) ? 'Editar Empleado' : 'Nuevo Empleado'; ?></h2>

    <form action="/inventario_equipos/controller/empleadoController.php" method="POST">
      <input type="hidden" name="origen_formulario" value="Empleado">
      <?php if (!empty($empleado)): ?>
        <input type="hidden" name="Id_Empleado" value="<?php echo htmlspecialchars($empleado['Id_Empleado']); ?>">
      <?php endif; ?>

      <label for="documento_Empleado">Documento *</label>
      <input type="text" id="documento_Empleado" name="documento_Empleado" required value="<?php echo htmlspecialchars($empleado['documento_Empleado'] ?? ''); ?>">

      <label for="Nombre_Empleado">Nombre *</label>
      <input type="text" id="Nombre_Empleado" name="Nombre_Empleado" required value="<?php echo htmlspecialchars($empleado['Nombre_Empleado'] ?? ''); ?>">

      <label for="Apellido_Empleado">Apellido</label>
      <input type="text" id="Apellido_Empleado" name="Apellido_Empleado" value="<?php echo htmlspecialchars($empleado['Apellido_Empleado'] ?? ''); ?>">

      <label for="Num_Telefono">Teléfono</label>
      <input type="text" id="Num_Telefono" name="Num_Telefono" value="<?php echo htmlspecialchars($empleado['Num_Telefono'] ?? ''); ?>">

      <label for="Correo_Electronico">Correo</label>
      <input type="email" id="Correo_Electronico" name="Correo_Electronico" value="<?php echo htmlspecialchars($empleado['Correo_Electronico'] ?? ''); ?>">

      <label for="Id_Cargo">ID Cargo (opcional)</label>
      <input type="number" id="Id_Cargo" name="Id_Cargo" value="<?php echo htmlspecialchars($empleado['Id_Cargo'] ?? ''); ?>">

      <?php if (!empty($empleado)): ?>
        <button type="submit" name="actualizarEmpleado">Actualizar Empleado</button>
      <?php else: ?>
        <button type="submit" name="crearEmpleado">Crear Empleado</button>
      <?php endif; ?>

      <a href="/inventario_equipos/controller/empleadoController.php?accion=listar">Volver</a>
    </form>
  </main>
</body>
</html>
