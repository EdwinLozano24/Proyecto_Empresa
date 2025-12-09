<?php
// Configuración y conexión a base de datos MySQL con PDO
/**
 * Archivo: conexion.php
 * Gestiona la conexión a la base de datos MySQL usando PDO
 * Patrón Singleton - Una única instancia de conexión para toda la aplicación
 */

declare(strict_types=1);

// ===================================
// CONFIGURACIÓN DE LA BASE DE DATOS
// ===================================

// Servidor MySQL (localhost para XAMPP local)
define('DB_HOST', 'localhost');

// Nombre de la base de datos (cambiar según tu BD)
// Nota: Debe ser 'inventario_equipos_gradezco' según Sql/Codigo.sql
define('DB_NAME', 'inventario_equipos_gradezco');

// Usuario de MySQL (por defecto en XAMPP es 'root')
define('DB_USER', 'root');

// Contraseña de MySQL (por defecto en XAMPP es vacía '')
define('DB_PASS', '');

// Codificación de caracteres (UTF-8 para soportar tildes, ñ, etc.)
define('DB_CHARSET', 'utf8mb4');

// Puerto MySQL (por defecto es 3306)
define('DB_PORT', 3306);

// ===================================
// FUNCIÓN DE CONEXIÓN (SINGLETON)
// ===================================

/**
 * Obtiene la conexión a la base de datos
 * Implementa el patrón Singleton para asegurar una única conexión
 * 
 * @return PDO Conexión a la base de datos
 * @throws PDOException Si hay error en la conexión
 */
function conectar(): PDO
{
    // Variable estática que mantiene la conexión entre llamadas
    static $pdo = null;
    
    // Si ya existe una conexión válida, retornarla
    if ($pdo instanceof PDO) {
        return $pdo;
    }

    // Construir la cadena de conexión (DSN)
    // Formato: mysql:host=localhost;port=3306;dbname=nombre_bd;charset=utf8mb4
    $dsn = sprintf(
        "mysql:host=%s;port=%d;dbname=%s;charset=%s",
        DB_HOST,
        DB_PORT,
        DB_NAME,
        DB_CHARSET
    );

    // Configuración de opciones de PDO
    $options = [
        // Lanzar excepciones en caso de error
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        
        // Modo de fetch por defecto: arrays asociativos
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        
        // NO emular prepared statements - usar los nativos de MySQL
        // Esto previene vulnerabilidades de SQL injection
        PDO::ATTR_EMULATE_PREPARES => false,
        
        // Persistencia de conexión (mantiene conexión abierta)
        PDO::ATTR_PERSISTENT => false,
    ];

    try {
        // Crear nueva conexión PDO
        $pdo = new PDO($dsn, DB_USER, DB_PASS, $options);
        
        // Mensaje de éxito (opcional, comentar en producción)
        // echo "✅ Conexión exitosa a la base de datos: " . DB_NAME;
        
        return $pdo;
        
    } catch (PDOException $e) {
        // Capturar y mostrar errores de conexión
        $error = sprintf(
            "❌ ERROR DE CONEXIÓN A LA BASE DE DATOS\n" .
            "Servidor: %s:%d\n" .
            "Base de Datos: %s\n" .
            "Usuario: %s\n" .
            "Detalles del Error: %s",
            DB_HOST,
            DB_PORT,
            DB_NAME,
            DB_USER,
            $e->getMessage()
        );
        
        // En desarrollo, mostrar detalles del error
        // En producción, mostrar mensaje genérico
        die($error);
    }
}

// FUNCIÓN AUXILIAR: PROBAR CONEXIÓN

/**
 * Función para probar la conexión (uso en desarrollo)
 * Ejemplo: php -r "require 'app/conexion.php'; probarConexion();"
 */
function probarConexion(): void
{
    try {
        $pdo = conectar();
        
        // Ejecutar una consulta simple para verificar la conexión
        $stmt = $pdo->query("SELECT VERSION() as version");
        $resultado = $stmt->fetch();
        
        echo "✅ Conexión a la base de datos exitosa\n";
        echo "Versión de MySQL: " . $resultado['version'] . "\n";
        echo "Base de Datos: " . DB_NAME . "\n";
        echo "Usuario: " . DB_USER . "\n";
        echo "Host: " . DB_HOST . "\n";
        
    } catch (PDOException $e) {
        echo "❌ Error en la conexión: " . $e->getMessage() . "\n";
    }
}


?>
