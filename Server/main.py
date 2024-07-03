"""
Flask server
- handles upload of audio files + passing off to celery workers to process audio

---
Celery Workers Jobs:
- transcriber audio into text
- *WIP* summarize text, get meaning full information and present to user

run celery worker like `celery -A main worker --loglevel=INFO`
"""
from flask import Flask, request, jsonify
from pathlib import Path
import os

from celery_setup import celery_init_app
from tasks import add_together, transcribe_audio

flask_app = Flask(__name__)

# dir setup
UPLOAD_FOLDER = 'uploads'
flask_app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

TRANSCRIPT_FOLDER = 'transcripts'
flask_app.config['TRANSCRIPT_FOLDER'] = TRANSCRIPT_FOLDER
if not os.path.exists(TRANSCRIPT_FOLDER):
    os.makedirs(TRANSCRIPT_FOLDER)

# celery setup
flask_app.config.from_mapping(
    CELERY=dict(
        broker_url="amqp://guest@localhost",
        task_ignore_result=True,
    ),
)
celery_app = celery_init_app(flask_app)

@flask_app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part in the request'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    if file:
        filename = file.filename
        filepath = os.path.join(flask_app.config['UPLOAD_FOLDER'], filename)
        file.save(filepath)
        transcribe_audio.delay(filepath) # celery job to process audio
        return jsonify({'message': 'File uploaded successfully', 'filename': filename}), 200

@flask_app.get("/add")
def start_add():
    a = 5
    b = 11
    add_together.delay(a, b)
    return jsonify({"result_id": ""}), 200

@flask_app.get("/testWhisper")
def test_whisper():
    filename = "2024-07-02_23:30:12.m4a"
    filepath = Path(flask_app.config['UPLOAD_FOLDER']) / filename
    print(filepath)
    transcribe_audio.delay(str(filepath))
    return jsonify({}), 200


if __name__ == '__main__':
    flask_app.run(debug=True)
