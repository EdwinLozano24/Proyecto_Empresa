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
    $cssPath = $_SERVER['DOCUMENT_ROOT'] . '/inventario_equipos/assets/css/EquipoForm.css';
    $cssUrl = '/inventario_equipos/assets/css/EquipoForm.css';
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

      <?php
        // Obtener lista de cargos desde la base de datos
        $cargos = [];
        try {
            $pdo = conectar();
            $stmt = $pdo->query("SELECT Id_Cargo, Nombre_Cargo FROM tbl_cargo ORDER BY Nombre_Cargo ASC");
            $cargos = $stmt->fetchAll();
        } catch (PDOException $e) {
            $cargos = [];
        }
      ?>

      <label for="Id_Cargo">Cargo (opcional)</label>
      <select id="Id_Cargo" name="Id_Cargo">
        <option value="">-- Ninguno --</option>
        <?php foreach ($cargos as $c): ?>
          <option value="<?php echo $c['Id_Cargo']; ?>" <?php echo (isset($empleado['Id_Cargo']) && $empleado['Id_Cargo'] == $c['Id_Cargo']) ? 'selected' : ''; ?>><?php echo htmlspecialchars($c['Nombre_Cargo']); ?></option>
        <?php endforeach; ?>
      </select>

      <?php if (!empty($empleado)): ?>
        <button type="submit" name="actualizarEmpleado">Actualizar Empleado</button>
      <?php else: ?>
        <button type="submit" name="crearEmpleado">Crear Empleado</button>
      <?php endif; ?>

      <a href="/inventario_equipos/controller/empleadoController.php?accion=listar"class="btn btn-secondary">Volver</a>
    </form>
  </main>
</body>
</html>
