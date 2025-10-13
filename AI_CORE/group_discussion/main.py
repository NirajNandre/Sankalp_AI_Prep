from session_manager import create_session
from agents.orchestrator_agent import agent as orchestrator_agent
from dotenv import load_dotenv
load_dotenv()
from google.adk import Runner
 # Correct import for Runner

session = create_session("USER_ID")
runner = Runner(agent=orchestrator_agent, session=session)

result = runner.run(user_input="USER_QUESTION")
print(session.state)
