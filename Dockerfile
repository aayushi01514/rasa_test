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
COPY . /app

# --- START OF VIRTUAL ENVIRONMENT CHANGES (LOCATION CHANGE) ---

# Create a virtual environment inside the /app directory
# The WORKDIR /app and COPY . /app lines ensure the user has permissions here.
RUN python3 -m venv /app/venv

# Activate the virtual environment and install dependencies into it.
# Use the pip executable from the newly created venv in /app/venv
RUN /app/venv/bin/pip install --no-cache-dir --upgrade --force-reinstall -r requirements.txt

# Set the PATH environment variable to prioritize the virtual environment's binaries.
# Ensure it points to the venv in /app
ENV PATH="/app/venv/bin:$PATH"

# --- END OF VIRTUAL ENVIRONMENT CHANGES ---

# Train the model during build. This step will now use the Rasa installed in your venv.
RUN rasa train

# Expose the default Rasa API port for clarity.
EXPOSE 5005

# Define the command to run your Rasa server.
CMD ["rasa", "run", "--enable-api", "--cors", "*", "--debug", "--port", "5005", "--host", "0.0.0.0", "--model", "models", "--endpoints", "endpoints.yml"]