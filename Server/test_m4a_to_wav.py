from pydub import AudioSegment

m4a_file = 'uploads/2024-07-03_01:45:49.m4a' # I have downloaded sample audio from this link https://getsamplefiles.com/sample-audio-files/m4a
wav_filename = '2024-07-03_01:45:49.wav'

sound = AudioSegment.from_file(m4a_file, format='m4a')
file_handle = sound.export(wav_filename, format='wav')