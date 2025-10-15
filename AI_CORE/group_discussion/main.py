from fastapi import FastAPI
from pydantic import BaseModel
from dotenv import load_dotenv
from google.adk.runners import Runner
from google.adk.sessions import InMemorySessionService
from google.genai import types
from agents.member_a_agent.agent import agent as member_a_agent
from agents.member_b_agent.agent import agent as member_b_agent
import logging
import random

load_dotenv()

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI()

class QueryRequest(BaseModel):
    user_id: str
    user_input: str


session_service = InMemorySessionService()
conversation_history = {}

async def run_agent(agent, user_id: str, session_id: str, conversation_context: str):
    """Run an agent with full conversation context"""
    runner = Runner(
        agent=agent,
        app_name='adk_conversation_app',
        session_service=session_service
    )
    
    content = types.Content(
        role="user",
        parts=[types.Part(text=conversation_context)]
    )
    
    response_text = ""
    async for chunk in runner.run_async(
        user_id=user_id,
        session_id=session_id,
        new_message=content
    ):
        if chunk and hasattr(chunk, 'content'):
            if hasattr(chunk.content, 'text'):
                response_text += chunk.content.text
            elif hasattr(chunk.content, 'parts'):
                for part in chunk.content.parts:
                    if hasattr(part, 'text'):
                        response_text += part.text
        elif chunk and hasattr(chunk, 'text'):
            response_text += chunk.text
    
    return response_text.strip()

def build_conversation_context(messages):
    """Build a readable conversation context"""
    if not messages:
        return ""
    
    context = "ONGOING GROUP DISCUSSION:\n\n"
    for msg in messages:
        role_name = {
            "user": "User",
            "member_a": "Member A",
            "member_b": "Member B"
        }.get(msg["role"], msg["role"])
        context += f"{role_name}: {msg['content']}\n\n"
    
    context += "Now respond to the discussion naturally. You can address anyone or everyone:"
    return context

@app.post("/ask")
async def ask(request: QueryRequest):
    try:
        logger.info(f"Request from {request.user_id}: {request.user_input}")
        
        if request.user_id not in conversation_history:
            conversation_history[request.user_id] = []
     
        session = await session_service.create_session(
            app_name='adk_conversation_app',
            user_id=request.user_id,
            state={'turn': 0, 'messages': 0}
        )
        
        
        conversation_history[request.user_id].append({
            "role": "user",
            "content": request.user_input
        })
        
      
        context = build_conversation_context(conversation_history[request.user_id])
        
      
        agents = [
            ("member_a", member_a_agent),
            ("member_b", member_b_agent)
        ]
        random.shuffle(agents)
        
        responses = {}
   
        first_agent_name, first_agent = agents[0]
        logger.info(f"Running {first_agent_name}...")
        
        first_response = await run_agent(
            first_agent,
            request.user_id,
            session.id,
            context
        )
        
        responses[first_agent_name] = first_response
        
      
        conversation_history[request.user_id].append({
            "role": first_agent_name,
            "content": first_response
        })
        
       
        second_agent_name, second_agent = agents[1]
        logger.info(f"Running {second_agent_name}...")
        
        updated_context = build_conversation_context(conversation_history[request.user_id])
        
        second_response = await run_agent(
            second_agent,
            request.user_id,
            session.id,
            updated_context
        )
        
        responses[second_agent_name] = second_response
        
      
        conversation_history[request.user_id].append({
            "role": second_agent_name,
            "content": second_response
        })
        
       
        session.state['turn'] = len([m for m in conversation_history[request.user_id] if m["role"] == "user"])
        session.state['messages'] = len(conversation_history[request.user_id])
        
        return {
            "responses": responses,
            "conversation_history": conversation_history[request.user_id],
            "session_state": session.state,
            "success": True
        }
    except Exception as e:
        logger.error(f"Error: {str(e)}", exc_info=True)
        return {"error": str(e), "success": False}

@app.get("/history/{user_id}")
async def get_history(user_id: str):
    return {
        "conversation_history": conversation_history.get(user_id, []),
        "success": True
    }

@app.post("/clear/{user_id}")
async def clear_history(user_id: str):
    if user_id in conversation_history:
        conversation_history[user_id] = []
    return {"message": f"History cleared for {user_id}", "success": True}