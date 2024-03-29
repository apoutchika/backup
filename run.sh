#!/bin/bash

# Init secrets variables
. /tools/secrets.sh

# Verify if driver is valid
if [[ -z ${BACKUP_DRIVER+x} || ! "${BACKUP_DRIVER}" =~ ^redis|mysql|mongo$ ]]; then
  echo "Must set BACKUP_DRIVER environment (redis, mysql or mongo)"
  exit 1
fi

# Prepare directories
mkdir -p /data/backup
mkdir -p /data/restore

# Import CMD variables
. /drivers/${BACKUP_DRIVER}.sh
. /tools/alert.sh
. /tools/alert_check.sh
. /tools/rotate.sh
. /tools/s3.sh

# Create Restore file
cat <<EOF > /restore.sh
#!/bin/bash

source /env.sh

NB="\$(ls /data/restore | wc -l)"
if [[ \${NB} != "0"  ]]; then
  echo "Start restore"
fi

for RESTORE_FILE_PATH in \$(ls /data/restore | sort)
do
  RESTORE_FILE_PATH="/data/restore/\${RESTORE_FILE_PATH}"
  echo "Restore \$RESTORE_FILE_PATH"
  ${DRIVER_RESTORE_CMD}
  rm \${RESTORE_FILE_PATH}
done
EOF

# Create Backup file
cat <<EOF > /backup.sh
#!/bin/bash

source /env.sh

function sendAlert() {
  echo "\$1"
  ${ALERT_CMD}
}

DATE=\`date ${BACKUP_NAME_FORMAT}\`
echo "Start backup \$DATE"

${DRIVER_BACKUP_CMD}

${ALERT_CHECK_CMD}

${ROTATE_CMD}

${S3_CMD}
EOF

# Chmod it
chmod +x /restore.sh
chmod +x /backup.sh

# Execute after delay if run on start is defined
if [[ ! -z ${BACKUP_RUN_ON_START+x} ]]; then
  sleep ${BACKUP_RUN_ON_START_DELAY}
  /backup.sh > /dev/stdout 2>&1
  /restore.sh > /dev/stdout 2>&1
fi


CLEAN_BACKUP_CRON_TIME=$(echo "$BACKUP_CRON_TIME" | sed 's/"//g')

# Create crontab for backup and restore function
cat <<EOF > /crontab.conf
$(env | grep BACKUP_)
PATH=${PATH}
${CLEAN_BACKUP_CRON_TIME} /backup.sh > /proc/1/fd/1 2>&1
* * * * * /restore.sh > /proc/1/fd/1 2>&1
# Add empty line
EOF

crontab /crontab.conf
cron -l 2 -f
