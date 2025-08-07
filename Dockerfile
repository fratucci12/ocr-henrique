FROM python:3.10-slim

# instala tesseract + idioma pt + poppler
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        tesseract-ocr \
        tesseract-ocr-por \
        poppler-utils \
    && rm -rf /var/lib/apt/lists/*

# garante que o Tesseract ache os dados de idioma
ENV TESSDATA_PREFIX=/usr/share/tesseract-ocr/5/tessdata

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

# expõe a porta dinâmica
EXPOSE $PORT

# usa o PORT que o Vercel configura
CMD ["bash", "-lc", "streamlit run app.py --server.port $PORT --server.address 0.0.0.0 --server.headless true"]
