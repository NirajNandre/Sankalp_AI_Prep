# In AI_CORE/main.py

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# Import the 'app' instance from each of your agent's main files.
# We rename them on import to avoid naming conflicts.
from group_discussion.main import app as group_discussion_app
from interview_agent.main import app as interview_agent_app
from notes_generator.main import app as notes_generator_app
from quiz_generator.main import app as quiz_generator_app

# This is the main application that will run in Cloud Run
app = FastAPI(title="Sankalp AI Core Main Router")

# Add CORS middleware to allow all origins
# This should be placed before mounting the sub-applications
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods (GET, POST, etc.)
    allow_headers=["*"],  # Allows all headers
)

# Mount each agent's application onto a specific URL path.
# All requests to /interview-agent will be forwarded to interview_agent_app.
app.mount("/interview-agent", interview_agent_app)

# All requests to /quiz-generator will be forwarded to quiz_generator_app.
app.mount("/quiz-generator", quiz_generator_app)

# All requests to /group-discussion will be forwarded to group_discussion_app.
app.mount("/group-discussion", group_discussion_app)

# All requests to /notes-generator will be forwarded to notes_generator_app.
app.mount("/notes-generator", notes_generator_app)


@app.get("/")
def read_root():
    """A simple endpoint to confirm the router is running."""
    return {"message": "Sankalp AI Core is running. Access agents at their respective paths."}
