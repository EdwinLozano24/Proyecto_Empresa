<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"> <!-- Codificación UTF-8 para soportar tildes, ñ, etc. -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> <!-- Página responsive en móviles -->
    <title>login</title>

    <!-- Fuente de Google -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300..800;1,300..800&display=swap" rel="stylesheet">

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">


    <!-- CSS personalizado (se fuerza actualización con versión al final) -->
  <?php
    // Usar el CSS estilizado para PQRS
    $cssPath = $_SERVER['DOCUMENT_ROOT'] . '/inventario_equipos/assets/css/LoginRegister.css';
    $cssUrl = '/inventario_equipos/assets/css/LoginRegister.css';
    if (file_exists($cssPath)) {
        echo '<link rel="stylesheet" href="' . $cssUrl . '">';
    } else {
        echo ' CSS File not found at: ' . $cssPath . '';
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
                <form id="loginForm"  class="formulario__login">
                    <h2>Iniciar Sesión</h2>

                    <!-- Campo oculto para identificar origen -->
                    <input type="hidden" name="origen_formulario" value="Usuario">

                    <!-- Documento -->
                    <label for="login_documento">Nombre de Usuario</label>
                    <input type="text" id="Nombre_Usuario" name="Nombre_Usuario" placeholder="Nombre de Usuario" required>

                    <!-- Contraseña -->
                    <label for="login_password">Contraseña</label>
                    <input type="password" id="login_password" name="Password_Usuario" placeholder="Contraseña" required>

                    <!-- Mensajes de error -->
                    <div id="error" style="color: red;"></div>

                    <!-- Botón login -->
                    <button type="submit" name="loginUsuario">Entrar</button>

                    <!-- Enlace recuperar contraseña -->
                    <a href="../../../views/.general/password/recuperar_form.php" style="text-decoration: none; padding-left: 10px;">
                        ¿Olvidaste la contraseña?
                    </a>
                </form>

                <!-- FORMULARIO REGISTRO -->
                <form id="registerForm" action="" method="POST" class="formulario__register">
                    <h2>Registrarse</h2>

                    <!-- Scroll interno por ser formulario largo -->
                    <div class="form-scroll-inner">

                        <!-- Nombre de Usuario -->
                        <label for="num_documento">Nombre de Usuario *</label>
                        <input type="text" placeholder="Nombre de Usuario" name="Nombre_Usuario" id="num_documento" required>
                        <!-- Contraseña -->
                        <label for="contrasena">Contraseña *</label>
                        <input type="password" placeholder="Contraseña" name="Password_Usuario" id="contrasena" required>
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