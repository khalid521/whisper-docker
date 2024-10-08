FROM python:3.10-slim

WORKDIR /python-docker

COPY requirements.txt requirements.txt

RUN apt-get update && apt-get install git -y



RUN pip3 install -r requirements.txt
RUN pip3 install "git+https://github.com/openai/whisper.git" 
RUN apt-get update && apt-get install -y ffmpeg
RUN apt-get update && apt-get install -y wget

COPY . .
# COPY whisper ~/.cache/whisper

# RUN cd /usr/local/lib/python3.10/site-packages/tiktoken_ext
# RUN ls
WORKDIR /usr/local/lib/python3.10/site-packages/tiktoken_ext
RUN sed -i "s|https://openaipublic.blob.core.windows.net/gpt-2/encodings/main/vocab.bpe|~/.cache/whisper/vocab.bpe|g" openai_public.py
RUN sed -i "s|https://openaipublic.blob.core.windows.net/gpt-2/encodings/main/encoder.json|~/.cache/whisper/encoder.json|g" openai_public.py

WORKDIR /root/.cache/whisper/
RUN wget https://openaipublic.blob.core.windows.net/gpt-2/encodings/main/encoder.json
RUN wget https://openaipublic.blob.core.windows.net/gpt-2/encodings/main/vocab.bpe
RUN wget https://openaipublic.azureedge.net/main/whisper/models/ed3a0b6b1c0edf879ad9b11b1af5a0e6ab5db9205f891f668f8b0e6c6326e34e/base.pt

WORKDIR /python-docker


EXPOSE 8000

# CMD ["flask", "run", "--host", "0.0.0.0", "--port", "8000"]
CMD ["uvicorn", "fastapi_app:app", "--host", "0.0.0.0", "--port", "8000"]

#/usr/local/lib/python3.10/site-packages/tiktoken_ext


# ~/.cache/whisper/


#cd /usr/local/lib/python3.10/site-packages/tiktoken_ext
# sed -i "s|https://openaipublic.blob.core.windows.net/gpt-2/encodings/main/vocab.bpe|~/.cache/whisper/vocab.bpe|g" openai_public.py
# sed -i "s|https://openaipublic.blob.core.windows.net/gpt-2/encodings/main/encoder.json|~/.cache/whisper/encoder.json|g" openai_public.py


# apt-get install wget -y 
# wget https://openaipublic.blob.core.windows.net/gpt-2/encodings/main/encoder.json
# wget https://openaipublic.blob.core.windows.net/gpt-2/encodings/main/vocab.bpe
# wget https://openaipublic.azureedge.net/main/whisper/models/ed3a0b6b1c0edf879ad9b11b1af5a0e6ab5db9205f891f668f8b0e6c6326e34e/base.pt


#vim openai_public.py