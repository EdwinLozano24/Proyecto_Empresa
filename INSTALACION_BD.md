# Configuración de la Base de Datos - XAMPP

## 📋 Requisitos Previos

- **XAMPP** instalado en tu sistema
- **MySQL** corriendo en XAMPP
- **Apache** corriendo en XAMPP
- Navegador web (Chrome, Firefox, Edge, Safari)

## 🚀 Pasos de Instalación

### Paso 1: Iniciar XAMPP

1. Abre el panel de control de XAMPP
2. Inicia los servicios:
   - ✅ Apache (debe estar en verde)
   - ✅ MySQL (debe estar en verde)
3. Si necesitas que se inicien automáticamente, marca las opciones de "Auto-start"

**En Windows:**
- XAMPP Control Panel: `C:\xampp\xampp-control.exe`
- O accede a: `http://localhost`

### Paso 2: Verificar la Instalación del Proyecto

El proyecto debe estar en: `C:\xampp\htdocs\inventario_equipos\`

```
C:\xampp\htdocs\
├── inventario_equipos/
│   ├── app/
│   │   ├── conexion.php        (Configuración BD)
│   │   └── protecciones.php    (Middleware)
│   ├── controller/
│   │   ├── usuarioController.php
│   │   └── cerrarSesion.php
│   ├── model/
│   │   ├── dashboardModel.php
│   │   └── usuarioModel.php
│   ├── view/
│   │   ├── loginRegister.php
│   │   └── dashboard.php
│   ├── assets/
│   │   ├── css/
│   │   └── js/
│   ├── Sql/
│   │   ├── Codigo.sql          (Schema completo)
│   │   └── instalacion.sql     (Creación BD)
│   └── test_conexion.php       (Test de conexión)
```

### Paso 3: Crear la Base de Datos

**OPCIÓN A: phpMyAdmin (Recomendado para principiantes)**

1. Abre phpMyAdmin: `http://localhost/phpmyadmin`
2. Inicia sesión (usuario: `root`, contraseña: vacía)
3. Haz clic en **"Nueva"** en la sección izquierda
4. En **"Nombre de la base de datos"**: escribe `inventario_equipos_gradezco`
5. En **"Cotejamiento"**: selecciona `utf8mb4_unicode_ci`
6. Haz clic en **"Crear"**

**OPCIÓN B: Línea de Comandos**

Abre PowerShell/CMD y ejecuta:

```powershell
cd C:\xampp\mysql\bin
mysql -u root -p < "C:\xampp\htdocs\inventario_equipos\Sql\instalacion.sql"
```

Si no tienes contraseña, solo presiona Enter cuando la solicite.

### Paso 4: Crear las Tablas y Triggers

**OPCIÓN A: phpMyAdmin**

1. En phpMyAdmin, selecciona la BD `inventario_equipos_gradezco`
2. Ve a la pestaña **"SQL"**
3. Abre el archivo `Sql/Codigo.sql` con un editor de texto
4. Copia TODO el contenido
5. Pégalo en el editor SQL de phpMyAdmin
6. Haz clic en **"Ejecutar"**

**OPCIÓN B: Importar archivo directamente**

1. En phpMyAdmin, selecciona la BD `inventario_equipos_gradezco`
2. Ve a la pestaña **"Importar"**
3. Haz clic en **"Seleccionar archivo"**
4. Selecciona: `C:\xampp\htdocs\inventario_equipos\Sql\Codigo.sql`
5. Haz clic en **"Ejecutar"**

**OPCIÓN C: Línea de Comandos**

```powershell
cd C:\xampp\mysql\bin
mysql -u root inventario_equipos_gradezco < "C:\xampp\htdocs\inventario_equipos\Sql\Codigo.sql"
```

### Paso 5: Verificar la Conexión

1. Abre tu navegador
2. Ve a: `http://localhost/inventario_equipos/test_conexion.php`
3. Deberías ver un panel verde con "✅ Conexión Exitosa"
4. Si hay error, verás los detalles y sugerencias para solucionarlo

### Paso 6: Probar el Sistema

1. Accede a: `http://localhost/inventario_equipos/view/loginRegister.php`
2. Haz clic en **"Registrarse"**
3. Completa el formulario:
   - Documento: `123456789`
   - Nombre de Usuario: `usuario_prueba`
   - Contraseña: `123456`
4. Haz clic en **"Registrarse"**
5. Deberías ver un mensaje de éxito
6. Ahora haz clic en **"Iniciar Sesión"**
7. Usa las credenciales que acabas de crear
8. Si todo funciona, entrarás al dashboard

## 🔧 Configuración Personalizada

Si necesitas cambiar las credenciales de la base de datos, edita `app/conexion.php`:

```php
define('DB_HOST', 'localhost');                    // Servidor
define('DB_NAME', 'inventario_equipos_gradezco'); // Nombre BD
define('DB_USER', 'root');                         // Usuario MySQL
define('DB_PASS', '');                             // Contraseña MySQL
define('DB_PORT', 3306);                           // Puerto MySQL
```

**Cambios comunes:**

- **Contraseña MySQL:** 
  ```php
  define('DB_PASS', 'tu_contraseña_aqui');
  ```

- **Usuario diferente:**
  ```php
  define('DB_USER', 'otro_usuario');
  ```

- **Puerto diferente:**
  ```php
  define('DB_PORT', 3307); // Si MySQL no está en el puerto 3306
  ```

## 📊 Verificar las Tablas Creadas

Abre phpMyAdmin y en la BD `inventario_equipos_gradezco` deberías ver:

```
✓ tbl_archivo
✓ tbl_cargo
✓ tbl_empleado
✓ tbl_equipos
✓ tbl_historial
✓ tbl_mantenimiento
✓ tbl_rol
✓ tbl_tipo_equipo
✓ tbl_usuario
```

## ❌ Solución de Problemas

### Error: "Error de conexión"

**Causa probable:** La base de datos no existe o XAMPP no está corriendo

**Solución:**
1. Verifica que MySQL esté corriendo en XAMPP ✅
2. Crea la BD `inventario_equipos_gradezco`
3. Importa el SQL desde `Sql/Codigo.sql`
4. Accede a: `http://localhost/test_conexion.php`

### Error: "Access denied for user 'root'"

**Causa probable:** Contraseña incorrecta configurada

**Solución:**
1. Edita `app/conexion.php`
2. En `DB_PASS`, coloca tu contraseña MySQL (si la tienes)
3. En XAMPP por defecto no hay contraseña: `define('DB_PASS', '');`

### Error: "Unknown database 'inventario_equipos_gradezco'"

**Causa probable:** La base de datos no fue creada

**Solución:**
1. Accede a phpMyAdmin: `http://localhost/phpmyadmin`
2. Crea la BD manualmente (Opción A del Paso 3)
3. Importa el SQL (Paso 4, Opción B)

### Las tablas no existen

**Causa probable:** El SQL no se ejecutó correctamente

**Solución:**
1. Ve a phpMyAdmin
2. En la BD `inventario_equipos_gradezco`, ve a SQL
3. Borra todo el contenido si hay algo
4. Abre `Sql/Codigo.sql` con bloc de notas
5. Copia TODO el contenido
6. Pégalo en phpMyAdmin
7. Ejecuta

## 📍 Ubicaciones Importantes

| Ubicación | Ruta |
|-----------|------|
| Proyecto | `C:\xampp\htdocs\inventario_equipos` |
| Raíz Web | `http://localhost` |
| phpMyAdmin | `http://localhost/phpmyadmin` |
| Login | `http://localhost/inventario_equipos/view/loginRegister.php` |
| Test Conexión | `http://localhost/inventario_equipos/test_conexion.php` |
| Apache Log | `C:\xampp\apache\logs\error.log` |
| MySQL Log | `C:\xampp\mysql\data\mysql_error.log` |

## 🔐 Credenciales Por Defecto en XAMPP

```
MySQL User: root
MySQL Password: (vacío - presionar Enter)
MySQL Host: localhost (127.0.0.1)
MySQL Port: 3306
```

## ✅ Checklist Final

- [ ] XAMPP corriendo (Apache + MySQL)
- [ ] Base de datos creada: `inventario_equipos_gradezco`
- [ ] Tablas importadas desde `Sql/Codigo.sql`
- [ ] `app/conexion.php` configurado correctamente
- [ ] Test de conexión exitoso: `http://localhost/inventario_equipos/test_conexion.php`
- [ ] Usuario de prueba creado
- [ ] Login funcionando correctamente
- [ ] Dashboard visible después de login

## 📞 Contacto/Soporte

Si encuentras problemas:

1. Revisa los logs de error en Apache o MySQL
2. Intenta acceder a `test_conexion.php` para diagnóstico automático
3. Verifica que todos los archivos estén en el lugar correcto
4. Reinicia XAMPP (detén y luego inicia nuevamente)

---

**Última actualización:** Diciembre 2025
**Versión:** 1.0
