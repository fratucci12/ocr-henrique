# 1. Base leve com Python
FROM python:3.10-slim

# 2. Instala dependências do sistema
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       tesseract-ocr \
       poppler-utils \
    && rm -rf /var/lib/apt/lists/*

# 3. Copia e instala libs Python
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 4. Copia o código
COPY . .

# 5. Expõe a porta que o Streamlit vai usar
EXPOSE 10000

# 6. Executa o Streamlit
CMD ["streamlit", "run", "app.py", \
     "--server.port", "10000", \
     "--server.address", "0.0.0.0", \
     "--server.headless", "true"]
