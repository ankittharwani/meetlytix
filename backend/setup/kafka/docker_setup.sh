# create instance
slcli vs create \
  --datacenter=sjc03 \
  --hostname=docker-host-2 \
  --domain=meetlytix.com \
  --billing=hourly \
  --key=ankitmacpersonal \
  --cpu=4 \
  --memory=8192 \
  --disk=100 \
  --network=100 \
  --os=CENTOS_LATEST_64

# install docker
yum -y update

tee /etc/yum.repos.d/docker.repo <<-EOF
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

yum -y install docker-engine

service docker start

# install docker compose
curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

# start / scale kafka
docker-compose up -d

docker-compose scale kafka=2

# create topic
./start-kafka-shell.sh kafka-01.meetlytix.com kafka-01.meetlytix.com:2181

./start-kafka-shell.sh kafka-01.meetlytix.com zookeeper.stratio-01.meetlytix.com:2181

$KAFKA_HOME/bin/kafka-topics.sh --create --topic ankit --partitions 3 --zookeeper $ZK --replication-factor 2
$KAFKA_HOME/bin/kafka-topics.sh --describe --topic ankit --zookeeper $ZK
$KAFKA_HOME/bin/kafka-console-producer.sh --topic=ankit \
--broker-list=`broker-list.sh`
$KAFKA_HOME/bin/kafka-console-consumer.sh --topic=ankit --zookeeper=$ZK
