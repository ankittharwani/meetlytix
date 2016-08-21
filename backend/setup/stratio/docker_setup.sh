docker-machine create --driver softlayer \
  --softlayer-user=ankitthar \
  --softlayer-api-key=b8d98b960bbc107d653a3eece5f9e56323c3adf1ad11020a2ae2ad4544179d38 \
  --softlayer-memory=16384 \
  --softlayer-disk-size=100 \
  --softlayer-cpu=8 \
  --softlayer-region=sjc01 \
  --softlayer-hostname=docker-host-01 \
  --softlayer-image=REDHAT_LATEST_64 \
  --softlayer-domain=meetlytix.com \
  doch-01

docker-compose -f sparta-compose.yml up -d
