import os
import numpy as np
import faiss
from fastapi import FastAPI, UploadFile, File, HTTPException, Depends
from fastapi.security import APIKeyHeader
from typing import List, Optional
from pydantic import BaseModel
from PyPDF2 import PdfReader
from io import BytesIO
import google.generativeai as genai
from dotenv import load_dotenv
import re
import json
load_dotenv()
from langchain.text_splitter import RecursiveCharacterTextSplitter


API_KEY = os.getenv("GOOGLE_API_KEY")
if not API_KEY:
    raise ValueError("GOOGLE_API_KEY environment variable not set. Please set it to your Google API key.")

genai.configure(api_key=API_KEY)


class QuizOption(BaseModel):
    label: str  
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

app = FastAPI(
    title="PDF Quiz Generator API",
    description="Upload a PDF, and then generate a quiz on a specific topic from its content.",
    version="2.0.0",
)


class SimpleVectorStore:
    def __init__(self):
        self.chunks = []
        self.index = None
        self.is_initialized = False

    def add_texts(self, texts: List[str], embeddings: np.ndarray):
        """Adds texts and their embeddings to the store."""
        if not self.is_initialized:
            dimension = embeddings.shape[1]
            self.index = faiss.IndexFlatL2(dimension)
            self.is_initialized = True

        self.index.add(embeddings)
        self.chunks.extend(texts)
        print(f"Added {len(texts)} new chunks. Total chunks: {len(self.chunks)}.")

    def similarity_search(self, query_embedding: np.ndarray, top_k: int = 5) -> List[str]:
        """Performs a similarity search."""
        if not self.is_initialized:
            return []
        
        distances, indices = self.index.search(query_embedding, top_k)
        return [self.chunks[i] for i in indices[0] if i < len(self.chunks)]


vector_store = SimpleVectorStore()


quiz_cache = {}


def extract_pdf_text(file_bytes: bytes) -> str:
    """Extracts text from a PDF file's bytes."""
    try:
        reader = PdfReader(BytesIO(file_bytes))
        text = ""
        for page in reader.pages:
            page_text = page.extract_text()
            if page_text:
                text += page_text
        return text
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Failed to process PDF: {e}")

def parse_quiz_response(quiz_text: str, num_questions: int) -> List[QuizQuestion]:
    """Parse the LLM's quiz response into structured QuizQuestion objects."""
    questions = []
    
 
    try:
        if quiz_text.strip().startswith('{') or quiz_text.strip().startswith('['):
            data = json.loads(quiz_text)
            if isinstance(data, dict) and 'questions' in data:
                data = data['questions']
            for idx, q_data in enumerate(data[:num_questions], 1):
                questions.append(QuizQuestion(
                    question_number=idx,
                    question_text=q_data['question'],
                    options=[QuizOption(**opt) for opt in q_data['options']],
                    correct_answer=q_data['correct_answer']
                ))
            return questions
    except:
        pass
    
    
    question_pattern = r'Question\s+(\d+):\s*(.+?)(?=Question\s+\d+:|$)'
    matches = re.finditer(question_pattern, quiz_text, re.DOTALL | re.IGNORECASE)
    
    for match in matches:
        q_num = int(match.group(1))
        if q_num > num_questions:
            continue
            
        question_block = match.group(2).strip()
        lines = question_block.split('\n')
        
       
        question_text = ""
        option_lines = []
        correct_answer = "A"
        
        for line in lines:
            line = line.strip()
            if not line:
                continue
            
        
            correct_match = re.match(r'Correct\s+Answer:\s*([A-D])', line, re.IGNORECASE)
            if correct_match:
                correct_answer = correct_match.group(1).upper()
                continue
            
        
            option_match = re.match(r'^([A-D])[).:\]]\s*(.+)', line, re.IGNORECASE)
            if option_match:
                option_lines.append((option_match.group(1).upper(), option_match.group(2).strip()))
            elif not question_text:
             
                question_text = line
    
        options = []
        for label, text in option_lines[:4]: 
            options.append(QuizOption(label=label, text=text))
        
       
        if question_text and len(options) == 4:
            questions.append(QuizQuestion(
                question_number=q_num,
                question_text=question_text,
                options=options,
                correct_answer=correct_answer
            ))
    
    return questions[:num_questions]  

@app.post("/upload-pdf/", tags=["PDF Processing"])
async def upload_pdf(file: UploadFile = File(...)):
    """
    Uploads a PDF, extracts text, splits it into chunks,
    generates embeddings, and stores them in the vector store.
    """
    pdf_bytes = await file.read()
    if not pdf_bytes:
        raise HTTPException(status_code=400, detail="Empty file uploaded.")

    text = extract_pdf_text(pdf_bytes)
    if not text.strip():
        raise HTTPException(status_code=400, detail="Could not extract any text from the PDF.")

    chunker = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=150)
    chunks = chunker.split_text(text)
    
    if not chunks:
        raise HTTPException(status_code=400, detail="Text extracted but could not be split into chunks.")

    try:
        result = genai.embed_content(
            model="models/text-embedding-004",
            content=chunks,
            task_type="RETRIEVAL_DOCUMENT",
            title="PDF Content"
        )
        embeddings = np.array(result['embedding'])
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to generate embeddings: {e}")

    vector_store.add_texts(chunks, embeddings)

    return {"message": f"PDF '{file.filename}' uploaded and indexed successfully with {len(chunks)} chunks."}


@app.get("/generate-quiz/", response_model=QuizResponse, tags=["Quiz Generation"])
async def generate_quiz(topic: str, num_questions: int = 10):
    """
    Generates a structured quiz on a given topic based on the uploaded PDF content.
    Returns questions in a format suitable for the mobile quiz UI.
    """
    if not vector_store.is_initialized:
        raise HTTPException(status_code=400, detail="No PDF has been uploaded yet. Please upload a PDF first.")

   
    try:
        query_embedding_result = genai.embed_content(
            model="models/text-embedding-004",
            content=topic,
            task_type="RETRIEVAL_QUERY"
        )
        query_embedding = np.array([query_embedding_result['embedding']])
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to embed the topic: {e}")


    relevant_chunks = vector_store.similarity_search(query_embedding, top_k=10)
    if not relevant_chunks:
        raise HTTPException(status_code=404, detail="No relevant information found for this topic in the uploaded PDF.")

    context = "\n---\n".join(relevant_chunks)

  
    try:
        llm = genai.GenerativeModel('gemini-2.0-flash-exp')
        prompt = (
            f"You are a helpful assistant designed to create quizzes.\n"
            f"Based *only* on the provided text below, generate exactly {num_questions} multiple-choice quiz questions about '{topic}'.\n\n"
            f"IMPORTANT: Format each question EXACTLY as shown below. Do not add any extra text or explanations.\n\n"
            f"Question 1: What is the main concept?\n"
            f"A) First option text here\n"
            f"B) Second option text here\n"
            f"C) Third option text here\n"
            f"D) Fourth option text here\n"
            f"Correct Answer: B\n\n"
            f"Question 2: Another question here?\n"
            f"A) First option\n"
            f"B) Second option\n"
            f"C) Third option\n"
            f"D) Fourth option\n"
            f"Correct Answer: A\n\n"
            f"Rules:\n"
            f"- Each question must have EXACTLY 4 options labeled A, B, C, D\n"
            f"- Each option should be on a new line\n"
            f"- Clearly indicate the correct answer after each question\n"
            f"- Make options complete and meaningful (not just 'Option A')\n"
            f"- Base all questions strictly on the context provided\n\n"
            f"--- CONTEXT ---\n"
            f"{context}\n"
            f"--- END CONTEXT ---\n\n"
            f"Generate {num_questions} questions now following the exact format above:"
        )
        
        response = llm.generate_content(prompt)
        quiz_text = response.text

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to generate the quiz: {e}")

  
    questions = parse_quiz_response(quiz_text, num_questions)
    
    if not questions:
        
        raise HTTPException(
            status_code=500, 
            detail=f"Failed to parse quiz questions. Raw response: {quiz_text[:500]}..."
        )
    
  
    quiz_id = f"{topic}_{num_questions}"
    quiz_cache[quiz_id] = questions

    return QuizResponse(
        topic=topic,
        total_questions=len(questions),
        questions=questions
    )


@app.post("/submit-answer/", response_model=AnswerFeedback, tags=["Quiz Interaction"])
async def submit_answer(topic: str, answer: SubmitAnswerRequest):
    """
    Validates a user's answer to a specific quiz question.
    Returns feedback indicating if the answer is correct.
    """
    quiz_id = f"{topic}_{10}"  
    
    if quiz_id not in quiz_cache:
        raise HTTPException(status_code=404, detail="Quiz not found. Please generate a quiz first.")
    
    questions = quiz_cache[quiz_id]
   
    question = next((q for q in questions if q.question_number == answer.question_number), None)
    if not question:
        raise HTTPException(status_code=404, detail=f"Question {answer.question_number} not found.")
    
    is_correct = answer.selected_answer.upper() == question.correct_answer
    
    return AnswerFeedback(
        is_correct=is_correct,
        correct_answer=question.correct_answer,
        explanation=f"The correct answer is {question.correct_answer}."
    )


@app.get("/quiz-status/", tags=["Quiz Interaction"])
async def get_quiz_status(topic: str):
    """
    Gets the current status of a quiz (available questions).
    """
    quiz_id = f"{topic}_10"
    
    if quiz_id not in quiz_cache:
        raise HTTPException(status_code=404, detail="No quiz found for this topic.")
    
    questions = quiz_cache[quiz_id]
    
    return {
        "topic": topic,
        "total_questions": len(questions),
        "available": True
    }


@app.post("/upload-pdf/", tags=["PDF Processing"])
async def upload_pdf(file: UploadFile = File(...)):
    """
    Uploads a PDF, extracts text, splits it into chunks,
    generates embeddings, and stores them in the vector store.
    """
    pdf_bytes = await file.read()
    if not pdf_bytes:
        raise HTTPException(status_code=400, detail="Empty file uploaded.")

    text = extract_pdf_text(pdf_bytes)
    if not text.strip():
        raise HTTPException(status_code=400, detail="Could not extract any text from the PDF.")

    chunker = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=150)
    chunks = chunker.split_text(text)
    
    if not chunks:
        raise HTTPException(status_code=400, detail="Text extracted but could not be split into chunks.")

    try:
        result = genai.embed_content(
            model="models/text-embedding-004",
            content=chunks,
            task_type="RETRIEVAL_DOCUMENT",
            title="PDF Content"
        )
        embeddings = np.array(result['embedding'])
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to generate embeddings: {e}")

    vector_store.add_texts(chunks, embeddings)

    return {"message": f"PDF '{file.filename}' uploaded and indexed successfully with {len(chunks)} chunks."}


@app.get("/generate-quiz/", response_model=QuizResponse, tags=["Quiz Generation"])
async def generate_quiz(topic: str, num_questions: int = 10):
    """
    Generates a structured quiz on a given topic based on the uploaded PDF content.
    Returns questions in a format suitable for the mobile quiz UI.
    """
    if not vector_store.is_initialized:
        raise HTTPException(status_code=400, detail="No PDF has been uploaded yet. Please upload a PDF first.")

    try:
        query_embedding_result = genai.embed_content(
            model="models/text-embedding-004",
            content=topic,
            task_type="RETRIEVAL_QUERY"
        )
        query_embedding = np.array([query_embedding_result['embedding']])
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to embed the topic: {e}")


    relevant_chunks = vector_store.similarity_search(query_embedding, top_k=10)
    if not relevant_chunks:
        raise HTTPException(status_code=404, detail="No relevant information found for this topic in the uploaded PDF.")

    context = "\n---\n".join(relevant_chunks)

 
    try:
        llm = genai.GenerativeModel('gemini-2.0-flash-exp')
        prompt = (
            f"You are a helpful assistant designed to create quizzes.\n"
            f"Based *only* on the provided text below, generate exactly {num_questions} multiple-choice quiz questions about '{topic}'.\n\n"
            f"Format each question EXACTLY as follows:\n"
            f"Question 1: [Question text here]\n"
            f"A) [Option A text]\n"
            f"B) [Option B text]\n"
            f"C) [Option C text]\n"
            f"D) [Option D text]\n"
            f"Correct Answer: [A/B/C/D]\n\n"
            f"Make sure each question has exactly 4 options and clearly indicate the correct answer.\n\n"
            f"--- CONTEXT ---\n"
            f"{context}\n"
            f"--- END CONTEXT ---\n\n"
            f"Generate the quiz now."
        )
        
        response = llm.generate_content(prompt)
        quiz_text = response.text

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to generate the quiz: {e}")

  
    questions = parse_quiz_response(quiz_text, num_questions)
    
    quiz_id = f"{topic}_{num_questions}"
    quiz_cache[quiz_id] = questions

    return QuizResponse(
        topic=topic,
        total_questions=len(questions),
        questions=questions
    )


@app.post("/submit-answer/", response_model=AnswerFeedback, tags=["Quiz Interaction"])
async def submit_answer(topic: str, answer: SubmitAnswerRequest):
    """
    Validates a user's answer to a specific quiz question.
    Returns feedback indicating if the answer is correct.
    """
    quiz_id = f"{topic}_{10}"  
    
    if quiz_id not in quiz_cache:
        raise HTTPException(status_code=404, detail="Quiz not found. Please generate a quiz first.")
    
    questions = quiz_cache[quiz_id]
    
   
    question = next((q for q in questions if q.question_number == answer.question_number), None)
    if not question:
        raise HTTPException(status_code=404, detail=f"Question {answer.question_number} not found.")
    
    is_correct = answer.selected_answer.upper() == question.correct_answer
    
    return AnswerFeedback(
        is_correct=is_correct,
        correct_answer=question.correct_answer,
        explanation=f"The correct answer is {question.correct_answer}."
    )


@app.get("/quiz-status/", tags=["Quiz Interaction"])
async def get_quiz_status(topic: str):
    """
    Gets the current status of a quiz (available questions).
    """
    quiz_id = f"{topic}_10"
    
    if quiz_id not in quiz_cache:
        raise HTTPException(status_code=404, detail="No quiz found for this topic.")
    
    questions = quiz_cache[quiz_id]
    
    return {
        "topic": topic,
        "total_questions": len(questions),
        "available": True
    }