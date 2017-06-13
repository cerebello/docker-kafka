# About:

[Docker](http://www.docker.com/) image based on [debian:jessie](https://hub.docker.com/_/debian/)

[![Docker Stars](https://img.shields.io/docker/stars/cerebello/kafka.svg)](https://hub.docker.com/r/cerebello/kafka/) [![Docker Pulls](https://img.shields.io/docker/pulls/cerebello/kafka.svg)](https://hub.docker.com/r/cerebello/kafka/) [![](https://images.microbadger.com/badges/image/cerebello/kafka.svg)](https://microbadger.com/images/cerebello/kafka)

## General Configuration:

| Variables | Property | Description | Default |
| --------- | -------- | ----------- | --------|
| KAFKA_ID | broker.id | The id of the broker. This must be set to a unique integer for each broker. | 1 |
| KAFKA_NETWORK_THREADS | num.network.threads | The number of threads handling network requests | 3 |
| KAFKA_IO_THREADS | num.io.threads | The number of threads doing disk I/O | 8 |
| KAFKA_SOCKET_SEND_BUFFER_BYTES | socket.send.buffer.bytes | The send buffer (SO_SNDBUF) used by the socket server | 102400 |
| KAFKA_SOCKET_RECEIVE_BUFFER_BYTES | socket.receive.buffer.bytes | The receive buffer (SO_RCVBUF) used by the socket server | 102400 |
| KAFKA_SOCKET_REQUEST_MAX_BYTES | socket.request.max.bytes | The maximum size of a request that the socket server will accept (protection against OOM) | 104857600 |
| KAFKA_LOG_DIR | log.dirs | A comma seperated list of directories under which to store log files | /var/kafka |
| KAFKA_NUM_PARTITIONS | num.partitions | The default number of log partitions per topic | 2 |
| KAFKA_NUM_RECOVERY_THREADS | num.recovery.threads.per.data.dir | The number of threads per data directory to be used for log recovery at startup and flushing at shutdown. | 1 |
| KAFKA_LOG_RETENTION_HOURS | log.retention.hours | The minimum age of a log file to be eligible for deletion due to age | 168 |
| KAFKA_SEGMENT_BYTES | log.segment.bytes | The maximum size of a log segment file. When this size is reached a new log segment will be created. | 1073741824 |
| KAFKA_RETENTION_CHECK_MS | log.retention.check.interval.ms | The interval at which log segments are checked to see if they can be deleted according. | 300000 |
| KAFKA_ZK_CONN_TIMEOUT_MS | zookeeper.connection.timeout.ms | Timeout in ms for connecting to zookeeper | 6000 |

## Running Mode:

```
$ docker run -d -p 9092:9092 cerebello/kafka
```