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

# --- START OF VIRTUAL ENVIRONMENT CHANGES ---

# Create a virtual environment inside a directory where the user has write permissions
# /opt/venv is a common and good choice
RUN python3 -m venv /opt/venv

# Activate the virtual environment and install dependencies into it.
# This ensures your project's dependencies are installed into an isolated space
# where you have full write permissions, bypassing system package issues.
# --no-deps is NOT usually needed here; --upgrade and --force-reinstall
# ensure your pinned versions take precedence.
RUN /opt/venv/bin/pip install --no-cache-dir --upgrade --force-reinstall -r requirements.txt

# Set the PATH environment variable to prioritize the virtual environment's binaries.
# This ensures that 'rasa' commands and other Python scripts use the packages
# installed in your virtual environment, not the system ones.
ENV PATH="/opt/venv/bin:$PATH"

# --- END OF VIRTUAL ENVIRONMENT CHANGES ---

# Train the model during build. This step will now use the Rasa installed in your venv.
RUN rasa train

# Expose the default Rasa API port for clarity.
EXPOSE 5005

# Define the command to run your Rasa server.
# This will also use the Rasa installed in your venv due to the PATH setting.
# Remember Render's "Start Command" will override this, so keep it consistent there.
CMD ["rasa", "run", "--enable-api", "--cors", "*", "--debug", "--port", "5005", "--host", "0.0.0.0", "--model", "models", "--endpoints", "endpoints.yml"]