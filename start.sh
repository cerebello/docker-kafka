#! /usr/bin/env bash

##########################################
### VALIDATE IP
### http://www.linuxjournal.com/content/validating-ip-address-bash-script
##########################################
function valid_ip()
{
    local  ip=$1
    local  stat=1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

##########################################
### CREATE config/server.properties
##########################################
echo "broker.id=${KAFKA_ID}" > ${KAFKA_HOME}/config/server.properties
echo "num.network.threads=${KAFKA_NETWORK_THREADS}" >> ${KAFKA_HOME}/config/server.properties
echo "num.io.threads=${KAFKA_IO_THREADS}" >> ${KAFKA_HOME}/config/server.properties
echo "socket.send.buffer.bytes=${KAFKA_SOCKET_SEND_BUFFER_BYTES}" >> ${KAFKA_HOME}/config/server.properties
echo "socket.receive.buffer.bytes=${KAFKA_SOCKET_RECEIVE_BUFFER_BYTES}" >> ${KAFKA_HOME}/config/server.properties
echo "socket.request.max.bytes=${KAFKA_SOCKET_REQUEST_MAX_BYTES}" >> ${KAFKA_HOME}/config/server.properties
echo "log.dirs=${KAFKA_LOG_DIR}" >> ${KAFKA_HOME}/config/server.properties
echo "num.partitions=${KAFKA_NUM_PARTITIONS}" >> ${KAFKA_HOME}/config/server.properties
echo "num.recovery.threads.per.data.dir=${KAFKA_NUM_RECOVERY_THREADS}" >> ${KAFKA_HOME}/config/server.properties
echo "log.retention.hours=${KAFKA_LOG_RETENTION_HOURS}" >> ${KAFKA_HOME}/config/server.properties
echo "log.segment.bytes=${KAFKA_SEGMENT_BYTES}" >> ${KAFKA_HOME}/config/server.properties
echo "log.retention.check.interval.ms=${KAFKA_RETENTION_CHECK_MS}" >> ${KAFKA_HOME}/config/server.properties
echo "zookeeper.connection.timeout.ms=${KAFKA_ZK_CONN_TIMEOUT_MS}" >> ${KAFKA_HOME}/config/server.properties

##########################################
### ZOOKEEPER SERVERS
##########################################
for VAR in `env`
do
  if [[ $VAR =~ ^ZK_SERVER_[0-9]+= ]]; then
    IP=`echo "$VAR" | sed 's/.*=//'`
    SERVER_ID=`echo "$VAR" | sed -r "s/ZK_SERVER_(.*)=.*/\1/"`
    valid_ip ${IP}
    if [[ $? -eq 0 ]]; then
      SERVER_IP=${IP}
    else
      SERVER_IP=`dig +short $IP`
    fi
    if [ -z ${ZK_NODES} ]; then
      ZK_NODES="${SERVER_IP}:2181"
    else
      ZK_NODES+=",${SERVER_IP}:2181"
    fi
  fi
done
if [ ${ZK_NODES} ]; then
  echo "zookeeper.connect=${ZK_NODES}" >> ${KAFKA_HOME}/config/server.properties
else
  echo "zookeeper.connect=0.0.0.0:2181" >> ${KAFKA_HOME}/config/server.properties
  export ZK_DEAMON=1
  /bin/bash -c /opt/start-zookeeper.sh
fi

# show configurations
/bin/cat ${KAFKA_HOME}/config/server.properties

# Run Kafka
${KAFKA_HOME}/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
