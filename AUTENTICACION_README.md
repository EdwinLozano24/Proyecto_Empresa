# Sistema de Autenticación - Inventario de Equipos

## Descripción
Sistema completo de login y registro de usuarios para el proyecto Inventario de Equipos.

## Archivos Creados/Modificados

### 1. **model/usuarioModel.php** (Nuevo)
Modelo que gestiona todas las operaciones con usuarios en la base de datos.

**Métodos principales:**
- `validarCredenciales($nombre_usuario, $password)`: Valida login
- `registrarUsuario($nombre_usuario, $password, $documento)`: Registra nuevo usuario
- `obtenerUsuarioPorNombre($nombre_usuario)`: Obtiene datos del usuario
- `usuarioExiste($nombre_usuario)`: Verifica si existe
- `documentoExiste($documento)`: Verifica si el documento ya está registrado
- `actualizarPassword($id_usuario, $nueva_password)`: Cambia contraseña
- `obtenerTodosLosUsuarios()`: Lista para administración

### 2. **controller/usuarioController.php** (Modificado)
Controlador que maneja la lógica de autenticación.

**Métodos principales:**
- `procesarSolicitud()`: Router principal de solicitudes POST
- `iniciarSesion()`: Maneja login
- `registrarUsuario()`: Maneja registro
- `cerrarSesion()`: Cierra sesión
- `usuarioAutenticado()`: Verifica si está autenticado
- `obtenerUsuarioActual()`: Obtiene datos de la sesión

### 3. **view/loginRegister.php** (Modificado)
Vista actualizada con:
- Formulario de login funcional
- Formulario de registro con validación
- Campo documento (requisito de BD)
- Alertas de error/éxito con Bootstrap
- Integración con controlador

### 4. **app/protecciones.php** (Nuevo)
Middleware para proteger páginas que requieren autenticación.

**Funciones:**
- `protegerPagina()`: Redirige a login si no está autenticado
- `verificarRol($rolesPermitidos)`: Verifica roles específicos
- `cerrarSesion()`: Cierra sesión

### 5. **controller/cerrarSesion.php** (Nuevo)
Script simple para cerrar sesión.

### 6. **view/dashboard.php** (Modificado)
Dashboard actualizado con:
- Protección de página (requiere autenticación)
- Información del usuario autenticado
- Botón de cerrar sesión
- Muestra nombre y rol del usuario

## Flujo de Funcionamiento

### Login
1. Usuario ingresa nombre y contraseña en formulario
2. Formulario envía POST a `usuarioController.php`
3. Controlador llama a `validarCredenciales()` del modelo
4. Si es válido:
   - Crea variables de sesión
   - Redirige a dashboard
5. Si es inválido:
   - Muestra error
   - Redirige a login

### Registro
1. Usuario completa formulario con: documento, nombre_usuario, password
2. Formulario envía POST a `usuarioController.php`
3. Controlador llama a `registrarUsuario()` del modelo
4. Modelo valida:
   - Campos no vacíos
   - Contraseña mínimo 6 caracteres
   - Usuario no existe
   - Documento no existe
5. Si todo es válido:
   - Hashea contraseña con PASSWORD_BCRYPT
   - Inserta en BD
   - Muestra éxito
6. Si hay error:
   - Muestra mensaje de error específico

## Campos de tbl_usuario Utilizados

```
- Id_Usuario (INT, AUTO_INCREMENT, PRIMARY KEY)
- documento_Usuario (VARCHAR 50, UNIQUE)
- Nombre_Usuario (VARCHAR 255, UNIQUE)
- Password_Usuario (VARCHAR 255) - Almacenado con hash BCRYPT
- Id_Empleado (INT, NULL) - Vinculado automáticamente por trigger
- Id_Rol (INT) - Rol de usuario
- Token_Recuperacion (VARCHAR 255, NULL) - Para recuperación de contraseña
- Token_Expira (DATETIME, NULL) - Expiración de token
```

## Variables de Sesión

Después de login exitoso, se crean estas variables de sesión:

```php
$_SESSION['usuario_id']           // ID del usuario
$_SESSION['usuario_nombre']       // Nombre de usuario
$_SESSION['usuario_documento']    // Documento
$_SESSION['usuario_empleado_id']  // ID del empleado vinculado
$_SESSION['usuario_rol']          // Nombre del rol
$_SESSION['usuario_email']        // Email del empleado
$_SESSION['autenticado']          // Bandera de autenticación
```

## Uso en Otras Páginas

### Proteger una página que requiere autenticación:
```php
<?php
require_once __DIR__ . '/../app/protecciones.php';
protegerPagina();

$usuario = UsuarioController::obtenerUsuarioActual();
echo "Bienvenido " . $usuario['nombre'];
?>
```

### Verificar rol específico:
```php
<?php
require_once __DIR__ . '/../app/protecciones.php';
verificarRol(['Administrador', 'Supervisor']);

// Solo usuarios con estos roles acceden aquí
?>
```

## Seguridad

✅ **Implementado:**
- Hashing de contraseñas con PASSWORD_BCRYPT
- Prepared statements (previene SQL injection)
- Sesiones PHP para autenticación
- Validación en servidor (no solo en cliente)
- Protección de páginas con middleware

⚠️ **Recomendaciones adicionales:**
- Agregar HTTPS en producción
- Implementar rate limiting para login
- Agregar 2FA para mayor seguridad
- Implementar renovación de tokens de sesión
- Agregar logs de auditoría

## Pruebas

1. **Crear una base de datos limpia:**
   ```sql
   CREATE DATABASE inventario_equipos_gradezco;
   -- Ejecutar Sql/Codigo.sql
   ```

2. **Actualizar `app/conexion.php`:**
   ```php
   define('DB_NAME', 'inventario_equipos_gradezco');
   ```

3. **Acceder a la página de login:**
   ```
   http://localhost/inventario_equipos/view/loginRegister.php
   ```

4. **Registrar un usuario:**
   - Documento: 123456789
   - Usuario: usuario_prueba
   - Contraseña: 123456

5. **Iniciar sesión:**
   - Usuario: usuario_prueba
   - Contraseña: 123456

6. **Verificar que se redirige a dashboard**

## Próximos Pasos

1. Implementar recuperación de contraseña (usar Token_Recuperacion)
2. Crear módulo de gestión de usuarios (CRUD)
3. Implementar diferentes roles y permisos
4. Agregar auditoría de accesos
5. Crear panel administrativo
