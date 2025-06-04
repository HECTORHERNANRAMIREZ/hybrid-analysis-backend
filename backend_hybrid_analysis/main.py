from flask import Flask, request, jsonify
import requests
import time
import os

app = Flask(__name__)

API_KEY = os.getenv("API_KEY")  # Lo configurarás en Railway

@app.route("/", methods=["GET"])
def home():
    return "🚀 API de Hybrid Analysis activa"

@app.route("/escanear", methods=["POST"])
def escanear_archivo():
    if 'file' not in request.files:
        return jsonify({"error": "Archivo no encontrado"}), 400

    archivo = request.files['file']
    files = {'file': (archivo.filename, archivo.stream)}
    headers = {
        "User-Agent": "Falcon Sandbox",
        "api-key": API_KEY
    }

    # Paso 1: Subir archivo
    respuesta = requests.post(
        "https://www.hybrid-analysis.com/api/v2/submit/file",
        headers=headers,
        files=files
    )

    if respuesta.status_code != 200:
        return jsonify({"error": "No se pudo subir el archivo"}), 500

    job_id = respuesta.json().get("job_id")

    # Paso 2: Consultar resultado
    for _ in range(10):  # Espera ~60 segundos máximo
        time.sleep(6)
        r = requests.get(
            f"https://www.hybrid-analysis.com/api/v2/report/summary/{job_id}",
            headers=headers
        )
        if r.status_code == 200:
            data = r.json()
            return jsonify({
                "threat_score": data.get("threat_score"),
                "verdict": data.get("verdict"),
                "tags": data.get("classification_tags", []),
                "job_id": job_id
            })

    return jsonify({"error": "No se obtuvo resultado a tiempo"}), 408

if __name__ == "__main__":
    app.run(debug=True)
