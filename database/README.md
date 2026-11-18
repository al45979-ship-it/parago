# 🗄️ Base de Datos Relacional - paraGO

Este directorio contiene el diseño y modelo de datos relacional para el sistema de micromovilidad y préstamo automatizado de paraguas **paraGO** en Monterrey, N.L.

---

## 📁 Archivos incluidos

1. **`schema.sql`**: Script DDL y DML estándar compatible con **PostgreSQL, SQLite, MySQL y Supabase**.
   - Incluye definición de tablas, llaves primarias, llaves foráneas e índices.
   - Incluye datos iniciales (semilla) de las estaciones de Metrorrey (Cuauhtémoc, Padre Mier, Zaragoza, Félix U. Gómez) y tiendas OXXO FEMSA.
   - Incluye usuarios de prueba (integrantes del equipo y docentes), inventario de paraguas con rastreador AirTag y registros de telemetría IoT (servomotores y sensores).
   - Incluye 2 vistas SQL analíticas (`vista_prestamos_detallados` y `vista_resumen_estaciones`).
2. **`init_db.py`**: Script de utilidad para generar una base local SQLite (`parago.db`).
3. **`diagrama_er.md`**: Diagrama de entidad-relación y diccionario de datos.

---

## 📊 Estructura de Tablas

| Tabla | Descripción | Llave Primaria |
| :--- | :--- | :--- |
| **`usuarios`** | Almacena los datos de los usuarios registrados (nombre, matrícula/teléfono, viajes y saldo). | `id` (INTEGER AUTO) |
| **`estaciones`** | Red de tótems en Metrorrey y tiendas OXXO con capacidad y coordenadas GPS. | `id` (VARCHAR) |
| **`paraguas`** | Inventario físico con ID de rastreador AirTag, filtro UV 50+ y contador de usos. | `id` (VARCHAR) |
| **`prestamos`** | Registro histórico y activo de cada viaje (estación origen, destino, fechas y duración). | `id` (INTEGER AUTO) |
| **`registros_iot`** | Bitácora de eventos de hardware: servomotores MG995 (0°-90°) y sensores de proximidad KY-004. | `id` (INTEGER AUTO) |
| **`patrocinadores`** | Convenios publicitarios (Grupo FEMSA, Metrorrey) para financiamiento 100% deducible. | `id` (VARCHAR) |

---

## 🚀 ¿Cómo utilizarla o probarla?

### Opción 1: En la página web de paraGO (GitHub Pages)
La interfaz web en `index.html` incluye un **Visor de Base de Datos en Vivo**, permitiendo consultar y registrar datos directamente en tiempo real sin necesidad de configurar un servidor.

### Opción 2: En SQLite (Local)
Puedes abrir el archivo `schema.sql` en cualquier cliente gráfico como **DB Browser for SQLite** (o DBeaver) y ejecutarlo para crear tu base de datos local al instante.

### Opción 3: En Supabase (PostgreSQL en la nube)
1. Crea un proyecto gratuito en [supabase.com](https://supabase.com).
2. Ve al **SQL Editor**.
3. Pega el contenido de `schema.sql` y presiona **Run**.
4. ¡Tendrás todas las tablas y datos creados en PostgreSQL en 10 segundos!
