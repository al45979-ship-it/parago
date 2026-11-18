# paraGO - Red Inteligente de Paraguas Compartidos (Monterrey, N.L.)

Sitio web oficial, simulador IoT y sistema de base de datos del proyecto **paraGO**, desarrollado para la materia de **Desarrollo de Emprendedores** en la **Universidad del Norte**.

---

## 📌 Datos del Proyecto y Equipo

- **Institución:** Universidad del Norte (Monterrey, N.L.)
- **Materia:** Desarrollo de Emprendedores
- **Docente:** Lic. Janet Gissel Tenorio Cuevas
- **Video Demostrativo:** [Ver en YouTube](https://youtu.be/JQP96qcPLdE)

### Integrantes:
1. **Ian David Villegas Reyna** - Contabilidad (Matrícula: 45726)
2. **Lorena Paola De Hoyos Garcia** - Adm. de Empresas (Matrícula: 45868)
3. **Emilio Alexander Luna Acosta** - Contabilidad (Matrícula: 45765)
4. **Eliezer Gabriel Ramirez Salazar** - Contabilidad (Matrícula: 45806)
5. **Salomón Rosales Flores** - Banca y Finanzas (Matrícula: 45769)
6. **Hector Andrés Uribe Garcia** - Informática (Matrícula: 45979)

---

## 🗄️ Base de Datos Relacional (Nueva Funcionalidad)

El repositorio incluye la especificación e implementación completa de la base de datos en la carpeta [`/database`](database/):
- **[`database/schema.sql`](database/schema.sql):** Esquema DDL y DML estándar compatible con **PostgreSQL, SQLite, MySQL y Supabase**.
  - Tablas: `usuarios`, `estaciones`, `paraguas`, `prestamos`, `registros_iot` y `patrocinadores`.
  - Vistas analíticas: `vista_prestamos_detallados` y `vista_resumen_estaciones`.
  - Datos semilla de estaciones de Metrorrey (Cuauhtémoc, Padre Mier, Zaragoza, Félix U. Gómez) y OXXO FEMSA.
- **[`database/init_db.py`](database/init_db.py):** Script en Python para inicializar la base de datos local SQLite (`parago.db`).
- **Visor de Base de Datos en Vivo en la Web:** En `index.html`, la sección **"Base de Datos en Tiempo Real (Live DB)"** almacena de forma reactiva cada préstamo generado desde el simulador QR, actualizando en tiempo real las tablas sin necesidad de recargar.

---

## 🚀 Características de la Plataforma Web

1. **Diseño Moderno y Responsivo:** Construido con Tailwind CSS, paleta de colores corporativa de paraGO y tipografías *Plus Jakarta Sans* y *Outfit*.
2. **Simulador de Préstamo con Código QR e IoT:**
   - Permite al usuario interactuar escaneando un QR virtual.
   - Simula la activación del **servomotor MG995** a 90°, apertura de la garra 3D y liberación del paraguas.
   - Cronómetro de trayecto y geoposicionamiento (AirTag).
   - Devolución en cualquier estación receptora con detección por sensor infrarrojo/pulsador KY-004.
   - **Conexión con BD:** Cada simulación inserta automáticamente un registro en la tabla de préstamos y telemetría IoT.
3. **Red de Estaciones en Monterrey:**
   - Filtros dinámicos por estaciones del **Metrorrey** (Cuauhtémoc, Padre Mier, Zaragoza, Félix U. Gómez) y tiendas **OXXO FEMSA** aliadas (Paseo Morelos, Macroplaza).
4. **Modelo de Negocios y Servitización:**
   - Explicación de la economía colaborativa (*Product-as-a-Service*).
   - Publicidad móvil deducible para marcas aliadas.
   - Análisis macroeconómico PEST en Monterrey.
5. **Ficha Técnica del Prototipo Electromecánico:**
   - Componentes reales: Protoboard 930, Servomotor MG995, Push Button KY-004, Cables Dupont, Diodos 1N4007, Resistencias 10Ω, Garra 3D, AirTag y Adaptador 3A 72W.
   - Metodología de desarrollo en 5 etapas.
6. **Impacto y Objetivos de Desarrollo Sostenible (ODS):**
   - ODS 3: Salud y Bienestar (prevención de golpes de calor >40°C y quemaduras solares).
   - ODS 9: Industria, Innovación e Infraestructura.
   - ODS 17: Alianzas para lograr los objetivos.
7. **Reproductor de Video Integrado:**
   - Presentación de YouTube embebida y accesible directamente.

---

## 🌐 ¿Cómo abrir la página web?

Abre directamente el archivo `index.html` en tu navegador favorito:
- Doble clic sobre `index.html` o visítalo si ya lo tienes alojado en GitHub Pages.
