FROM python:3.10-slim

RUN apt-get update \
    && apt-get install -y tesseract-ocr tesseract-ocr-por poppler-utils \
    && rm -rf /var/lib/apt/lists/*

ENV TESSDATA_PREFIX=/usr/share/tesseract-ocr/5/tessdata

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

# importante: EXPOSEx $PORT
EXPOSE $PORT

CMD ["bash", "-lc", "streamlit run app.py --server.port $PORT --server.address 0.0.0.0 --server.headless true"]
