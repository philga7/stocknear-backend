# Environment Configuration Documentation

## Overview

This document provides the complete environment configuration structure for the StockNear Backend application. The environment variables are organized by category and include comprehensive configuration for both development and production scenarios.

## File Structure

The following environment files are used:

1. `.env.example` - Template file with all required variables (comprehensive template)
2. `.env` - Current environment configuration (copy from .env.example and customize)

## Complete Environment Variables

### Application Environment
```bash
ENVIRONMENT=development
```

### Redis Configuration
```bash
REDIS_HOST=redis
REDIS_PORT=6380
REDIS_DB=0
```

### Database Configuration
```bash
STOCK_DB=stocks
ETF_DB=etf
INDEX_DB=index
INSTITUTE_DB=institute
CRYPTO_DB=crypto
```

### API Keys

#### Financial Market Data APIs
```bash
FMP_API_KEY=your_fmp_api_key_here
BENZINGA_API_KEY=your_benzinga_api_key_here
INTRINIO_API_KEY=your_intrinio_api_key_here
NASDAQ_API_KEY=your_nasdaq_api_key_here
FINRA_API_KEY=your_finra_api_key_here
FINRA_API_SECRET=your_finra_api_secret_here
```

#### AI/ML APIs
```bash
OPENAI_API_KEY=your_openai_api_key_here
OPENAI_ORG=your_openai_org_id_here
```

#### Cryptocurrency APIs
```bash
COINGECKO_API_KEY=your_coingecko_api_key_here
```

#### Social Media APIs
```bash
TWITTER_API_KEY=your_twitter_api_key_here
TWITTER_API_SECRET=your_twitter_api_secret_here
TWITTER_ACCESS_TOKEN=your_twitter_access_token_here
TWITTER_ACCESS_TOKEN_SECRET=your_twitter_access_token_secret_here
```

#### Reddit APIs
```bash
REDDIT_API_KEY=your_reddit_api_key_here
REDDIT_API_SECRET=your_reddit_api_secret_here
REDDIT_USER_AGENT=your_reddit_user_agent_here
REDDIT_BOT_API_KEY=your_reddit_bot_api_key_here
REDDIT_BOT_API_SECRET=your_reddit_bot_api_secret_here
REDDIT_USERNAME=your_reddit_username_here
REDDIT_PASSWORD=your_reddit_password_here
```

#### LinkedIn API
```bash
LINKEDIN_ACCESS_TOKEN=your_linkedin_access_token_here
```

#### Payment Processing
```bash
LEMON_SQUEEZY_API_KEY=your_lemon_squeezy_api_key_here
```

### Authentication & Security
```bash
FASTAPI_USERNAME=admin
FASTAPI_PASSWORD=password
STOCKNEAR_API_KEY=your_stocknear_api_key_here
```

### PocketBase Configuration
```bash
POCKETBASE_ADMIN_EMAIL=admin@stocknear.com
POCKETBASE_ADMIN_PASSWORD=admin123
```

### AWS Configuration (for file storage)
```bash
AWS_ACCESS_KEY_ID=your_aws_access_key_id_here
AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key_here
```

### Discord Bot Configuration
```bash
DISCORD_BOT_TOKEN=your_discord_bot_token_here
DISCORD_DARK_POOL_WEBHOOK=your_discord_dark_pool_webhook_url_here
DISCORD_OPTIONS_FLOW_WEBHOOK=your_discord_options_flow_webhook_url_here
DISCORD_RECENT_EARNINGS_WEBHOOK=your_discord_recent_earnings_webhook_url_here
DISCORD_EXECUTIVE_ORDER_WEBHOOK=your_discord_executive_order_webhook_url_here
DISCORD_ANALYST_REPORT_WEBHOOK=your_discord_analyst_report_webhook_url_here
DISCORD_WIIM_WEBHOOK=your_discord_wiim_webhook_url_here
DISCORD_CONGRESS_TRADING_WEBHOOK=your_discord_congress_trading_webhook_url_here
DISCORD_TRUTH_SOCIAL_WEBHOOK=your_discord_truth_social_webhook_url_here
```

### External Service URLs
```bash
CRAMER_WEBSITE=your_cramer_website_url_here
CORPORATE_LOBBYING=your_corporate_lobbying_url_here
IPO_NEWS=https://stockanalysis.com/ipos/news/
DIVIDEND_KINGS=your_dividend_kings_url_here
```

### AI Model Configuration
```bash
CHAT_MODEL=gpt-4-turbo-preview
REASON_CHAT_MODEL=gpt-4-turbo-preview
```

### Logging Configuration
```bash
LOG_LEVEL=INFO|DEBUG|WARNING|ERROR
```

### Python Environment
```bash
PYTHONUNBUFFERED=1
```

## Environment Setup

### Development Setup
For development, use dummy keys and development-specific settings:

```bash
ENVIRONMENT=development
LOG_LEVEL=DEBUG
REDIS_HOST=redis
REDIS_PORT=6380
REDIS_DB=0

# Use dummy keys for development
FMP_API_KEY=dummy_fmp_api_key_dev
BENZINGA_API_KEY=dummy_benzinga_api_key_dev
OPENAI_API_KEY=dummy_openai_api_key_dev
# ... (all other API keys with dummy values)

FASTAPI_USERNAME=admin
FASTAPI_PASSWORD=password
STOCKNEAR_API_KEY=dummy_stocknear_api_key_dev

POCKETBASE_ADMIN_EMAIL=admin@stocknear.com
POCKETBASE_ADMIN_PASSWORD=admin123

# Development-specific URLs
CRAMER_WEBSITE=https://www.cnbc.com/jim-cramer/
CORPORATE_LOBBYING=https://www.opensecrets.org/federal-lobbying
IPO_NEWS=https://stockanalysis.com/ipos/news/
DIVIDEND_KINGS=https://www.dividend.com/dividend-kings/

CHAT_MODEL=gpt-4-turbo-preview
REASON_CHAT_MODEL=gpt-4-turbo-preview

PYTHONUNBUFFERED=1
```

### Production Setup
For production, use real API keys and production-specific settings:

```bash
ENVIRONMENT=production
LOG_LEVEL=INFO
REDIS_HOST=redis
REDIS_PORT=6380
REDIS_DB=0

# Real API keys for production
FMP_API_KEY=your_real_fmp_api_key
BENZINGA_API_KEY=your_real_benzinga_api_key
OPENAI_API_KEY=your_real_openai_api_key
# ... (all other API keys with real values)

FASTAPI_USERNAME=admin
FASTAPI_PASSWORD=secure_production_password
STOCKNEAR_API_KEY=your_real_stocknear_api_key

POCKETBASE_ADMIN_EMAIL=admin@stocknear.com
POCKETBASE_ADMIN_PASSWORD=secure_production_password

# Production-specific URLs
CRAMER_WEBSITE=https://www.cnbc.com/jim-cramer/
CORPORATE_LOBBYING=https://www.opensecrets.org/federal-lobbying
IPO_NEWS=https://stockanalysis.com/ipos/news/
DIVIDEND_KINGS=https://www.dividend.com/dividend-kings/

CHAT_MODEL=gpt-4-turbo-preview
REASON_CHAT_MODEL=gpt-4-turbo-preview

PYTHONUNBUFFERED=1
```

## Docker Integration

The environment variables are integrated with Docker through the `docker-compose.yml` file. Key Docker-specific configurations:

- Redis service runs on port 6380
- FastAPI service runs on port 8000
- Fastify service runs on port 2000
- All services are connected through the `stocknear-network` bridge network

## Security Considerations

1. **Never commit real API keys** to version control
2. **Use the .env file** for your actual configuration
3. **Rotate API keys regularly** in production
4. **Use secure passwords** for production environments
5. **Enable logging** for security monitoring

## Usage

1. Copy `.env.example` to `.env` to create your environment file
2. Replace placeholder values with real API keys
3. Use appropriate settings for your deployment (development vs production)
4. Ensure Docker containers have access to environment variables

## Verification

To verify environment configuration:

1. Check that all required variables are set
2. Test API connections with dummy keys in development
3. Verify Redis connection
4. Test database connections
5. Validate Docker container startup

## File Management

- `.env.example` - Template file (safe to commit to version control)
- `.env` - Actual configuration file (should be in .gitignore)
- The `.env` file contains all the same variables as `.env.example` but with actual values 