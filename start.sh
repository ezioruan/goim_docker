echo "start zookeeper..."
kafka/bin/zookeeper-server-start.sh -daemon kafka/config/zookeeper.properties
echo "start kafka ..."
kafka/bin/kafka-server-start.sh -daemon kafka/config/server.properties
cd  go/bin
echo "start router ..."
nohup ./router -c router.conf 2>&1 > /data/logs/goim/panic-router.log &
echo "start logic ..."
nohup ./logic -c logic.conf 2>&1 > /data/logs/goim/panic-logic.log &
echo "start comet ..."
nohup ./comet -c comet.conf 2>&1 > /data/logs/goim/panic-comet.log &
echo "start job ..."
nohup ./job -c job.conf 2>&1 > /data/logs/goim/panic-job.log &
cd ../..
