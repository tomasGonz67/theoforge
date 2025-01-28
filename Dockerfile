# Use an official Python image as the base image
# The slim version reduces the image size and potential attack surface
FROM python:3.9-slim

# Set environment variables to improve security and performance
# - PYTHONDONTWRITEBYTECODE: Prevents Python from writing .pyc files to disk
# - PYTHONUNBUFFERED: Ensures logs are streamed directly, useful for debugging
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Add ~/.local/bin to PATH
ENV PATH="/home/appuser/.local/bin:$PATH"

# Set a non-root user for better security
# Avoid running the application as root to reduce risks if the container is compromised
RUN adduser --disabled-password --gecos "" appuser

# Set the working directory and change ownership to the non-root user
WORKDIR /app
RUN chown -R appuser:appuser /app

# Switch to the non-root user
USER appuser

# Copy only the necessary files into the container
# Using a .dockerignore file can help exclude unnecessary files
COPY --chown=appuser:appuser . .


# Copy the requirements.txt file into the container
COPY requirements.txt /app/

# Install dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install dependencies in a single layer to minimize image size
# --no-cache-dir prevents caching of pip dependencies, reducing image bloat
RUN pip install --no-cache-dir fastapi jinja2 uvicorn

# Expose the application port
EXPOSE 8000


# Command to run the application in production
# Using multiple workers improves performance under load
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4"]