
## running jobs

we have jobs for processing audio files and running ML/ other tasks (or that is the plan LOL)

- https://flask.palletsprojects.com/en/2.3.x/patterns/celery/


run celery worker like (make sure broker is running - rabbitmq in our case)
```
celery -A main worker --loglevel=INFO
```



- use RabitMQ as the broker for Celery (which handles our jobs for data processing)
    - install on mac using `brew install rabbitmq`  

start rabbittmq service using:
```
# starts a local RabbitMQ node
brew services start rabbitmq

# highly recommended: enable all feature flags on the running node
/opt/homebrew/sbin/rabbitmqctl enable_feature_flag all
```

end rabbittmq service 
```
# stops the locally running RabbitMQ node
brew services stop rabbitmq
```

## audio to text
using openai whisper but locally
https://github.com/openai/whisper


## pyannote

needs the files in .wav format so we need to use pydub that uses ffmpeg and ffprobe to convert the file. Maybe there is a better way but this should work for now.

## WhisperX
To get this to work we need to build CTranslate2 from source with the `-DWITH_ACCELERATE=ON` flag.
- see https://opennmt.net/CTranslate2/installation.html and https://github.com/SYSTRAN/faster-whisper/issues/515