#!/bin/bash

# Prepare cmd for sendAlert function
if [[ -z ${BACKUP_ALERT} ]]; then BACKUP_ALERT='log'; fi


if [[ ${BACKUP_ALERT} == 'mail' ]]; then
  ALERT_CMD="swaks"
  if [[ ! -z ${BACKUP_MAIL_TO+x} ]]; then ALERT_CMD="${ALERT_CMD} --to ${BACKUP_MAIL_TO}"; fi
  if [[ ! -z ${BACKUP_MAIL_HOST+x} ]]; then ALERT_CMD="${ALERT_CMD} --server ${BACKUP_MAIL_HOST}"; fi
  if [[ ! -z ${BACKUP_MAIL_FROM+x} ]]; then ALERT_CMD="${ALERT_CMD} --from ${BACKUP_MAIL_FROM}"; fi
  if [[ ! -z ${BACKUP_MAIL_USER+x} || ${MAIL_PASS+x} ]]; then ALERT_CMD="${ALERT_CMD} --auth LOGIN"; fi
  if [[ ! -z ${BACKUP_MAIL_USER+x} ]]; then ALERT_CMD="${ALERT_CMD} --auth-user ${BACKUP_MAIL_USER}"; fi
  if [[ ! -z ${BACKUP_MAIL_PASS+x} ]]; then ALERT_CMD="${ALERT_CMD} --auth-password ${BACKUP_MAIL_PASS}"; fi
  ALERT_CMD="${ALERT_CMD} --silent -h-Subject: \"[${BACKUP_ALERT_NAME}] Error Backup\" --body \"\${1}\""
elif [[ ${BACKUP_ALERT} == 'slack' ]]; then
  ALERT_CMD="curl -X POST --silent -H 'Content-type: application/json' --data \"{'text':'\${1}'}\" ${BACKUP_SLACK_WEBHOOK_URL} > /dev/null"
fi
