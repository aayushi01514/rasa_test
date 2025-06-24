# FROM rasa/rasa:3.6.21-full

# WORKDIR /app

# COPY . /app

# RUN rasa train

# CMD ["run", "--enable-api", "--cors", "*", "--debug", "--port", "8000"]

# # Expose the port that Rasa will run on
# EXPOSE 8000
FROM rasa/rasa:3.6.21-full

WORKDIR /app

COPY . /app

RUN rasa train

EXPOSE 8000

CMD ["run", "--enable-api", "--cors", "*", "--debug", "--port", "8000"]
