<?php
/**
 * Archivo: restaurar_bd.php
 * Script para restaurar la BD eliminando tablas y recreándolas
 * ADVERTENCIA: Esto eliminará todos los datos
 */

require_once __DIR__ . '/app/conexion.php';

?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurar Base de Datos</title>
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
            color: #c00;
            border-bottom: 2px solid #c00;
            padding-bottom: 10px;
        }
        .warning {
            background: #fff3cd;
            border: 1px solid #ffc107;
            color: #856404;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
        }
        .button {
            padding: 12px 24px;
            margin: 10px 5px 10px 0;
            background: #c00;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            font-size: 16px;
        }
        .button:hover {
            background: #900;
        }
        .button-secondary {
            background: #667eea;
        }
        .button-secondary:hover {
            background: #764ba2;
        }
        .result {
            padding: 15px;
            margin: 15px 0;
            border-radius: 5px;
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
        .steps {
            background: #f9f9f9;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
        }
        .steps ol {
            margin: 10px 0;
            padding-left: 20px;
        }
        .steps li {
            margin: 10px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>⚠️ Restaurar Base de Datos</h1>

        <div class="warning">
            <strong>⚠️ ADVERTENCIA:</strong> Esta opción eliminará TODOS los datos de la base de datos y recreará las tablas.
            Esta acción es IRREVERSIBLE.
        </div>

        <?php
        if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['confirmar_restauracion'])) {
            try {
                $pdo = conectar();

                echo '<h2>Iniciando restauración...</h2>';

                // 1. Desactivar verificación de claves foráneas temporalmente
                $pdo->exec("SET FOREIGN_KEY_CHECKS=0");
                echo '<div class="result info">✓ Desactivando verificación de claves foráneas</div>';

                // 2. Eliminar tablas
                $tablas = [
                    'tbl_historial',
                    'tbl_mantenimiento',
                    'tbl_equipos',
                    'tbl_usuario',
                    'tbl_empleado',
                    'tbl_archivo',
                    'tbl_cargo',
                    'tbl_rol',
                    'tbl_tipo_equipo'
                ];

                foreach ($tablas as $tabla) {
                    $pdo->exec("DROP TABLE IF EXISTS $tabla");
                    echo '<div class="result info">✓ Tabla eliminada: ' . $tabla . '</div>';
                }

                // 3. Reactivar verificación de claves foráneas
                $pdo->exec("SET FOREIGN_KEY_CHECKS=1");
                echo '<div class="result info">✓ Reactivando verificación de claves foráneas</div>';

                // 4. Leer el archivo SQL
                $sql_file = __DIR__ . '/Sql/Codigo.sql';
                if (!file_exists($sql_file)) {
                    throw new Exception('Archivo Codigo.sql no encontrado');
                }

                $sql_content = file_get_contents($sql_file);

                // 5. Ejecutar el SQL (dividir por ";" para evitar problemas)
                $statements = array_filter(array_map('trim', explode(';', $sql_content)));

                $count = 0;
                foreach ($statements as $statement) {
                    if (!empty($statement)) {
                        try {
                            $pdo->exec($statement);
                            $count++;
                        } catch (Exception $e) {
                            // Ignorar errores de comentarios o sentencias vacías
                            if (strpos($e->getMessage(), 'syntax error') !== false) {
                                throw $e;
                            }
                        }
                    }
                }

                echo '<div class="result info">✓ ' . $count . ' sentencias SQL ejecutadas</div>';

                // 6. Verificar resultados
                $stmt = $pdo->query("SHOW TABLES FROM " . DB_NAME);
                $tablas_creadas = $stmt->fetchAll(PDO::FETCH_COLUMN);

                echo '<div class="result success">';
                echo '<strong>✅ Restauración completada exitosamente</strong><br>';
                echo 'Tablas creadas: ' . count($tablas_creadas) . '<br>';
                echo 'Lista: ' . implode(', ', $tablas_creadas);
                echo '</div>';

                // 7. Verificar roles
                $stmt = $pdo->query("SELECT COUNT(*) as total FROM tbl_rol");
                $roles = $stmt->fetch();
                echo '<div class="result success">✓ Roles creados: ' . $roles['total'] . '</div>';

                // 8. Verificar cargos
                $stmt = $pdo->query("SELECT COUNT(*) as total FROM tbl_cargo");
                $cargos = $stmt->fetch();
                echo '<div class="result success">✓ Cargos creados: ' . $cargos['total'] . '</div>';

                // 9. Verificar tipos de equipos
                $stmt = $pdo->query("SELECT COUNT(*) as total FROM tbl_tipo_equipo");
                $tipos = $stmt->fetch();
                echo '<div class="result success">✓ Tipos de equipos creados: ' . $tipos['total'] . '</div>';

                echo '<div class="result success">';
                echo '<strong>✅ Base de datos restaurada correctamente</strong><br>';
                echo 'Ahora puedes registrar nuevos usuarios sin problemas.';
                echo '</div>';

            } catch (Exception $e) {
                echo '<div class="result error">';
                echo '<strong>❌ Error durante la restauración:</strong><br>';
                echo htmlspecialchars($e->getMessage());
                echo '</div>';
            }
        }
        ?>

        <!-- Formulario de confirmación -->
        <form method="POST">
            <div class="warning">
                <strong>Para continuar, escribe "RESTAURAR":</strong>
                <input type="text" name="confirmacion" placeholder="Escribe RESTAURAR" style="width: 200px; padding: 5px; margin: 10px 0;">
            </div>

            <?php if ($_POST['confirmacion'] ?? '' === 'RESTAURAR'): ?>
                <button type="submit" name="confirmar_restauracion" class="button">
                    🗑️ Eliminar y Recrear Todo
                </button>
            <?php else: ?>
                <button type="submit" class="button" disabled style="opacity: 0.5;">
                    🗑️ Confirmar Restauración
                </button>
            <?php endif; ?>
        </form>

        <div class="steps">
            <h3>Pasos a seguir después de restaurar:</h3>
            <ol>
                <li>La base de datos será completamente restaurada</li>
                <li>Se crearán todos los roles, cargos y tipos de equipos</li>
                <li>Los usuarios anteriores serán eliminados</li>
                <li>Podrás registrar nuevos usuarios sin problemas de claves foráneas</li>
                <li>Los triggers y funciones serán recreados</li>
            </ol>
        </div>

        <div style="margin-top: 20px;">
            <a href="/inventario_equipos/test_conexion.php" class="button button-secondary">🔍 Test Conexión</a>
            <a href="/inventario_equipos/debug_registro.php" class="button button-secondary">🧪 Debug Registro</a>
            <a href="/inventario_equipos/view/loginRegister.php" class="button button-secondary">📝 Login</a>
        </div>
    </div>
</body>
</html>
