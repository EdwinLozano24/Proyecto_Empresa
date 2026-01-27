# Sistema de Filtrado Avanzado - Inventario de Equipos

## Descripción
Se ha implementado un sistema de filtrado avanzado y búsqueda en todos los CRUDs del sistema:
- **Equipos**
- **Empleados**  
- **Usuarios (Administración)**

## Características

### 1. Búsqueda Avanzada Expandible
- Interfaz colapsable que se expande al hacer clic
- Se expande automáticamente cuando hay filtros activos
- Botón para limpiar todos los filtros de una vez

### 2. Filtros Dinámicos por CRUD

#### Equipos
- **Código de Inventario**: Búsqueda parcial (LIKE)
- **Marca**: Búsqueda parcial (LIKE)
- **Número de Serie**: Búsqueda parcial (LIKE)
- **Ubicación**: Búsqueda parcial (LIKE)
- **Estado**: Dropdown (Activo, Inactivo, Mantenimiento, Dado de Baja)
- **Tipo de Equipo**: Dropdown dinámico con tipos disponibles
- **Propietario**: Dropdown con empleados disponibles
- **Rango de Fechas**: Fecha desde y Fecha hasta

#### Empleados
- **Documento**: Búsqueda parcial (LIKE)
- **Nombre o Apellido**: Búsqueda parcial en ambos campos (LIKE)
- **Correo Electrónico**: Búsqueda parcial (LIKE)
- **Teléfono**: Búsqueda parcial (LIKE)
- **Cargo**: Dropdown dinámico con cargos disponibles

#### Usuarios
- **Documento**: Búsqueda parcial (LIKE)
- **Nombre de Usuario**: Búsqueda parcial (LIKE)
- **Nombre del Empleado**: Búsqueda parcial en nombre y apellido (LIKE)
- **Correo Electrónico**: Búsqueda parcial (LIKE)
- **Rol**: Dropdown dinámico con roles disponibles

### 3. Consultas SQL Optimizadas
Todos los filtros usan:
- **Prepared Statements** para prevenir inyección SQL
- **LIKE queries** para búsquedas flexibles
- **WHERE dinámicos** que se construyen según los filtros enviados
- **Índices en base de datos** para mejor rendimiento

### 4. Interfaz de Usuario

#### Formulario de Búsqueda
```
🔍 Búsqueda Avanzada      ↓ Expandir
────────────────────────────────────
[ Campo 1    ]  [ Campo 2    ]
[ Campo 3    ]  [ Campo 4    ]
────────────────────────────────────
🔎 Buscar   |  Limpiar Campos
```

#### Características
- Botones principales al lado del formulario:
  - **Nuevo** - crear nuevo registro
  - **Limpiar Filtros** - vuelve a la vista sin filtros (solo aparece si hay filtros activos)
  - **Expandir/Contraer** - muestra/oculta el formulario

### 5. Funcionalidad JavaScript

#### `toggleSearchForm()`
```javascript
function toggleSearchForm() {
  const form = document.getElementById('searchForm');
  const btn = document.querySelector('.btn-toggle-filter');
  if (form.style.display === 'none') {
    form.style.display = 'grid';
    btn.textContent = '↑ Contraer';
  } else {
    form.style.display = 'none';
    btn.textContent = '↓ Expandir';
  }
}
```

Auto-expande si hay filtros activos en el load de página.

## Métodos en los Models

### EquipoModel
```php
public function buscar($filtros)
// Retorna equipos filtrados según criterios
// $filtros = [
//   'codigo' => '',
//   'marca' => '',
//   'serie' => '',
//   'ubicacion' => '',
//   'estado' => '',
//   'tipo' => '',
//   'propietario' => '',
//   'fecha_desde' => '',
//   'fecha_hasta' => ''
// ]
```

### EmpleadoModel
```php
public function buscar($filtros)
// Retorna empleados filtrados
// $filtros = [
//   'documento' => '',
//   'nombre' => '',
//   'correo' => '',
//   'telefono' => '',
//   'cargo' => ''
// ]
```

### UsuarioModel
```php
public function buscar($filtros)
// Retorna usuarios filtrados
// $filtros = [
//   'documento' => '',
//   'nombre_usuario' => '',
//   'nombre_empleado' => '',
//   'correo' => '',
//   'rol' => ''
// ]
```

## Controllers Actualizados

### equipoController.php
```php
// Procesa filtros desde GET
if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['filtrar'])) {
    $filtros = [...];
    $filtros_activos = !empty(array_filter($filtros));
}

if ($accion == 'listar') {
    if ($filtros_activos) {
        $equipos = $equipoModel->buscar($filtros);
    } else {
        $equipos = $equipoModel->obtenerTodos();
    }
}
```

### empleadoController.php
Similar al equipoController

### usuarioAdminController.php  
Similar al equipoController

## Uso del Sistema

### Desde la Vista
1. Click en "🔍 Búsqueda Avanzada" → ↓ Expandir
2. Completa los campos deseados
3. Click en "🔎 Buscar"
4. El sistema recarga la página con parámetro `?filtrar=1` y los valores

### URL con Filtros
```
/inventario_equipos/controller/equipoController.php?accion=listar&filtrar=1&codigo=INV&marca=HP&estado=Activo
```

### Limpiar Filtros
Click en botón "Limpiar Filtros" o acceder sin parámetro `filtrar`

## Estilos CSS

### Archivos principales
- `Equipos.css` - Tema claro con gradientes
- `Empleados.css` - Tema oscuro con verdes
- `Usuarios.css` - Tema oscuro con azules
- `FilterStyles.css` - Estilos compartidos (opcional)

### Clases principales
- `.search-filter-container` - Contenedor principal
- `.search-toggle` - Botón de expandir
- `.search-form` - Formulario de filtros
- `.filter-grid` - Grid de campos
- `.filter-actions` - Botones de acción
- `.filter-group` - Grupo individual (label + input)

## Rendimiento

### Optimizaciones aplicadas
1. **Prepared Statements**: Previene inyección SQL
2. **Índices en BD**: Campo `Id_Empleado`, `Estado_Equipo`, etc.
3. **LIMIT/ORDER BY**: Resultados ordenados y limitados
4. **Lazy Loading**: Los campos se cargan bajo demanda

### Complejidad
- Tiempo de búsqueda: O(n) en general, O(log n) con índices
- Memoria: Variable según cantidad de resultados
- Recursos BD: Bajo - queries simples con filtros específicos

## Extensión futura

Para agregar nuevos filtros:

1. **En el Model**:
```php
if (!empty($filtros['nuevo_campo'])) {
    $sql .= " AND tabla.nuevo_campo LIKE ?";
    $parametros[] = '%' . $filtros['nuevo_campo'] . '%';
}
```

2. **En el Controller**:
```php
$filtros = [
    // ... otros
    'nuevo_campo' => $_GET['nuevo_campo'] ?? ''
];
```

3. **En la Vista**:
```php
<div class="filter-group">
    <label for="nuevo_campo">Nuevo Campo</label>
    <input type="text" id="nuevo_campo" name="nuevo_campo" 
           value="<?php echo htmlspecialchars($filtros['nuevo_campo'] ?? ''); ?>">
</div>
```

## Notas Técnicas

- Todos los valores se pasan vía GET para que sean bookmarkeable
- Los parámetros se sanitizan con `htmlspecialchars()` en las vistas
- Las búsquedas son case-insensitive (por defecto en MySQL con charset UTF-8)
- Se mantienen los valores en los inputs para UX mejorado
- El formulario se expande automáticamente si hay filtros activos
