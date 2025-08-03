# StockNear Backend Makefile
# Provides convenient commands for managing the Docker setup

.PHONY: help setup start stop restart logs status clean test build

# Default target
help:
	@echo "StockNear Backend Docker Management"
	@echo ""
	@echo "Available commands:"
	@echo "  setup    - Initialize and start all services (recommended for first time)"
	@echo "  start    - Start all services"
	@echo "  stop     - Stop all services"
	@echo "  restart  - Restart all services"
	@echo "  logs     - View logs for all services"
	@echo "  status   - Show status of all services"
	@echo "  clean    - Stop services and clean up"
	@echo "  test     - Test all service endpoints"
	@echo "  build    - Build all Docker images"
	@echo "  shell    - Open shell in FastAPI container"
	@echo "  fastify  - Open shell in Fastify container"
	@echo "  redis    - Open shell in Redis container"

# Initialize and start all services (recommended for first time)
setup:
	@echo "🚀 Setting up StockNear Backend..."
	@./init-docker.sh

# Start all services
start:
	@echo "Starting services..."
	@docker-compose up -d

# Stop all services
stop:
	@echo "Stopping services..."
	@docker-compose down

# Restart all services
restart:
	@echo "Restarting services..."
	@docker-compose restart

# View logs for all services
logs:
	@docker-compose logs -f

# Show status of all services
status:
	@docker-compose ps

# Stop services and clean up
clean:
	@echo "Cleaning up..."
	@docker-compose down
	@docker system prune -f

# Test all service endpoints
test:
	@echo "Testing service endpoints..."
	@echo "Testing FastAPI..."
	@curl -s http://localhost:8000/ || echo "FastAPI not responding"
	@echo "Testing Fastify health..."
	@curl -s http://localhost:2000/health || echo "Fastify health not responding"
	@echo "Testing Redis..."
	@docker exec stocknear-backend-redis-1 redis-cli ping || echo "Redis not responding"

# Build all Docker images
build:
	@echo "Building Docker images..."
	@docker-compose build

# Open shell in FastAPI container
shell:
	@docker-compose exec fastapi bash

# Open shell in Fastify container
fastify:
	@docker-compose exec fastify sh

# Open shell in Redis container
redis:
	@docker-compose exec redis sh

# View logs for specific service
logs-fastapi:
	@docker-compose logs -f fastapi

logs-fastify:
	@docker-compose logs -f fastify

logs-redis:
	@docker-compose logs -f redis

# Database management
db-init:
	@echo "Initializing databases..."
	@python3 init_db.py

db-reset:
	@echo "Resetting databases..."
	@rm -f *.db
	@python3 init_db.py
	@docker-compose restart fastapi

# Quick development commands
dev-start:
	@echo "Starting development environment..."
	@make start
	@echo "Services started. View logs with: make logs"

dev-stop:
	@echo "Stopping development environment..."
	@make stop

dev-restart:
	@echo "Restarting development environment..."
	@make restart 