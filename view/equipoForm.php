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
  <title><?php echo !empty($equipo) ? 'Editar Equipo' : 'Nuevo Equipo'; ?></title>
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
    <h2><?php echo !empty($equipo) ? 'Editar Equipo' : 'Nuevo Equipo'; ?></h2>

    <form action="/inventario_equipos/controller/equipoController.php" method="POST">
      <input type="hidden" name="origen_formulario" value="<?php echo !empty($equipo) ? 'editar' : 'crear'; ?>">
      <?php if (!empty($equipo)): ?>
        <input type="hidden" name="Id_Equipo" value="<?php echo htmlspecialchars($equipo['Id_Equipo']); ?>">
      <?php endif; ?>

      <label for="Codigo_Inventario">Código de Inventario *</label>
      <input type="text" id="Codigo_Inventario" name="Codigo_Inventario" required value="<?php echo htmlspecialchars($equipo['Codigo_Inventario'] ?? ''); ?>">

      <label for="Marca_Equipo">Marca *</label>
      <input type="text" id="Marca_Equipo" name="Marca_Equipo" required value="<?php echo htmlspecialchars($equipo['Marca_Equipo'] ?? ''); ?>">

      <label for="Numero_Serie">Número de Serie</label>
      <input type="text" id="Numero_Serie" name="Numero_Serie" value="<?php echo htmlspecialchars($equipo['Numero_Serie'] ?? ''); ?>">

      <label for="Ubicacion_Equipo">Ubicación</label>
      <input type="text" id="Ubicacion_Equipo" name="Ubicacion_Equipo" value="<?php echo htmlspecialchars($equipo['Ubicacion_Equipo'] ?? ''); ?>">

      <label for="Propietario_Equipo">Propietario (Empleado)</label>
      <select id="Propietario_Equipo" name="Propietario_Equipo">
        <option value="">-- Sin propietario --</option>
        <?php foreach ($empleados as $emp): ?>
          <option value="<?php echo $emp['Id_Empleado']; ?>" <?php echo (isset($equipo['Propietario_Equipo']) && $equipo['Propietario_Equipo'] == $emp['Id_Empleado']) ? 'selected' : ''; ?>>
            <?php echo htmlspecialchars($emp['Nombre']); ?>
          </option>
        <?php endforeach; ?>
      </select>

      <label for="Estado_Equipo">Estado *</label>
      <select id="Estado_Equipo" name="Estado_Equipo" required>
        <option value="Activo" <?php echo (isset($equipo['Estado_Equipo']) && $equipo['Estado_Equipo'] == 'Activo') ? 'selected' : ''; ?>>Activo</option>
        <option value="Inactivo" <?php echo (isset($equipo['Estado_Equipo']) && $equipo['Estado_Equipo'] == 'Inactivo') ? 'selected' : ''; ?>>Inactivo</option>
        <option value="Mantenimiento" <?php echo (isset($equipo['Estado_Equipo']) && $equipo['Estado_Equipo'] == 'Mantenimiento') ? 'selected' : ''; ?>>Mantenimiento</option>
        <option value="Dado de Baja" <?php echo (isset($equipo['Estado_Equipo']) && $equipo['Estado_Equipo'] == 'Dado de Baja') ? 'selected' : ''; ?>>Dado de Baja</option>
      </select>

      <label for="Fecha_Ad_Equipo">Fecha de Adquisición *</label>
      <input type="date" id="Fecha_Ad_Equipo" name="Fecha_Ad_Equipo" required value="<?php echo htmlspecialchars($equipo['Fecha_Ad_Equipo'] ?? date('Y-m-d')); ?>">

      <label for="Id_Tipo_Equipo">Tipo de Equipo</label>
      <select id="Id_Tipo_Equipo" name="Id_Tipo_Equipo">
        <option value="">-- Seleccionar tipo --</option>
        <?php foreach ($tiposEquipo as $tipo): ?>
          <option value="<?php echo $tipo['Id_Tipo_Equipo']; ?>" <?php echo (isset($equipo['Id_Tipo_Equipo']) && $equipo['Id_Tipo_Equipo'] == $tipo['Id_Tipo_Equipo']) ? 'selected' : ''; ?>>
            <?php echo htmlspecialchars($tipo['Nombre_Tipo_Equipo']); ?>
          </option>
        <?php endforeach; ?>
      </select>

      <?php if (!empty($equipo)): ?>
        <button type="submit" class="btn btn-primary">Actualizar Equipo</button>
      <?php else: ?>
        <button type="submit" class="btn btn-primary">Crear Equipo</button>
      <?php endif; ?>

      <a href="/inventario_equipos/controller/equipoController.php?accion=listar" class="btn btn-secondary">Volver</a>
    </form>
  </main>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
