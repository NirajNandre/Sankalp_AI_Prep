from google.adk.agents import LlmAgent
from dotenv import load_dotenv
load_dotenv()

agent = LlmAgent(
    name="member_b_agent",
     model="gemini-2.5-flash",
    instruction="Respond by contradicting MemberA's response in a logical or creative manner.",
    output_key="member_b_response"
)
