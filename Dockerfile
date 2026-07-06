# Use Python 3.11 (best TensorFlow compatibility)
FROM python:3.11-slim

# Install system dependencies for OpenCV
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first (Docker layer caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY . .

# Create upload directory
RUN mkdir -p static/shots

# Expose port (Render sets PORT env var)
EXPOSE 5000

# Run with gunicorn (production WSGI server)
CMD gunicorn --bind 0.0.0.0:${PORT:-5000} --timeout 120 --workers 1 --threads 2 app:app
