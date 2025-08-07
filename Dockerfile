FROM python:3.10-slim

# Instala Tesseract + dados de idioma + Poppler
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         tesseract-ocr \
         tesseract-ocr-por \
         poppler-utils \
    && rm -rf /var/lib/apt/lists/*

# Defina onde o Tesseract encontra os arquivos .traineddata
ENV TESSDATA_PREFIX=/usr/share/tesseract-ocr/5/tessdata

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

EXPOSE 10000
CMD ["streamlit", "run", "app.py", \
     "--server.port", "10000", \
     "--server.address", "0.0.0.0", \
     "--server.headless", "true"]
