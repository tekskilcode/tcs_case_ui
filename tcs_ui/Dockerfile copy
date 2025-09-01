# Use the official Python image as the base image
#FROM python:3.9-slim-buster
FROM python:3.9


# Set the working directory
WORKDIR /app

# Set environment variables for Django
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt /app/
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
CMD ["sh", "-c", "python3 manage.py migrate"]

# Copy the project files
COPY ./case_ui /app/

# Expose the port Django will run on
EXPOSE 6969

# Run the development server
CMD ["sh", "-c", "python3 manage.py runserver 0.0.0.0:6969"]


