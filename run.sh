#!/bin/bash

# Quiet period before start backup
WAIT_TIME="180"

VARIABLES=(
  S3_URL
  AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY
  PATH_TO_BACKUP
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

echo "Updating time data to prevent problems with S3 time mismatch"
ntpdate pool.ntp.org

inotifywait_events="modify,attrib,move,create,delete"

echo "Starting recovery from $S3_URL to $PATH_TO_BACKUP"
duplicity --progress --progress-rate 5 --force --no-encryption $S3_URL $PATH_TO_BACKUP
echo "Recovery complete!"

# Now, start waiting for file system events on this path.
# After an event, wait for a quiet period of N seconds before doing a backup

echo "Starting monitoring $PATH_TO_BACKUP"
while inotifywait -r -e $inotifywait_events $PATH_TO_BACKUP ; do
  echo "Change detected."
  while inotifywait -r -t $WAIT_TIME -e $inotifywait_events $PATH_TO_BACKUP ; do
  	echo "waiting for quiet period.."
  done

  echo "Starting backup"
  duplicity --progress --progress-rate 5 --no-encryption --allow-source-mismatch --full-if-older-than 7D $PATH_TO_BACKUP $S3_URL
  echo "Starting cleanup"
  duplicity --progress --progress-rate 5 remove-all-but-n-full 3 --force --no-encryption --allow-source-mismatch $S3_URL
  duplicity --progress --progress-rate 5 cleanup --force --no-encryption $S3_URL
done
