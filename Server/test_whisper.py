import whisper


model = whisper.load_model("base")
result = model.transcribe("uploads/2024-07-02_23:30:12.m4a")
print(result['text'])