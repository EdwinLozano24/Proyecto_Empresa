<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Inventario de Equipos</title>

    <!-- Fuente de Google -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300..800;1,300..800&display=swap" rel="stylesheet">

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- CSS personalizado -->
    <?php
    $cssPath = $_SERVER['DOCUMENT_ROOT'] . '/inventario_equipos/assets/css/LoginRegister.css';
    $cssUrl = '/inventario_equipos/assets/css/LoginRegister.css';
    if (file_exists($cssPath)) {
        echo '<link rel="stylesheet" href="' . $cssUrl . '">';
    } else {
        echo '<!-- CSS File not found at: ' . $cssPath . ' -->';
    }
    ?>
</head>
<body>
    <main>
        <div class="contenedor__todo">
            
            <!-- Caja trasera con botones para alternar entre login y registro -->
            <div class="caja__trasera">
                <div class="caja__trasera-login">
                    <h3>¿Ya tienes una cuenta?</h3>
                    <p>Inicia sesión para continuar</p>
                    <button id="btn__iniciar-sesion" type="button">Iniciar Sesión</button>
                </div>
                <div class="caja__trasera-register">
                    <h3>¿Aún no tienes una cuenta?</h3>
                    <p>Regístrate para que puedas iniciar sesión</p>
                    <button id="btn__registrarse" type="button">Registrarse</button>
                </div>
            </div>

            <!-- Contenedor de los formularios -->
            <div class="contenedor__login-register">

                <!-- FORMULARIO LOGIN -->
                <form id="loginForm" action="/inventario_equipos/controller/usuarioController.php" method="POST" class="formulario__login">
                    <h2>Iniciar Sesión</h2>

                    <!-- Campo oculto para identificar origen -->
                    <input type="hidden" name="origen_formulario" value="Usuario">

                    <!-- Mostrar errores de login si existen -->
                    <?php if (isset($_SESSION['error_login'])): ?>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <strong>Error:</strong> <?php echo htmlspecialchars($_SESSION['error_login']); ?>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <?php unset($_SESSION['error_login']); ?>
                    <?php endif; ?>

                    <!-- Nombre de Usuario -->
                    <label for="login_nombre_usuario">Nombre de Usuario</label>
                    <input type="text" id="login_nombre_usuario" name="Nombre_Usuario" placeholder="Nombre de Usuario" required>

                    <!-- Contraseña -->
                    <label for="login_password">Contraseña</label>
                    <input type="password" id="login_password" name="Password_Usuario" placeholder="Contraseña" required>

                    <!-- Botón login -->
                    <button type="submit" name="loginUsuario">Entrar</button>

                    <!-- Enlace recuperar contraseña -->
                    <a href="#" style="text-decoration: none; padding-left: 10px; display: block; margin-top: 10px;">
                        ¿Olvidaste la contraseña?
                    </a>
                </form>

                <!-- FORMULARIO REGISTRO -->
                <form id="registerForm" action="/inventario_equipos/controller/usuarioController.php" method="POST" class="formulario__register">
                    <h2>Registrarse</h2>

                    <!-- Campo oculto para identificar origen -->
                    <input type="hidden" name="origen_formulario" value="Usuario">

                    <!-- Mostrar errores de registro si existen -->
                    <?php if (isset($_SESSION['error_registro'])): ?>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <strong>Error:</strong> <?php echo htmlspecialchars($_SESSION['error_registro']); ?>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <?php unset($_SESSION['error_registro']); ?>
                    <?php endif; ?>

                    <!-- Mostrar éxito de registro si existe -->
                    <?php if (isset($_SESSION['exito_registro'])): ?>
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <strong>Éxito:</strong> <?php echo htmlspecialchars($_SESSION['exito_registro']); ?>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <?php unset($_SESSION['exito_registro']); ?>
                    <?php endif; ?>

                    <div class="form-scroll-inner">
                        <!-- Documento -->
                        <label for="documento_usuario">Documento *</label>
                        <input type="text" id="documento_usuario" name="documento_Usuario" placeholder="Número de documento" required>

                        <!-- Nombre de Usuario -->
                        <label for="nombre_usuario_reg">Nombre de Usuario *</label>
                        <input type="text" id="nombre_usuario_reg" name="Nombre_Usuario" placeholder="Nombre de usuario único" required>

                        <!-- Contraseña -->
                        <label for="password_reg">Contraseña *</label>
                        <input type="password" id="password_reg" name="Password_Usuario" placeholder="Mínimo 6 caracteres" required>

                        <small style="color: #999; display: block; margin-top: 5px;">* Campos requeridos</small>
                    </div>

                    <!-- Botón registro -->
                    <button type="submit" name="registrarUsuario">Registrarse</button>
                </form>
            </div>

        </div>
    </main>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Script propio para alternar entre login/registro -->
    <script src="/inventario_equipos/assets/js/script.js"></script>

</body>
</html>
