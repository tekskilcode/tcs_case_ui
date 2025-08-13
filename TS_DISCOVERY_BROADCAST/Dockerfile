#FROM python:3.9
FROM python:3.9-slim-bookworm
RUN pip install netifaces
WORKDIR /app
COPY discovery.py /app
CMD ["python3", "discovery.py"] 
