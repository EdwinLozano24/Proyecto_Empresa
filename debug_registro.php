<?php
/**
 * Archivo: debug_registro.php
 * Script de debug para verificar el proceso de registro
 */

session_start();

require_once __DIR__ . '/app/conexion.php';
require_once __DIR__ . '/model/usuarioModel.php';

?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Debug - Registro de Usuarios</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 900px;
            margin: 30px auto;
            padding: 20px;
            background: #f5f5f5;
        }
        .container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
        }
        .section {
            margin: 20px 0;
            padding: 15px;
            background: #f9f9f9;
            border-left: 4px solid #667eea;
            border-radius: 4px;
        }
        .section h2 {
            color: #667eea;
            margin-top: 0;
        }
        .test-form {
            background: #fff;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            margin: 15px 0;
        }
        .test-form input, .test-form button {
            padding: 8px;
            margin: 5px 0;
            width: 100%;
            box-sizing: border-box;
        }
        .test-form button {
            background: #667eea;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 4px;
            font-weight: bold;
        }
        .test-form button:hover {
            background: #764ba2;
        }
        .result {
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
        }
        .result.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .result.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .result.info {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
        code {
            background: #f4f4f4;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'Courier New', monospace;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 10px 0;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background: #667eea;
            color: white;
        }
        tr:hover {
            background: #f5f5f5;
        }
        .button-group {
            display: flex;
            gap: 10px;
            margin-top: 15px;
            flex-wrap: wrap;
        }
        .button-group a {
            padding: 10px 15px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            display: inline-block;
        }
        .button-group a:hover {
            background: #764ba2;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔧 Debug - Sistema de Registro</h1>

        <!-- SECCIÓN 1: Verificación de Conexión -->
        <div class="section">
            <h2>1️⃣ Verificación de Conexión a Base de Datos</h2>
            <?php
            try {
                $pdo = conectar();
                echo '<div class="result success">✅ Conexión exitosa a la BD</div>';
                
                // Verificar si la tabla existe
                $stmt = $pdo->query("SELECT 1 FROM tbl_usuario LIMIT 1");
                echo '<div class="result success">✅ Tabla tbl_usuario existe</div>';
                
                // Contar usuarios existentes
                $stmt = $pdo->query("SELECT COUNT(*) as total FROM tbl_usuario");
                $count = $stmt->fetch();
                echo '<div class="result info">📊 Usuarios registrados: ' . $count['total'] . '</div>';
                
            } catch (Exception $e) {
                echo '<div class="result error">❌ Error: ' . htmlspecialchars($e->getMessage()) . '</div>';
            }
            ?>
        </div>

        <!-- SECCIÓN 2: Información de Configuración -->
        <div class="section">
            <h2>2️⃣ Configuración de Base de Datos</h2>
            <table>
                <tr>
                    <th>Parámetro</th>
                    <th>Valor</th>
                </tr>
                <tr>
                    <td>Host</td>
                    <td><code><?php echo DB_HOST; ?></code></td>
                </tr>
                <tr>
                    <td>Puerto</td>
                    <td><code><?php echo DB_PORT; ?></code></td>
                </tr>
                <tr>
                    <td>Base de Datos</td>
                    <td><code><?php echo DB_NAME; ?></code></td>
                </tr>
                <tr>
                    <td>Usuario</td>
                    <td><code><?php echo DB_USER; ?></code></td>
                </tr>
                <tr>
                    <td>Charset</td>
                    <td><code><?php echo DB_CHARSET; ?></code></td>
                </tr>
            </table>
        </div>

        <!-- SECCIÓN 3: Prueba Manual de Registro -->
        <div class="section">
            <h2>3️⃣ Prueba Manual de Registro</h2>
            
            <?php
            if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['test_registro'])) {
                $nombre = trim($_POST['test_nombre'] ?? '');
                $documento = trim($_POST['test_documento'] ?? '');
                $password = trim($_POST['test_password'] ?? '');

                echo '<h3>Resultado de la Prueba:</h3>';

                try {
                    $model = new UsuarioModel($pdo);
                    
                    // Log de datos enviados
                    echo '<div class="result info">📝 Datos recibidos:<br>';
                    echo '- Nombre: ' . htmlspecialchars($nombre) . '<br>';
                    echo '- Documento: ' . htmlspecialchars($documento) . '<br>';
                    echo '- Password: (ocultada)</div>';

                    // Intentar registrar
                    $resultado = $model->registrarUsuario($nombre, $password, $documento);

                    if ($resultado['success']) {
                        echo '<div class="result success">✅ ' . htmlspecialchars($resultado['mensaje']) . '<br>';
                        echo 'ID Usuario: ' . $resultado['id_usuario'] . '</div>';
                        
                        // Verificar en BD
                        $stmt = $pdo->prepare("SELECT * FROM tbl_usuario WHERE Nombre_Usuario = ?");
                        $stmt->execute([$nombre]);
                        $usuario = $stmt->fetch();
                        if ($usuario) {
                            echo '<div class="result success">✅ Usuario verificado en la BD:<br>';
                            echo 'ID: ' . $usuario['Id_Usuario'] . '<br>';
                            echo 'Documento: ' . $usuario['documento_Usuario'] . '<br>';
                            echo 'Nombre: ' . $usuario['Nombre_Usuario'] . '</div>';
                        }
                    } else {
                        echo '<div class="result error">❌ ' . htmlspecialchars($resultado['mensaje']) . '</div>';
                    }
                } catch (Exception $e) {
                    echo '<div class="result error">❌ Error: ' . htmlspecialchars($e->getMessage()) . '</div>';
                }
            }
            ?>

            <form method="POST" class="test-form">
                <h3>Completa el formulario para probar el registro:</h3>
                <input type="text" name="test_nombre" placeholder="Nombre de Usuario (ej: usuario_test)" required>
                <input type="text" name="test_documento" placeholder="Documento (ej: 987654321)" required>
                <input type="password" name="test_password" placeholder="Contraseña (mínimo 6 caracteres)" required>
                <button type="submit" name="test_registro">🧪 Probar Registro</button>
            </form>
        </div>

        <!-- SECCIÓN 4: Listado de Usuarios -->
        <div class="section">
            <h2>4️⃣ Usuarios Registrados</h2>
            <?php
            try {
                $stmt = $pdo->query("SELECT Id_Usuario, Nombre_Usuario, documento_Usuario, Id_Rol FROM tbl_usuario ORDER BY Id_Usuario DESC LIMIT 10");
                $usuarios = $stmt->fetchAll();

                if (empty($usuarios)) {
                    echo '<div class="result info">📭 No hay usuarios registrados aún</div>';
                } else {
                    echo '<table>';
                    echo '<tr><th>ID</th><th>Usuario</th><th>Documento</th><th>Rol</th></tr>';
                    foreach ($usuarios as $user) {
                        echo '<tr>';
                        echo '<td>' . $user['Id_Usuario'] . '</td>';
                        echo '<td>' . htmlspecialchars($user['Nombre_Usuario']) . '</td>';
                        echo '<td>' . htmlspecialchars($user['documento_Usuario']) . '</td>';
                        echo '<td>' . ($user['Id_Rol'] ?? 'N/A') . '</td>';
                        echo '</tr>';
                    }
                    echo '</table>';
                }
            } catch (Exception $e) {
                echo '<div class="result error">❌ Error: ' . htmlspecialchars($e->getMessage()) . '</div>';
            }
            ?>
        </div>

        <!-- SECCIÓN 5: Botones de Acción -->
        <div class="section">
            <h2>5️⃣ Acciones Rápidas</h2>
            <div class="button-group">
                <a href="/inventario_equipos/test_conexion.php">🔍 Test Conexión</a>
                <a href="/inventario_equipos/view/loginRegister.php">📝 Formulario Login</a>
                <a href="http://localhost/phpmyadmin">🗄️ phpMyAdmin</a>
                <a href="/inventario_equipos/debug_registro.php">🔄 Recargar</a>
            </div>
        </div>
    </div>
</body>
</html>
