FROM rasa/rasa:3.6.21-full

WORKDIR /app

COPY . /app

RUN rasa train

CMD ["run", "--enable-api", "--cors", "*", "--debug", "--port", "8000"]