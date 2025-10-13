from google.adk.agents import Agent
from dotenv import load_dotenv
load_dotenv() 

interview_agent = Agent(
    name="interview_agent",
    model="gemini-2.5-flash",
    description="Conducts interviews by asking targeted questions, guides user responses, and evaluates answers.",
    instruction="You are an expert interviewer. Ask thoughtful, structured questions and follow up to elicit deeper responses. Adapt your question flow based on user answers."
)

root_agent = interview_agent