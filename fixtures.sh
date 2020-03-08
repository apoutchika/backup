#!/bin/bash

if [[ "$(docker-compose ps | grep -E "(redis|mongo|mysql)" | grep tcp | wc -l)" != "3" ]]; then
  echo "You must start mongo, redis and mysql before start fixture import"
  exit 1
fi

CREATE_TABLE=$(cat <<EOF
CREATE TABLE IF NOT EXISTS \`toto\` (
  \`id\` mediumint(8) unsigned NOT NULL auto_increment,
  \`value\` varchar(255) NOT NULL,
  PRIMARY KEY  (\`id\`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;
EOF
)

docker-compose exec mysql bash -c "echo '${CREATE_TABLE}' | mysql -u user -ppass test"

for I in `seq 0 10`
do
  echo "Mongo"
  docker-compose exec mongo mongo -u user -p pass --authenticationDatabase admin test --eval "db.toto.insert({a: 'test', b: $I})"
  echo "Redis"
  docker-compose exec redis redis-cli -a pass SET test:${I} ${I}
  echo "Mysql"
  docker-compose exec mysql mysql -u user -ppass test -e "use test; INSERT INTO \`toto\` (\`value\`) VALUES ('Hello ${I}');"
done
