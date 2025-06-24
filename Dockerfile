# FROM rasa/rasa:3.6.21-full

# WORKDIR /app

# COPY . /app

# RUN rasa train

# CMD ["run", "--enable-api", "--cors", "*", "--debug", "--port", "8000"]

# # Expose the port that Rasa will run on
# EXPOSE 8000
# Use the official Rasa base image.
FROM rasa/rasa:3.6.21-full

# Set the working directory inside the container
WORKDIR /app

# Copy your entire Rasa project into the container
# This assumes your Dockerfile is at the root of your Rasa project
# which contains data/, models/, config.yml, domain.yml, endpoints.yml, etc.
COPY . /app

# Install any additional Python dependencies your Rasa project might have
# Ensure you have a requirements.txt file in your project root if needed
COPY requirements.txt ./
RUN pip install --no-cache-dir --upgrade --force-reinstall --break-system-packages -r requirements.txt

# Train the model during build. This is fine, but can make builds long.
# If you train locally and commit the 'models' folder, you can remove this.
RUN rasa train

# Expose the default Rasa port for clarity.
# Render will map its internal $PORT (e.g., 10000) to this exposed port.
EXPOSE 5005 
# Changed to standard Rasa API port

# Define a default command. Render's "Start Command" will override this.
# This is useful for local testing with 'docker run'.
CMD ["rasa", "run", "--enable-api", "--cors", "*", "--debug", "--port", "5005", "--host", "0.0.0.0", "--model", "models", "--endpoints", "endpoints.yml"]