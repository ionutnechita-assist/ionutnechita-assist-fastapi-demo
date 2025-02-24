# Stage 1: Build dependencies
FROM python:3.13-alpine AS builder

WORKDIR /app

# Install build dependencies including Rust and Cargo
RUN apk add --no-cache \
    gcc \
    musl-dev \
    python3-dev \
    libffi-dev \
    openssl-dev \
    git \
    curl \
    rust \
    cargo

# Copy requirements file
COPY requirements.txt .

# Install dependencies
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels -r requirements.txt

# Stage 2: Final alpine image
FROM python:3.13-alpine

WORKDIR /app

# Install runtime dependencies
RUN apk add --no-cache libstdc++

# Create a non-root user to run the application
RUN adduser -D appuser

# Copy only the built wheels from the builder stage
COPY --from=builder /app/wheels /wheels
COPY --from=builder /app/requirements.txt .

# Install the built wheels
RUN pip install --no-cache /wheels/*

# Copy application code
COPY . .

# Set ownership to the non-root user
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Expose the port
EXPOSE 8000

# Command to run the application
CMD ["python", "app.py"]
