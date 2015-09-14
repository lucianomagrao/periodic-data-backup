periodic-data-backup
====================

Docker container that monitor and backup a folder to S3 using [duplicity](http://duplicity.nongnu.org/) to backup and [inotify-tools ](http://linux.die.net/man/7/inotify) to monitor files changes.

Use
---
```shell
docker run -e S3_URL=s3://foo.bar -e AWS_ACCESS_KEY_ID=foo -e AWS_SECRET_ACCESS_KEY=bar -e PATH_BACKUP=/my/folder/ leslau/periodic-data-backup
```

- S3_URL = Your bucket url ex: s3://s3-sa-east-1.amazonaws.com/foo-bar
- AWS_ACCESS_KEY_ID = Your access key id to S3
- AWS_SECRET_ACCESS_KEY = Your secret access key to S3
- PATH_BACKUP = Folder that you want to monitor and backup.
