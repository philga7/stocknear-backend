<div align="center">

# **Stocknear: Open Source Stock Analysis Platform**

<h3>

[Homepage](https://stocknear.com/) | [Discord](https://discord.com/invite/hCwZMMZ2MT)

</h3>

[![GitHub Repo stars](https://img.shields.io/github/stars/stocknear/backend)](https://github.com/stocknear/backend/stargazers)

</div>

# Techstack

This is the codebase that powers [stocknear's](https://stocknear.com/) backend, which is an open-source stock analysis research platform.

Built with:
- [FastAPI](https://fastapi.tiangolo.com/): Python Backend
- [Fastify](https://fastify.dev/): Nodejs Backend
- [Pocketbase](https://pocketbase.io/): Database
- [Redis](https://redis.io/): Caching Data

# 🚀 Quick Start

## Docker Setup (Recommended)

The easiest way to get started is using Docker:

```bash
# Clone the repository
git clone <repository-url>
cd stocknear-backend

# One-command setup
./init-docker.sh
```

This will:
- ✅ Initialize all databases
- ✅ Create required directories and files
- ✅ Build and start all Docker containers
- ✅ Wait for services to be healthy
- ✅ Test all endpoints

**Services will be available at:**
- FastAPI: http://localhost:8000
- Fastify: http://localhost:2000
- Redis: localhost:6380

## Manual Setup

If you prefer to run without Docker:

1. Install Python 3.8+ and Node.js
2. Install dependencies: `pip install -r requirements.txt`
3. Initialize databases: `python3 init_db.py`
4. Start services manually

For detailed setup instructions, see [DOCKER_README.md](DOCKER_README.md).

# 📚 Documentation

- **[Docker Setup Guide](DOCKER_README.md)** - Complete Docker setup and troubleshooting
- **[Setup Summary](SETUP_SUMMARY.md)** - Overview of the Docker MVP implementation
- **[Environment Configuration](ENVIRONMENT_CONFIGURATION.md)** - Environment variable setup

# Contributing
Stocknear is an open-source project, soley maintained by Muslem Rahimi.

We are not accepting pull requests. However, you are more than welcome to fork the project and customize it to suit your needs.

The core idea of stocknear shall always be: **_Fast_**, **_Simple_** & **_Efficient_**.

# Support ❤️

If you love the idea of stocknear and want to support our mission you can help us in two ways:

- Become a [Pro Member](https://stocknear.com/pricing) of stocknear to get unlimited feature access to enjoy the platform to the fullest.
- You can sponsor us via [Github](https://github.com/sponsors/stocknear) to help us pay the servers & data providers to keep everything running!
