from typing import Union, Dict, Any
from fastapi import FastAPI

def create_app() -> FastAPI:
    """Create and configure the FastAPI application."""
    app = FastAPI(
        title="Test API",
        description="Test API",
        version="0.1.0",
    )

    @app.get("/health")
    def health_check() -> Dict[str, str]:
        """Health check endpoint to verify the service is running."""
        return {"status": "ok"}

    @app.get("/")
    def read_root() -> Dict[str, str]:
        """Root endpoint returning a welcome message."""
        return {"Hello": "World"}

    return app

# Create the application instance
app = create_app()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
