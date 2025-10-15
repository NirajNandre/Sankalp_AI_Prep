import streamlit as st
import requests
from datetime import datetime
import time

API_URL = "http://localhost:8000"

st.set_page_config(
    page_title="Group Discussion", 
    layout="wide", 
    initial_sidebar_state="expanded",
    page_icon="💬"
)

# Custom CSS
st.markdown("""
    <style>
    .user-message { 
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 15px 20px; 
        border-radius: 18px 18px 5px 18px; 
        margin: 10px 0 10px auto; 
        box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        max-width: 75%;
        margin-left: auto;
    }
    .member-a { 
        background-color: #E8F5E9; 
        padding: 15px 20px; 
        border-radius: 18px 18px 18px 5px; 
        margin: 10px 0; 
        border-left: 4px solid #4CAF50; 
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        max-width: 75%;
    }
    .member-b { 
        background-color: #FFF3E0; 
        padding: 15px 20px; 
        border-radius: 18px 18px 18px 5px; 
        margin: 10px 0; 
        border-left: 4px solid #FF9800; 
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        max-width: 75%;
    }
    .agent-name {
        font-weight: bold;
        font-size: 0.85em;
        margin-bottom: 5px;
        opacity: 0.7;
    }
    .timestamp {
        font-size: 0.7em;
        opacity: 0.5;
        margin-top: 5px;
    }
    </style>
""", unsafe_allow_html=True)

# Header
st.title("💬 AI Group Discussion")
st.markdown("**Join a dynamic discussion with two AI agents who think independently**")

# Sidebar
with st.sidebar:
    st.header("⚙️ Discussion Settings")
    
    # User ID
    if "user_id" not in st.session_state:
        st.session_state.user_id = f"user_{datetime.now().strftime('%H%M%S')}"
    
    user_id = st.text_input(
        "Your Name/ID", 
        value=st.session_state.user_id, 
        help="Your identifier in this discussion"
    )
    st.session_state.user_id = user_id
    
    st.divider()
    
    # Controls
    col1, col2 = st.columns(2)
    with col1:
        if st.button("🗑️ Clear", use_container_width=True):
            try:
                response = requests.post(f"{API_URL}/clear/{user_id}", timeout=5)
                if response.status_code == 200:
                    st.session_state.messages = []
                    st.session_state.session_state = {}
                    st.success("Cleared!")
                    time.sleep(0.3)
                    st.rerun()
            except:
                st.error("Failed")
    
    with col2:
        if st.button("🔄 Sync", use_container_width=True):
            try:
                response = requests.get(f"{API_URL}/history/{user_id}", timeout=5)
                if response.status_code == 200:
                    data = response.json()
                    st.session_state.messages = data.get("conversation_history", [])
                    st.success("Synced!")
                    time.sleep(0.3)
                    st.rerun()
            except:
                st.error("Failed")
    
    st.divider()
    
    # Stats
    st.markdown("### 📊 Discussion Stats")
    if "session_state" in st.session_state and st.session_state.session_state:
        col1, col2 = st.columns(2)
        with col1:
            st.metric("Your Turns", st.session_state.session_state.get("turn", 0))
        with col2:
            st.metric("Total Messages", st.session_state.session_state.get("messages", 0))
    else:
        st.info("No active discussion")
    
    st.divider()
    
    # Participants
    with st.expander("👥 Participants"):
        st.markdown("""
        **👤 You**  
        The human in the discussion
        
        **🟢 Member A**  
        AI agent with independent thinking
        
        **🟠 Member B**  
        AI agent with independent thinking
        
        *Both agents can agree with you, disagree with you, or debate with each other!*
        """)
    
    # Tips
    with st.expander("💡 Discussion Tips"):
        st.markdown("""
        - **Ask open-ended questions** for richer discussions
        - **Take sides** - support one agent over another
        - **Challenge them** - they'll defend their views
        - **Ask follow-ups** - they remember context
        - **Be natural** - talk like you would with friends
        """)
    
    # Connection status
    st.divider()
    try:
        response = requests.get(f"{API_URL}/history/{user_id}", timeout=2)
        if response.status_code == 200:
            st.success("🟢 Connected")
        else:
            st.warning("🟡 Issues")
    except:
        st.error("🔴 Offline")
        st.caption("`uvicorn main:app --reload`")

# Initialize session state
if "messages" not in st.session_state:
    st.session_state.messages = []

if "session_state" not in st.session_state:
    st.session_state.session_state = {}

# Chat display
st.subheader("🗨️ Discussion Thread")

chat_container = st.container()

with chat_container:
    if len(st.session_state.messages) == 0:
        st.info("👋 **Welcome to the discussion!** Start by sharing your thoughts or asking a question below.")
        
        # Show example starter
        st.markdown("**Example starters:**")
        examples = [
            "What do you both think about AI safety?",
            "I believe renewable energy is the future. Thoughts?",
            "Can someone explain blockchain to me?",
        ]
        for ex in examples:
            st.caption(f"• {ex}")
    else:
        for idx, msg in enumerate(st.session_state.messages):
            role = msg["role"]
            content = msg["content"]
            
            if role == "user":
                st.markdown(f"""
                <div class='user-message'>
                    <div class='agent-name'>👤 {user_id}</div>
                    {content}
                </div>
                """, unsafe_allow_html=True)
                
            elif role == "member_a":
                st.markdown(f"""
                <div class='member-a'>
                    <div class='agent-name'>🟢 Member A</div>
                    {content}
                </div>
                """, unsafe_allow_html=True)
                
            elif role == "member_b":
                st.markdown(f"""
                <div class='member-b'>
                    <div class='agent-name'>🟠 Member B</div>
                    {content}
                </div>
                """, unsafe_allow_html=True)

# Input section
st.divider()

col1, col2 = st.columns([5, 1])

with col1:
    user_input = st.text_area(
        "Your Message",
        placeholder="Share your thoughts, ask a question, or respond to the agents...",
        height=100,
        key="user_input_area",
        label_visibility="collapsed"
    )

with col2:
    st.write("")
    st.write("")
    send_button = st.button("💬 Send", use_container_width=True, type="primary")

# Handle send
if send_button:
    if not user_input or not user_input.strip():
        st.warning("⚠️ Please type something first")
    else:
        with st.spinner("💭 Discussion in progress..."):
            progress_bar = st.progress(0)
            status_text = st.empty()
            
            try:
                payload = {
                    "user_id": user_id,
                    "user_input": user_input.strip()
                }
                
                status_text.text("📤 Sharing with group...")
                progress_bar.progress(20)
                
                response = requests.post(f"{API_URL}/ask", json=payload, timeout=120)
                progress_bar.progress(50)
                
                response.raise_for_status()
                data = response.json()
                
                status_text.text("🎯 Agents responding...")
                progress_bar.progress(80)
                
                if data.get("success"):
                    st.session_state.messages = data.get("conversation_history", [])
                    st.session_state.session_state = data.get("session_state", {})
                    
                    progress_bar.progress(100)
                    status_text.text("✅ Responses received!")
                    
                    time.sleep(0.3)
                    progress_bar.empty()
                    status_text.empty()
                    
                    st.rerun()
                else:
                    progress_bar.empty()
                    status_text.empty()
                    st.error(f"❌ Error: {data.get('error', 'Unknown error')}")
                    
            except requests.exceptions.ConnectionError:
                progress_bar.empty()
                status_text.empty()
                st.error("❌ Cannot connect to backend")
                st.info("Run: `uvicorn main:app --reload`")
                
            except requests.exceptions.Timeout:
                progress_bar.empty()
                status_text.empty()
                st.error("⏱️ Agents are taking too long")
                
            except Exception as e:
                progress_bar.empty()
                status_text.empty()
                st.error(f"❌ Error: {str(e)}")

# Quick actions
with st.expander("⚡ Quick Responses"):
    col1, col2, col3 = st.columns(3)
    
    with col1:
        if st.button("👍 I agree", use_container_width=True):
            st.session_state.user_input_area = "I agree with that point"
            st.rerun()
        
        if st.button("🤔 Interesting", use_container_width=True):
            st.session_state.user_input_area = "That's an interesting perspective"
            st.rerun()
    
    with col2:
        if st.button("👎 I disagree", use_container_width=True):
            st.session_state.user_input_area = "I disagree with that"
            st.rerun()
        
        if st.button("❓ Why?", use_container_width=True):
            st.session_state.user_input_area = "Why do you think that?"
            st.rerun()
    
    with col3:
        if st.button("📚 Tell me more", use_container_width=True):
            st.session_state.user_input_area = "Can you elaborate on that?"
            st.rerun()
        
        if st.button("🎯 Example?", use_container_width=True):
            st.session_state.user_input_area = "Can you give me an example?"
            st.rerun()

# Footer
st.divider()
st.markdown("""
<div style='text-align: center; color: #666; padding: 10px;'>
    <small>💬 Natural Group Discussion System | Powered by Google ADK</small>
</div>
""", unsafe_allow_html=True)