<?php
if (session_status() === PHP_SESSION_NONE) session_start();
require_once __DIR__ . '/../app/protecciones.php';
protegerPagina();
verificarRol('Administrador');
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title><?php echo !empty($usuario) ? 'Editar Usuario' : 'Nuevo Usuario'; ?></title>
  <link rel="stylesheet" href="/inventario_equipos/assets/css/LoginRegister.css">
</head>
<body>
  <main>
    <h2><?php echo !empty($usuario) ? 'Editar Usuario' : 'Nuevo Usuario'; ?></h2>

    <form action="/inventario_equipos/controller/usuarioAdminController.php" method="POST">
      <input type="hidden" name="accion" value="guardar">
      <?php if (!empty($usuario)): ?>
        <input type="hidden" name="Id_Usuario" value="<?php echo htmlspecialchars($usuario['Id_Usuario']); ?>">
      <?php endif; ?>

      <label for="documento_Usuario">Documento *</label>
      <input type="text" id="documento_Usuario" name="documento_Usuario" required value="<?php echo htmlspecialchars($usuario['documento_Usuario'] ?? ''); ?>">

      <label for="Nombre_Usuario">Nombre de Usuario *</label>
      <input type="text" id="Nombre_Usuario" name="Nombre_Usuario" required value="<?php echo htmlspecialchars($usuario['Nombre_Usuario'] ?? ''); ?>">

      <label for="Id_Rol">Rol</label>
      <select id="Id_Rol" name="Id_Rol">
        <option value="0">-- Seleccionar rol --</option>
        <?php foreach ($roles as $r): ?>
          <option value="<?php echo $r['Id_Rol']; ?>" <?php echo (!empty($usuario) && $usuario['Id_Rol'] == $r['Id_Rol']) ? 'selected' : ''; ?>><?php echo htmlspecialchars($r['Nombre_Rol']); ?></option>
        <?php endforeach; ?>
      </select>

      <!-- Permisos por usuario -->
      <fieldset style="margin-top:12px; padding:10px; border:1px solid #ddd;">
        <legend>Permisos adicionales (opcional)</legend>
        <?php if (!empty($permissions)): ?>
          <?php foreach ($permissions as $p): ?>
            <?php $checked = (!empty($userPerms) && in_array($p, $userPerms)) ? 'checked' : ''; ?>
            <label style="display:block; margin-bottom:6px;"><input type="checkbox" name="permisos_usuario[]" value="<?php echo $p; ?>" <?php echo $checked; ?>> <?php echo $p; ?></label>
          <?php endforeach; ?>
        <?php else: ?>
          <p>No hay permisos configurados.</p>
        <?php endif; ?>
      </fieldset>

      <?php if (!empty($usuario)): ?>
        <button type="submit">Actualizar Usuario</button>
      <?php else: ?>
        <button type="submit">Crear Usuario</button>
      <?php endif; ?>

      <a href="/inventario_equipos/controller/usuarioAdminController.php?accion=listar">Volver</a>
    </form>
  </main>
</body>
</html>
