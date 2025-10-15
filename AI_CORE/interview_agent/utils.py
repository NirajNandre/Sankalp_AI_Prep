# utils.py
import asyncio
from google.adk.runners import Runner
from google.adk.sessions import InMemorySessionService
from google.genai import types
from dotenv import load_dotenv


from agent import interview_agent


load_dotenv()

session_service = InMemorySessionService()
runner = Runner(
    app_name="interview_app", 
    agent=interview_agent, 
    session_service=session_service
)


class Colors:
    RESET = "\033[0m"
    BOLD = "\033[1m"
    CYAN = "\033[36m"
    GREEN = "\033[32m"
    RED = "\033[31m"
    YELLOW = "\033[33m"
    BG_GREEN = "\033[42m"
    BG_RED = "\033[41m"
    WHITE = "\033[37m"


async def handle_interview_chat(user_input: str, user_id: str):
    """
    Handles interview chat interaction with proper session management.
    
    Args:
        user_input: The user's message/query
        user_id: Unique identifier for the user
        
    Returns:
        dict: Response containing the agent's reply or error message
    """
   
    try:
        session = await session_service.get_session(
            app_name="interview_app", 
            user_id=user_id
        )
    except:
        session = None
    
    if not session:
       
        session = await session_service.create_session(
            app_name="interview_app", 
            user_id=user_id, 
            state={"interaction_history": []}
        )
    
    
    content = types.Content(
        role="user", 
        parts=[types.Part(text=user_input)]
    )
    
    responses = []
    final_response = None
    
    try:
        async for chunk in runner.run_async(
            user_id=user_id, 
            session_id=session.id, 
            new_message=content
        ):
            if chunk.content and chunk.content.parts:
                for part in chunk.content.parts:
                    if hasattr(part, 'text') and part.text:
                        responses.append(part.text)
            
           
            if chunk.is_final_response and chunk.content and chunk.content.parts:
                final_response = chunk.content.parts[0].text if hasattr(chunk.content.parts[0], 'text') else None
        
       
        full_response = ''.join(responses) if responses else final_response
        
        return {
            "response": full_response,
            "session_id": session.id,
            "status": "success"
        }
        
    except Exception as e:
        print(f"{Colors.RED}Error during agent run: {e}{Colors.RESET}")
        import traceback
        traceback.print_exc()
        return {
            "error": str(e),
            "status": "error"
        }


async def add_to_interaction_history(user_id: str, role: str, content: str):
    """
    Add an entry to the interaction history.
    
    Args:
        user_id: User identifier
        role: Role of the message sender (user/agent)
        content: Message content
    """
    try:
        session = await session_service.get_session(
            app_name="interview_app",
            user_id=user_id
        )
        
        if session:
            history = session.state.get("interaction_history", [])
            history.append({
                "role": role,
                "content": content
            })
          
            
    except Exception as e:
        print(f"{Colors.RED}Error updating interaction history: {e}{Colors.RESET}")


async def get_session_state(user_id: str):
    """
    Retrieve the current session state for a user.
    
    Args:
        user_id: User identifier
        
    Returns:
        dict: Session state or None if session doesn't exist
    """
    try:
        session = await session_service.get_session(
            app_name="interview_app",
            user_id=user_id
        )
        return session.state if session else None
    except:
        return None


async def clear_user_session(user_id: str):
    """
    Clear the session for a user by creating a fresh one.
    
    Args:
        user_id: User identifier
        
    Returns:
        dict: New session information or error
    """
    try:
        
        session = await session_service.create_session(
            app_name="interview_app",
            user_id=user_id,
            state={"interaction_history": []}
        )
        return {
            "message": "Session cleared successfully",
            "user_id": user_id,
            "new_session_id": session.id,
            "status": "success"
        }
    except Exception as e:
        print(f"{Colors.RED}Error clearing session: {e}{Colors.RESET}")
        return {
            "error": str(e),
            "status": "error"
        }


async def process_agent_response(event):
    """Process and display agent response events."""
    final_response = None
    
    if event.content and event.content.parts:
        for part in event.content.parts:
            if hasattr(part, "text") and part.text and not part.text.isspace():
                print(f"{Colors.CYAN}{part.text.strip()}{Colors.RESET}")
    
    if event.is_final_response():
        if (
            event.content
            and event.content.parts
            and hasattr(event.content.parts[0], "text")
            and event.content.parts[0].text
        ):
            final_response = event.content.parts[0].text.strip()
    
    return final_response