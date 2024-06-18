# Dockerized Backup

This is a simple docker image to backup postgres databases. It uses pg_dump to backup the databases. And backup files are uploaded to google drive using rclone.

## Usage

1. Build the image

   ```bash
   docker build -t dockerized-backup .
   ```

2. Run the image

   ```bash
   docker run -e PGPASSWORD='postgres_password' -e PGDATABASE="db1,db2,db3" dockerized-backup
   ```

   - `PGPASSWORD` is the password of the postgres user.
   - `PGDATABASE` is the list of databases to backup. Databases should be comma separated.

3. Backup files are uploaded to google drive. You need to configure rclone for this. You can find the instructions [here](https://rclone.org/drive/). You need to set credentials for rclone in the `rclone.conf` file.

   ```conf
   // rclone.conf
   [nameofremote]
   type = drive
   client_id = Google_Client_ID (Google Cloud Console)
   client_secret = Google_Client_Secret (Google Cloud Console)
   scope = drive
   token = access_token
   team_drive =
   ```

## Modify the image

- You can modify the `Dockerfile` to add more configurations or remove hardcorded environment variables(Be sure to ).
