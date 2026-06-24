import os
from groq import Groq

client = Groq() # Ele lerá a chave automaticamente da variável de ambiente acima
chat_completion = client.chat.completions.create(
    messages=[{"role": "user", "content": "Olá, tudo bem?Qual seu nome?"}],
    model="llama-3.3-70b-versatile", # Mude para este nome
)

# Imprimir a resposta
print(chat_completion.choices[0].message.content)