<?php
/**
 * Archivo: test_conexion.php
 * Prueba la conexión a la base de datos
 * Acceso: http://localhost/inventario_equipos/test_conexion.php
 */

require_once __DIR__ . '/app/conexion.php';
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Conexión - Inventario de Equipos</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            padding: 40px;
            max-width: 600px;
            width: 100%;
        }
        h1 {
            color: #333;
            margin-bottom: 10px;
            text-align: center;
        }
        .subtitle {
            color: #666;
            text-align: center;
            margin-bottom: 30px;
            font-size: 14px;
        }
        .section {
            margin-bottom: 30px;
        }
        .section-title {
            background: #667eea;
            color: white;
            padding: 12px 16px;
            border-radius: 5px;
            font-weight: 600;
            margin-bottom: 15px;
        }
        .info-item {
            display: flex;
            justify-content: space-between;
            padding: 12px;
            border-bottom: 1px solid #eee;
            background: #f9f9f9;
            margin-bottom: 8px;
            border-radius: 4px;
        }
        .info-label {
            font-weight: 600;
            color: #333;
        }
        .info-value {
            color: #666;
            font-family: 'Courier New', monospace;
        }
        .status {
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            font-weight: 600;
            font-size: 18px;
            margin: 20px 0;
        }
        .status.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .status.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .tables-list {
            background: #f9f9f9;
            padding: 15px;
            border-radius: 5px;
            max-height: 250px;
            overflow-y: auto;
        }
        .table-item {
            padding: 8px;
            margin: 5px 0;
            background: white;
            border-left: 3px solid #667eea;
            border-radius: 3px;
            font-family: 'Courier New', monospace;
            font-size: 13px;
        }
        .button {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 24px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-weight: 600;
            transition: background 0.3s ease;
        }
        .button:hover {
            background: #764ba2;
        }
        .button-group {
            display: flex;
            gap: 10px;
            margin-top: 20px;
            flex-wrap: wrap;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔍 Test de Conexión</h1>
        <p class="subtitle">Verificación de conexión a la base de datos</p>

        <?php
        // Intentar conectar
        try {
            $pdo = conectar();
            $conexionExitosa = true;
            $errorMsg = null;
        } catch (Exception $e) {
            $conexionExitosa = false;
            $errorMsg = $e->getMessage();
        }
        ?>

        <!-- Información de Configuración -->
        <div class="section">
            <div class="section-title">⚙️ Configuración de Conexión</div>
            <div class="info-item">
                <span class="info-label">Host:</span>
                <span class="info-value"><?php echo DB_HOST; ?>:<?php echo DB_PORT; ?></span>
            </div>
            <div class="info-item">
                <span class="info-label">Base de Datos:</span>
                <span class="info-value"><?php echo DB_NAME; ?></span>
            </div>
            <div class="info-item">
                <span class="info-label">Usuario:</span>
                <span class="info-value"><?php echo DB_USER; ?></span>
            </div>
            <div class="info-item">
                <span class="info-label">Charset:</span>
                <span class="info-value"><?php echo DB_CHARSET; ?></span>
            </div>
        </div>

        <!-- Estado de Conexión -->
        <div class="section">
            <div class="section-title">📡 Estado de Conexión</div>
            <?php if ($conexionExitosa): ?>
                <div class="status success">✅ Conexión Exitosa</div>
                
                <?php
                try {
                    // Obtener versión de MySQL
                    $stmt = $pdo->query("SELECT VERSION() as version, DATABASE() as bd");
                    $info = $stmt->fetch();
                    
                    // Contar tablas
                    $stmt = $pdo->query("SELECT COUNT(*) as total FROM information_schema.tables WHERE table_schema = DATABASE()");
                    $tablas = $stmt->fetch();
                ?>
                
                <div class="info-item">
                    <span class="info-label">Versión MySQL:</span>
                    <span class="info-value"><?php echo $info['version']; ?></span>
                </div>
                <div class="info-item">
                    <span class="info-label">BD Actual:</span>
                    <span class="info-value"><?php echo $info['bd']; ?></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Número de Tablas:</span>
                    <span class="info-value"><?php echo $tablas['total']; ?></span>
                </div>

                <?php
                    // Listar todas las tablas
                    $stmt = $pdo->query("SHOW TABLES");
                    $tablesList = $stmt->fetchAll(PDO::FETCH_COLUMN);
                ?>

                <div class="section">
                    <div class="section-title">📋 Tablas en la Base de Datos</div>
                    <div class="tables-list">
                        <?php if (empty($tablesList)): ?>
                            <p style="color: #666; text-align: center;">No hay tablas en la base de datos</p>
                        <?php else: ?>
                            <?php foreach ($tablesList as $tabla): ?>
                                <div class="table-item">✓ <?php echo htmlspecialchars($tabla); ?></div>
                            <?php endforeach; ?>
                        <?php endif; ?>
                    </div>
                </div>

                <?php
                } catch (Exception $e) {
                    echo '<div class="status error">⚠️ Error al obtener información: ' . htmlspecialchars($e->getMessage()) . '</div>';
                }
                ?>

            <?php else: ?>
                <div class="status error">❌ Error de Conexión</div>
                <div style="background: #f8d7da; padding: 15px; border-radius: 5px; margin: 15px 0; border-left: 4px solid #721c24;">
                    <strong>Detalles del Error:</strong>
                    <p style="margin-top: 10px; color: #721c24; font-family: monospace; word-break: break-all;">
                        <?php echo htmlspecialchars($errorMsg); ?>
                    </p>
                </div>

                <div style="background: #fff3cd; padding: 15px; border-radius: 5px; margin: 15px 0; border-left: 4px solid #856404;">
                    <strong>🔧 Solución de Problemas:</strong>
                    <ul style="margin-top: 10px; margin-left: 20px; color: #856404;">
                        <li>Verifica que XAMPP (Apache y MySQL) está corriendo</li>
                        <li>Confirma que la base de datos <code><?php echo DB_NAME; ?></code> existe</li>
                        <li>Revisa las credenciales en <code>app/conexion.php</code></li>
                        <li>Abre phpMyAdmin: <code>http://localhost/phpmyadmin</code></li>
                        <li>Intenta crear la BD si no existe: <code>CREATE DATABASE <?php echo DB_NAME; ?>;</code></li>
                    </ul>
                </div>
            <?php endif; ?>
        </div>

        <!-- Acciones -->
        <div class="button-group">
            <a href="/inventario_equipos/test_conexion.php" class="button">🔄 Reintentar</a>
            <a href="/inventario_equipos/view/loginRegister.php" class="button">🚀 Ir a Login</a>
            <a href="http://localhost/phpmyadmin" class="button">📊 phpMyAdmin</a>
        </div>
    </div>
</body>
</html>
