import streamlit as st
import requests
import os
from dotenv import load_dotenv

load_dotenv()

# Page configuration
st.set_page_config(
    page_title="PDF Notes Generator",
    page_icon="📝",
    layout="wide",
    initial_sidebar_state="expanded"
)

st.title("📝 PDF Notes Generator")
st.markdown("Upload a PDF and generate intelligent notes on any topic from its content.")

# API Configuration
API_URL = "http://127.0.0.1:8000"

# Initialize session state
if "pdf_uploaded" not in st.session_state:
    st.session_state.pdf_uploaded = False

# Sidebar
with st.sidebar:
    st.header("⚙️ Settings")
    st.info("Make sure the FastAPI server is running on http://127.0.0.1:8000")
    
    if st.button("🔄 Check API Status", use_container_width=True):
        try:
            response = requests.get(f"{API_URL}/docs")
            st.success("✅ API is running!")
        except:
            st.error("❌ API is not running. Start the server with: uvicorn main:app --reload")

# Main content
col1, col2 = st.columns([1, 1])

with col1:
    st.header("📤 Upload PDF")
    uploaded_file = st.file_uploader("Choose a PDF file", type="pdf")
    
    if uploaded_file is not None:
        if st.button("Process PDF", use_container_width=True, type="primary"):
            try:
                files = {"file": (uploaded_file.name, uploaded_file.getvalue(), "application/pdf")}
                
                with st.spinner("Uploading and processing PDF..."):
                    response = requests.post(f"{API_URL}/upload_pdf/", files=files)
                
                if response.status_code == 200:
                    result = response.json()
                    st.session_state.pdf_uploaded = True
                    st.success("✅ PDF processed successfully!")
                    st.info(f"📊 {result['message']}")
                else:
                    st.error(f"❌ Error: {response.json()}")
            except requests.exceptions.ConnectionError:
                st.error("❌ Cannot connect to API. Make sure the server is running on http://127.0.0.1:8000")
            except Exception as e:
                st.error(f"❌ Error processing PDF: {str(e)}")

with col2:
    st.header("🔍 Query")
    
    if st.session_state.pdf_uploaded:
        query = st.text_input("What topic would you like notes on?", placeholder="e.g., Machine Learning basics")
        
        if st.button("Generate Notes", use_container_width=True, type="primary"):
            if query.strip():
                try:
                    with st.spinner("Generating notes..."):
                        response = requests.get(f"{API_URL}/query/", params={"q": query})
                    
                    if response.status_code == 200:
                        result = response.json()
                        st.success("✅ Notes generated!")
                        st.markdown(result["answer"])
                    else:
                        st.error(f"❌ Error: {response.json()}")
                except requests.exceptions.ConnectionError:
                    st.error("❌ Cannot connect to API. Make sure the server is running.")
                except Exception as e:
                    st.error(f"❌ Error generating notes: {str(e)}")
            else:
                st.warning("⚠️ Please enter a query.")
    else:
        st.info("📌 Please upload and process a PDF first to query it.")

# Footer
st.divider()
st.markdown(
    """
    <div style='text-align: center; color: gray; font-size: 12px;'>
        Powered by Google Gemini API | FastAPI | Streamlit
    </div>
    """,
    unsafe_allow_html=True
)