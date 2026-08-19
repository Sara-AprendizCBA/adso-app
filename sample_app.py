from flask import Flask, request, render_template, redirect, url_for
import mysql.connector
from mysql.connector import Error

sample = Flask(__name__)

def get_connection():
    return mysql.connector.connect(
        host="servidor-bd",
        user="root",
        password="root123",
        database="adso_db"
    )

@sample.route("/")
def main():
    registros = []
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT id, nombre_completo, numero_documento, ficha FROM aprendices")
        registros = cursor.fetchall()
        cursor.close()
        conn.close()
    except Error as e:
        print(f"Error al consultar: {e}")
    return render_template("index.html", registros=registros)

@sample.route("/registrar", methods=["POST"])
def registrar():
    nombre = request.form.get("nombre_completo", "").strip()
    documento = request.form.get("numero_documento", "").strip()
    ficha = request.form.get("ficha", "").strip()

    if nombre and documento and ficha:
        try:
            conn = get_connection()
            cursor = conn.cursor()
            cursor.execute(
                "INSERT INTO aprendices (nombre_completo, numero_documento, ficha) VALUES (%s, %s, %s)",
                (nombre, documento, ficha)
            )
            conn.commit()
            cursor.close()
            conn.close()
        except Error as e:
            print(f"Error al insertar: {e}")

    return redirect(url_for("main"))

# Endpoint de prueba para verificar que el despliegue trajo el codigo actualizado
# Si al entrar a /version ves este mensaje, significa que el pipeline de GitHub Actions
# hizo el pull de la imagen nueva y el contenedor se reinicio correctamente
@sample.route("/version")
def version():
    return {"estado": "Deploy verificado - version 2"}

if __name__ == "__main__":
    sample.run(host="0.0.0.0", port=5050)