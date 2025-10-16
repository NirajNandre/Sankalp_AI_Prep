import os
import json
import google.generativeai as genai
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Configure the API key
API_KEY = os.getenv("GOOGLE_API_KEY")
if not API_KEY:
    raise ValueError("GOOGLE_API_KEY environment variable not set.")
genai.configure(api_key=API_KEY)

# --- Pydantic Models for Request and Response ---
# These models ensure the data conforms to the structure your Flutter app expects.

class Option(BaseModel):
    text: str
    isCorrect: bool
    reason: str

class Question(BaseModel):
    question: str
    options: List[Option]

class QuizRequest(BaseModel):
    topic: str

# --- FastAPI Application ---
app = FastAPI(
    title="Sankalp Quiz Generator",
    description="API for generating quizzes using the Gemini API.",
    version="1.0.0",
)

@app.post("/generate-quiz/", response_model=List[Question])
async def generate_quiz(request: QuizRequest):
    """
    Generates 10 quiz questions on a given topic.
    """
    try:
        # Construct the prompt for the Gemini API
        prompt = f'''
You are a quiz question generator. Your task is to generate a list of exactly 10 multiple-choice quiz questions on the user-specified topic. Each question must have exactly four options, one of which is correct. The correct option must include a brief, informative reason for why it is correct. All incorrect options must also include a brief, informative reason for why they are incorrect.
for every request give different sets of mcq for same topic.

The output must be a single JSON array that adheres strictly to the following structure:

[
  {{
    "question": "Which Fundamental Right was removed from the list of Fundamental Rights by the 44th Amendment Act of 1978 and converted into a legal right?",
    "options": [
      {{
        "text": "Right to Freedom",
        "isCorrect": false,
        "reason": "The Right to Freedom (Article 19) remains a fundamental right, though it can be suspended during an Emergency."
      }},
      {{
        "text": "Right to Property",
        "isCorrect": true,
        "reason": "The Right to Property (Article 31) was deleted from Part III and made a legal right under Article 300A."
      }},
      {{
        "text": "Right against Exploitation",
        "isCorrect": false,
        "reason": "This right (Articles 23-24) remains a fundamental right."
      }},
      {{
        "text": "Right to Constitutional Remedies",
        "isCorrect": false,
        "reason": "This right (Article 32) remains a fundamental right and is crucial for the enforcement of the others."
      }}
    ]
  }}
]

---
User Request:
Generate 10 multiple-choice quiz questions on the topic: **{request.topic}**
'''
        # Configure the generative model
        model = genai.GenerativeModel('gemini-2.5-flash-lite')
        response = model.generate_content(
            prompt,
            generation_config=genai.types.GenerationConfig(
                response_mime_type="application/json",
                temperature=0.8,
            ),
        )

        # The response from the API should be a clean JSON string
        return json.loads(response.text)

    except Exception as e:
        print(f"An error occurred: {e}")
        raise HTTPException(status_code=500, detail="Failed to generate quiz.")

if __name__ == "__main__":
    import uvicorn
    # Host on 0.0.0.0 to make it accessible on your local network
    uvicorn.run(app, host="0.0.0.0", port=8000)
