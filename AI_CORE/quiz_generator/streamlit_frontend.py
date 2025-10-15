import streamlit as st
import requests
from typing import List, Optional
import json
from pydantic import BaseModel, Field

# --- Configuration ---
# Set the base URL for your running FastAPI application
# IMPORTANT: Change this if your FastAPI server is running on a different port/host.
FASTAPI_BASE_URL = "http://127.0.0.1:8000" 

# --- Pydantic Models (Replicated for Frontend Consistency) ---
# NOTE: These are only used for type hinting and data structure clarity in the frontend.
class QuizOption(BaseModel):
    label: str  # A, B, C, D
    text: str

class QuizQuestion(BaseModel):
    question_number: int
    question_text: str
    options: List[QuizOption]
    correct_answer: str

class QuizResponse(BaseModel):
    topic: str
    total_questions: int
    questions: List[QuizQuestion]

class SubmitAnswerRequest(BaseModel):
    question_number: int
    selected_answer: str

class AnswerFeedback(BaseModel):
    is_correct: bool
    correct_answer: str
    explanation: Optional[str] = None

# --- API Interaction Functions ---

@st.cache_data(show_spinner="Uploading and processing PDF...")
def upload_pdf_to_api(uploaded_file):
    """Calls the /upload-pdf/ endpoint."""
    url = f"{FASTAPI_BASE_URL}/upload-pdf/"
    files = {'file': uploaded_file}
    try:
        response = requests.post(url, files=files)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        st.error(f"Error connecting to API or processing PDF: {e}")
        st.error(f"Response: {response.text if 'response' in locals() else 'N/A'}")
        return None

def generate_quiz_from_api(topic: str, num_questions: int):
    """Calls the /generate-quiz/ endpoint."""
    url = f"{FASTAPI_BASE_URL}/generate-quiz/"
    params = {"topic": topic, "num_questions": num_questions}
    try:
        response = requests.get(url, params=params)
        response.raise_for_status()
        # Use Pydantic to validate and structure the response
        quiz_data = response.json()
        return QuizResponse(**quiz_data)
    except requests.exceptions.HTTPError as e:
        if response.status_code == 404:
            st.warning(f"No relevant content found for topic: '{topic}'. Try a different topic.")
        elif response.status_code == 400:
             st.error("Please upload a PDF before generating a quiz.")
        else:
            st.error(f"HTTP Error: {e}. Details: {response.json().get('detail', 'No details available')}")
        return None
    except requests.exceptions.RequestException as e:
        st.error(f"Error connecting to the API: {e}")
        return None
    except Exception as e:
        st.error(f"Error parsing quiz response: {e}")
        return None

def submit_answer_to_api(topic: str, question_number: int, selected_answer: str):
    """Calls the /submit-answer/ endpoint."""
    url = f"{FASTAPI_BASE_URL}/submit-answer/"
    params = {"topic": topic}
    payload = SubmitAnswerRequest(
        question_number=question_number,
        selected_answer=selected_answer
    ).model_dump_json() # Use model_dump_json for Pydantic v2
    
    try:
        response = requests.post(
            url, 
            params=params, 
            data=payload, 
            headers={'Content-Type': 'application/json'}
        )
        response.raise_for_status()
        return AnswerFeedback(**response.json())
    except requests.exceptions.RequestException as e:
        st.error(f"Error submitting answer: {e}")
        return None

# --- Streamlit UI Components ---

def render_quiz(quiz: QuizResponse):
    """Renders the quiz questions and handles user interaction."""
    st.header(f"Quiz on: **{quiz.topic}**")
    st.markdown(f"Total Questions: **{quiz.total_questions}**")

    # Initialize session state for tracking answers and feedback
    if 'current_answers' not in st.session_state:
        st.session_state.current_answers = {}
    if 'current_feedback' not in st.session_state:
        st.session_state.current_feedback = {}

    for q in quiz.questions:
        st.subheader(f"Question {q.question_number}")
        st.write(q.question_text)

        # Radio button key must be unique per question
        radio_key = f"q_{q.question_number}_selection"
        
        # Format options for radio button: ["A) Option Text", "B) Option Text", ...]
        option_labels = [f"{opt.label}) {opt.text}" for opt in q.options]
        
        # Get the current selection if it exists
        current_selection = st.session_state.current_answers.get(q.question_number)
        
        # Find the index of the previously selected option for 'index' argument
        try:
            default_index = option_labels.index(f"{current_selection}) {q.options[[opt.label for opt in q.options].index(current_selection)].text}") if current_selection else 0
        except:
             default_index = 0

        # Radio buttons for selection
        selected_label_text = st.radio(
            "Select your answer:",
            options=option_labels,
            key=radio_key,
            index=None, # Start with no selection
        )
        
        # Extract the single letter label (A, B, C, D) from the selected string
        selected_label = selected_label_text.split(')')[0] if selected_label_text else None
        
        # Submission button
        submit_key = f"q_{q.question_number}_submit"
        if st.button("Submit Answer", key=submit_key, disabled=q.question_number in st.session_state.current_feedback):
            if selected_label:
                # Store the selection
                st.session_state.current_answers[q.question_number] = selected_label
                
                # Call the API for validation
                feedback = submit_answer_to_api(quiz.topic, q.question_number, selected_label)
                
                if feedback:
                    st.session_state.current_feedback[q.question_number] = feedback
                    # Rerun the app to show the feedback immediately
                    st.rerun()
            else:
                st.warning("Please select an answer before submitting.")

        # Display feedback if available
        feedback = st.session_state.current_feedback.get(q.question_number)
        if feedback:
            if feedback.is_correct:
                st.success("✅ Correct!")
            else:
                st.error(f"❌ Incorrect. The correct answer was **{feedback.correct_answer}**.")
            
            if feedback.explanation:
                 st.info(f"Explanation: {feedback.explanation}")
            
            st.divider()
        else:
             st.divider()

# --- Main App Logic ---

def main():
    st.set_page_config(
        page_title="PDF Quiz Generator",
        layout="wide",
        initial_sidebar_state="expanded"
    )
    
    st.title("📄 PDF-to-Quiz Generator")
    st.markdown("Upload a document, then generate and take a quiz based on its content using the Gemini API and a FAISS vector store.")

    # --- Sidebar for Upload and Settings ---
    with st.sidebar:
        st.header("1. Upload PDF")
        uploaded_file = st.file_uploader(
            "Upload a PDF file", 
            type=["pdf"], 
            key="pdf_uploader"
        )

        st.header("2. Quiz Settings")
        quiz_topic = st.text_input(
            "Topic for the Quiz", 
            placeholder="e.g., 'Recurrent Neural Networks' or 'Company History'",
            key="quiz_topic"
        )
        num_questions = st.slider(
            "Number of Questions", 
            min_value=1, 
            max_value=20, 
            value=10, 
            key="num_questions"
        )
        
        generate_button = st.button("🚀 Generate Quiz")
        
        st.subheader("FastAPI Status")
        st.code(f"API Base URL: {FASTAPI_BASE_URL}", language="plaintext")
        st.warning("Ensure your FastAPI app is running locally on the specified URL!")

    # --- Main Content Area ---
    
    # --- Step 1: Handle PDF Upload ---
    if uploaded_file and 'upload_success' not in st.session_state:
        # Check if the file object has changed (Streamlit automatically caches the file data)
        if 'last_uploaded_hash' not in st.session_state or st.session_state.last_uploaded_hash != uploaded_file.file_id:
             
            # Reset the quiz data when a new file is uploaded
            st.session_state.quiz = None
            st.session_state.current_answers = {}
            st.session_state.current_feedback = {}
            st.session_state.last_uploaded_hash = uploaded_file.file_id

            # Call the upload API
            upload_result = upload_pdf_to_api(uploaded_file)
            if upload_result:
                st.session_state.upload_success = True
                st.success(upload_result.get("message", "PDF processed successfully!"))
            else:
                st.session_state.upload_success = False

    if 'upload_success' in st.session_state and not st.session_state.upload_success:
        st.error("PDF upload failed. Check the error message in the console or network tab.")

    # --- Step 2: Handle Quiz Generation ---
    if generate_button:
        if not quiz_topic:
            st.error("Please enter a topic for the quiz.")
        elif 'upload_success' not in st.session_state or not st.session_state.upload_success:
             st.error("Please upload and process a PDF successfully first.")
        else:
            # Clear previous quiz answers/feedback
            st.session_state.quiz = None
            st.session_state.current_answers = {}
            st.session_state.current_feedback = {}

            # Call the generation API
            quiz_data = generate_quiz_from_api(quiz_topic, num_questions)
            if quiz_data:
                st.session_state.quiz = quiz_data
                st.success("Quiz generated successfully!")

    # --- Step 3: Display Quiz ---
    if 'quiz' in st.session_state and st.session_state.quiz:
        render_quiz(st.session_state.quiz)
    
    elif 'upload_success' in st.session_state and st.session_state.upload_success:
         st.info("PDF uploaded successfully. Now, enter a **Topic** in the sidebar and click **Generate Quiz**.")
    else:
        st.info("Start by **Uploading a PDF** in the sidebar.")

if __name__ == "__main__":
    main()