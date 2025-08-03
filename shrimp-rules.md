# Stocknear Backend Development Guidelines

## Project Overview

Stocknear is a FastAPI-based stock analysis platform with extensive data collection, ML models, and financial data processing capabilities. The platform uses FastAPI for the main backend, Fastify for Node.js services, PocketBase for database, Redis for caching, and includes comprehensive cron job scheduling for data collection.

## Project Architecture

### Core Components
- **FastAPI Backend**: Main API server in `app/main.py`
- **Cron Jobs**: Data collection scripts in `app/cron_*.py`
- **ML Models**: Prediction models in `app/ml_models/`
- **Database**: SQLite for local data, PocketBase for user data
- **Caching**: Redis for performance optimization
- **Node.js Services**: Fastify server in `fastify/`

### Directory Structure
```
app/
├── main.py                 # FastAPI application entry point
├── functions.py            # Core data processing functions
├── cron_*.py              # Data collection cron jobs
├── ml_models/             # Machine learning models
├── utils/                 # Utility functions
├── llm/                   # LLM integration
├── ai_agent/              # AI agent functionality
└── html_template/         # Email templates
```

## Code Standards

### FastAPI Endpoint Development

**MUST** use `@function_tool` decorator for all API endpoints:
```python
@function_tool
async def get_ticker_data(tickers: List[str]) -> Dict[str, Any]:
    # Implementation
    return {"data": result}
```

**MUST** use async/await patterns for all database and external API calls:
```python
async def fetch_data():
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as response:
            return await response.json()
```

**MUST** use Pydantic models for request/response validation:
```python
class TickerData(BaseModel):
    ticker: str
    timePeriod: str = "1y"
```

### Cron Job Development

**MUST** follow the pattern in `primary_cron_job.py`:
```python
def run_job_name():
    now = datetime.now(ny_tz)
    week = now.weekday()
    hour = now.hour
    if week <= 4 and 8 <= hour < 17:  # Market hours
        run_command(["python3", "cron_job_name.py"])
```

**MUST** use timezone-aware scheduling:
```python
ny_tz = timezone('America/New_York')
berlin_tz = timezone('Europe/Berlin')
```

**MUST** implement job status tracking:
```python
job_status = {
    'job_name': {'running': False}
}
```

### Database Interaction Patterns

**MUST** use context managers for SQLite connections:
```python
@contextmanager
def db_connection(db_name):
    conn = sqlite3.connect(f'{db_name}.db')
    try:
        yield conn
    finally:
        conn.close()
```

**MUST** use async patterns for PocketBase:
```python
client = PocketBase('http://localhost:8090')
```

**MUST** implement Redis caching for performance:
```python
redis_client = redis.Redis(host='localhost', port=6379, db=0)
```

### Data Processing Standards

**MUST** use structured data processing with JSON files:
```python
async def load_json_async(file_path):
    async with aiofiles.open(file_path, 'r') as f:
        content = await f.read()
        return orjson.loads(content)
```

**MUST** implement data validation and cleaning:
```python
def replace_nan_inf_with_none(obj):
    if isinstance(obj, dict):
        return {k: replace_nan_inf_with_none(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [replace_nan_inf_with_none(item) for item in obj]
    elif isinstance(obj, float) and (np.isnan(obj) or np.isinf(obj)):
        return None
    return obj
```

### ML Model Integration

**MUST** place models in `app/ml_models/` directory
**MUST** implement standardized model interfaces:
```python
class ModelInterface:
    async def predict(self, data: Dict[str, Any]) -> Dict[str, Any]:
        # Implementation
        pass
```

**MUST** use async patterns for model inference
**MUST** implement proper error handling for model failures

### API Response Formatting

**MUST** return consistent JSON response structure:
```python
{
    "data": result_data,
    "status": "success",
    "timestamp": datetime.now().isoformat()
}
```

**MUST** handle errors gracefully:
```python
@app.exception_handler(HTTPException)
async def http_exception_handler(request, exc):
    return JSONResponse(
        status_code=exc.status_code,
        content={"error": exc.detail}
    )
```

### Security and Authentication

**MUST** implement API key authentication:
```python
api_key_header = APIKeyHeader(name="X-API-Key")
async def get_api_key(api_key: str = Security(api_key_header)):
    if not api_key:
        raise HTTPException(status_code=401, detail="API key required")
    return api_key
```

**MUST** use rate limiting:
```python
limiter = Limiter(key_func=get_remote_address)
app.state.limiter = limiter
```

### File Organization Standards

**MUST** follow naming conventions:
- Cron jobs: `cron_<functionality>.py`
- ML models: `<model_type>.py`
- Utility functions: `<purpose>.py`

**MUST** organize imports in this order:
1. Standard library imports
2. Third-party library imports
3. Local application imports

### Error Handling Patterns

**MUST** implement comprehensive error handling:
```python
try:
    result = await fetch_data()
except aiohttp.ClientError as e:
    logger.error(f"Network error: {e}")
    raise HTTPException(status_code=503, detail="Service unavailable")
except Exception as e:
    logger.error(f"Unexpected error: {e}")
    raise HTTPException(status_code=500, detail="Internal server error")
```

### Caching Patterns

**MUST** implement Redis caching for expensive operations:
```python
cache_key = f"ticker_data:{ticker}"
cached_data = redis_client.get(cache_key)
if cached_data:
    return orjson.loads(cached_data)
```

**MUST** set appropriate cache expiration times
**MUST** implement cache invalidation strategies

## Functionality Implementation Standards

### Adding New API Endpoints

1. **MUST** add endpoint to `app/main.py`
2. **MUST** create corresponding function in `app/functions.py`
3. **MUST** use `@function_tool` decorator
4. **MUST** implement proper error handling
5. **MUST** add to `all_tools` list in main.py

### Adding New Cron Jobs

1. **MUST** create script in `app/cron_<name>.py`
2. **MUST** add scheduling function to `primary_cron_job.py`
3. **MUST** implement timezone-aware scheduling
4. **MUST** add job status tracking
5. **MUST** implement proper error handling

### Adding New ML Models

1. **MUST** place model in `app/ml_models/`
2. **MUST** implement standardized interface
3. **MUST** add model loading to main.py
4. **MUST** implement async inference
5. **MUST** add proper error handling

### Data Processing Pipeline

1. **MUST** use async patterns for data fetching
2. **MUST** implement data validation
3. **MUST** use structured JSON storage
4. **MUST** implement caching strategies
5. **MUST** handle data cleaning and normalization

## Framework/Plugin/Third-party Library Usage Standards

### FastAPI Standards
- **MUST** use Pydantic for data validation
- **MUST** implement proper CORS configuration
- **MUST** use dependency injection for authentication
- **MUST** implement proper OpenAPI documentation

### Redis Usage
- **MUST** use connection pooling
- **MUST** implement proper error handling
- **MUST** set appropriate expiration times
- **MUST** implement cache invalidation

### SQLite Usage
- **MUST** use context managers
- **MUST** implement proper connection handling
- **MUST** use parameterized queries
- **MUST** implement proper error handling

### PocketBase Usage
- **MUST** use async patterns
- **MUST** implement proper error handling
- **MUST** use structured data models

## Workflow Standards

### Development Workflow
1. Create feature branch
2. Implement functionality following patterns
3. Add proper error handling
4. Test with sample data
5. Update documentation
6. Submit pull request

### Data Collection Workflow
1. Create cron job script
2. Add to primary_cron_job.py
3. Implement timezone-aware scheduling
4. Add error handling and logging
5. Test with sample data
6. Deploy and monitor

### API Development Workflow
1. Define Pydantic models
2. Create function in functions.py
3. Add endpoint to main.py
4. Add to all_tools list
5. Implement error handling
6. Test with sample requests
7. Update documentation

## Key File Interaction Standards

### Multi-file Coordination Requirements

**When modifying `app/main.py`:**
- **MUST** update `all_tools` list if adding new functions
- **MUST** update import statements
- **MUST** update error handlers if needed

**When modifying `app/functions.py`:**
- **MUST** add function to `all_tools` in main.py
- **MUST** update imports if needed
- **MUST** ensure async patterns are used

**When adding new cron jobs:**
- **MUST** add scheduling function to `primary_cron_job.py`
- **MUST** update job_status dictionary
- **MUST** implement proper timezone handling

**When modifying ML models:**
- **MUST** update model loading in main.py
- **MUST** ensure async patterns are used
- **MUST** update error handling

## AI Decision-making Standards

### Task Management Memory Rules
- **MUST** append new tasks to existing completed tasks
- **MUST** preserve task history and completed task records
- **MUST** use 'append' mode when adding new tasks to existing task lists
- **MUST** maintain continuity with previous development work
- **PROHIBITED** from clearing or overwriting completed tasks

### Priority Decision Tree
1. **Security Issues**: Highest priority - fix immediately
2. **Data Integrity Issues**: High priority - investigate and fix
3. **Performance Issues**: Medium priority - optimize as needed
4. **Feature Requests**: Low priority - implement when time permits

### Error Handling Decision Tree
1. **Network Errors**: Retry with exponential backoff
2. **Database Errors**: Log and return appropriate error response
3. **Validation Errors**: Return 400 Bad Request with details
4. **Authentication Errors**: Return 401 Unauthorized
5. **Rate Limit Errors**: Return 429 Too Many Requests

### Caching Decision Tree
1. **Frequently accessed data**: Cache for 1 hour
2. **Rarely accessed data**: Cache for 24 hours
3. **Real-time data**: No caching
4. **Historical data**: Cache for 1 week

## Prohibited Actions

### Code Quality Prohibitions
- **PROHIBITED**: Using synchronous patterns for I/O operations
- **PROHIBITED**: Hardcoding API keys or sensitive data
- **PROHIBITED**: Ignoring error handling
- **PROHIBITED**: Using global variables for state management
- **PROHIBITED**: Implementing blocking operations in async functions

### Architecture Prohibitions
- **PROHIBITED**: Adding endpoints without function_tool decorator
- **PROHIBITED**: Creating cron jobs without timezone handling
- **PROHIBITED**: Implementing database queries without proper connection management
- **PROHIBITED**: Adding ML models without standardized interfaces
- **PROHIBITED**: Implementing caching without proper invalidation

### Security Prohibitions
- **PROHIBITED**: Exposing sensitive data in API responses
- **PROHIBITED**: Implementing authentication without proper validation
- **PROHIBITED**: Using unvalidated user input
- **PROHIBITED**: Storing passwords in plain text
- **PROHIBITED**: Implementing rate limiting without proper configuration

### Performance Prohibitions
- **PROHIBITED**: Implementing blocking operations in async functions
- **PROHIBITED**: Not implementing caching for expensive operations
- **PROHIBITED**: Using inefficient database queries
- **PROHIBITED**: Implementing memory leaks
- **PROHIBITED**: Not implementing proper connection pooling

## Examples

### What Should Be Done
```python
@function_tool
async def get_ticker_data(tickers: List[str]) -> Dict[str, Any]:
    try:
        result = await fetch_data_async(tickers)
        return {"data": result, "status": "success"}
    except Exception as e:
        logger.error(f"Error fetching data: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")
```

### What Should Not Be Done
```python
def get_ticker_data(tickers):  # Missing async, function_tool decorator
    result = requests.get(url)  # Blocking operation
    return result.json()  # No error handling
``` 