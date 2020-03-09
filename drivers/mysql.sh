#!/bin/bash

# Must set driver backup extension, withou first point
DRIVER_EXTENSION='sql.gz'

# Do not change this line, and use this variable for backup file path
DRIVER_FILE_PATH="/data/backup/\${DATE}.${DRIVER_EXTENSION}"

# Create you'r logic for generate backup and restore command
MYSQL_OPTS=""
if [[ ! -z ${BACKUP_HOST+x} ]]; then MYSQL_OPTS="${MYSQL_OPTS} -h ${BACKUP_HOST}"; fi
if [[ ! -z ${BACKUP_PORT+x} ]]; then MYSQL_OPTS="${MYSQL_OPTS} -P ${BACKUP_PORT}"; fi
if [[ ! -z ${BACKUP_USER+x} ]]; then MYSQL_OPTS="${MYSQL_OPTS} -u ${BACKUP_USER}"; fi
if [[ ! -z ${BACKUP_PASS+x} ]]; then MYSQL_OPTS="${MYSQL_OPTS} -p${BACKUP_PASS}"; fi
if [[ ! -z ${BACKUP_EXTRA_OPTS+x} ]]; then MYSQL_OPTS="${MYSQL_OPTS} ${BACKUP_EXTRA_OPTS}"; fi
if [[ ! -z ${BACKUP_DB+x} ]]; then MYSQL_OPTS="${MYSQL_OPTS} ${BACKUP_DB}"; fi

# export driver backup command
DRIVER_BACKUP_CMD="mysqldump ${MYSQL_OPTS} > /tmp/dump.sql && gzip /tmp/dump.sql && mv /tmp/dump.sql.gz ${DRIVER_FILE_PATH} || rm ${DRIVER_FILE_PATH}"

# export driver restore command. You must use \${RESTORE_FILE_PATH} for get backup file to restore.
DRIVER_RESTORE_CMD="gunzip < \${RESTORE_FILE_PATH} | mysql ${MYSQL_OPTS}"

