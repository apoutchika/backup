#!/bin/bash

# Must set driver backup extension, withou first point
DRIVER_EXTENSION='gz'

# Do not change this line, and use this variable for backup file path
DRIVER_FILE_PATH="/data/backup/\${DATE}.${DRIVER_EXTENSION}"

# Create you'r logic for generate backup and restore command
MONGO_OPTS=""
if [[ ! -z ${HOST+x} ]]; then MONGO_OPTS="${MONGO_OPTS} --host=${HOST}"; fi
if [[ ! -z ${PORT+x} ]]; then MONGO_OPTS="${MONGO_OPTS} --port=${PORT}"; fi
if [[ ! -z ${USER+x} ]]; then MONGO_OPTS="${MONGO_OPTS} --username=${USER}"; fi
if [[ ! -z ${PASS+x} ]]; then MONGO_OPTS="${MONGO_OPTS} --password=${PASS}"; fi
if [[ ! -z ${EXTRA_OPTS+x} ]]; then MONGO_OPTS="${MONGO_OPTS} ${EXTRA_OPTS}"; fi

# export driver restore command. You must use \${RESTORE_FILE_PATH} for get backup file to restore. Don't forget the \ !
DRIVER_RESTORE_CMD="mongorestore ${MONGO_OPTS} --drop --gzip --archive=\${RESTORE_FILE_PATH}"

if [[ ! -z ${DB+x} ]]; then MONGO_OPTS="${MONGO_OPTS} --db=${DB}"; fi

# export driver backup command
DRIVER_BACKUP_CMD="mongodump ${MONGO_OPTS} --gzip --archive=${DRIVER_FILE_PATH} || rm ${DRIVER_FILE_PATH}"
