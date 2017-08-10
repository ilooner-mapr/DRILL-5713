#!/bin/bash

waitForPort() {
  portFlag="0"

  while [ $portFlag = "0" ]; do
    portFlag=`docker exec postgres netstat -tulpn | grep $1 | wc -l | tr -d ' '`
    sleep 1
  done
}

docker run -d --rm --name postgres -p 5432:5432 mapr/postgresdrill5713

# Populate postgres

waitForPort 5432
sleep 2

## Create trx table

docker exec -i -t postgres psql -U postgres -c 'create table trx (categoryguid text, trxid text);'
docker exec -i -t postgres psql -U postgres -c "insert into trx (categoryguid , trxid) values ('id1', 'tid1');"
docker exec -i -t postgres psql -U postgres -c "insert into trx (categoryguid , trxid) values ('id1', 'tid2');"
docker exec -i -t postgres psql -U postgres -c "insert into trx (categoryguid , trxid) values ('id2', 'tid3');"
docker exec -i -t postgres psql -U postgres -c "insert into trx (categoryguid , trxid) values ('id2', 'tid4');"

