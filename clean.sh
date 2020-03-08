#!/bin/bash

if [[ "$(docker-compose ps | grep -E "(redis|mongo|mysql)" | grep tcp | wc -l)" != "3" ]]; then
  echo "You must start mongo, redis and mysql before start fixture import"
  exit 1
fi

docker-compose exec mongo mongo -u user -p pass --authenticationDatabase admin test --eval "db.toto.remove({})"
docker-compose exec mysql mysql -u user -ppass test -e "use test; DELETE FROM \`toto\`;"
docker-compose exec redis redis-cli -a pass FLUSHALL
