import os
from groq import Groq

# Coloque a sua chave aqui por enquanto para testar
os.environ["GROQ_API_KEY"] = "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"


client = Groq() # Ele lerá a chave automaticamente da variável de ambiente acima
chat_completion = client.chat.completions.create(
    messages=[{"role": "user", "content": "Olá, tudo bem?Qual seu nome?"}],
    model="llama-3.3-70b-versatile", # Mude para este nome
)

# Imprimir a resposta
print(chat_completion.choices[0].message.content)