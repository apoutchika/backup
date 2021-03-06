Universal Database Backup
=========================


Why ?
-----

Because I want :

- The same container and same environments variables for backup my redis, mysql and mongodb databases.
- Auto rotation backup files.
- Alert (mail or slack) if the backup size is suspect or backup fail.
- Send backup to S3.
- ...


> PLEASE . REMEMBER . TO . TEST . YOUR . BACKUPS . **REGULARLY** .


Volume
------

You can mount the directory `/data`. The directory contains 2 subdirectories :

- `/data/backup` Directory where is saved the backup files.
- `/data/restore` (for mysql and mongo only) copy file from backup in this directory and the backup is imported in database.


Docker Secret
-------------

All variables can used with docker secrets, simply append `_FILE` of the variable name, and set the secret file path. i.e. :

- `BACKUP_PASS_FILE` and set to `/run/secrets/BACKUP_PASS`


Environments variables
----------------------

### File

- `BACKUP_NAME_FORMAT`: (OPTIONNAL) Name format of backup (without extension). It use [date](https://manpages.debian.org/buster/coreutils/date.1.en.html) format. Default is `+%Y-%m-%d.%Hh%M.%S`

### Cron

- `BACKUP_CRON_TIME`: (OPTIONNAL) Cron schedule, default is `0 0 * * *`
- `BACKUP_RUN_ON_START`: (OPTIONNAL) Run first backup when container start if this env is defined
- `BACKUP_RUN_ON_START_DELAY`: (OPTIONNAL) Delay in seconds if run on start is set. Default is `20`

### Database (One of them required)

#### MongoDB

- `BACKUP_DRIVER`: Backup type, must be `mongo`
- `BACKUP_HOST`: Mongo host
- `BACKUP_PORT`: Mongo port
- `BACKUP_USER`: Mongo username
- `BACKUP_PASS`: Mongo password
- `BACKUP_DB`: Mongo database
- `BACKUP_EXTRA_OPTS`: Extra options

#### MySQL

- `BACKUP_DRIVER`: Backup type, must be `mysql`
- `BACKUP_HOST`: MySQL host
- `BACKUP_PORT`: MySQL port
- `BACKUP_USER`: MySQL username
- `BACKUP_PASS`: MySQL password
- `BACKUP_DB`: MySQL database (optionnal)
- `BACKUP_EXTRA_OPTS`: Extra options (you can use `--all-databases`)

#### Redis

- `BACKUP_DRIVER`: Backup type, must be `redis`
- `BACKUP_HOST`: Redis host
- `BACKUP_PORT`: Redis port
- `BACKUP_PASS`: Redis password
- `BACKUP_EXTRA_OPTS`: Extra options

#### Other database

You can contribute ;)


### Backup Rotation (optionnal)

See [rotate-backups](https://rotate-backups.readthedocs.io/en/latest/) for more details

- `BACKUP_ROTATE_MINUTELY`: Number
- `BACKUP_ROTATE_HOURLY`: Number
- `BACKUP_ROTATE_DAILY`: Number
- `BACKUP_ROTATE_WEEKLY`: Number
- `BACKUP_ROTATE_MONTHLY`: Number
- `BACKUP_ROTATE_YEARLY`: Number
- `BACKUP_ROTATE_OPTS`: Add more options


### Alert (Optionnal)

Send alert if backup file is not created, the size of last backup is greater a value or backup size is less a value.

- `BACKUP_ALERT_NAME`: Name of backup, i.e. : `My project - Mongo Backup`
- `BACKUP_ALERT_IF_THE_SIZE_OF_LAST_BACKUP_GREATER_THAN`: Alert from diff size with last backup is lower. See [numfmt format](https://manpages.debian.org/buster/coreutils/numfmt.1.en.html). Default no alert
- `BACKUP_ALERT_IF_THE_BACKUP_SIZE_IS_SMALLER_THAN`: If the size of backup is smaller of this value. See [numfmt format](https://manpages.debian.org/buster/coreutils/numfmt.1.en.html). Default no alert.

Availables transports :

#### Slack

- `BACKUP_ALERT`: value must be `slack`
- `BACKUP_SLACK_WEBHOOK_URL`: i.e `https://hooks.slack.com/services/XXX/YYYY/ZZZZ`

#### Mail

- `BACKUP_ALERT`: value must be `mail`
- `BACKUP_MAIL_FROM`: expeditor@domain.com
- `BACKUP_MAIL_HOST`: smtp.host.com
- `BACKUP_MAIL_PASS`: mail password
- `BACKUP_MAIL_TO`: my@email.com
- `BACKUP_MAIL_USER`: usermail


### Sync to S3 (Optionnal)

- `BACKUP_S3_ACCESS_KEY`
- `BACKUP_S3_HOST_BASE`
- `BACKUP_S3_HOST_BUCKET`
- `BACKUP_S3_OPS`: Additional options, you can (*should?*) use `--delete-removed`
- `BACKUP_S3_PATH`: i.e.: `s3://mys3/my-projet-mongo-backup/`
- `BACKUP_S3_REGION`: default `us-west-1`
- `BACKUP_S3_SECRET_KEY`
- `BACKUP_S3_USE_HTTPS`: default `True`


Restore a backup
----------------

### Mysql and Mongodb

Simply copy zipped file in `data/restore` directory. A cron try to restore a database all minutes.

### Redis

- Stop redis container
- Unzip the backup file and remplace the dump.rdb
- Start redis container


Test it on 5 minutes
--------------------

Host port `8042` and `9000` is required for test

- Clone the repository `git clone https://github.com/apoutchika/backup`
- Start databases and backups `docker-compose up` 
- Wait all databases is started, and wait the first backup
- Run `./fixtures.sh` for create datas in DB
- See next backup size, on `data/backups` directory or on S3

You can see alert mail on [http://localhost:8042/](http://localhost:8042/), and S3 data on [http://localhost:9000/](http://localhost:9000/) (access is `s3\_key` and `s3\_secret`).

The backup is created all minutes.


Test restore :

- Stop all container `docker-compose down`
- Delete datas `sudo rm -rf ./data/{mongo,mysql,redis}/*`
- unzip last redis backup and move dump.rdb on `./data/redis/dump.rdb` 
- Restart containers `docker-compose up --force-recreate`
- Copy file in `./data/backups/mongo/backup/` to `./data/backups/mongo/restore/` for MongoDB
- Copy file in `./data/backups/mysql/backup/` to `./data/backups/mysql/restore/` for MySQL
- See next data backup size, or connect to the container for see datas

Test alerts :

- Create a big fake backup, the next is smaller and send mail alert :
  - `docker-compose exec backup-mysql bash -c "truncate -s 3M /data/backup/fakeBigBackup.gz"`
  - `docker-compose exec backup-mongo bash -c "truncate -s 3M /data/backup/fakeBigBackup.gz"`
  - `docker-compose exec backup-redis bash -c "truncate -s 3M /data/backup/fakeBigBackup.gz"`
- Wait next backup, see alerts
- Try to delete fixutres with `./clean.sh`. After the next backup, see alerts on [webmail](http://localhost:8042/)
- Try to stop database : `docker-compose stop mysql mongo redis`. After, the next backup, see alerts on [webmail](http://localhost:8042/)
