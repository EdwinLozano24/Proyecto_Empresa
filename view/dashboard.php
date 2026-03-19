<?php
    // Proteger la página - requiere autenticación
    require_once __DIR__ . '/../app/protecciones.php';
    protegerPagina();
    
    // Obtener datos del usuario actual
    $usuario = UsuarioController::obtenerUsuarioActual();
    
    // Variables para el header
    $pageTitle = 'Dashboard Inventario';
    $activeTab = 'Dashboard';
    $cssUrl = '/inventario_equipos/assets/css/Dashboard.css';
    
    // Incluir el header común
    require_once 'header.php';
    
    // Contar empleados reales desde la base de datos
    $empleados_count = 0;
    $equipos_total = 0;
    $equipos_activos = 0;
    $equipos_inactivos = 0;
    $equipos_mantenimiento = 0;
    $equipos_dado_baja = 0;
    $ubicaciones_count = 0;

    try {
      $pdo = conectar();

      $stmt = $pdo->query("SELECT COUNT(*) AS total FROM tbl_empleado");
      $row = $stmt->fetch();
      $empleados_count = $row ? (int)$row['total'] : 0;

      require_once __DIR__ . '/../model/equipoModel.php';
      $equipoModel = new EquipoModel($pdo);
      $equipos_total = $equipoModel->contarTotal();
      $equipos_activos = $equipoModel->contarPorEstado('Activo');
      $equipos_inactivos = $equipoModel->contarPorEstado('Inactivo');
      $equipos_mantenimiento = $equipoModel->contarPorEstado('Mantenimiento');
      $equipos_dado_baja = $equipoModel->contarPorEstado('Dado de Baja');

      // Obtener últimos equipos en mantenimiento
      $ultimos_mantenimiento = $equipoModel->obtenerUltimosEnMantenimiento(3);

      $stmt = $pdo->query("SELECT COUNT(DISTINCT Ubicacion_Equipo) AS total FROM tbl_equipos WHERE Ubicacion_Equipo IS NOT NULL AND Ubicacion_Equipo <> ''");
      $row = $stmt->fetch();
      $ubicaciones_count = $row ? (int)$row['total'] : 0;

      // Tipos de equipo (top 4) + porcentaje
      $tipos_equipos = [];
      $stmt = $pdo->query("SELECT te.Nombre_Tipo_Equipo AS tipo, COUNT(e.Id_Equipo) AS total
                           FROM tbl_tipo_equipo te
                           LEFT JOIN tbl_equipos e ON te.Id_Tipo_Equipo = e.Id_Tipo_Equipo
                           GROUP BY te.Id_Tipo_Equipo
                           ORDER BY total DESC
                           LIMIT 4");
      $tipos_equipos = $stmt->fetchAll(PDO::FETCH_ASSOC);

      foreach ($tipos_equipos as &$tipo) {
        $tipo['porcentaje'] = $equipos_total ? round(($tipo['total'] / $equipos_total) * 100) : 0;
      }
      unset($tipo);

      // Ubicaciones principales (top 2)
      $top_ubicaciones = [];
      $stmt = $pdo->query("SELECT Ubicacion_Equipo AS ubicacion, COUNT(*) AS total
                           FROM tbl_equipos
                           WHERE Ubicacion_Equipo IS NOT NULL AND Ubicacion_Equipo <> ''
                           GROUP BY Ubicacion_Equipo
                           ORDER BY total DESC
                           LIMIT 2");
      $top_ubicaciones = $stmt->fetchAll(PDO::FETCH_ASSOC);

      $porcentaje_activo = $equipos_total ? round(($equipos_activos / $equipos_total) * 100) : 0;
      $porcentaje_mantenimiento = $equipos_total ? round(($equipos_mantenimiento / $equipos_total) * 100) : 0;
      $porcentaje_inactivo = $equipos_total ? round(($equipos_inactivos / $equipos_total) * 100) : 0;
      $porcentaje_dado_baja = $equipos_total ? round(($equipos_dado_baja / $equipos_total) * 100) : 0;

    } catch (PDOException $e) {
      // Si falla la conexión, se usan valores por defecto (0)
    }
    ?>

  <main>


  </header>  <main>
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
          <h2><?php echo htmlspecialchars($equipos_total); ?></h2>
          <span class="stat-badge positive"></span>
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
          <h2><?php echo htmlspecialchars($equipos_activos); ?></h2>
          <span class="stat-badge positive"><?php echo $equipos_total ? '+' . $porcentaje_activo . '%' : ''; ?></span>
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
          <h2><?php echo htmlspecialchars($equipos_mantenimiento); ?></h2>
          <span class="stat-badge negative"><?php echo $equipos_total ? '+' . $porcentaje_mantenimiento . '%' : ''; ?></span>
        </div>
      </div>

      <a href="/inventario_equipos/controller/empleadoController.php?accion=listar" style="text-decoration: none; color: inherit; cursor: pointer;">
        <div class="stat-card" style="cursor: pointer; transition: transform 0.2s, box-shadow 0.2s;" onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 8px 16px rgba(0,0,0,0.15)';" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 2px 8px rgba(0,0,0,0.1)';">
          <div class="stat-header">
            <div class="stat-info">
              <h3>Personal</h3>
              <p>Empleados activos</p>
            </div>
            <div class="stat-icon green">👥</div>
          </div>
          <div class="stat-value">
            <h2><?php echo htmlspecialchars($empleados_count); ?></h2>
            <span class="stat-badge positive">+3</span>
          </div>
        </div>
      </a>
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
            <h3><?php echo htmlspecialchars($equipos_total); ?></h3>
            <p>Equipos registrados</p>
          </div>
          <div class="feature-stat">
            <h3><?php echo htmlspecialchars($equipos_mantenimiento); ?></h3>
            <p>Mantenimientos activos</p>
          </div>
          <div class="feature-stat">
            <h3><?php echo htmlspecialchars($ubicaciones_count); ?></h3>
            <p>Ubicaciones</p>
          </div>
        </div>
        <div class="feature-buttons">
          <a href="/inventario_equipos/view/equipoForm.php" class="btn btn-primary" style="text-decoration: none;">Nuevo Equipo</a>
          <a href="/inventario_equipos/controller/historialController.php?accion=listar" class="btn btn-secondary" style="text-decoration: none;">Ver Reportes</a>
          <a href="/inventario_equipos/controller/usuarioAdminController.php?accion=listar" class="btn btn-outline" style="margin-left:8px; text-decoration:none; display:inline-block; padding:8px 12px; border-radius:4px; border:1px solid #ccc; color:inherit;">Usuarios</a>
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
          <?php if (!empty($ultimos_mantenimiento)): ?>
            <?php foreach ($ultimos_mantenimiento as $equipo): ?>
              <div class="maintenance-item">
                <span class="status-dot warning"></span>
                <div class="maintenance-info">
                  <h4><?php echo htmlspecialchars($equipo['Marca_Equipo']); ?></h4>
                  <p><?php echo htmlspecialchars($equipo['Numero_Serie']); ?> • <?php 
                    $fecha = new DateTime($equipo['Fecha_Ad_Equipo']);
                    $ahora = new DateTime();
                    $diferencia = $ahora->diff($fecha);
                    if ($diferencia->days == 0) {
                      echo 'Hoy';
                    } elseif ($diferencia->days == 1) {
                      echo 'Hace 1 día';
                    } else {
                      echo 'Hace ' . $diferencia->days . ' días';
                    }
                  ?></p>
                </div>
                <span class="maintenance-status process">En proceso</span>
              </div>
            <?php endforeach; ?>
          <?php else: ?>
            <div class="maintenance-item">
              <div class="maintenance-info">
                <h4>No hay equipos en mantenimiento</h4>
                <p>Todos los equipos están operativos</p>
              </div>
            </div>
          <?php endif; ?>
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
            <h4>Activo <span><?php echo htmlspecialchars($equipos_activos); ?></span></h4>
            <div class="progress-bar">
              <div class="progress-fill green" style="width: <?php echo htmlspecialchars($porcentaje_activo); ?>%"></div>
            </div>
          </div>
          <div class="status-item">
            <h4>Mantenimiento <span><?php echo htmlspecialchars($equipos_mantenimiento); ?></span></h4>
            <div class="progress-bar">
              <div class="progress-fill amber" style="width: <?php echo htmlspecialchars($porcentaje_mantenimiento); ?>%"></div>
            </div>
          </div>
          <div class="status-item">
            <h4>Inactivo <span><?php echo htmlspecialchars($equipos_inactivos); ?></span></h4>
            <div class="progress-bar">
              <div class="progress-fill gray" style="width: <?php echo htmlspecialchars($porcentaje_inactivo); ?>%"></div>
            </div>
          </div>
          <div class="status-item">
            <h4>Dado de Baja <span><?php echo htmlspecialchars($equipos_dado_baja); ?></span></h4>
            <div class="progress-bar">
              <div class="progress-fill red" style="width: <?php echo htmlspecialchars($porcentaje_dado_baja); ?>%"></div>
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
          <?php if (!empty($tipos_equipos)): ?>
            <?php foreach ($tipos_equipos as $tipo): ?>
              <div class="type-item">
                <div class="type-info">
                  <div class="type-badge"><?php echo htmlspecialchars($tipo['porcentaje']); ?>%</div>
                  <div class="type-details">
                    <h4><?php echo htmlspecialchars($tipo['tipo']); ?></h4>
                    <p><?php echo htmlspecialchars($tipo['total']); ?> equipos</p>
                  </div>
                </div>
                <span class="type-trend">📈</span>
              </div>
            <?php endforeach; ?>
          <?php else: ?>
            <div class="type-item">
              <div class="type-info">
                <div class="type-badge">0%</div>
                <div class="type-details">
                  <h4>No hay tipos</h4>
                  <p>Sin datos</p>
                </div>
              </div>
            </div>
          <?php endif; ?>
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
        <?php if (!empty($top_ubicaciones)): ?>
          <?php foreach ($top_ubicaciones as $index => $loc): ?>
            <div class="location-item">
              <div class="location-header">
                <span>📍</span>
                <span class="location-rank">#<?php echo $index + 1; ?></span>
              </div>
              <p class="location-name"><?php echo htmlspecialchars($loc['ubicacion']); ?></p>
              <h3 class="location-count"><?php echo htmlspecialchars($loc['total']); ?></h3>
              <p class="location-label">equipos registrados</p>
            </div>
          <?php endforeach; ?>
        <?php else: ?>
          <div class="location-item">
            <div class="location-header">
              <span>📍</span>
              <span class="location-rank">#1</span>
            </div>
            <p class="location-name">Sin ubicaciones</p>
            <h3 class="location-count">0</h3>
            <p class="location-label">equipos registrados</p>
          </div>
        <?php endif; ?>
      </div>
    </section>
  </main>

  <!-- Script para prevenir caché y manejar botón atrás -->
  <script>
    // Impedir el caché del navegador
    history.pushState(null, null, location.href);
    window.onpopstate = function() {
      history.pushState(null, null, location.href);
      // Redirigir a login cuando se intenta ir atrás
      window.location.href = '/inventario_equipos/view/loginRegister.php';
    };

    // Prevenir recarga con caché
    if (performance.navigation.type === 2) {
      location.reload(true);
    }
  </script>
</body>
</html>
