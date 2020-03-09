#!/bin/bash

# Must set driver backup extension, withou first point
DRIVER_EXTENSION='gz'

# Do not change this line, and use this variable for backup file path
DRIVER_FILE_PATH="/data/backup/\${DATE}.${DRIVER_EXTENSION}"

# Create you'r logic for generate backup and restore command
MONGO_OPTS=""
if [[ ! -z ${BACKUP_HOST+x} ]]; then MONGO_OPTS="${MONGO_OPTS} --host=${BACKUP_HOST}"; fi
if [[ ! -z ${BACKUP_PORT+x} ]]; then MONGO_OPTS="${MONGO_OPTS} --port=${BACKUP_PORT}"; fi
if [[ ! -z ${BACKUP_USER+x} ]]; then MONGO_OPTS="${MONGO_OPTS} --username=${BACKUP_USER}"; fi
if [[ ! -z ${BACKUP_PASS+x} ]]; then MONGO_OPTS="${MONGO_OPTS} --password=${BACKUP_PASS}"; fi
if [[ ! -z ${BACKUP_EXTRA_OPTS+x} ]]; then MONGO_OPTS="${MONGO_OPTS} ${BACKUP_EXTRA_OPTS}"; fi

# export driver restore command. You must use \${RESTORE_FILE_PATH} for get backup file to restore. Don't forget the \ !
DRIVER_RESTORE_CMD="mongorestore ${MONGO_OPTS} --drop --gzip --archive=\${RESTORE_FILE_PATH}"

if [[ ! -z ${BACKUP_DB+x} ]]; then MONGO_OPTS="${MONGO_OPTS} --db=${BACKUP_DB}"; fi

# export driver backup command
DRIVER_BACKUP_CMD="mongodump ${MONGO_OPTS} --gzip --archive=${DRIVER_FILE_PATH} || rm ${DRIVER_FILE_PATH}"
