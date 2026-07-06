# Use Python 3.11 slim
FROM python:3.11-slim

# Install system dependencies for OpenCV + git-lfs for model files
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    git-lfs \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first (Docker layer caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY . .

# If LFS pointer files exist, try to fetch actual files
RUN if [ -f .gitattributes ] && command -v git-lfs > /dev/null 2>&1; then \
    git lfs install --skip-repo 2>/dev/null || true; \
    fi

# Create upload directory
RUN mkdir -p static/shots

# Expose port
EXPOSE 5000

# Use single worker with limited threads to stay within free tier memory (512MB)
# Increase timeout for TensorFlow model loading
CMD gunicorn --bind 0.0.0.0:${PORT:-5000} --timeout 300 --workers 1 --threads 2 --preload app:app
