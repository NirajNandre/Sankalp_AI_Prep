import streamlit as st
import requests
from datetime import datetime
import json

# Configuration
API_BASE_URL = "http://localhost:8000"

# Page configuration
st.set_page_config(
    page_title="Interview Agent",
    page_icon="💼",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Custom CSS for better styling
st.markdown("""
<style>
    .main-header {
        font-size: 2.5rem;
        font-weight: bold;
        color: #1f77b4;
        text-align: center;
        margin-bottom: 2rem;
    }
    .chat-message {
        padding: 1rem;
        border-radius: 0.5rem;
        margin-bottom: 1rem;
        display: flex;
        flex-direction: column;
    }
    .user-message {
        background-color: #e3f2fd;
        margin-left: 20%;
    }
    .agent-message {
        background-color: #f5f5f5;
        margin-right: 20%;
    }
    .timestamp {
        font-size: 0.75rem;
        color: #666;
        margin-top: 0.25rem;
    }
    .sidebar-section {
        background-color: #f8f9fa;
        padding: 1rem;
        border-radius: 0.5rem;
        margin-bottom: 1rem;
    }
    .status-badge {
        padding: 0.25rem 0.75rem;
        border-radius: 1rem;
        font-size: 0.875rem;
        font-weight: bold;
    }
    .status-active {
        background-color: #d4edda;
        color: #155724;
    }
    .status-inactive {
        background-color: #f8d7da;
        color: #721c24;
    }
</style>
""", unsafe_allow_html=True)


def init_session_state():
    """Initialize session state variables."""
    if 'messages' not in st.session_state:
        st.session_state.messages = []
    if 'user_id' not in st.session_state:
        st.session_state.user_id = f"user_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
    if 'session_id' not in st.session_state:
        st.session_state.session_id = None
    if 'api_healthy' not in st.session_state:
        st.session_state.api_healthy = check_api_health()


def check_api_health():
    """Check if the API is running."""
    try:
        response = requests.get(f"{API_BASE_URL}/health", timeout=2)
        return response.status_code == 200
    except:
        return False


def send_message(user_input: str, user_id: str):
    """Send a message to the interview agent API."""
    try:
        response = requests.post(
            f"{API_BASE_URL}/interview/chat",
            json={"user_input": user_input, "user_id": user_id},
            timeout=30
        )
        
        if response.status_code == 200:
            return response.json()
        else:
            return {
                "status": "error",
                "error": f"API returned status code {response.status_code}: {response.text}"
            }
    except requests.exceptions.ConnectionError:
        return {
            "status": "error",
            "error": "Cannot connect to API. Make sure the FastAPI server is running."
        }
    except requests.exceptions.Timeout:
        return {
            "status": "error",
            "error": "Request timed out. The API took too long to respond."
        }
    except Exception as e:
        return {
            "status": "error",
            "error": f"An error occurred: {str(e)}"
        }


def get_session_info(user_id: str):
    """Get session information for a user."""
    try:
        response = requests.get(f"{API_BASE_URL}/interview/session/{user_id}", timeout=5)
        if response.status_code == 200:
            return response.json()
        return None
    except:
        return None


def clear_session(user_id: str):
    """Clear the session for a user."""
    try:
        response = requests.delete(f"{API_BASE_URL}/interview/session/{user_id}", timeout=5)
        return response.status_code == 200
    except:
        return False


def display_message(role: str, content: str, timestamp: str):
    """Display a chat message."""
    css_class = "user-message" if role == "user" else "agent-message"
    role_emoji = "👤" if role == "user" else "🤖"
    role_label = "You" if role == "user" else "Interview Agent"
    
    st.markdown(f"""
    <div class="chat-message {css_class}">
        <div><strong>{role_emoji} {role_label}</strong></div>
        <div>{content}</div>
        <div class="timestamp">{timestamp}</div>
    </div>
    """, unsafe_allow_html=True)


def main():
    init_session_state()
    
    # Sidebar
    with st.sidebar:
        st.markdown('<p class="main-header">⚙️ Settings</p>', unsafe_allow_html=True)
        
        # API Status
        st.markdown('<div class="sidebar-section">', unsafe_allow_html=True)
        st.subheader("API Status")
        if st.button("🔄 Check Connection", use_container_width=True):
            st.session_state.api_healthy = check_api_health()
        
        status_class = "status-active" if st.session_state.api_healthy else "status-inactive"
        status_text = "Connected ✓" if st.session_state.api_healthy else "Disconnected ✗"
        st.markdown(f'<span class="status-badge {status_class}">{status_text}</span>', unsafe_allow_html=True)
        st.markdown('</div>', unsafe_allow_html=True)
        
        # User Information
        st.markdown('<div class="sidebar-section">', unsafe_allow_html=True)
        st.subheader("User Information")
        
        # Allow user to set custom user_id
        custom_user_id = st.text_input(
            "User ID",
            value=st.session_state.user_id,
            help="Enter a unique identifier for this session"
        )
        
        if custom_user_id != st.session_state.user_id:
            st.session_state.user_id = custom_user_id
            st.session_state.messages = []
            st.session_state.session_id = None
            st.rerun()
        
        if st.session_state.session_id:
            st.info(f"**Session ID:** {st.session_state.session_id[:16]}...")
        st.markdown('</div>', unsafe_allow_html=True)
        
        # Session Management
        st.markdown('<div class="sidebar-section">', unsafe_allow_html=True)
        st.subheader("Session Management")
        
        col1, col2 = st.columns(2)
        
        with col1:
            if st.button("📊 View Session", use_container_width=True):
                session_info = get_session_info(st.session_state.user_id)
                if session_info:
                    st.json(session_info)
                else:
                    st.error("No session found")
        
        with col2:
            if st.button("🗑️ Clear Session", use_container_width=True):
                if clear_session(st.session_state.user_id):
                    st.session_state.messages = []
                    st.session_state.session_id = None
                    st.success("Session cleared!")
                    st.rerun()
                else:
                    st.error("Failed to clear session")
        
        st.markdown('</div>', unsafe_allow_html=True)
        
        # API Configuration
        st.markdown('<div class="sidebar-section">', unsafe_allow_html=True)
        st.subheader("API Configuration")
        st.text_input("API Base URL", value=API_BASE_URL, disabled=True)
        st.markdown('</div>', unsafe_allow_html=True)
        
        # Statistics
        st.markdown('<div class="sidebar-section">', unsafe_allow_html=True)
        st.subheader("Statistics")
        st.metric("Total Messages", len(st.session_state.messages))
        user_msgs = len([m for m in st.session_state.messages if m["role"] == "user"])
        agent_msgs = len([m for m in st.session_state.messages if m["role"] == "agent"])
        st.metric("Your Messages", user_msgs)
        st.metric("Agent Responses", agent_msgs)
        st.markdown('</div>', unsafe_allow_html=True)
    
    # Main content
    st.markdown('<p class="main-header">💼 Interview Agent</p>', unsafe_allow_html=True)
    
    # Warning if API is not healthy
    if not st.session_state.api_healthy:
        st.error("⚠️ Cannot connect to the API. Please make sure the FastAPI server is running on http://localhost:8000")
        st.code("python main.py", language="bash")
    
    # Chat container
    chat_container = st.container()
    
    with chat_container:
        # Display chat history
        if not st.session_state.messages:
            st.info("👋 Welcome! Start your interview by typing a message below.")
        else:
            for message in st.session_state.messages:
                display_message(
                    message["role"],
                    message["content"],
                    message["timestamp"]
                )
    
    # Input area
    st.markdown("---")
    
    col1, col2 = st.columns([5, 1])
    
    with col1:
        user_input = st.text_input(
            "Your message:",
            key="user_input",
            placeholder="Type your message here...",
            label_visibility="collapsed"
        )
    
    with col2:
        send_button = st.button("📤 Send", use_container_width=True, type="primary")
    
    # Handle sending message
    if send_button and user_input:
        if not st.session_state.api_healthy:
            st.error("Cannot send message. API is not available.")
        else:
            # Add user message
            timestamp = datetime.now().strftime("%H:%M:%S")
            st.session_state.messages.append({
                "role": "user",
                "content": user_input,
                "timestamp": timestamp
            })
            
            # Send to API
            with st.spinner("🤔 Interview Agent is thinking..."):
                result = send_message(user_input, st.session_state.user_id)
            
            if result.get("status") == "error":
                st.error(f"Error: {result.get('error')}")
            else:
                # Add agent response
                agent_timestamp = datetime.now().strftime("%H:%M:%S")
                st.session_state.messages.append({
                    "role": "agent",
                    "content": result.get("response", "No response received"),
                    "timestamp": agent_timestamp
                })
                
                # Update session_id
                if result.get("session_id"):
                    st.session_state.session_id = result.get("session_id")
            
            # Rerun to clear input and show new messages
            st.rerun()
    
    # Tips section
    with st.expander("💡 Tips for using the Interview Agent"):
        st.markdown("""
        - **Be clear and specific** in your responses
        - **Take your time** to think through your answers
        - **Ask for clarification** if you don't understand a question
        - **Use the sidebar** to view session details or start fresh
        - **Check the API status** if messages aren't sending
        """)


if __name__ == "__main__":
    main()