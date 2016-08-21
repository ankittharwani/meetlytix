# sudo -i
# curl -L https://github.com/docker/compose/releases/download/1.5.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
# chmod +x /usr/local/bin/docker-compose
# weave launch-router --dns-domain="stratio-01.meetlytix.com" --init-peer-count 1 && weave launch-proxy -H tcp://0.0.0.0:12375
# weave expose
# eval $(weave env)

zookeeper:
  image: stratio/zookeeper:3.4.6
  container_name: zookeeper
  ports:
    - "2181:2181"

waitzk:
  image: aanand/wait
  container_name: waitzk
  links:
      - zookeeper

sparta:
  image: stratio/sparta:0.9.4
  container_name: sparta
  ports:
    - "9090:9090"
    - "9091:9091"
  links:
    - waitzk
  environment:
    ZOOKEEPER_HOST: zookeeper.stratio-01.meetlytix.com

#eval $(weave env --restore)
