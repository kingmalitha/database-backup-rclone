#!/bin/bash

# Setting up the variables
RREMOTE="mygoogledrive"
RPATH="backups/"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="/app/backups"

# Starting Message
echo "Starting Backup at $DATE"

# Create the backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Check if the PGDATABASE variable is set
if [ -z "$PGDATABASE" ]; then
  echo "The PGDATABASE environment variable is not set. Exiting..."
  exit 1
fi

# Split the PGDATABASE variable into an array using comma as the delimiter
IFS=',' read -ra DATABASES <<< "$PGDATABASE"

# Loop through the databases
for DATABASE in "${DATABASES[@]}"; do
     # Create the directory for the current database if it doesn't exist
    mkdir -p "$BACKUP_DIR/${DATE}"

    # Set the backup file name for the current database
    BACKUP_FILE="$BACKUP_DIR/${DATE}/${DATABASE}.sql"

    # Perform the pg_dump for the current database
    PGPASSWORD=$PGPASSWORD pg_dump -U $PGUSER -h $PGHOST -p $PGPORT --disable-triggers $DATABASE > $BACKUP_FILE

    # Check if the dump was successful
    if [ $? -eq 0 ]; then
      echo "Backup successful: $BACKUP_FILE"
    else
      echo "Backup failed for database $DATABASE"
      exit 1
    fi
done

# Set the rclone configuration file path
export RCLONE_CONFIG=/app/rclone.conf

# Upload the backup files to Google Drive using rclone
rclone copy $BACKUP_DIR $RREMOTE:$RPATH

# Check if the upload was successful
if [ $? -eq 0 ]; then
  echo "Upload successful"
else
  echo "Upload failed"
  exit 1
fi

# Cleanup the backup directory
rm -rf $BACKUP_DIR

# Check if the cleanup was successful
if [ $? -eq 0 ]; then
  echo "Cleanup successful"
else
  echo "Cleanup failed"
  exit 1
fi

# Ending Message
echo "Backup and upload completed successfully"
exit 0

