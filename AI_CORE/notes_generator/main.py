from fastapi import FastAPI, UploadFile, File
from typing import Optional
from PyPDF2 import PdfReader
from langchain.text_splitter import RecursiveCharacterTextSplitter
import google.generativeai as genai
from dotenv import load_dotenv
import os

load_dotenv()


genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

app = FastAPI(
    title="PDF Notes Generator API",
    description="Upload a PDF, and then generate notes on a specific topic from its content.",
    version="1.0.0",
)

class SimpleVectorStore:
    def __init__(self):
        self.chunks = []
        self.embeddings = []
    
    def add_vectors(self, embeddings, chunks):
        self.embeddings.extend(embeddings)
        self.chunks.extend(chunks)
    
    def similarity_search(self, query_embedding, top_k=5):
        if not self.embeddings:
            return []
        
        import numpy as np
        similarities = []
        for emb in self.embeddings:
            score = np.dot(query_embedding, emb) / (np.linalg.norm(query_embedding) * np.linalg.norm(emb) + 1e-8)
            similarities.append(score)
        
        top_indices = np.argsort(similarities)[-top_k:][::-1]
        return [self.chunks[i] for i in top_indices]

vector_store = SimpleVectorStore()


def extract_pdf_text(file_bytes):
    """Extract text from PDF bytes."""
    from io import BytesIO
    reader = PdfReader(BytesIO(file_bytes))
    text = ""
    for page in reader.pages:
        text += page.extract_text()
    return text


def get_embeddings(texts):
    """Get embeddings from Gemini API."""
    embeddings = []
    for text in texts:
        result = genai.embed_content(
            model="models/text-embedding-004",
            content=text
        )
        embeddings.append(result["embedding"])
    return embeddings


@app.post("/upload_pdf/")
async def upload_pdf(file: UploadFile = File(...)):
    """Upload and index a PDF file."""
    pdf_bytes = await file.read()
    text = extract_pdf_text(pdf_bytes)
    
   
    chunker = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=100)
    chunks = chunker.split_text(text)

    embeddings = get_embeddings(chunks)
    vector_store.add_vectors(embeddings, chunks)
    
    return {"message": f"PDF uploaded and indexed with {len(chunks)} chunks."}


@app.get("/query/")
def query_notes(q: str):
    """Query the vector store and generate notes."""
 
    query_result = genai.embed_content(
        model="models/text-embedding-004",
        content=q
    )
    query_embedding = query_result["embedding"]
    

    relevant_chunks = vector_store.similarity_search(query_embedding, top_k=5)
    
    if not relevant_chunks:
        return {"query": q, "answer": "No relevant content found in the uploaded PDF."}
    
    context = " ".join(relevant_chunks)
    
 
    model = genai.GenerativeModel("gemini-2.5-flash")
    prompt = f"Using the following document context, prepare concise and structured notes on '{q}':\n\n{context}"
    response = model.generate_content(prompt)
    
    return {"query": q, "answer": response.text}