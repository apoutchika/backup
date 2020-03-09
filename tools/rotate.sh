#!/bin/bash

ROTATE_CMD="rotate-backups"
if [[ ! -z ${BACKUP_ROTATE_MINUTELY+x} ]]; then ROTATE_CMD="${ROTATE_CMD} -M ${BACKUP_ROTATE_MINUTELY}"; fi
if [[ ! -z ${BACKUP_ROTATE_HOURLY+x} ]]; then ROTATE_CMD="${ROTATE_CMD} -H ${BACKUP_ROTATE_HOURLY}"; fi
if [[ ! -z ${BACKUP_ROTATE_DAILY+x} ]]; then ROTATE_CMD="${ROTATE_CMD} -d ${BACKUP_ROTATE_DAILY}"; fi
if [[ ! -z ${BACKUP_ROTATE_WEEKLY+x} ]]; then ROTATE_CMD="${ROTATE_CMD} -w ${BACKUP_ROTATE_WEEKLY}"; fi
if [[ ! -z ${BACKUP_ROTATE_MONTHLY+x} ]]; then ROTATE_CMD="${ROTATE_CMD} -m ${BACKUP_ROTATE_MONTHLY}"; fi
if [[ ! -z ${BACKUP_ROTATE_YEARLY+x} ]]; then ROTATE_CMD="${ROTATE_CMD} -y ${BACKUP_ROTATE_YEARLY}"; fi
if [[ ! -z ${BACKUP_ROTATE_OPTS+x} ]]; then ROTATE_CMD="${ROTATE_CMD} ${BACKUP_ROTATE_OPTS}"; fi

# If not configuration for rotate, empty variable
if [[ "${ROTATE_CMD}" != "rotate-backups" ]]; then
  ROTATE_CMD="${ROTATE_CMD} /data/backup/"
else
  ROTATE_CMD=""
fi
