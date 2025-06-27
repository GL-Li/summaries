FROM python:3.13-slim

WORKDIR app

COPY requirements.txt ./
RUN pip install -r requirements.txt

COPY llm.py ./

# Create non-admin user and set permissions
RUN useradd -m appuser && \
    chown -R appuser:appuser /app

USER appuser

CMD ["python", "llm.py"]
