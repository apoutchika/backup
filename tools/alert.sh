#!/bin/bash

# Prepare cmd for sendAlert function
if [[ -z ALERT ]]; then ALERT='log'; fi


if [[ ${ALERT} == 'mail' ]]; then
  ALERT_CMD="swaks"
  if [[ ! -z ${MAIL_TO+x} ]]; then ALERT_CMD="${ALERT_CMD} --to ${MAIL_TO}"; fi
  if [[ ! -z ${MAIL_HOST+x} ]]; then ALERT_CMD="${ALERT_CMD} --server ${MAIL_HOST}"; fi
  if [[ ! -z ${MAIL_FROM+x} ]]; then ALERT_CMD="${ALERT_CMD} --from ${MAIL_FROM}"; fi
  if [[ ! -z ${MAIL_USER+x} || ${MAIL_PASS+x} ]]; then ALERT_CMD="${ALERT_CMD} --auth LOGIN"; fi
  if [[ ! -z ${MAIL_USER+x} ]]; then ALERT_CMD="${ALERT_CMD} --auth-user ${MAIL_USER}"; fi
  if [[ ! -z ${MAIL_PASS+x} ]]; then ALERT_CMD="${ALERT_CMD} --auth-user ${MAIL_PASS}"; fi
  ALERT_CMD="${ALERT_CMD} --silent -h-Subject: \"[${ALERT_NAME}] Error Backup\" --body \"\${1}\""
elif [[ ${ALERT} == 'slack' ]]; then
  ALERT_CMD="curl -X POST --silent -H 'Content-type: application/json' --data \"{'text':'\${1}'}\" ${SLACK_WEBHOOK_URL} > /dev/null"
fi
