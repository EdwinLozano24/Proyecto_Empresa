# Instrucciones para Copilot - Inventario de Equipos

## Descripción General del Proyecto
**Inventario de Equipos** es un sistema de gestión de inventario de equipos para prácticas empresariales, desarrollado en PHP. Rastreat equipos, empleados y operaciones de inventario usando arquitectura MVC clásica con conectividad PDO a bases de datos MySQL.

## Arquitectura y Patrones Clave

### Estructura MVC
- **Modelos** (`model/`): Capa de interacción con base de datos usando inyección de dependencias. Reciben conexión PDO y ejecutan consultas.
  - Ejemplo: `DashboardModel` recibe parámetro `$conexion` en constructor, usa prepared statements
- **Controladores** (`controller/`): Incluyen modelos correspondientes y orquestan lógica de negocio
  - Ejemplo: patrón `DashboardController` → `DashboardModel`
- **Vistas** (`view/`): Plantillas PHP renderizando HTML/Bootstrap. Usan etiquetas `<?php ?>` embebidas en HTML.

### Patrón de Conexión a Base de Datos
Ubicado en `app/conexion.php` - Usa **patrón Singleton de PDO**:
```php
function conectar(): PDO {
    static $pdo = null;
    if ($pdo instanceof PDO) return $pdo;
    // Crea única conexión persistente con manejo de errores
}
```
**Configuración clave**: charset UTF-8, excepciones habilitadas, prepared statements nativos, modo fetch asociativo.

### Esquema de Base de Datos
Tablas principales en `Sql/Codigo.sql`:
- `tbl_usuario`: Usuarios con documento, nombre_usuario, password, vinculación a empleado y rol
- `tbl_empleado`: Empleados vinculados a `tbl_cargo` vía FK, con datos de contacto
- `tbl_tipo_equipo`: Tipos de equipos con descripciones
- `tbl_equipos`: Tabla principal de equipos con estado (ENUM: 'Activo', 'Inactivo', 'Mantenimiento', 'Dado de Baja')
- `tbl_mantenimiento`: Historial de mantenimientos de equipos
- `tbl_historial`: Registro de cambios de ubicación de equipos
- `tbl_rol`, `tbl_cargo`, `tbl_archivo`: Tablas de lookup y soporte

### Normalización de Datos con Triggers
El SQL incluye **triggers automáticos** que normalizan datos al insertar/actualizar:
- `CapitalizarPalabras()`: Capitaliza cada palabra en nombres
- `Capitalizar()`: Capitaliza solo primera letra
- Emails se convierten a minúsculas automáticamente
- Códigos de inventario y series se convierten a mayúsculas
- **Nota**: Los triggers se aplican a empleados, equipos, cargos, roles, archivos, mantenimiento e historial

### Relaciones de Usuario-Empleado
Triggers especiales autovinculan usuarios con empleados:
1. Al crear usuario: busca empleado con mismo documento y asigna `Id_Empleado`
2. Al crear empleado: actualiza cualquier usuario existente con mismo documento

## Flujos de Trabajo de Desarrollo

### Configuración Inicial de Base de Datos
1. Crear base de datos: `CREATE DATABASE inventario_equipos_gradezco;`
2. Ejecutar SQL completo desde `Sql/Codigo.sql` (crea tablas, funciones y triggers)
3. Actualizar credenciales en `app/conexion.php` (DB_HOST, DB_NAME, DB_USER, DB_PASS)
4. **Nota**: `app/conexion.php` actualmente referencia `proyecto_sab` (verificar/actualizar a `inventario_equipos_gradezco`)

### Gestión de Dependencias
Usa Composer con PHPMailer. Instalar vía:
```bash
composer install
```
Ubicado en `vendor/` con autoload en `vendor/autoload.php`.

## Convenciones de Código

### Organización de Archivos
- Controladores: Sin sufijo, coinciden con nombres de modelos (ej: `usuarioController.php` → `usuarioModel.php`)
- Clases: Nombres en PascalCase, coinciden con nombres de archivo
- Funciones: camelCase (ej: `contarEquiposActivos()`)
- Consultas SQL: Usar COUNT/SELECT con cláusulas WHERE para filtrado
- Prepared statements: SIEMPRE usar (PDO nativo, no emulado)

### Frontend (Bootstrap 5 + Vanilla JS)
- Formularios: Usar `<input type="hidden" name="origen_formulario">` para rastrear origen de formulario
- CSS: Hojas de estilo personalizadas en `assets/css/` (ej: `LoginRegister.css`, `Dashboard.css`)
- JS: JavaScript vanilla en `assets/js/script.js` - Manipulación DOM vía `querySelector`
- Punto de quiebre responsive: 850px ancho para layouts móvil/escritorio

### Manejo de Errores
- PDO: Lanza `PDOException` - capturada en `conexion.php` con die() para mostrar
- Prepared statements previenen inyección SQL (nativo PDO, no emulado)
- Rastreo de estado: Estado de equipo usa valores ENUM ('Activo', 'Inactivo', 'Mantenimiento', 'Dado de Baja')
- Los triggers mantienen integridad de datos (capitalización automática, vinculación usuario-empleado)

## Puntos de Integración y Dependencias

- **PHPMailer** (v7.0+): Para notificaciones de email (instalado vía Composer)
- **Bootstrap 5**: Cargado vía CDN para componentes UI
- **Google Fonts**: Cargado vía CDN (Open Sans)
- **MySQL**: Backend de base de datos requerido
- **XAMPP**: Entorno de desarrollo local recomendado

## Agregando Nuevas Funcionalidades

Al implementar nuevas funcionalidades:
1. Crear tabla/columnas en base de datos en `Sql/` (SQL puro, sin triggers específicos a menos que sea necesario normalización)
2. Agregar clase Model correspondiente con consultas usando prepared statements
3. Crear clase Controller que incluye e instancia el Model
4. Crear plantilla View en `view/` que recibe datos del Controller
5. Usar patrón de campo: `<input name="fieldName" required>` para campos obligatorios
6. Para AJAX: Incluir campo de formulario oculto `origen_formulario` para rastrear origen de solicitud
7. Considerar agregar triggers para normalización automática si la tabla contiene datos de texto
