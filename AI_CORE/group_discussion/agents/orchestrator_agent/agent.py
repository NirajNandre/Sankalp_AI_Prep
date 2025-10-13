from google.adk.agents import SequentialAgent
from ..member_a_agent.agent import agent as member_a_agent
from ..member_b_agent.agent import agent as member_b_agent

orchestrator_agent = SequentialAgent(
    name="orchestrator_agent",
    sub_agents=[member_a_agent, member_b_agent]
)

agent = orchestrator_agent
