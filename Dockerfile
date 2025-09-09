FROM python:3.13-slim
RUN pip install Flask prometheus-flask-exporter
WORKDIR /app
COPY pythonserver.py .
EXPOSE 8080
CMD ["python", "pythonserver.py"]