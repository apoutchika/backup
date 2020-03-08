#!/bin/bash

# Must set driver backup extension, withou first point
DRIVER_EXTENSION='gz'


# Do not change this line, and use this variable for backup file path
DRIVER_FILE_PATH="/data/backup/\${DATE}.${DRIVER_EXTENSION}"


# Create you'r logic for generate backup and restore command


# export driver backup command
DRIVER_BACKUP_CMD="mybackupcmd --myoptions ${DRIVER_FILE_PATH}"


# export driver restore command. You must use \${RESTORE_FILE_PATH} for get backup file to restore. Don't forget the \ !
DRIVER_RESTORE_CMD="myrestorecmd --myoptions \${RESTORE_FILE_PATH}"
