#!/bin/bash

# MySQL credentials
USERNAME="lpadmin"
PASSWORD="!P$winnow#2021!plu"
HOSTNAME="lpwinnow-staging.mysql.database.azure.com "
DBNAME="staging_winnowv3"

# Blob storage details
STORAGE_ACCOUNT="lpwinnow"
CONTAINER="https://lpwinnow.blob.core.windows.net/winnow-db-backup"
SAS_TOKEN="sp=racwdli&st=2024-12-13T11:53:30Z&se=2024-12-19T19:53:30Z&sv=2022-11-02&sr=c&sig=Rw%2F%2FInJ6zav1p9Kj8Y%2FbzdMYY3S2jOCreCQT4Qf4rjA%3D"

# Backup filename with timestamp
BACKUP_FILE="backup_$(date +%F_%T).sql"


echo "Starting database backup process..."

# Step 1: Export MySQL database
# Export database
mysqldump -u $USERNAME -h $HOSTNAME -p$PASSWORD $DBNAME > $BACKUP_FILE

if [ $? -eq 0 ]; then
    echo "Database export completed: $BACKUP_PATH"
else
    echo "Error during database export." >&2
    exit 1
fi

# Step 2: Upload backup file to Azure Blob Storage using SAS token
echo "Uploading backup to Azure Blob Storage..."
az storage blob upload \
    --account-name $STORAGE_ACCOUNT \
    --container-name $CONTAINER \
    --name $BACKUP_FILE \
    --file $BACKUP_FILE
    --sas-token $SAS_TOKEN

if [ $? -eq 0 ]; then
    echo "Backup uploaded successfully to Blob Storage."
else
    echo "Error during upload to Blob Storage." >&2
    exit 1
fi

# Step 3: Clean up temporary backup file
echo "Cleaning up temporary files..."
#rm $BACKUP_PATH

if [ $? -eq 0 ]; then
    echo "Cleanup completed successfully."
else
    echo "Error during cleanup." >&2
    exit 1
fi

echo "Backup process completed successfully!"

