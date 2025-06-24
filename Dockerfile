# Use official Rasa image
FROM rasa/rasa:3.6.21

# Copy your full project (except models) into the container
COPY . /app

# Set working directory
WORKDIR /app

# Train the model during Docker build
RUN rasa train

# Expose Rasa server port
EXPOSE 5005

# Start Rasa server on the port Render assigns
CMD ["rasa", "run", "--enable-api", "--model", "models", "--port", "${PORT}", "--debug"]
