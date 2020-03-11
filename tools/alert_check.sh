#!/bin/bash

function testNumFmt () {
  if [[ "${2}" != '' && ! "$2" =~ ^[0-9.,]+[KMGTPEZY]?i?$ ]]; then
    echo "Bad format for ${1} : ${2}" 1>&2
    exit 1
  fi
}

if [[ ! -z ${BACKUP_ALERT_IF_THE_SIZE_OF_LAST_BACKUP_GREATER_THAN+x} ]]; then
  testNumFmt 'BACKUP_ALERT_IF_THE_SIZE_OF_LAST_BACKUP_GREATER_THAN' "${BACKUP_ALERT_IF_THE_SIZE_OF_LAST_BACKUP_GREATER_THAN}"
  DIFF=$(numfmt --from=auto "${BACKUP_ALERT_IF_THE_SIZE_OF_LAST_BACKUP_GREATER_THAN}")
fi
if [[ ! -z ${BACKUP_ALERT_IF_THE_BACKUP_SIZE_IS_SMALLER_THAN+x} ]]; then
  testNumFmt 'BACKUP_ALERT_IF_THE_BACKUP_SIZE_IS_SMALLER_THAN' "${BACKUP_ALERT_IF_THE_BACKUP_SIZE_IS_SMALLER_THAN}"
  MIN=$(numfmt --from=auto "${BACKUP_ALERT_IF_THE_BACKUP_SIZE_IS_SMALLER_THAN}")
fi

ALERT_CHECK_CMD=$(cat <<EOF
# If backup is not create, stop and alert
if [[ ! -f ${DRIVER_FILE_PATH} ]]; then
  sendAlert "[$BACKUP_ALERT_NAME] Error when create backup"
  exit 1
fi

NEW_SIZE=\$(stat -c %s $DRIVER_FILE_PATH)

if [[ ! -z \${BACKUP_ALERT_IF_THE_BACKUP_SIZE_IS_SMALLER_THAN+x} ]]; then
    if [[ \${NEW_SIZE} -lt ${MIN} ]]; then
      sendAlert "[${BACKUP_ALERT_NAME}] Backup size is \$(numfmt --to=si \${NEW_SIZE}), it's smaller than $(numfmt --to=si ${MIN})"
    fi
fi

if [[ ! -z \${BACKUP_ALERT_IF_THE_SIZE_OF_LAST_BACKUP_GREATER_THAN+x} ]]; then
  LAST=\$(ls -t /data/backup/ | head -n 2 | tail -n 1)
  # test if is the first backup (value is "0")
  if [[ "\$(echo \${LAST} | wc -l)" == "1" ]]; then
    LAST_SIZE=\$(stat -c %s /data/backup/\${LAST})
    NEW_SIZE_WITH_DIFF=\$(expr \${NEW_SIZE} + ${DIFF})

    if [[ \${NEW_SIZE_WITH_DIFF} -lt \${LAST_SIZE} ]]; then
      sendAlert "[${BACKUP_ALERT_NAME}] Backup size changed from \$(numfmt --to=si \${LAST_SIZE}) to \$(numfmt --to=si \${NEW_SIZE})"
    fi
  fi
fi
EOF
)
