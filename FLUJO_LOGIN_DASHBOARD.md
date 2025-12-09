# Flujo de Login → Dashboard

## ✅ Sistema Completo de Autenticación

El sistema de login ya está completamente configurado y funcional. Aquí está el flujo completo:

## 🔄 Flujo de Login

```
1. Usuario accede a: http://localhost/inventario_equipos/view/loginRegister.php
                          ↓
2. Completa datos:
   - Nombre de Usuario
   - Contraseña
                          ↓
3. Envía formulario a: /inventario_equipos/controller/usuarioController.php
                          ↓
4. Controlador valida credenciales llamando a UsuarioModel
                          ↓
5. Si credenciales son válidas:
   - Crea variables de sesión
   - Redirige a: /inventario_equipos/view/dashboard.php
                          ↓
6. Dashboard muestra:
   - Bienvenida al usuario
   - Información del usuario
   - Botón de cerrar sesión
```

## 🧪 Prueba de Flujo Completo

### Paso 1: Acceder al Login
```
http://localhost/inventario_equipos/view/loginRegister.php
```

### Paso 2: Registrar Usuario (si aún no lo has hecho)
- Pestaña: "Registrarse"
- Documento: `987654321`
- Nombre de Usuario: `usuario_prueba`
- Contraseña: `123456`

### Paso 3: Iniciar Sesión
- Pestaña: "Iniciar Sesión"
- Nombre de Usuario: `usuario_prueba`
- Contraseña: `123456`
- ✅ Deberías ser redirigido automáticamente al Dashboard

### Paso 4: Verificar Dashboard
- Deberías ver: "Bienvenida usuario_prueba"
- Deberías ver tu rol: "Usuario"
- Botón de "Cerrar Sesión" funcional

## 📋 Componentes Configurados

### ✅ Vista: loginRegister.php
- Formulario de login
- Formulario de registro
- Envía a: `/inventario_equipos/controller/usuarioController.php`
- Método: POST

### ✅ Controlador: usuarioController.php
- Función: `iniciarSesion()`
- Valida credenciales
- Crea sesión
- Redirige a: `/inventario_equipos/view/dashboard.php`

### ✅ Modelo: usuarioModel.php
- Función: `validarCredenciales()`
- Comprueba usuario y contraseña
- Retorna datos del usuario

### ✅ Vista: dashboard.php
- Protegida (requiere autenticación)
- Muestra datos del usuario
- Botón para cerrar sesión

### ✅ Middleware: protecciones.php
- Función: `protegerPagina()`
- Redirige a login si no está autenticado

## 🔐 Variables de Sesión Creadas

Después de login exitoso:

```php
$_SESSION['usuario_id']           // ID del usuario
$_SESSION['usuario_nombre']       // Nombre de usuario
$_SESSION['usuario_documento']    // Documento
$_SESSION['usuario_empleado_id']  // ID empleado (si está vinculado)
$_SESSION['usuario_rol']          // Nombre del rol
$_SESSION['usuario_email']        // Email del empleado (si existe)
$_SESSION['autenticado']          // Bandera de autenticación = true
```

## 🚀 Rutas Clave

| Descripción | URL |
|-------------|-----|
| Login | `http://localhost/inventario_equipos/view/loginRegister.php` |
| Dashboard | `http://localhost/inventario_equipos/view/dashboard.php` |
| Controlador Login | `/inventario_equipos/controller/usuarioController.php` |
| Cerrar Sesión | `/inventario_equipos/controller/cerrarSesion.php` |
| Test Conexión | `http://localhost/inventario_equipos/test_conexion.php` |
| Debug Registro | `http://localhost/inventario_equipos/debug_registro.php` |

## 🎯 Caso de Uso

### Usuario no autenticado:
1. Intenta acceder a: `/inventario_equipos/view/dashboard.php`
2. La función `protegerPagina()` lo detecta
3. Lo redirige a: `/inventario_equipos/view/loginRegister.php`

### Usuario autenticado:
1. Accede a: `/inventario_equipos/view/dashboard.php`
2. Dashboard se carga normalmente
3. Muestra: Nombre, Rol, Botón de cerrar sesión

## ✨ Funcionalidades Implementadas

- ✅ Registro de usuarios
- ✅ Hash de contraseñas con PASSWORD_BCRYPT
- ✅ Login con validación
- ✅ Sesiones seguras
- ✅ Redireccionamiento automático al Dashboard
- ✅ Protección de páginas
- ✅ Cerrar sesión
- ✅ Verificación de roles

## 📞 Si Hay Problemas

### Problema: "Error de conexión"
- Verifica: `http://localhost/inventario_equipos/test_conexion.php`

### Problema: "Error de registro"
- Verifica: `http://localhost/inventario_equipos/debug_registro.php`

### Problema: No redirige al Dashboard
- Verifica que el navegador acepta redirecciones (headers)
- Verifica los logs: `C:\xampp\apache\logs\error.log`
- Comprueba que `dashboard.php` existe

### Problema: Sesión no persiste
- Verifica que las cookies están habilitadas
- Comprueba `session.php_sapi_name` en phpinfo()

---

**¡El sistema está listo para usar!** 🎉

Prueba el flujo completo:
1. Registra un usuario
2. Inicia sesión
3. Deberías ver el dashboard

