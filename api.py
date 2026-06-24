import os
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from groq import Groq

# Inicializa o FastAPI e o cliente do Groq
app = FastAPI()
client = Groq() # Ele vai pegar a GROQ_API_KEY que você salvou no Render

# Define o formato do dado que o Laravel vai enviar (JSON)
class PerguntaRequest(BaseModel):
    duvida: str

@app.get("/")
def inicio():
    return {"status": "Servidor da IA rodando com sucesso!"}

@app.post("/perguntar")
def perguntar_ia(request: PerguntaRequest):
    try:
        chat_completion = client.chat.completions.create(
            messages=[{"role": "user", "content": request.duvida}],
            model="llama-3.3-70b-versatile",
        )
        return {"resposta": chat_completion.choices[0].message.content}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))