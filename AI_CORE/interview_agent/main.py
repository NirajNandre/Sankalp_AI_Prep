# main.py
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from utils import handle_interview_chat, get_session_state, clear_user_session
import uvicorn

app = FastAPI(title="Interview Agent API", version="1.0.0")


class InterviewRequest(BaseModel):
    user_input: str
    user_id: str


class InterviewResponse(BaseModel):
    response: str = None
    error: str = None
    status: str
    session_id: str = None

@app.get("/interview/greeting/{user_id}")
async def get_greeting(user_id: str):
    """
    Get an initial greeting to start the interview session.
    
    Args:
        user_id: User identifier
        
    Returns:
        Greeting message with session_id
    """
    if not user_id or not user_id.strip():
        raise HTTPException(status_code=400, detail="user_id cannot be empty")
    
    # Initialize session and get greeting
    result = await handle_interview_chat("", user_id)
    
    if result.get("status") == "error":
        raise HTTPException(status_code=500, detail=result.get("error"))
    
    return {
        "greeting": result.get("response"),
        "session_id": result.get("session_id"),
        "user_id": user_id
    }



@app.post("/interview/chat", response_model=InterviewResponse)
async def interview_chat(req: InterviewRequest):
    """
    Handle interview chat requests.
    
    Args:
        req: InterviewRequest containing user_input and user_id
        
    Returns:
        InterviewResponse with agent's response or error
    """
    if not req.user_input or not req.user_input.strip():
        raise HTTPException(status_code=400, detail="user_input cannot be empty")
    
    if not req.user_id or not req.user_id.strip():
        raise HTTPException(status_code=400, detail="user_id cannot be empty")
    
    result = await handle_interview_chat(req.user_input, req.user_id)
    
    if result.get("status") == "error":
        raise HTTPException(status_code=500, detail=result.get("error"))
    
    return InterviewResponse(
        response=result.get("response"),
        status=result.get("status"),
        session_id=result.get("session_id")
    )


@app.get("/interview/session/{user_id}")
async def get_session(user_id: str):
    """
    Retrieve the current session state for a user.
    
    Args:
        user_id: User identifier
        
    Returns:
        Session state or error message
    """
    state = await get_session_state(user_id)
    
    if state is None:
        raise HTTPException(status_code=404, detail="Session not found for user")
    
    return {"user_id": user_id, "state": state}


@app.delete("/interview/session/{user_id}")
async def clear_session(user_id: str):
    """
    Clear the session for a user (creates a fresh session).
    
    Args:
        user_id: User identifier
        
    Returns:
        Success message
    """
    result = await clear_user_session(user_id)
    
    if result.get("status") == "error":
        raise HTTPException(status_code=500, detail=result.get("error"))
    
    return {
        "message": result.get("message"),
        "user_id": result.get("user_id"),
        "new_session_id": result.get("new_session_id")
    }


@app.get("/")
def root():
    """Root endpoint providing API information."""
    return {
        "message": "Interview Agent API is running",
        "version": "1.0.0",
        "endpoints": {
            "POST /interview/chat": "Send a message to the interview agent",
            "GET /interview/session/{user_id}": "Get session state for a user",
            "DELETE /interview/session/{user_id}": "Clear session for a user"
        }
    }


@app.get("/health")
def health_check():
    """Health check endpoint."""
    return {"status": "healthy"}


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)