#!/bin/bash

# Quiet period before start backup
INTERVAL="21600"

VARIABLES=(
  S3_URL
  AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY
  PATH_TO_BACKUP
  FULL_BACKUPS_TO_KEEP
)

for var in "${VARIABLES[@]}"; do
	eval var_value=\$$var
	if [ -z "$var_value" ]; then
		echo >&2
		echo >&2 '=================================================================================================='
 		echo >&2 'Required variable -> '$var' not defined.'
 		echo >&2 '=================================================================================================='
 		echo >&2
 		exit 1
 	fi
done

echo "Starting recovery from $S3_URL to $PATH_TO_BACKUP"
duplicity --progress --progress-rate 5 --force --no-encryption $S3_URL $PATH_TO_BACKUP
echo "Recovery complete!"

while :
do
  echo "Starting backup"
  duplicity --progress --progress-rate 5 --no-encryption --allow-source-mismatch --full-if-older-than 7D $PATH_TO_BACKUP $S3_URL
  echo "Starting cleanup"
  duplicity --progress --progress-rate 5 remove-all-but-n-full $FULL_BACKUPS_TO_KEEP --force --no-encryption --allow-source-mismatch $S3_URL
  duplicity --progress --progress-rate 5 cleanup --force --no-encryption $S3_URL
  sleep $INTERVAL
done
