-- =====================================================================
-- PROYECTO: paraGO - Red Inteligente de Paraguas Compartidos
-- UNIVERSIDAD DEL NORTE - DESARROLLO DE EMPRENDEDORES
-- BASE DE DATOS RELACIONAL (ESQUEMA SQL & DATOS INICIALES)
-- =====================================================================

-- 1. TABLA: USUARIOS
CREATE TABLE IF NOT EXISTS usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre VARCHAR(120) NOT NULL,
    matricula_o_telefono VARCHAR(50) NOT NULL UNIQUE,
    correo VARCHAR(150),
    tipo_usuario VARCHAR(30) DEFAULT 'Estudiante', -- 'Estudiante', 'Trabajador', 'Peatón'
    viajes_completados INTEGER DEFAULT 0,
    saldo_cuenta DECIMAL(10,2) DEFAULT 0.00,
    estado VARCHAR(20) DEFAULT 'Activo',           -- 'Activo', 'Suspendido'
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. TABLA: PATROCINADORES (PUBLICIDAD DEDUCIBLE)
CREATE TABLE IF NOT EXISTS patrocinadores (
    id VARCHAR(30) PRIMARY KEY,
    empresa VARCHAR(100) NOT NULL,
    campana VARCHAR(150) NOT NULL,
    porcentaje_deducible DECIMAL(5,2) DEFAULT 100.00,
    paraguas_patrocinados INTEGER DEFAULT 0,
    fecha_convenio DATE
);

-- 3. TABLA: ESTACIONES (TÓTEMS ELECTROMECÁNICOS)
CREATE TABLE IF NOT EXISTS estaciones (
    id VARCHAR(30) PRIMARY KEY,                    -- ej: 'EST-CUAUHTEMOC'
    nombre VARCHAR(120) NOT NULL,
    tipo VARCHAR(30) NOT NULL,                     -- 'Metrorrey L1/L2', 'OXXO FEMSA'
    direccion VARCHAR(200) NOT NULL,
    capacidad_total INTEGER NOT NULL DEFAULT 20,
    paraguas_disponibles INTEGER NOT NULL DEFAULT 0,
    bahias_libres INTEGER NOT NULL DEFAULT 0,
    latitud DECIMAL(10,7),
    longitud DECIMAL(10,7),
    estado_sensor VARCHAR(30) DEFAULT 'En Línea',
    ultima_sincronizacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 4. TABLA: PARAGUAS (INVENTARIO FÍSICO CON SERVITIZACIÓN)
CREATE TABLE IF NOT EXISTS paraguas (
    id VARCHAR(30) PRIMARY KEY,                    -- ej: 'PG-MTY-8421'
    codigo_qr VARCHAR(100) NOT NULL UNIQUE,
    id_airtag VARCHAR(50) NOT NULL UNIQUE,         -- Rastreador físico antirrobo
    estacion_actual_id VARCHAR(30),
    patrocinador_id VARCHAR(30),
    filtro_uv VARCHAR(20) DEFAULT 'UPF 50+',
    usos_totales INTEGER DEFAULT 0,
    estado VARCHAR(30) DEFAULT 'Disponible',       -- 'Disponible', 'En Uso', 'En Mantenimiento'
    fecha_alta DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (estacion_actual_id) REFERENCES estaciones(id),
    FOREIGN KEY (patrocinador_id) REFERENCES patrocinadores(id)
);

-- 5. TABLA: PRESTAMOS (TRANSACCIONES DE MOVILIDAD)
CREATE TABLE IF NOT EXISTS prestamos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario_id INTEGER NOT NULL,
    paraguas_id VARCHAR(30) NOT NULL,
    estacion_origen_id VARCHAR(30) NOT NULL,
    estacion_destino_id VARCHAR(30),
    fecha_inicio DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_fin DATETIME,
    duracion_minutos INTEGER,
    tarifa_cobrada DECIMAL(10,2) DEFAULT 0.00,     -- $0.00 por financiamiento de patrocinadores
    estado VARCHAR(30) DEFAULT 'Activo',           -- 'Activo', 'Completado', 'Excedido'
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (paraguas_id) REFERENCES paraguas(id),
    FOREIGN KEY (estacion_origen_id) REFERENCES estaciones(id),
    FOREIGN KEY (estacion_destino_id) REFERENCES estaciones(id)
);

-- 6. TABLA: REGISTROS_IOT (TELEMETRÍA DE HARDWARE)
CREATE TABLE IF NOT EXISTS registros_iot (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    estacion_id VARCHAR(30) NOT NULL,
    paraguas_id VARCHAR(30),
    componente VARCHAR(50) NOT NULL,               -- 'Servomotor MG995', 'Sensor KY-004', 'AirTag'
    evento VARCHAR(100) NOT NULL,                  -- 'Desbloqueo 90°', 'Inserción detectada'
    angulo_servo INTEGER DEFAULT 0,
    voltaje_medido DECIMAL(4,2) DEFAULT 5.00,
    fecha_evento DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (estacion_id) REFERENCES estaciones(id)
);

-- 7. TABLA: ACCESOS_SISTEMA (AUDITORÍA & CONTROL DE QUIÉNES ACCEDEN)
CREATE TABLE IF NOT EXISTS accesos_sistema (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario_nombre VARCHAR(120) NOT NULL,
    matricula_o_id VARCHAR(50) NOT NULL,
    rol VARCHAR(40) DEFAULT 'Estudiante',          -- 'Estudiante', 'Docente', 'Administrador', 'Operador IoT'
    tipo_acceso VARCHAR(50) NOT NULL,              -- 'Login Web', 'Escaneo QR Estación', 'Consulta BD', 'Admin Panel'
    estacion VARCHAR(60),                          -- Estación física o 'Portal Web'
    ip_origen VARCHAR(45) DEFAULT '189.204.12.85', -- IP pública / local
    dispositivo VARCHAR(150),                      -- Navegador y SO (ej: 'Chrome Mobile / Android')
    fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) DEFAULT 'Autorizado'        -- 'Autorizado', 'Denegado'
);

-- =====================================================================
-- DATOS INICIALES (SEMILLA / PILOTO MONTERREY)
-- =====================================================================

-- Patrocinadores
INSERT INTO patrocinadores (id, empresa, campana, porcentaje_deducible, paraguas_patrocinados, fecha_convenio) VALUES
('PAT-FEMSA', 'Grupo FEMSA / OXXO', 'Protección Peatonal Monterrey Sustentable', 100.00, 100, '2026-01-15'),
('PAT-METRORREY', 'Metrorrey Sistema de Transporte', 'Conectividad Última Milla Climatizada', 100.00, 50, '2026-02-01');

-- Estaciones en Monterrey
INSERT INTO estaciones (id, nombre, tipo, direccion, capacidad_total, paraguas_disponibles, bahias_libres, latitud, longitud, estado_sensor) VALUES
('EST-CUAUHTEMOC', 'Metrorrey Cuauhtémoc', 'Metrorrey L1/L2', 'Av. Colón y Av. Cuauhtémoc, Centro', 20, 16, 4, 25.6865, -100.3168, 'En Línea'),
('EST-PADRE-MIER', 'Metrorrey Padre Mier', 'Metrorrey L2', 'Av. Juárez y Padre Mier, Centro Comercial', 20, 12, 8, 25.6698, -100.3142, 'En Línea'),
('EST-ZARAGOZA', 'Metrorrey Zaragoza', 'Metrorrey L2', 'Macroplaza y Palacio Municipal de Monterrey', 20, 18, 2, 25.6672, -100.3097, 'En Línea'),
('EST-FELIX-U-GOMEZ', 'Metrorrey Félix U. Gómez', 'Metrorrey L1/L3', 'Av. Colón y Félix U. Gómez, Clínica 33 IMSS', 20, 14, 6, 25.6841, -100.2974, 'En Línea'),
('EST-OXXO-MORELOS', 'OXXO Paseo Morelos', 'OXXO FEMSA', 'Corredor Peatonal Morelos No. 415', 12, 8, 4, 25.6685, -100.3135, 'En Línea'),
('EST-OXXO-MACROPLAZA', 'OXXO Macroplaza', 'OXXO FEMSA', 'Zaragoza esq. Washington', 16, 10, 6, 25.6740, -100.3101, 'En Línea');

-- Usuarios Iniciales (Equipo de Proyecto y Evaluadores)
INSERT INTO usuarios (nombre, matricula_o_telefono, correo, tipo_usuario, viajes_completados) VALUES
('Hector Andrés Uribe Garcia', '45979', 'hector.uribe@un.edu.mx', 'Estudiante - Informática', 3),
('Lorena Paola De Hoyos Garcia', '45868', 'lorena.dehoyos@un.edu.mx', 'Estudiante - Adm. Empresas', 2),
('Ian David Villegas Reyna', '45726', 'ian.villegas@un.edu.mx', 'Estudiante - Contabilidad', 1),
('Emilio Alexander Luna Acosta', '45765', 'emilio.luna@un.edu.mx', 'Estudiante - Contabilidad', 2),
('Eliezer Gabriel Ramirez Salazar', '45806', 'eliezer.ramirez@un.edu.mx', 'Estudiante - Contabilidad', 1),
('Salomón Rosales Flores', '45769', 'salomon.rosales@un.edu.mx', 'Estudiante - Banca y Finanzas', 1),
('Lic. Janet Gissel Tenorio Cuevas', 'DOCENTE-UN', 'janet.tenorio@un.edu.mx', 'Docente Evaluador', 5);

-- Inventario de Paraguas de Demostración
INSERT INTO paraguas (id, codigo_qr, id_airtag, estacion_actual_id, patrocinador_id, usos_totales, estado) VALUES
('PG-MTY-8421', 'QR-PG-8421-MTY', 'ATAG-MTY-001', 'EST-CUAUHTEMOC', 'PAT-FEMSA', 14, 'Disponible'),
('PG-MTY-8422', 'QR-PG-8422-MTY', 'ATAG-MTY-002', 'EST-CUAUHTEMOC', 'PAT-FEMSA', 9, 'Disponible'),
('PG-MTY-8423', 'QR-PG-8423-MTY', 'ATAG-MTY-003', 'EST-PADRE-MIER', 'PAT-FEMSA', 18, 'Disponible'),
('PG-MTY-8424', 'QR-PG-8424-MTY', 'ATAG-MTY-004', 'EST-ZARAGOZA', 'PAT-METRORREY', 22, 'Disponible'),
('PG-MTY-8425', 'QR-PG-8425-MTY', 'ATAG-MTY-005', 'EST-OXXO-MORELOS', 'PAT-FEMSA', 7, 'Disponible');

-- Préstamos de Ejemplo Registrados
INSERT INTO prestamos (usuario_id, paraguas_id, estacion_origen_id, estacion_destino_id, fecha_inicio, fecha_fin, duracion_minutos, tarifa_cobrada, estado) VALUES
(1, 'PG-MTY-8421', 'EST-CUAUHTEMOC', 'EST-PADRE-MIER', datetime('now', '-3 hours'), datetime('now', '-2 hours', '-45 minutes'), 15, 0.00, 'Completado'),
(2, 'PG-MTY-8423', 'EST-PADRE-MIER', 'EST-ZARAGOZA', datetime('now', '-2 hours'), datetime('now', '-1 hours', '-40 minutes'), 20, 0.00, 'Completado'),
(7, 'PG-MTY-8424', 'EST-ZARAGOZA', 'EST-OXXO-MORELOS', datetime('now', '-45 minutes'), datetime('now', '-33 minutes'), 12, 0.00, 'Completado');

-- Registros de Telemetría IoT
INSERT INTO registros_iot (estacion_id, paraguas_id, componente, evento, angulo_servo, voltaje_medido) VALUES
('EST-CUAUHTEMOC', 'PG-MTY-8421', 'Servomotor MG995', 'Apertura de garra 3D para entrega', 90, 5.02),
('EST-PADRE-MIER', 'PG-MTY-8421', 'Sensor KY-004', 'Paraguas detectado en bahía de retorno', 0, 4.98),
('EST-ZARAGOZA', 'PG-MTY-8424', 'Servomotor MG995', 'Bloqueo electromecánico activado', 0, 5.01);

-- Bitácora de Accesos de Usuarios al Sistema (Quiénes acceden)
INSERT INTO accesos_sistema (usuario_nombre, matricula_o_id, rol, tipo_acceso, estacion, ip_origen, dispositivo) VALUES
('Hector Andrés Uribe Garcia', '45979', 'Estudiante - Informática', 'Login Web & QR', 'Metrorrey Cuauhtémoc', '189.204.14.22', 'Chrome Windows / PC'),
('Lorena Paola De Hoyos Garcia', '45868', 'Estudiante - Adm. Empresas', 'Escaneo QR Estación', 'Metrorrey Padre Mier', '187.190.45.10', 'Safari iOS / iPhone 14'),
('Lic. Janet Gissel Tenorio Cuevas', 'DOCENTE-UN', 'Docente Evaluador', 'Admin Panel & Evaluacion', 'Portal Web Oficial', '189.204.12.85', 'Chrome macOS / MacBook'),
('Ian David Villegas Reyna', '45726', 'Estudiante - Contabilidad', 'Consulta de Saldo', 'OXXO Paseo Morelos', '201.144.33.60', 'Chrome Android / Samsung S23');

-- =====================================================================
-- VISTAS ANALÍTICAS ÚTILES
-- =====================================================================

-- Vista de préstamos con nombres legibles
CREATE VIEW IF NOT EXISTS vista_prestamos_detallados AS
SELECT 
    p.id AS prestamo_id,
    u.nombre AS usuario_nombre,
    u.matricula_o_telefono,
    p.paraguas_id,
    eo.nombre AS estacion_origen,
    ed.nombre AS estacion_destino,
    p.fecha_inicio,
    p.fecha_fin,
    p.duracion_minutos,
    p.estado
FROM prestamos p
JOIN usuarios u ON p.usuario_id = u.id
JOIN estaciones eo ON p.estacion_origen_id = eo.id
LEFT JOIN estaciones ed ON p.estacion_destino_id = ed.id;

-- Vista de inventario por estación
CREATE VIEW IF NOT EXISTS vista_resumen_estaciones AS
SELECT 
    e.nombre AS estacion,
    e.tipo,
    e.capacidad_total,
    e.paraguas_disponibles,
    e.bahias_libres,
    e.estado_sensor,
    ROUND((CAST(e.paraguas_disponibles AS FLOAT) / e.capacidad_total) * 100, 1) AS porcentaje_ocupacion
FROM estaciones e;
