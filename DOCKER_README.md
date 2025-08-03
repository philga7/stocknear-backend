# StockNear Backend Docker Setup

This document provides a comprehensive guide for setting up and running the StockNear backend services using Docker.

## 🚀 Quick Start

### Prerequisites

- Docker Desktop installed and running
- Python 3.8+ (for database initialization)
- Git (to clone the repository)

### One-Command Setup

```bash
# Clone the repository (if not already done)
git clone <repository-url>
cd stocknear-backend

# Run the initialization script
./init-docker.sh
```

This script will:
- ✅ Clean up any existing database directories
- ✅ Initialize SQLite databases with proper schemas
- ✅ Create required directories and files
- ✅ Build and start all Docker containers
- ✅ Wait for containers to be healthy
- ✅ Test all service endpoints

## 📋 Services Overview

| Service | Port | Purpose | Health Check |
|---------|------|---------|--------------|
| FastAPI | 8000 | Main API server | `GET /` |
| Fastify | 2000 | WebSocket price data | `GET /health` |
| Redis | 6380 | Caching and session storage | `redis-cli ping` |

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   FastAPI       │    │   Fastify       │    │   Redis         │
│   (Port 8000)   │    │   (Port 2000)   │    │   (Port 6380)   │
│                 │    │                 │    │                 │
│ • REST API      │    │ • WebSocket     │    │ • Caching       │
│ • Database      │    │ • Price Data    │    │ • Sessions      │
│ • Business      │    │ • Real-time     │    │ • Queues        │
│   Logic         │    │   Updates       │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 📁 File Structure

```
stocknear-backend/
├── docker-compose.yml          # Docker services configuration
├── init-docker.sh             # One-command setup script
├── init_db.py                 # Database initialization
├── *.db                       # SQLite database files
├── json/
│   └── stock-screener/
│       └── data.json          # Stock screener data
├── app/
│   └── json/
│       └── websocket/
│           └── companies/     # WebSocket price data files
├── logs/                      # Application logs
└── fastify/
    └── app.js                 # Fastify WebSocket server
```

## 🔧 Manual Setup (if needed)

### 1. Initialize Databases

```bash
# Remove any existing database directories
rm -rf *.db

# Initialize databases with proper schemas
python3 init_db.py
```

### 2. Create Required Directories

```bash
# Create logs directory
mkdir -p logs

# Create stock-screener data
mkdir -p json/stock-screener
echo "[]" > json/stock-screener/data.json

# Create WebSocket data directory
mkdir -p app/json/websocket/companies
```

### 3. Start Services

```bash
# Start all services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

## 🐛 Troubleshooting

### Common Issues

#### 1. FastAPI Container Restarting

**Symptoms:**
- Container shows "Up Less than a second (health: starting)"
- Logs show database connection errors

**Solutions:**
```bash
# Check if database files are directories instead of files
ls -la *.db

# If they're directories, remove and recreate
rm -rf *.db
python3 init_db.py

# Restart containers
docker-compose down && docker-compose up -d
```

#### 2. Database Schema Errors

**Symptoms:**
- `sqlite3.OperationalError: no such column: type`
- `sqlite3.OperationalError: no such column: marketCap`

**Solutions:**
```bash
# Update database schemas
python3 init_db.py

# Restart containers
docker-compose restart fastapi
```

#### 3. Missing Files

**Symptoms:**
- `FileNotFoundError: [Errno 2] No such file or directory: 'json/stock-screener/data.json'`

**Solutions:**
```bash
# Create missing directories and files
mkdir -p json/stock-screener
echo "[]" > json/stock-screener/data.json

# Restart containers
docker-compose restart fastapi
```

#### 4. Fastify Connection Issues

**Symptoms:**
- `curl: (56) Recv failure: Connection reset by peer`
- Fastify container is healthy but HTTP requests fail

**Solutions:**
- This is expected behavior due to CORS configuration
- WebSocket connections should work properly
- Health endpoint may not respond to external HTTP requests

### Debugging Commands

```bash
# Check container status
docker-compose ps

# View logs for specific service
docker-compose logs fastapi
docker-compose logs fastify
docker-compose logs redis

# Check database files
ls -la *.db

# Test endpoints
curl http://localhost:8000/
curl http://localhost:2000/health

# Access container shell
docker-compose exec fastapi bash
docker-compose exec fastify sh
```

## 🔄 Maintenance

### Updating Services

```bash
# Pull latest changes
git pull

# Rebuild and restart services
docker-compose down
docker-compose up -d --build
```

### Database Management

```bash
# Backup databases
cp *.db backups/

# Restore databases
cp backups/*.db ./

# Reset databases (WARNING: This will delete all data)
rm *.db
python3 init_db.py
docker-compose restart fastapi
```

### Log Management

```bash
# View real-time logs
docker-compose logs -f

# View logs for specific service
docker-compose logs -f fastapi

# Clear logs
docker-compose logs --tail=0
```

## 📊 Monitoring

### Health Checks

All services include health checks that monitor:
- Service availability
- Endpoint responsiveness
- Database connectivity

### Log Locations

- **Application logs**: `./logs/`
- **Container logs**: `docker-compose logs`
- **Database files**: `./*.db`

## 🚀 Production Considerations

### Environment Variables

Create a `.env` file for production:

```env
REDIS_HOST=redis
REDIS_PORT=6380
REDIS_DB=0
PYTHONUNBUFFERED=1
ENVIRONMENT=production
FMP_API_KEY=your_api_key_here
BENZINGA_API_KEY=your_api_key_here
```

### Security

- Change default passwords
- Use proper API keys
- Enable HTTPS in production
- Configure proper CORS settings

### Performance

- Monitor memory usage: `docker stats`
- Scale services as needed
- Configure Redis persistence
- Set up log rotation

## 📚 Additional Resources

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Fastify Documentation](https://www.fastify.io/)
- [Redis Documentation](https://redis.io/documentation)

## 🤝 Support

If you encounter issues:

1. Check the troubleshooting section above
2. Review container logs: `docker-compose logs`
3. Verify file permissions and ownership
4. Ensure Docker has sufficient resources allocated

---

**Note**: This setup is designed for development. For production deployment, additional security, monitoring, and scaling considerations should be implemented. 