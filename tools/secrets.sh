#!/bin/bash

cat /dev/null > /env.sh

for SECRET_ENV in $(env | grep '_FILE=')
do
  SECRET_NAME=$(echo ${SECRET_ENV} | cut -d '=' -f 1 | sed -e 's/_FILE$//')
  SECRET_PATH=$(echo ${SECRET_ENV} | rev | cut -d '=' -f 1 | rev)
  SECRET_VALUE=$(cat < $SECRET_PATH)
  eval "${SECRET_NAME}=${SECRET_VALUE}"
  echo "${SECRET_NAME}=${SECRET_VALUE}" >> /env.sh
done
