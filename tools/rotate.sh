#!/bin/bash

ROTATE_CMD="rotate-backups"
if [[ ! -z ${ROTATE_MINUTELY+x} ]]; then ROTATE_CMD="${ROTATE_CMD} -M ${ROTATE_MINUTELY}"; fi
if [[ ! -z ${ROTATE_HOURLY+x} ]]; then ROTATE_CMD="${ROTATE_CMD} -H ${ROTATE_HOURLY}"; fi
if [[ ! -z ${ROTATE_DAILY+x} ]]; then ROTATE_CMD="${ROTATE_CMD} -d ${ROTATE_DAILY}"; fi
if [[ ! -z ${ROTATE_WEEKLY+x} ]]; then ROTATE_CMD="${ROTATE_CMD} -w ${ROTATE_WEEKLY}"; fi
if [[ ! -z ${ROTATE_MONTHLY+x} ]]; then ROTATE_CMD="${ROTATE_CMD} -m ${ROTATE_MONTHLY}"; fi
if [[ ! -z ${ROTATE_YEARLY+x} ]]; then ROTATE_CMD="${ROTATE_CMD} -y ${ROTATE_YEARLY}"; fi
if [[ ! -z ${ROTATE_OPTS+x} ]]; then ROTATE_CMD="${ROTATE_CMD} ${ROTATE_OPTS}"; fi

# If not configuration for rotate, empty variable
if [[ "${ROTATE_CMD}" != "rotate-backups" ]]; then
  ROTATE_CMD="${ROTATE_CMD} /data/backup/"
else
  ROTATE_CMD=""
fi
