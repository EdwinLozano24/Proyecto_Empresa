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
  <title>Permisos por Rol</title>
  <link rel="stylesheet" href="/inventario_equipos/assets/css/LoginRegister.css">
</head>
<body>
  <main>
    <h2>Permisos por Rol</h2>
    <form action="/inventario_equipos/controller/usuarioAdminController.php" method="POST">
      <input type="hidden" name="accion" value="guardar_roles">
      <?php foreach ($roles as $r): ?>
        <fieldset style="border:1px solid #ddd; padding:10px; margin-bottom:10px;">
          <legend><?php echo htmlspecialchars($r['Nombre_Rol']); ?></legend>
          <?php foreach ($permissions as $p): ?>
            <?php $checked = (!empty($rolePerms[$r['Id_Rol']]) && in_array($p, $rolePerms[$r['Id_Rol']])) ? 'checked' : ''; ?>
            <label style="display:block; margin-bottom:4px;"><input type="checkbox" name="permisos[<?php echo $r['Id_Rol']; ?>][]" value="<?php echo $p; ?>" <?php echo $checked; ?>> <?php echo $p; ?></label>
          <?php endforeach; ?>
        </fieldset>
      <?php endforeach; ?>
      <button type="submit">Guardar Permisos</button>
      <a href="/inventario_equipos/controller/usuarioAdminController.php?accion=listar">Volver</a>
    </form>
  </main>
</body>
</html>
