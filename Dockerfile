FROM cerebello/zookeeper:3.4.10
MAINTAINER Robson Júnior <bsao@cerebello.co>

##########################################
### USER ROOT
##########################################
USER root

##########################################
### ARGS AND ENVS
##########################################
ARG SCALA_VERSION=2.12
ARG KAFKA_MIRROR=http://artfiles.org/apache.org/kafka
ARG KAFKA_VERSION=0.10.2.1
ENV SCALA_VERSION=${SCALA_VERSION}
ENV KAFKA_VERSION=${KAFKA_VERSION}
ENV KAFKA_HOME=/opt/kafka
ENV KAFKA_DATA_DIR=/var/kafka
LABEL name="KAFKA" version=${KAFKA_VERSION}

##########################################
### CREATE USERS
##########################################
ARG KAFKA_USER=kafka
ARG KAFKA_GROUP=kafka
ARG KAFKA_UID=6000
ARG KAFKA_GID=6000
ENV KAFKA_USER=${KAFKA_USER}
ENV KAFKA_GROUP=${KAFKA_GROUP}
ENV KAFKA_UID=${KAFKA_UID}
ENV KAFKA_GID=${KAFKA_GID}
RUN addgroup -g ${KAFKA_GID} -S ${KAFKA_GROUP}
RUN adduser -u ${KAFKA_UID} -D -S -G ${KAFKA_USER} ${KAFKA_GROUP}
RUN usermod -a -G ${ZK_GROUP} ${KAFKA_USER}

##########################################
### KAFKA CONFIGRUATION
##########################################
# The id of the broker. This must be set to a unique integer for each broker.
ENV KAFKA_ID=1
# The number of threads handling network requests
ENV KAFKA_NETWORK_THREADS=3
# The number of threads doing disk I/O
ENV KAFKA_IO_THREADS=8
# The send buffer (SO_SNDBUF) used by the socket server
ENV KAFKA_SOCKET_SEND_BUFFER_BYTES=102400
# The receive buffer (SO_RCVBUF) used by the socket server
ENV KAFKA_SOCKET_RECEIVE_BUFFER_BYTES=102400
# The maximum size of a request that the socket server will accept (protection against OOM)
ENV KAFKA_SOCKET_REQUEST_MAX_BYTES=104857600
# A comma seperated list of directories under which to store log files
ENV KAFKA_LOG_DIR=${KAFKA_DATA_DIR}
# The default number of log partitions per topic
ENV KAFKA_NUM_PARTITIONS=2
# The number of threads per data directory to be used for log recovery at startup and flushing at shutdown.
ENV KAFKA_NUM_RECOVERY_THREADS=1
# The minimum age of a log file to be eligible for deletion due to age
ENV KAFKA_LOG_RETENTION_HOURS=168
# The maximum size of a log segment file. When this size is reached a new log segment will be created.
ENV KAFKA_SEGMENT_BYTES=1073741824
# The interval at which log segments are checked to see if they can be deleted according.
ENV KAFKA_RETENTION_CHECK_MS=300000
# Timeout in ms for connecting to zookeeper
ENV KAFKA_ZK_CONN_TIMEOUT_MS=6000

##########################################
### DIRECTORIES
##########################################
RUN mkdir -p ${KAFKA_HOME} && \
    mkdir -p ${KAFKA_DATA_DIR}

##########################################
### DOWNLOAD AND INSTALL ZOOKEEPER
##########################################
RUN wget ${KAFKA_MIRROR}/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    tar -xvf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C ${KAFKA_HOME} --strip=1 && \
    rm -rf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    chown -R ${KAFKA_USER}:${KAFKA_GROUP} ${KAFKA_DATA_DIR} && \
    chown -R ${KAFKA_USER}:${KAFKA_GROUP} ${KAFKA_HOME}

##########################################
### START SCRIPT
##########################################
ADD ./start.sh /opt/start-kafka.sh
RUN chmod +x /opt/start-kafka.sh

##########################################
### PORTS
##########################################
EXPOSE 9092

##########################################
### ENTRYPOINT
##########################################
USER ${KAFKA_USER}
WORKDIR ${KAFKA_HOME}
ENTRYPOINT ["/opt/start-kafka.sh"]
