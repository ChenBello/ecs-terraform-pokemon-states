FROM python:3.11-slim

# Set the working directory where all files will be stored
WORKDIR /app

# Copy all files from the context into the container
COPY . /app

# Update packages and install curl so it's available for health checks
RUN apt-get update && apt-get install -y curl

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 5000 for container communication
EXPOSE 5000

# Development mode (run Flask directly)
# You can use this when working in a development environment
CMD ["python", "app.py"]

# Production mode (run the app with Gunicorn)
# You can uncomment this line when deploying to production
# CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]