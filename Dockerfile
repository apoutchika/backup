FROM debian:buster-slim

ENV CRON_TIME '*/2 * * * *'
ENV S3_REGION us-west-1
ENV S3_USE_HTTPS True
ENV NAME_FORMAT '+%Y-%m-%d.%Hh%M.%S'
ENV RUN_ON_START_DELAY 20

RUN apt-get update
RUN apt-get install -y cron wget gnupg redis default-mysql-client python-pip swaks curl
RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
RUN echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.2 main" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list
RUN apt-get update
RUN apt-get install -y mongodb-org-tools

RUN rm -rf /var/lib/apt/lists/*

RUN pip install rotate-backups s3cmd

COPY ./run.sh /run.sh
COPY ./drivers /drivers
COPY ./tools /tools

RUN chmod +x /run.sh

RUN mkdir -p /data

CMD ["/bin/bash", "/run.sh"]

VOLUME ["/data"]
