FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy requirements files
COPY pyproject.toml ./

# Install dependencies system-wide using pip
RUN pip install -e .

# Copy application code
COPY . .

# Run Django
CMD ["python", "case_ui/manage.py", "runserver", "0.0.0.0:6969"]