from fastapi import FastAPI, Request
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
import os

# Create the FastAPI application
app = FastAPI()

# Set up Jinja2 templates
templates = Jinja2Templates(directory="templates")

# Mount static files for CSS/JS if needed
app.mount("/static", StaticFiles(directory="static"), name="static")

# Get the environment from environment variables
def get_environment():
    return os.getenv("APP_ENV", "production").capitalize()

# Define the homepage route
@app.get("/", include_in_schema=False)
def homepage(request: Request):
    return templates.TemplateResponse(
        "index.html",
        {"request": request, "environment": get_environment()}
    )