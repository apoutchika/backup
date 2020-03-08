#!/bin/bash

# Must set driver backup extension, withou first point
DRIVER_EXTENSION='sql.gz'

# Do not change this line, and use this variable for backup file path
DRIVER_FILE_PATH="/data/backup/\${DATE}.${DRIVER_EXTENSION}"

# Create you'r logic for generate backup and restore command
MYSQL_OPTS=""
if [[ ! -z ${HOST+x} ]]; then MYSQL_OPTS="${MYSQL_OPTS} -h ${HOST}"; fi
if [[ ! -z ${PORT+x} ]]; then MYSQL_OPTS="${MYSQL_OPTS} -P ${PORT}"; fi
if [[ ! -z ${USER+x} ]]; then MYSQL_OPTS="${MYSQL_OPTS} -u ${USER}"; fi
if [[ ! -z ${PASS+x} ]]; then MYSQL_OPTS="${MYSQL_OPTS} -p${PASS}"; fi
if [[ ! -z ${EXTRA_OPTS+x} ]]; then MYSQL_OPTS="${MYSQL_OPTS} ${EXTRA_OPTS}"; fi
if [[ ! -z ${DB+x} ]]; then MYSQL_OPTS="${MYSQL_OPTS} ${DB}"; fi

# export driver backup command
DRIVER_BACKUP_CMD="mysqldump ${MYSQL_OPTS} > /tmp/dump.sql && gzip /tmp/dump.sql && mv /tmp/dump.sql.gz ${DRIVER_FILE_PATH} || rm ${DRIVER_FILE_PATH}"

# export driver restore command. You must use \${RESTORE_FILE_PATH} for get backup file to restore.
DRIVER_RESTORE_CMD="gunzip < \${RESTORE_FILE_PATH} | mysql ${MYSQL_OPTS}"

