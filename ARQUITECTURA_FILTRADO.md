# 📐 ARQUITECTURA DEL SISTEMA DE FILTRADO

## 🏗️ Diagrama de Flujo General

```
┌─────────────────────────────────────────────────────────────┐
│                      NAVEGADOR USUARIO                        │
└─────────────────────────────────────────────────────────────┘
                              ↓
                              │
                   ┌──────────┴──────────┐
                   │                     │
            ┌──────▼──────┐      ┌──────▼──────┐
            │  CLICK EN   │      │  RELLENAR  │
            │ BÚSQUEDA    │      │  FORMULARIO│
            │ AVANZADA    │      │  Y BUSCAR  │
            └──────┬──────┘      └──────┬──────┘
                   │                    │
         JavaScript│                    │ GET Request
         Toggle   │                    │
         display  │                    │
                   │        ┌───────────┘
                   │        │
            ┌──────▼────────▼──────┐
            │   VISTA (view.php)   │
            │  - Formulario        │
            │  - Tabla Resultados  │
            └──────┬───────────────┘
                   │ Datos
                   │ procesados
                   ↓
            ┌──────────────────┐
            │  CONTROLADOR     │
            │  (Controller)    │
            │ - GET['filtrar'] │
            │ - Extrae parámet │
            │ - Valida datos   │
            └────────┬─────────┘
                     │ $filtros[]
                     ↓
            ┌──────────────────┐
            │  MODELO (Model)  │
            │  - buscar()      │
            │  - Prepara SQL   │
            │  - Bind params   │
            └────────┬─────────┘
                     │ Prepared
                     │ Statement
                     ↓
            ┌──────────────────┐
            │   BD - MySQL     │
            │  - WHERE dinámico│
            │  - Índices       │
            │  - ORDER/LIMIT   │
            └────────┬─────────┘
                     │ Resultados
                     │
            ┌────────▼─────────┐
            │ CONTROLADOR      │
            │ (retorno)        │
            │ $resultados[]    │
            └────────┬─────────┘
                     │
            ┌────────▼──────────────┐
            │ VISTA (renderizar)    │
            │ - Tabla resultados    │
            │ - Valores en formulario│
            │ - Botón limpiar       │
            └────────┬──────────────┘
                     │ HTML
                     ↓
            ┌──────────────────────┐
            │  NAVEGADOR           │
            │  - Tabla actualizada │
            │  - Filtros aplicados │
            └──────────────────────┘
```

---

## 🎯 Flujo por CRUD

### 1. EQUIPOS

```
equipoController.php
├─ GET Parámetros
│  ├─ ?filtrar=1
│  ├─ ?codigo=INV
│  ├─ ?marca=HP
│  ├─ ?estado=Activo
│  └─ ...8 filtros posibles
│
├─ Extrae en array $filtros
│
├─ Llama equipoModel->buscar($filtros)
│  │
│  └─ SQL generado:
│     SELECT e.*, emp.*, te.*
│     FROM tbl_equipos e
│     LEFT JOIN tbl_empleado emp...
│     LEFT JOIN tbl_tipo_equipo te...
│     WHERE 1=1
│       AND e.codigo LIKE ?      ← Si código filtrado
│       AND e.marca LIKE ?       ← Si marca filtrada
│       AND e.estado = ?         ← Si estado filtrado
│       ... (cada filtro dinámico)
│     ORDER BY e.Id_Equipo DESC
│
├─ Retorna $equipos[]
│
└─ Incluye view/equipos.php
   └─ Renderiza tabla con resultados
```

### 2. EMPLEADOS

```
empleadoController.php
├─ GET Parámetros
│  ├─ ?filtrar=1
│  ├─ ?nombre=Juan
│  ├─ ?cargo=1
│  └─ ...5 filtros posibles
│
├─ Extrae en array $filtros
│
├─ Llama empleadoModel->buscar($filtros)
│  │
│  └─ SQL generado:
│     SELECT * FROM tbl_empleado
│     WHERE 1=1
│       AND (nombre LIKE ? OR apellido LIKE ?)
│       AND cargo_id = ?
│       ...
│     ORDER BY nombre ASC
│
├─ Retorna $empleados[]
│
└─ Incluye view/empleados.php
   └─ Renderiza tabla con resultados
```

### 3. USUARIOS

```
usuarioAdminController.php
├─ GET Parámetros
│  ├─ ?filtrar=1
│  ├─ ?nombre_usuario=juan
│  ├─ ?rol=1
│  └─ ...5 filtros posibles
│
├─ Extrae en array $filtros
│
├─ Llama usuarioModel->buscar($filtros)
│  │
│  └─ SQL generado:
│     SELECT u.*, e.*, r.*
│     FROM tbl_usuario u
│     LEFT JOIN tbl_empleado e...
│     LEFT JOIN tbl_rol r...
│     WHERE 1=1
│       AND u.nombre_usuario LIKE ?
│       AND u.id_rol = ?
│       ...
│     ORDER BY u.nombre_usuario ASC
│
├─ Retorna $usuarios[]
│
└─ Incluye view/usuarios.php
   └─ Renderiza tabla con resultados
```

---

## 💾 Estructura de Base de Datos Relevante

```
tbl_equipos
├─ Id_Equipo (PK)
├─ Codigo_Inventario (INDEX)
├─ Marca_Equipo
├─ Numero_Serie
├─ Ubicacion_Equipo
├─ Propietario_Equipo (FK → tbl_empleado)
├─ Estado_Equipo (ENUM - INDEX)
├─ Fecha_Ad_Equipo (INDEX)
├─ Id_Tipo_Equipo (FK → tbl_tipo_equipo)
└─ Id_Archivo (FK → tbl_archivo)

tbl_empleado
├─ Id_Empleado (PK)
├─ documento_Empleado (UNIQUE - INDEX)
├─ Nombre_Empleado (INDEX)
├─ Apellido_Empleado
├─ Num_Telefono
├─ Correo_Electronico
└─ Id_Cargo (FK → tbl_cargo)

tbl_usuario
├─ Id_Usuario (PK)
├─ documento_Usuario (UNIQUE - INDEX)
├─ Nombre_Usuario (UNIQUE - INDEX)
├─ Password_Usuario
├─ Id_Empleado (FK → tbl_empleado)
└─ Id_Rol (FK → tbl_rol)
```

---

## 🔐 Capa de Seguridad

```
INPUT (Usuario)
    ↓
CONTROLLER (Validación básica)
    │ empty() checks
    │ htmlspecialchars()
    ↓
MODELO (Prepared Statements)
    │ $stmt = prepare(SQL)
    │ $stmt->execute($params)
    │ Sin concatenación de strings
    ↓
BD (Ejecución segura)
    │ Parámetros bindados
    │ Valores escapados automáticamente
    ↓
VISTA (Escaping HTML)
    │ htmlspecialchars() en outputs
    ↓
OUTPUT (HTML Renderizado)
```

---

## 📊 Estructura de Archivos

```
inventario_equipos/
├── model/
│   ├── equipoModel.php
│   │   └── buscar($filtros) ............ [~95 líneas]
│   │       └── Construye 9 WHERE dinámicos
│   ├── empleadoModel.php
│   │   └── buscar($filtros) ............ [~45 líneas]
│   │       └── Construye 5 WHERE dinámicos
│   └── usuarioModel.php
│       └── buscar($filtros) ............ [~60 líneas]
│           └── Construye 5 WHERE dinámicos
│
├── controller/
│   ├── equipoController.php
│   │   ├── GET filtros ................ [~30 líneas]
│   │   └── Lógica CRUD + filtrado
│   ├── empleadoController.php
│   │   ├── GET filtros ................ [~20 líneas]
│   │   └── Lógica CRUD + filtrado
│   └── usuarioAdminController.php
│       ├── GET filtros ................ [~20 líneas]
│       └── Lógica CRUD + filtrado
│
├── view/
│   ├── equipos.php
│   │   ├── Formulario filtrado ........ [~80 líneas]
│   │   ├── 8 campos de entrada
│   │   ├── Tabla resultados
│   │   └── JavaScript toggle
│   ├── empleados.php
│   │   ├── Formulario filtrado ........ [~60 líneas]
│   │   ├── 5 campos de entrada
│   │   └── Tabla resultados
│   └── usuarios.php
│       ├── Formulario filtrado ........ [~60 líneas]
│       ├── 5 campos de entrada
│       └── Tabla resultados
│
└── assets/css/
    ├── Equipos.css
    │   └── .search-filter-container ... [~150 líneas]
    ├── Empleados.css
    │   └── .search-filter-container ... [~150 líneas]
    ├── Usuarios.css
    │   └── .search-filter-container ... [~150 líneas]
    └── FilterStyles.css
        └── Estilos reutilizables ....... [~100 líneas]
```

---

## 🔄 Ciclo de Vida de una Búsqueda

```
TIEMPO 0: Usuario carga página
┌────────────────────────────────┐
│ GET equipoController.php        │
│ ?accion=listar                  │
│ (sin filtrar)                   │
└────────────────────────────────┘
        ↓
        Muestra 100% de equipos
        

TIEMPO 1: Usuario hace clic en "Búsqueda Avanzada"
┌────────────────────────────────┐
│ JavaScript: toggleSearchForm()  │
│ form.style.display = 'grid'     │
└────────────────────────────────┘
        ↓
        Formulario expandido


TIEMPO 2: Usuario completa filtros
┌────────────────────────────────┐
│ form.codigo = "INV"             │
│ form.estado = "Activo"          │
└────────────────────────────────┘
        ↓
        Usuario listo para buscar


TIEMPO 3: Usuario hace clic en "Buscar"
┌────────────────────────────────┐
│ form.submit()                   │
│ GET equipoController.php        │
│ ?accion=listar&filtrar=1&      │
│  codigo=INV&estado=Activo       │
└────────────────────────────────┘
        ↓
        Página se recarga


TIEMPO 4: Servidor procesa búsqueda
┌────────────────────────────────┐
│ Controller verifica GET         │
│ isset($_GET['filtrar']) → true  │
│ $filtros = extraer parámetros   │
│ equipoModel->buscar($filtros)   │
└────────────────────────────────┘
        ↓
        Model construye SQL


TIEMPO 5: SQL Dinámico se construye
┌────────────────────────────────┐
│ $sql = "WHERE 1=1"              │
│ + " AND codigo LIKE ?"          │
│ + " AND estado = ?"             │
│ $parametros = ['INV', 'Activo'] │
│ $stmt->execute($parametros)     │
└────────────────────────────────┘
        ↓
        BD ejecuta query


TIEMPO 6: Resultados se retornan
┌────────────────────────────────┐
│ $resultados = [                 │
│   ['id' => 1, 'codigo'=>'INV-1'],
│   ['id' => 5, 'codigo'=>'INV-5'],
│   ...                           │
│ ]                               │
└────────────────────────────────┘
        ↓
        View renderiza


TIEMPO 7: Página renderizada con resultados
┌────────────────────────────────┐
│ Formulario con valores:         │
│ - codigo: "INV"                 │
│ - estado: "Activo"              │
│                                 │
│ Tabla actualizada:              │
│ - Solo 2 equipos mostrados      │
│ - Otros ocultados               │
│                                 │
│ Botón "Limpiar Filtros" visible │
└────────────────────────────────┘
        ↓
        ✅ Búsqueda Completada


TIEMPO 8: Usuario hace clic en "Limpiar Filtros"
┌────────────────────────────────┐
│ GET equipoController.php        │
│ ?accion=listar                  │
│ (sin filtrar)                   │
└────────────────────────────────┘
        ↓
        ✅ Vuelve a mostrar todos
```

---

## 📈 Complejidad de Algoritmos

```
BÚSQUEDA SIMPLE (por texto)
├─ Campo: nombre LIKE '%Juan%'
├─ Complejidad: O(n)
├─ Con INDEX: O(log n)
└─ Tiempo: <100ms

BÚSQUEDA EXACTA (select)
├─ Campo: estado = 'Activo'
├─ Complejidad: O(1) con index
├─ Tiempo: <50ms
└─ Muy rápido

BÚSQUEDA MÚLTIPLE
├─ AND nombre LIKE ? AND estado = ?
├─ Complejidad: O(n) pero con índices
├─ Tiempo: <150ms
└─ Optimizable con índice compuesto

ORDENAMIENTO
├─ ORDER BY Id DESC
├─ Complejidad: O(n log n)
├─ Con pequeño dataset: O(1)
└─ Tiempo: Negligible
```

---

## 🔗 URLs Completas por Acción

```
LISTAR
/controller/equipoController.php?accion=listar

CREAR
/controller/equipoController.php?accion=crear

EDITAR
/controller/equipoController.php?accion=editar&id=5

BUSCAR SIMPLE
/controller/equipoController.php?accion=listar&filtrar=1&marca=HP

BUSCAR MÚLTIPLE
/controller/equipoController.php?accion=listar&filtrar=1&marca=HP&estado=Activo&ubicacion=Oficina

BUSCAR CON FECHAS
/controller/equipoController.php?accion=listar&filtrar=1&fecha_desde=2025-01-01&fecha_hasta=2025-12-31

LIMPIAR FILTROS
/controller/equipoController.php?accion=listar
```

---

## 📝 Variables Clave por Componente

### Controller
```php
$filtros = []              // Array con filtros GET
$filtros_activos = false   // Boolean si hay filtros
$resultados = []           // Resultados del modelo
```

### View
```php
$filtros                   // Array en template
$filtros_activos           // Boolean para auto-expand
$resultados                // Array para renderizar tabla
```

### JavaScript
```javascript
form.style.display         // Toggle grid/none
btn.textContent             // Toggle ↓/↑
window.DOMContentLoaded     // Auto-expand si hay filtros
```

---

**Diagrama Actualizado: Enero 27, 2026**
**Versión: 1.0 - Final**
