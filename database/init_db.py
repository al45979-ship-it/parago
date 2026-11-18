"""
Script para inicializar la base de datos SQLite de paraGO
Uso: python database/init_db.py
"""
import sqlite3
import os

DB_DIR = os.path.dirname(os.path.abspath(__file__))
SQL_PATH = os.path.join(DB_DIR, "schema.sql")
DB_PATH = os.path.join(DB_DIR, "parago.db")

def init_database():
    print("=" * 60)
    print("Iniciando creación de Base de Datos paraGO (SQLite)...")
    print("=" * 60)

    if not os.path.exists(SQL_PATH):
        print(f"Error: no se encontró el archivo {SQL_PATH}")
        return

    with open(SQL_PATH, "r", encoding="utf-8") as f:
        sql_script = f.read()

    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    try:
        cursor.executescript(sql_script)
        conn.commit()
        print(f"Base de datos creada exitosamente en:\n-> {DB_PATH}")

        # Comprobar registros
        cursor.execute("SELECT count(*) FROM estaciones")
        num_est = cursor.fetchone()[0]
        cursor.execute("SELECT count(*) FROM usuarios")
        num_usu = cursor.fetchone()[0]
        cursor.execute("SELECT count(*) FROM paraguas")
        num_par = cursor.fetchone()[0]
        cursor.execute("SELECT count(*) FROM prestamos")
        num_pre = cursor.fetchone()[0]

        print(f"\nResumen de datos cargados:")
        print(f"  - Estaciones: {num_est}")
        print(f"  - Usuarios registrados: {num_usu}")
        print(f"  - Paraguas en inventario: {num_par}")
        print(f"  - Préstamos registrados: {num_pre}")
        print("=" * 60)
        print("Base de datos lista para pruebas locales y despliegue.")
    except Exception as e:
        print(f"Error ejecutando SQL: {e}")
    finally:
        conn.close()

if __name__ == "__main__":
    init_database()
