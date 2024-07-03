from celery import shared_task
from pathlib import Path
import whisper

# just a test task
@shared_task(ignore_result=True)
def add_together(a: int, b: int) -> int:
    return a + b

@shared_task(ignore_result=True)
def transcribe_audio(filePath: str) -> str: 
    model = whisper.load_model("base")
    result = model.transcribe(filePath)

    # TODO: save to file and pass to next job?
    # we want to also look into whisperX
    # goals: 
    # - be able to separate different speakers in audio (especially host speaker)
    # - have this text be accurate and in readable form
    # next part:
    # - do other processing to above text to extract info for user
    # - can look into other projects that already do this
    # Save result to text file
    
    file_name = Path(filePath).name.split('.')[0] + ".txt"
    # TODO: fix hardcoded path
    output_file = Path("transcripts") / file_name 

    with open(output_file, "w") as f:
        f.write(result["text"])

    return result['text']