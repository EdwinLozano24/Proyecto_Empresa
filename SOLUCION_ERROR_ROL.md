# Solución - Error de Clave Foránea en Rol

## Error Recibido
```
SQLSTATE[23000]: Integrity constraint violation: 1452 
Cannot add or update a child row: a foreign key constraint fails 
(`inventario_equipos_gradezco`.`tbl_usuario`, CONSTRAINT `tbl_usuario_ibfk_2` 
FOREIGN KEY (`Id_Rol`) REFERENCES `tbl_rol` (`Id_Rol`))
```

## 🔍 Causa del Problema

El sistema intentaba insertar un usuario con `Id_Rol = 2`, pero la tabla `tbl_rol` estaba **vacía**. 

La tabla `tbl_rol` no tenía datos iniciales, así que intentar referenciar a un rol que no existe causa la violación de clave foránea.

## ✅ Solución

He actualizado el archivo `Sql/Codigo.sql` para incluir datos iniciales de:
- **Roles** (Administrador, Usuario, Supervisor, Técnico)
- **Cargos** (Gerente, Asistente, Técnico, Operario)
- **Tipos de Equipos** (Computadora, Monitor, Impresora, Router, etc.)

### Opción 1: Restaurar la BD Automáticamente (RECOMENDADO)

1. Accede a: `http://localhost/inventario_equipos/restaurar_bd.php`
2. Lee la advertencia cuidadosamente
3. Escribe "RESTAURAR" en el campo de confirmación
4. Haz clic en el botón
5. Se recrearán todas las tablas con datos iniciales

### Opción 2: Restaurar Manualmente

1. Abre phpMyAdmin: `http://localhost/phpmyadmin`
2. Selecciona la BD `inventario_equipos_gradezco`
3. Ve a la pestaña **"SQL"**
4. Ejecuta:
   ```sql
   SET FOREIGN_KEY_CHECKS=0;
   DROP TABLE IF EXISTS tbl_historial;
   DROP TABLE IF EXISTS tbl_mantenimiento;
   DROP TABLE IF EXISTS tbl_equipos;
   DROP TABLE IF EXISTS tbl_usuario;
   DROP TABLE IF EXISTS tbl_empleado;
   DROP TABLE IF EXISTS tbl_archivo;
   DROP TABLE IF EXISTS tbl_cargo;
   DROP TABLE IF EXISTS tbl_rol;
   DROP TABLE IF EXISTS tbl_tipo_equipo;
   SET FOREIGN_KEY_CHECKS=1;
   ```
5. Importa nuevamente el archivo `Sql/Codigo.sql`

### Opción 3: Insertar Solo los Datos Iniciales

Si ya tienes las tablas y solo necesitas los datos:

```sql
-- Insertar roles
INSERT INTO tbl_rol (Nombre_Rol, Descripcion_Rol) VALUES 
('Administrador', 'Acceso total al sistema'),
('Usuario', 'Acceso básico al sistema'),
('Supervisor', 'Supervisión de inventario'),
('Técnico', 'Técnico de mantenimiento');

-- Insertar cargos
INSERT INTO tbl_cargo (Nombre_Cargo, Descripcion_Cargo) VALUES 
('Gerente', 'Gerente del departamento'),
('Asistente', 'Asistente administrativo'),
('Técnico', 'Técnico de soporte'),
('Operario', 'Personal operativo');

-- Insertar tipos de equipos
INSERT INTO tbl_tipo_equipo (Nombre_Tipo_Equipo, Descripcion_Tipo_Equipo) VALUES 
('Computadora', 'Equipos de cómputo de escritorio y portátiles'),
('Monitor', 'Monitores para visualización'),
('Impresora', 'Impresoras y multifuncionales'),
('Router', 'Equipos de red'),
('Escáner', 'Equipos de escaneo de documentos'),
('Teléfono', 'Teléfonos y equipos de comunicación'),
('Servidor', 'Servidores de red');
```

## 🔄 Cambios Realizados

### 1. Archivo `Sql/Codigo.sql`
- ✅ Agregados datos iniciales de roles
- ✅ Agregados datos iniciales de cargos
- ✅ Agregados datos iniciales de tipos de equipos

### 2. Archivo `model/usuarioModel.php`
- ✅ Mejorada la función `registrarUsuario()` para buscar automáticamente el rol "Usuario"
- ✅ Si no existe ese rol, busca el primer rol disponible
- ✅ Si no hay roles disponibles, retorna un error claro

### 3. Archivo `restaurar_bd.php` (NUEVO)
- ✅ Script para restaurar la BD de forma segura
- ✅ Interfaz visual para confirmar la acción
- ✅ Verifica que los datos se crearon correctamente

## 🧪 Próximos Pasos

### 1. Restaurar la Base de Datos

Elige una opción:
- **Automático**: http://localhost/inventario_equipos/restaurar_bd.php
- **Manual**: phpMyAdmin > Importar Sql/Codigo.sql

### 2. Verificar los Datos

Accede a: `http://localhost/inventario_equipos/debug_registro.php`

Debería mostrar:
- ✅ Conexión exitosa
- ✅ Tabla tbl_rol existe
- ✅ Tabla tbl_cargo existe
- ✅ Tabla tbl_tipo_equipo existe

### 3. Probar el Registro

1. Ve a: `http://localhost/inventario_equipos/view/loginRegister.php`
2. Completa el formulario de registro
3. Debería registrarse sin problemas

### 4. Verificar en BD

Abre phpMyAdmin y verifica:
- `SELECT * FROM tbl_rol;` - Debe mostrar 4 roles
- `SELECT * FROM tbl_cargo;` - Debe mostrar 4 cargos
- `SELECT * FROM tbl_tipo_equipo;` - Debe mostrar 7 tipos de equipos
- `SELECT * FROM tbl_usuario;` - Debe mostrar tu nuevo usuario

## 📋 Roles Disponibles

Después de la restauración, estos roles estarán disponibles:

| Id | Nombre | Descripción |
|----|--------|-----------|
| 1 | Administrador | Acceso total al sistema |
| 2 | Usuario | Acceso básico al sistema |
| 3 | Supervisor | Supervisión de inventario |
| 4 | Técnico | Técnico de mantenimiento |

El rol "Usuario" tiene `Id_Rol = 2`, que es el que el sistema usa por defecto.

## ⚠️ Si Aún Hay Problemas

1. **Verifica que las tablas existan:**
   - phpMyAdmin > Selecciona BD > pestaña "Estructura"
   - Deberías ver 9 tablas

2. **Verifica que tbl_rol tiene datos:**
   ```sql
   SELECT * FROM tbl_rol;
   ```
   Debe devolver al menos 1 fila

3. **Revisa los logs:**
   - Error de Apache: `C:\xampp\apache\logs\error.log`
   - Error de MySQL: `C:\xampp\mysql\data\mysql_error.log`

4. **Reinicia XAMPP:**
   - Detén Apache y MySQL
   - Espera 5 segundos
   - Inicia nuevamente

## 🎯 Resumen

- El error ocurría porque `tbl_rol` estaba vacía
- He agregado datos iniciales al SQL
- He mejorado el modelo para ser más flexible
- He creado un script de restauración automática
- Ahora el registro debería funcionar sin problemas

---

**Última actualización:** Diciembre 2025
