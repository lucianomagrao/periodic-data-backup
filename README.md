periodic-data-backup
====================

Docker container that monitor and backup a folder to S3 using duplicity to backup and inotify-tools to monitor files changes.

### Use

```shell
docker run [OPTIONS] leslau/periodic-data-backup
```

### Parameters:

* `S3_URL`: Your bucket url ex: s3://s3-sa-east-1.amazonaws.com/foo-bar
* `AWS_ACCESS_KEY_ID`: Your access key id to S3.
* `AWS_SECRET_ACCESS_KEY`: Your secret access key to S3.
* `PATH_TO_BACKUP`: Folder that you want to monitor and backup.
* `FULL_BACKUPS_TO_KEEP`: Number of full backups to keep after cleanup

### Examples:

    docker run -d \
        -e AWS_ACCESS_KEY_ID=foo \
        -e AWS_SECRET_ACCESS_KEY=bar \
        -e S3_URL=s3://s3-sa-east-1.amazonaws.com/foo-bar \
        -e PATH_TO_BACKUP=/my/folder/to/backup \
        -e FULL_BACKUPS_TO_KEEP=1
        leslau/periodic-data-backup
