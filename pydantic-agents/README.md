# Brokkr AI Agents

This directory contains the Python-based AI agent service for the Brokkr platform. It is built using FastAPI and Pydantic for type safety and validation.

## Features

- API endpoints for various AI agents
- Supabase integration for data access
- OpenAI and Anthropic integration for AI models
- Containerized deployment with Docker

## Available Agents

- **Account Management Agent**: Helps users manage their accounts through natural language
- **Technical Agent**: Provides technical assistance, code validation, and troubleshooting
- **Data Population Agent**: Generates reference data for the platform

## Getting Started

### Prerequisites

- Python 3.11+
- Docker (for containerized deployment)

### Local Development

1. Create a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Set up environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your API keys and Supabase credentials
   ```

4. Run the development server:
   ```bash
   uvicorn main:app --reload
   ```

5. Access the API documentation at http://localhost:8000/docs

### Docker Deployment

1. Build the Docker image:
   ```bash
   docker build -t brokkr/pydantic-agents .
   ```

2. Run the container:
   ```bash
   docker run -p 8000:8000 \
     -e SUPABASE_URL=your_supabase_url \
     -e SUPABASE_ANON_KEY=your_anon_key \
     -e SUPABASE_SERVICE_ROLE_KEY=your_service_role_key \
     -e OPENAI_API_KEY=your_openai_key \
     -e ANTHROPIC_API_KEY=your_anthropic_key \
     brokkr/pydantic-agents
   ```

## Testing

Run tests using pytest:

```bash
pip install -r requirements-test.txt
pytest
```

## API Documentation

When the service is running, visit:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Best Practices

All agents in the Pydantic AI service follow these best practices:

- **MCP Architecture**: Agents use the Model-Controller-Presenter pattern
  - Models: Define data structures using Pydantic for automatic validation
  - Agents: Implement core business logic with minimal dependencies
  - Controllers: Handle API requests, validation, and coordinate with agents
  - Presenters: Format data for API responses

- **ServiceResponse Pattern**: All methods return a consistent response format

- **Proper Model Definitions**: Models use Pydantic with descriptive fields

- **Comprehensive Error Handling**: All agent methods include try/except blocks

- **Dependency Injection**: External services use FastAPI dependency injection