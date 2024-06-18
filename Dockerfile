# Use the official PostgreSQL image from the Docker Hub
FROM postgres:latest

# Set the working directory
WORKDIR /app

# Install curl and cron (if needed)
RUN apt-get update && apt-get install -y \
    curl \
    cron \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install rclone
RUN curl https://rclone.org/install.sh | bash

# COPY THE SCRIPT INTO THE DOCKER IMAGE
COPY backup.sh /app/backup.sh
COPY rclone.conf /app/rclone.conf

# MAKE THE SCRIPT EXECUTABLE
RUN chmod +x /app/backup.sh

# SET ENVIRONMENT VARIABLES
ENV PGUSER='postgres'
ENV PGHOST="host.docker.internal"
ENV PGPORT=5432

# RUN THE SCRIPT
CMD ["/app/backup.sh"]

