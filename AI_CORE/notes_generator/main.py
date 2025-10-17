import os
from fastapi import FastAPI, UploadFile, File, Form, HTTPException
from pydantic import BaseModel
from typing import List
from PyPDF2 import PdfReader
import google.generativeai as genai
from dotenv import load_dotenv
from io import BytesIO
from datetime import datetime

# Load environment variables from .env file
load_dotenv()

# Configure the Gemini API key
api_key = os.getenv("GOOGLE_API_KEY")
if not api_key:
    raise ValueError("GOOGLE_API_KEY not found in .env file")
genai.configure(api_key=api_key)

# Pydantic model for the response structure
class NotesResponse(BaseModel):
    topic: str
    notes: str
    date: str

app = FastAPI(
    title="Sankalp Notes Generator API",
    description="An API to generate AI notes from a PDF document on a specific topic.",
    version="1.0.0",
)

@app.post("/", response_model=NotesResponse)
async def generate_notes_from_pdf(topic: str = Form(...), file: UploadFile = File(...)):
    """
    Accepts a PDF file and a topic, extracts text, and generates structured notes using the Gemini API.
    """
    try:
        # 1. Extract Text from the Uploaded PDF
        pdf_bytes = await file.read()
        reader = PdfReader(BytesIO(pdf_bytes))
        pdf_text = ""
        for page in reader.pages:
            page_text = page.extract_text()
            if page_text:
                pdf_text += page_text + "\n"

        if not pdf_text.strip():
            raise HTTPException(status_code=400, detail="Could not extract any text from the provided PDF.")

        # 2. Construct the Prompt for Gemini
        # We use a limited amount of text to stay within context window limits for safety
        prompt = f"""
You are an expert academic assistant specializing in creating clear and concise study material.
Based on the provided text from a document, generate a well-structured set of notes on the specific topic: '{topic}'.

The notes should be:
- Formatted in clean markdown.
- Easy to understand and logically organized.
- Include headings, bullet points, and use bold text for key terms.

---
DOCUMENT CONTEXT:
{pdf_text[:12000]}
---

Generate the markdown-formatted notes on '{topic}' now.
"""
        # 3. Generate Content with Gemini
        model = genai.GenerativeModel('gemini-2.5-flash-lite')
        response = model.generate_content(
            prompt,
            generation_config=genai.types.GenerationConfig(temperature=0.5)
        )

        # 4. Return the Structured Response
        return {
            "topic": topic,
            "notes": response.text,
            "date": datetime.now().strftime("%B %d, %Y")
        }

    except Exception as e:
        print(f"An error occurred: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to generate notes. Error: {e}")


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8001)
