from google.adk.agents import LlmAgent
from dotenv import load_dotenv
load_dotenv()

agent = LlmAgent(
    name="member_a_agent",
     model="gemini-2.5-flash",
    instruction="Respond to the user's question. Always state your answer confidently.",
    output_key="member_a_response"
)
