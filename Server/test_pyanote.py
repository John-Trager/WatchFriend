# instantiate the pipeline
from pyannote.audio import Pipeline

pipeline = Pipeline.from_pretrained(
  "pyannote/speaker-diarization-3.1",
  use_auth_token="HUGGING_FACE_TOKEN")

import torch
pipeline.to(torch.device("mps"))

# run the pipeline on an audio file
diarization = pipeline("2024-07-03_01:45:49.wav")

# dump the diarization output to disk using RTTM format
with open("test_2024-07-03_01:45:49.rttm", "w") as rttm:
    diarization.write_rttm(rttm)