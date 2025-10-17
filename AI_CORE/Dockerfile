# Use a newer, compatible Python version
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

# Copy the dependencies file to the working directory
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code to the working directory
COPY . .

# NEW: Expose the port the server will run on
EXPOSE 8080

# UPDATED: Run the Gunicorn web server directly.
# This is the command that will start and run your application.
CMD ["gunicorn", "-w", "4", "-k", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:8080", "main:app"]
