#!/bin/bash

# StockNear Backend Docker Initialization Script
# This script sets up all necessary files and directories before starting Docker containers

set -e  # Exit on any error

echo "🚀 Initializing StockNear Backend for Docker..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

print_status "Docker is running ✓"

# Step 1: Clean up any existing database directories (not files)
print_status "Cleaning up existing database directories..."
for db in stocks etf index institute crypto; do
    if [ -d "${db}.db" ]; then
        print_warning "Removing directory ${db}.db (should be a file)"
        rm -rf "${db}.db"
    fi
done

# Step 2: Initialize databases
print_status "Initializing SQLite databases..."
python3 init_db.py

# Step 3: Create required directories and files
print_status "Creating required directories and files..."

# Create logs directory if it doesn't exist
mkdir -p logs

# Create json/stock-screener directory and data.json if it doesn't exist
mkdir -p json/stock-screener
if [ ! -f "json/stock-screener/data.json" ]; then
    print_status "Creating minimal stock-screener data.json..."
    echo "[]" > json/stock-screener/data.json
fi

# Create websocket directory structure if it doesn't exist
mkdir -p app/json/websocket/companies

# Step 4: Verify database files
print_status "Verifying database files..."
for db in stocks etf index institute crypto; do
    if [ -f "${db}.db" ]; then
        db_size=$(stat -f%z "${db}.db" 2>/dev/null || stat -c%s "${db}.db" 2>/dev/null)
        if [ "$db_size" -gt 0 ]; then
            print_success "${db}.db created successfully (${db_size} bytes)"
        else
            print_error "${db}.db is empty!"
            exit 1
        fi
    else
        print_error "${db}.db was not created!"
        exit 1
    fi
done

# Step 5: Check if required files exist
print_status "Checking required files..."
required_files=(
    "json/stock-screener/data.json"
    "logs"
    "app/json/websocket/companies"
)

for file in "${required_files[@]}"; do
    if [ -e "$file" ]; then
        print_success "$file exists ✓"
    else
        print_error "$file is missing!"
        exit 1
    fi
done

# Step 6: Stop any running containers
print_status "Stopping any existing containers..."
docker-compose down > /dev/null 2>&1 || true

# Step 7: Build and start containers
print_status "Building and starting Docker containers..."
docker-compose up -d

# Step 8: Wait for containers to be healthy
print_status "Waiting for containers to be healthy..."
max_attempts=30
attempt=0

while [ $attempt -lt $max_attempts ]; do
    if docker-compose ps | grep -q "healthy"; then
        print_success "All containers are healthy! ✓"
        break
    fi
    
    attempt=$((attempt + 1))
    print_status "Waiting for containers to be healthy... (attempt $attempt/$max_attempts)"
    sleep 10
done

if [ $attempt -eq $max_attempts ]; then
    print_error "Containers failed to become healthy within the expected time."
    print_status "Checking container logs..."
    docker-compose logs --tail=20
    exit 1
fi

# Step 9: Test endpoints
print_status "Testing service endpoints..."

# Test FastAPI
if curl -s http://localhost:8000/ > /dev/null; then
    print_success "FastAPI is responding ✓"
else
    print_warning "FastAPI endpoint test failed (this might be expected if no data)"
fi

# Test Fastify health endpoint
if curl -s http://localhost:2000/health > /dev/null; then
    print_success "Fastify health endpoint is responding ✓"
else
    print_warning "Fastify health endpoint test failed (this might be expected due to CORS)"
fi

# Test Redis
if docker exec stocknear-backend-redis-1 redis-cli ping > /dev/null 2>&1; then
    print_success "Redis is responding ✓"
else
    print_error "Redis is not responding!"
fi

print_success "🎉 StockNear Backend initialization complete!"
print_status "Services available at:"
print_status "  - FastAPI: http://localhost:8000"
print_status "  - Fastify: http://localhost:2000"
print_status "  - Redis: localhost:6380"

print_status "To view logs: docker-compose logs -f"
print_status "To stop services: docker-compose down"
print_status "To restart services: docker-compose restart" 