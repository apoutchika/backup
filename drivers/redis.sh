#!/bin/bash

# Must set driver backup extension, withou first point
DRIVER_EXTENSION='tar.gz'

# Do not change this line, and use this variable for backup file path
DRIVER_FILE_PATH="/data/backup/\${DATE}.${DRIVER_EXTENSION}"

# Create you'r logic for generate backup and restore command
REDIS_OPTS=""
if [[ ! -z ${HOST+x} ]]; then REDIS_OPTS="${REDIS_OPTS} -h ${HOST}"; fi
if [[ ! -z ${PORT+x} ]]; then REDIS_OPTS="${REDIS_OPTS} -p ${PORT}"; fi
if [[ ! -z ${PASS+x} ]]; then REDIS_OPTS="${REDIS_OPTS} -a ${PASS}"; fi
if [[ ! -z ${EXTRA_OPTS+x} ]]; then REDIS_OPTS="${REDIS_OPTS} ${EXTRA_OPTS}"; fi

# export driver backup command
DRIVER_BACKUP_CMD="redis-cli ${REDIS_OPTS} --rdb /tmp/dump.rdb && tar -C /tmp -zcvf ${DRIVER_FILE_PATH} dump.rdb && rm /tmp/dump.rdb"

# export driver restore command. You must use \${RESTORE_FILE_PATH} for get backup file to restore. Don't forget the \ !
DRIVER_RESTORE_CMD="echo 'No restore \${RESTORE_FILE_PATH} for redis, stop redis container and copy dump.rdb in redis volume.'"
