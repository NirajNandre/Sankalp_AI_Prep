import streamlit as st
import requests
from datetime import datetime
import time

API_URL = "http://localhost:8000"

st.set_page_config(
    page_title="Multi-Agent Discussion", 
    layout="wide", 
    initial_sidebar_state="expanded",
    page_icon="🤖"
)

# Custom CSS
st.markdown("""
    <style>
    .user-message { 
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 15px 20px; 
        border-radius: 15px 15px 5px 15px; 
        margin: 10px 0; 
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        max-width: 80%;
        margin-left: auto;
    }
    .member-a { 
        background-color: #F3E5F5; 
        padding: 15px 20px; 
        border-radius: 15px 15px 15px 5px; 
        margin: 10px 0; 
        border-left: 4px solid #9C27B0; 
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        max-width: 80%;
    }
    .member-b { 
        background-color: #FFF3E0; 
        padding: 15px 20px; 
        border-radius: 15px 15px 15px 5px; 
        margin: 10px 0; 
        border-left: 4px solid #FF9800; 
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        max-width: 80%;
    }
    .agent-name {
        font-weight: bold;
        font-size: 0.9em;
        margin-bottom: 5px;
        opacity: 0.8;
    }
    .stTextArea textarea {
        border-radius: 10px;
    }
    </style>
""", unsafe_allow_html=True)

# Header
st.title("🤖 Multi-Agent Discussion Forum")
st.markdown("**Watch AI agents engage in dynamic discussions - supporting or challenging each other's viewpoints**")

# Sidebar
with st.sidebar:
    st.header("⚙️ Configuration")
    
    # User ID
    if "user_id" not in st.session_state:
        st.session_state.user_id = f"user_{datetime.now().strftime('%H%M%S')}"
    
    user_id = st.text_input(
        "User ID", 
        value=st.session_state.user_id, 
        help="Your unique session identifier"
    )
    st.session_state.user_id = user_id
    
    st.divider()
    
    # Clear history
    col1, col2 = st.columns(2)
    with col1:
        if st.button("🗑️ Clear", use_container_width=True):
            try:
                response = requests.post(f"{API_URL}/clear/{user_id}", timeout=5)
                if response.status_code == 200:
                    st.session_state.messages = []
                    st.session_state.session_state = {}
                    st.success("Cleared!")
                    time.sleep(0.5)
                    st.rerun()
            except:
                st.error("Failed to clear")
    
    with col2:
        if st.button("🔄 Refresh", use_container_width=True):
            try:
                response = requests.get(f"{API_URL}/history/{user_id}", timeout=5)
                if response.status_code == 200:
                    data = response.json()
                    st.session_state.messages = data.get("conversation_history", [])
                    st.success("Refreshed!")
                    time.sleep(0.5)
                    st.rerun()
            except:
                st.error("Failed to refresh")
    
    st.divider()
    
    # Stats
    st.markdown("### 📊 Session Stats")
    if "session_state" in st.session_state and st.session_state.session_state:
        col1, col2 = st.columns(2)
        with col1:
            st.metric("🔄 Turns", st.session_state.session_state.get("turn", 0))
        with col2:
            st.metric("💬 Messages", st.session_state.session_state.get("messages", 0))
    else:
        st.info("Start chatting to see stats")
    
    st.divider()
    
    # Agent info
    with st.expander("👥 Meet the Agents"):
        st.markdown("""
        **🟣 Member A**  
        Provides initial perspectives and reasoning
        
        **🟠 Member B**  
        Responds by supporting, building upon, or challenging Member A's points
        """)
    
    # Instructions
    with st.expander("ℹ️ How to Use"):
        st.markdown("""
        1. Type your question in the text box below
        2. Click **Send** to start the discussion
        3. Watch both agents respond
        4. Ask follow-up questions to continue
        5. Agents remember context from previous messages
        """)
    
    # Connection status
    st.divider()
    try:
        response = requests.get(f"{API_URL}/history/{user_id}", timeout=2)
        if response.status_code == 200:
            st.success("🟢 Backend Connected")
        else:
            st.warning("🟡 Backend Issues")
    except:
        st.error("🔴 Backend Offline")
        st.caption("Run: `uvicorn main:app --reload`")

# Initialize session state
if "messages" not in st.session_state:
    st.session_state.messages = []

if "session_state" not in st.session_state:
    st.session_state.session_state = {}

# Chat display area
st.subheader("💭 Discussion Thread")

chat_container = st.container()

with chat_container:
    if len(st.session_state.messages) == 0:
        st.info("👋 Welcome! Ask a question below to start the discussion between our AI agents.")
    else:
        for idx, msg in enumerate(st.session_state.messages):
            if msg["role"] == "user":
                st.markdown(f"""
                <div class='user-message'>
                    <div class='agent-name'>👤 You</div>
                    {msg['content']}
                </div>
                """, unsafe_allow_html=True)
            elif msg["role"] == "member_a":
                st.markdown(f"""
                <div class='member-a'>
                    <div class='agent-name'>🟣 Member A</div>
                    {msg['content']}
                </div>
                """, unsafe_allow_html=True)
            elif msg["role"] == "member_b":
                st.markdown(f"""
                <div class='member-b'>
                    <div class='agent-name'>🟠 Member B</div>
                    {msg['content']}
                </div>
                """, unsafe_allow_html=True)

# Input section
st.divider()

# Create columns for better layout
input_col, button_col = st.columns([6, 1])

with input_col:
    user_input = st.text_area(
        "Your Question",
        placeholder="Ask anything... (e.g., 'What are the pros and cons of artificial intelligence?')",
        height=100,
        key="user_input_area",
        label_visibility="collapsed"
    )

with button_col:
    st.write("")
    st.write("")
    send_button = st.button("📤 Send", use_container_width=True, type="primary")

# Handle send
if send_button:
    if not user_input or not user_input.strip():
        st.warning("⚠️ Please enter a question first")
    else:
        # Show loading state
        with st.spinner("🤔 Agents are thinking..."):
            progress_bar = st.progress(0)
            status_text = st.empty()
            
            try:
                payload = {
                    "user_id": user_id,
                    "user_input": user_input.strip()
                }
                
                status_text.text("📤 Sending your question...")
                progress_bar.progress(20)
                
                response = requests.post(f"{API_URL}/ask", json=payload, timeout=120)
                progress_bar.progress(50)
                
                response.raise_for_status()
                data = response.json()
                
                status_text.text("📝 Processing responses...")
                progress_bar.progress(80)
                
                if data.get("success"):
                    # Update state
                    st.session_state.messages = data.get("conversation_history", [])
                    st.session_state.session_state = data.get("session_state", {})
                    
                    progress_bar.progress(100)
                    status_text.text("✅ Discussion complete!")
                    
                    time.sleep(0.5)
                    progress_bar.empty()
                    status_text.empty()
                    
                    st.rerun()
                else:
                    progress_bar.empty()
                    status_text.empty()
                    st.error(f"❌ Error: {data.get('error', 'Unknown error occurred')}")
                    
            except requests.exceptions.ConnectionError:
                progress_bar.empty()
                status_text.empty()
                st.error("❌ Cannot connect to backend server")
                st.info("Make sure FastAPI is running: `uvicorn main:app --reload`")
                
            except requests.exceptions.Timeout:
                progress_bar.empty()
                status_text.empty()
                st.error("⏱️ Request timed out - agents took too long to respond")
                
            except requests.exceptions.RequestException as e:
                progress_bar.empty()
                status_text.empty()
                st.error(f"❌ Network error: {str(e)}")
                
            except Exception as e:
                progress_bar.empty()
                status_text.empty()
                st.error(f"❌ Unexpected error: {str(e)}")

# Quick examples
with st.expander("💡 Example Questions"):
    col1, col2 = st.columns(2)
    
    with col1:
        if st.button("What are the benefits of renewable energy?", use_container_width=True):
            st.session_state.user_input_area = "What are the benefits of renewable energy?"
            st.rerun()
        
        if st.button("Should AI be regulated?", use_container_width=True):
            st.session_state.user_input_area = "Should AI be regulated?"
            st.rerun()
    
    with col2:
        if st.button("Is remote work better than office work?", use_container_width=True):
            st.session_state.user_input_area = "Is remote work better than office work?"
            st.rerun()
        
        if st.button("What's the future of space exploration?", use_container_width=True):
            st.session_state.user_input_area = "What's the future of space exploration?"
            st.rerun()

# Footer
st.divider()
st.markdown("""
<div style='text-align: center; color: #666; padding: 10px;'>
    <small>🤖 Powered by Google ADK & FastAPI | Multi-Agent Discussion System</small>
</div>
""", unsafe_allow_html=True)