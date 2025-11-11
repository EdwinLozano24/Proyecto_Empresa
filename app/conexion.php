<?php
// Configuración y conexión a base de datos MySQL con PDO
declare(strict_types=1);

// Parámetros de conexión a la base de datos
define('DB_HOST', '127.0.0.1');      // Servidor MySQL
define('DB_NAME', 'proyecto_sab');   // Nombre de la BD
define('DB_USER', 'root');           // Usuario
define('DB_PASS', '');               // Contraseña
define('DB_CHARSET', 'utf8mb4');     // Codificación UTF-8

// Función de conexión (patrón Singleton - una única instancia)
function conectar(): PDO
{
    static $pdo = null;
    
    // Retorna conexión existente si ya está creada
    if ($pdo instanceof PDO) {
        return $pdo;
    }

    // Construye la cadena de conexión (DSN)
    $dsn = "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=" . DB_CHARSET;
    
    // Opciones de configuración de PDO
    $options = [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,  // Excepciones en errores
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,        // Arrays asociativos
        PDO::ATTR_EMULATE_PREPARES   => false,                   // Prepared statements nativos
    ];

    try {
        $pdo = new PDO($dsn, DB_USER, DB_PASS, $options);
        return $pdo;
    } catch (PDOException $e) {
        die('❌ Error de conexión: ' . $e->getMessage());
    }
}
