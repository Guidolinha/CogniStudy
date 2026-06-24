import os
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional
from groq import Groq

app = FastAPI()
client = Groq()

# Atualizamos a estrutura para aceitar o texto e, opcionalmente, uma imagem em Base64
class PerguntaRequest(BaseModel):
    duvida: str
    imagem_base64: Optional[str] = None # String da imagem (opcional)

@app.get("/")
def inicio():
    return {"status": "Servidor da IA rodando com sucesso!"}

@app.post("/perguntar")
def perguntar_ia(request: PerguntaRequest):
    try:
        # 1. Definição do comportamento de Professor (System Prompt)
        instrucoes_professor = (
            "Você é o tutor de IA do CogniStudy. Seu objetivo é ajudar o aluno a entender o conteúdo "
            "por conta própria. NÃO dê a resposta final de bandeja de forma alguma. "
            "Se o aluno mandar uma questão ou imagem de exercício, analise-a, explique os conceitos "
            "envolvidos passo a passo, dê dicas textuais de caminhos para a resolução e faça perguntas "
            "retóricas guiando o raciocínio dele. Seja encorajador, didático e paciente."
        )

        # 2. Montando a estrutura da mensagem
        conteudo_mensagem = [{"type": "text", "text": request.duvida}]

        # Se o Laravel enviou uma imagem em Base64, adicionamos no formato que o Groq exige
        if request.imagem_base64:
            conteudo_mensagem.append({
                "type": "image_url",
                "image_url": {
                    "url": f"data:image/jpeg;base64,{request.imagem_base64}"
                }
            })

        # 3. Chamada da API usando o modelo de VISÃO (Llama 3.2 Vision)
        chat_completion = client.chat.completions.create(
            messages=[
                {"role": "system", "content": instrucoes_professor},
                {"role": "user", "content": conteudo_mensagem}
            ],
            model="llama-3.2-11b-vision-preview", # Modelo que lê imagens e texto
        )
        
        return {"resposta": chat_completion.choices[0].message.content}
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))