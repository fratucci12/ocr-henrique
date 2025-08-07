import io
from pdf2image import convert_from_bytes
from PIL import Image
import pytesseract
from PyPDF2 import PdfMerger
import streamlit as st

# Se necessário, ajuste o caminho para o executável do Tesseract:
# pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"

st.title("📄 OCR em PDF → PDF Pesquisável")

uploaded_file = st.file_uploader("Faça upload do seu PDF", type=["pdf"])
if uploaded_file:
    with st.spinner("Convertendo PDF em imagens…"):
        images = convert_from_bytes(uploaded_file.read(), dpi=300)

    st.success(f"{len(images)} página(s) convertida(s). Agora gerando PDF pesquisável…")
    merger = PdfMerger()

    for i, img in enumerate(images, start=1):
        # Gera um PDF de _uma_ página contendo imagem + camada de texto
        pdf_bytes = pytesseract.image_to_pdf_or_hocr(img, extension='pdf', lang='por')
        merger.append(io.BytesIO(pdf_bytes))

    # Grava tudo num único buffer
    output_buffer = io.BytesIO()
    merger.write(output_buffer)
    merger.close()
    output_buffer.seek(0)

    st.download_button(
        label="📥 Baixar PDF OCR",
        data=output_buffer.read(),
        file_name="ocr_output.pdf",
        mime="application/pdf"
    )
