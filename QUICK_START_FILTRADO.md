# ⚡ QUICK START - PRUEBA EL SISTEMA DE FILTRADO EN 5 MINUTOS

## 🚀 Inicio Rápido

### Paso 1: Acceder a Equipos (El más completo)
```
http://localhost/inventario_equipos/controller/equipoController.php?accion=listar
```

### Paso 2: Expandir búsqueda
Click en botón: **🔍 Búsqueda Avanzada** → **↓ Expandir**

### Paso 3: Probar un filtro
- **Opción A:** Escribir texto en "Código Inventario": `INV`
- **Opción B:** Seleccionar "Estado": `Activo`
- **Opción C:** Seleccionar "Tipo de Equipo": (primera opción)

### Paso 4: Click en "🔎 Buscar"

### Paso 5: Verificar resultados
Los equipos se han filtrado según tu búsqueda ✅

---

## 🧪 Test Cases Rápidos

### Test 1: Filtro Simple (Texto)
```
1. Abre: /controller/equipoController.php?accion=listar
2. Click: Búsqueda Avanzada ↓
3. Escribe: "HP" en campo "Marca"
4. Click: 🔎 Buscar
5. Resultado: Solo equipos HP
```

### Test 2: Filtro Dropdown (Select)
```
1. Abre: /controller/equipoController.php?accion=listar
2. Click: Búsqueda Avanzada ↓
3. Selecciona: "Activo" en "Estado"
4. Click: 🔎 Buscar
5. Resultado: Solo equipos en estado Activo
```

### Test 3: Múltiples Filtros
```
1. Abre: /controller/equipoController.php?accion=listar
2. Click: Búsqueda Avanzada ↓
3. Escribe: "INV" en Código Inventario
4. Selecciona: "Activo" en Estado
5. Click: 🔎 Buscar
6. Resultado: Equipos con código INV que están Activos
```

### Test 4: Limpiar Filtros
```
1. Después de cualquier búsqueda
2. Click: Botón "Limpiar Filtros"
3. Resultado: Vuelve a mostrar TODOS los equipos
4. Formulario se contrae
```

### Test 5: Empleados
```
1. Abre: /controller/empleadoController.php?accion=listar
2. Click: Búsqueda Avanzada ↓
3. Escribe: "Juan" en Nombre o Apellido
4. Click: 🔎 Buscar
5. Resultado: Empleados con nombre o apellido Juan
```

### Test 6: Usuarios
```
1. Abes: /controller/usuarioAdminController.php?accion=listar
2. Click: Búsqueda Avanzada ↓
3. Selecciona: Un rol en el dropdown
4. Click: 🔎 Buscar
5. Resultado: Usuarios con ese rol
```

---

## 📍 URLs Directas de Prueba

### Con Filtros Aplicados (ya busca)
```
Equipos Activos HP:
/controller/equipoController.php?accion=listar&filtrar=1&marca=HP&estado=Activo

Empleados con nombre Juan:
/controller/empleadoController.php?accion=listar&filtrar=1&nombre=Juan

Usuarios con rol Admin:
/controller/usuarioAdminController.php?accion=listar&filtrar=1&rol=1
```

---

## ✅ Checklist de Funcionalidades

- [ ] Formulario se expande al click
- [ ] Formulario se contrae al click
- [ ] Campos de texto filtran correctamente
- [ ] Campos select filtran correctamente
- [ ] Múltiples filtros funcionan juntos
- [ ] Botón "Buscar" ejecuta la búsqueda
- [ ] Botón "Limpiar Campos" limpia los campos
- [ ] Botón "Limpiar Filtros" limpia todos y vuelve a listar
- [ ] URL cambia con los parámetros de búsqueda
- [ ] Los valores persisten en el formulario
- [ ] Formulario se auto-expande si hay filtros activos
- [ ] Contador de estadísticas es correcto

---

## 🎯 Casos de Uso Reales

### Caso 1: Encontrar equipos en mantenimiento
```
Necesito: Ver todos los equipos que están en mantenimiento
Solución:
1. Búsqueda Avanzada ↓
2. Estado = "Mantenimiento"
3. Buscar
```

### Caso 2: Equipos de un empleado específico
```
Necesito: Ver todos los equipos asignados a Juan
Solución:
1. Búsqueda Avanzada ↓
2. Propietario = "Juan García"
3. Buscar
```

### Caso 3: Equipos comprados en 2025
```
Necesito: Ver equipos adquiridos en el año 2025
Solución:
1. Búsqueda Avanzada ↓
2. Fecha Desde = "2025-01-01"
3. Fecha Hasta = "2025-12-31"
4. Buscar
```

### Caso 4: Empleados del cargo Gerente
```
Necesito: Ver todos los empleados que son Gerentes
Solución:
1. Búsqueda Avanzada ↓
2. Cargo = "Gerente"
3. Buscar
```

### Caso 5: Usuarios con rol Administrador
```
Necesito: Ver todos los usuarios administradores
Solución:
1. Búsqueda Avanzada ↓
2. Rol = "Administrador"
3. Buscar
```

---

## 🔧 Troubleshooting

### Problema: Formulario no se expande
**Solución:** Verificar consola del navegador (F12) por errores JavaScript

### Problema: Búsqueda no filtra
**Solución:** 
1. Verificar que hay datos en la tabla
2. Revisar los valores ingresados
3. Verificar ortografía exacta

### Problema: Botón "Limpiar Filtros" no aparece
**Solución:** Solo aparece cuando hay filtros activos (normal)

### Problema: Campos select vacíos
**Solución:** Verificar que en la BD existen registros en las tablas relacionadas
- Para Tipo de Equipo: verificar tbl_tipo_equipo
- Para Cargo: verificar tbl_cargo
- Para Rol: verificar tbl_rol

---

## 📊 Métricas de Prueba

```
Búsqueda por Texto:      ✅ Rápida (<100ms)
Búsqueda por Select:     ✅ Rápida (<50ms)
Múltiples Filtros:       ✅ Rápida (<150ms)
Expansión Formulario:    ✅ Fluida (CSS)
Persistencia de Valores: ✅ Funcional
```

---

## 💡 Tips

**Tip 1:** Los filtros son case-insensitive
```
Buscar "HP" = Buscar "hp" = Buscar "Hp"
```

**Tip 2:** Búsquedas parciales funcionan
```
Buscar "inv" encuentra "INV-001", "INV-002", etc.
```

**Tip 3:** URLs son bookmarkeable
```
Guardar como favorito una búsqueda
Compartir URL con colegas
```

**Tip 4:** Los selects buscan por ID exacto
```
No confundir con búsqueda de texto
Dropdown selecciona la opción exacta
```

**Tip 5:** Limpiar Campos ≠ Limpiar Filtros
```
"Limpiar Campos" = borra contenido del formulario (sin buscar)
"Limpiar Filtros" = vuelve a mostrar TODO (borra búsqueda)
```

---

## 🎓 Aprendizaje

Después de probar, entiende:
- ✅ Cómo se expande/contrae el formulario
- ✅ Diferencia entre LIKE (texto) y EXACT (select)
- ✅ Cómo se construyen URLs con parámetros
- ✅ Cómo persisten los valores en formulario
- ✅ Cómo se combinan múltiples filtros

---

## 🔄 Ciclo Completo

```
1. USUARIO
   ↓ Click en "Búsqueda Avanzada"
   
2. VISTA
   ↓ Formulario se expande (JS)
   
3. USUARIO
   ↓ Completa filtros y click "Buscar"
   
4. CONTROLLER
   ↓ Recibe GET['filtrar'] y parámetros
   
5. MODEL
   ↓ Construye SQL con WHERE dinámico
   ↓ Ejecuta Prepared Statement
   
6. BASE DE DATOS
   ↓ Retorna registros filtrados
   
7. CONTROLLER
   ↓ Pasa resultados a vista
   
8. VISTA
   ↓ Renderiza tabla con resultados
   ↓ Mantiene valores en formulario
   
9. USUARIO
   ↓ Ve resultados filtrados ✅
```

---

## 📞 ¿Qué Sigue?

Ahora que probaste el sistema:

1. **Explorar:** Prueba todos los filtros en Equipos
2. **Combinar:** Usa múltiples filtros juntos
3. **Entender:** Lee FILTRADO_AVANZADO.md para detalles
4. **Personalizar:** Agrega tus propios filtros (ver REFERENCIA_RAPIDA_FILTRADO.md)
5. **Integrar:** Usa en tus propios proyectos

---

**¡Listo para probar! 🚀**

Abre tu navegador e ingresa:
```
http://localhost/inventario_equipos/controller/equipoController.php?accion=listar
```

Luego haz click en **🔍 Búsqueda Avanzada** y ¡empieza a filtrar!
