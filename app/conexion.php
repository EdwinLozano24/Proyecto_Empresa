<?php
// app/conexion.php
declare(strict_types=1);

/**
 * Configuración de la base de datos
 * Actualiza los valores según tu entorno (XAMPP: host, usuario, contraseña, nombre de BD)
 */
define('DB_HOST', '127.0.0.1');
define('DB_NAME', 'nombre_basedatos');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_CHARSET', 'utf8mb4');

/**
 * Devuelve una instancia PDO reutilizable.
 * Uso: $pdo = conectar();
 *
 * @return PDO
 */
function conectar(): PDO
{
    static $pdo = null;
    if ($pdo instanceof PDO) {
        return $pdo;
    }

    $dsn = "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=" . DB_CHARSET;
    $options = [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
    ];

    try {
        $pdo = new PDO($dsn, DB_USER, DB_PASS, $options);
        return $pdo;
    } catch (PDOException $e) {
        // En producción registra el error y muestra un mensaje genérico.
        die('Conexión fallida: ' . $e->getMessage());
    }
}