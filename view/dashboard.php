<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard Inventario - Gradezco</title>
  <?php
    // Usar el CSS estilizado para PQRS
    $cssPath = $_SERVER['DOCUMENT_ROOT'] . '/inventario_equipos/assets/css/a.css';
    $cssUrl = '/inventario_equipos/assets/css/a.css';
    if (file_exists($cssPath)) {
        echo '<link rel="stylesheet" href="' . $cssUrl . '">';
    } else {
        echo ' CSS File not found at: ' . $cssPath . '';
    }
    ?>
</head>

<body>
  <header>
    <div class="header-container">
      <div class="logo-section">
        <div class="logo-icon">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2">
            <rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect>
            <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path>
          </svg>
        </div>
        <div class="logo-info">
          <h1>Gradezco</h1>
          <p>Sistema de Inventario de Equipos</p>
        </div>
        <div class="search-container">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="11" cy="11" r="8"></circle>
            <path d="m21 21-4.35-4.35"></path>
          </svg>
          <input type="text" placeholder="Buscar equipo, código...">
        </div>
      </div>
      <nav class="nav-tabs">
        <button class="nav-tab active">Dashboard</button>
        <button class="nav-tab">Equipos</button>
        <button class="nav-tab">Mantenimiento</button>
        <button class="nav-tab">Reportes</button>
      </nav>
    </div>
  </header>

  <main>
    <!-- Stats Grid -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-header">
          <div class="stat-info">
            <h3>Equipos Totales</h3>
            <p>Inventario</p>
          </div>
          <div class="stat-icon green">📦</div>
        </div>
        <div class="stat-value">
          <h2>847</h2>
          <span class="stat-badge positive">+12%</span>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-header">
          <div class="stat-info">
            <h3>Equipos Activos</h3>
            <p>En operación</p>
          </div>
          <div class="stat-icon green">📊</div>
        </div>
        <div class="stat-value">
          <h2>723</h2>
          <span class="stat-badge positive">+5%</span>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-header">
          <div class="stat-info">
            <h3>En Mantenimiento</h3>
            <p>Requiere atención</p>
          </div>
          <div class="stat-icon amber">⚠️</div>
        </div>
        <div class="stat-value">
          <h2>34</h2>
          <span class="stat-badge negative">+8</span>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-header">
          <div class="stat-info">
            <h3>Personal</h3>
            <p>Empleados activos</p>
          </div>
          <div class="stat-icon green">👥</div>
        </div>
        <div class="stat-value">
          <h2>142</h2>
          <span class="stat-badge positive">+3</span>
        </div>
      </div>
    </div>

    <!-- Main Grid -->
    <div class="main-grid">
      <div class="feature-card">
        <div class="feature-header">
          <div class="feature-icon">📈</div>
          <div class="feature-title">
            <h2>Control total de equipos</h2>
            <p>Gestión centralizada</p>
          </div>
        </div>
        <p class="feature-description">
          Registra, monitorea y mantén - todo en tiempo real.
        </p>
        <div class="feature-stats">
          <div class="feature-stat">
            <h3>847</h3>
            <p>Equipos registrados</p>
          </div>
          <div class="feature-stat">
            <h3>34</h3>
            <p>Mantenimientos activos</p>
          </div>
          <div class="feature-stat">
            <h3>15</h3>
            <p>Ubicaciones</p>
          </div>
        </div>
        <div class="feature-buttons">
          <button class="btn btn-primary">Nuevo Equipo</button>
          <button class="btn btn-secondary">Ver Reportes</button>
        </div>
      </div>

      <div class="maintenance-card">
        <div class="card-header">
          <div>
            <h3>Mantenimientos</h3>
            <p>Última semana</p>
          </div>
          <span class="card-icon">🔧</span>
        </div>
        <div class="maintenance-list">
          <div class="maintenance-item">
            <span class="status-dot warning"></span>
            <div class="maintenance-info">
              <h4>Laptop HP ProBook 450</h4>
              <p>LAP-2024-001 • Hace 2 días</p>
            </div>
            <span class="maintenance-status process">En proceso</span>
          </div>
          <div class="maintenance-item">
            <span class="status-dot success"></span>
            <div class="maintenance-info">
              <h4>Monitor Dell 24"</h4>
              <p>MON-2024-045 • Hace 3 días</p>
            </div>
            <span class="maintenance-status completed">Completado</span>
          </div>
          <div class="maintenance-item">
            <span class="status-dot info"></span>
            <div class="maintenance-info">
              <h4>Impresora Canon MF445</h4>
              <p>IMP-2024-012 • Hace 5 días</p>
            </div>
            <span class="maintenance-status scheduled">Programado</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Bottom Grid -->
    <div class="bottom-grid">
      <div class="chart-card">
        <div class="card-header">
          <div>
            <h3>Estado de Equipos</h3>
            <p>Distribución actual</p>
          </div>
          <span class="card-icon">📊</span>
        </div>
        <div class="status-list">
          <div class="status-item">
            <h4>Activo <span>723</span></h4>
            <div class="progress-bar">
              <div class="progress-fill green" style="width: 85%"></div>
            </div>
          </div>
          <div class="status-item">
            <h4>Mantenimiento <span>34</span></h4>
            <div class="progress-bar">
              <div class="progress-fill amber" style="width: 4%"></div>
            </div>
          </div>
          <div class="status-item">
            <h4>Inactivo <span>67</span></h4>
            <div class="progress-bar">
              <div class="progress-fill gray" style="width: 8%"></div>
            </div>
          </div>
          <div class="status-item">
            <h4>Dado de Baja <span>23</span></h4>
            <div class="progress-bar">
              <div class="progress-fill red" style="width: 3%"></div>
            </div>
          </div>
        </div>
      </div>

      <div class="chart-card">
        <div class="card-header">
          <div>
            <h3>Tipos de Equipos</h3>
            <p>Categorías principales</p>
          </div>
          <span class="card-icon">🖥️</span>
        </div>
        <div class="type-list">
          <div class="type-item">
            <div class="type-info">
              <div class="type-badge">38%</div>
              <div class="type-details">
                <h4>Computadores</h4>
                <p>324 equipos</p>
              </div>
            </div>
            <span class="type-trend">📈</span>
          </div>
          <div class="type-item">
            <div class="type-info">
              <div class="type-badge">34%</div>
              <div class="type-details">
                <h4>Monitores</h4>
                <p>289 equipos</p>
              </div>
            </div>
            <span class="type-trend">📈</span>
          </div>
          <div class="type-item">
            <div class="type-info">
              <div class="type-badge">17%</div>
              <div class="type-details">
                <h4>Impresoras</h4>
                <p>145 equipos</p>
              </div>
            </div>
            <span class="type-trend">📈</span>
          </div>
          <div class="type-item">
            <div class="type-info">
              <div class="type-badge">11%</div>
              <div class="type-details">
                <h4>Periféricos</h4>
                <p>89 equipos</p>
              </div>
            </div>
            <span class="type-trend">📈</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Locations -->
    <div class="locations-card">
      <div class="card-header">
        <div>
          <h3>Ubicaciones Principales</h3>
          <p>Mayor concentración de equipos</p>
        </div>
        <span class="card-icon">📍</span>
      </div>
      <div class="locations-grid">
        <div class="location-item">
          <div class="location-header">
            <span>📍</span>
            <span class="location-rank">#1</span>
          </div>
          <p class="location-name">Edificio A - Piso 3</p>
          <h3 class="location-count">156</h3>
          <p class="location-label">equipos registrados</p>
        </div>
        <div class="location-item">
          <div class="location-header">
            <span>📍</span>
            <span class="location-rank">#2</span>
          </div>
          <p class="location-name">Edificio B - Piso 2</p>
          <h3