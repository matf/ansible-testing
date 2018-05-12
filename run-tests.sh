#!/bin/sh

set -e

TARGET_CONTAINER_ID=$(uuidgen)
NETWORK_ID=$(uuidgen)

# Remove target container and network when done
function cleanup {
  echo "Cleanup..."
  docker stop ${TARGET_CONTAINER_ID} > /dev/null
  docker network rm ${NETWORK_ID} > /dev/null
}
trap cleanup EXIT

# 1. Build runner container
echo "Building/updating runner container"
docker build --tag ansible-runner:latest runner/

# 2. Create network
echo "Creating network $NETWORK_ID"
docker network create --driver=bridge \
  ${NETWORK_ID}

# 1. Start target container
echo "Starting target container $TARGET_CONTAINER_ID"
docker run --rm --detach --name ${TARGET_CONTAINER_ID} --hostname targethost --privileged \
  --network ${NETWORK_ID} --network-alias=targethost \
  -v $(pwd)/keys/target/authorized_keys:/root/.ssh/authorized_keys \
  chrismeyers/centos7

# 2. Execute ansible playbook in ansible runner container
echo "Executing ansible playbook"
docker run --rm -t -v "$(pwd)/playbook":/playbook -w /playbook \
  --network ${NETWORK_ID} \
  ansible-runner:latest \
  ansible-playbook -i inventory site.yml

# 3. Run testinfra tests in ansible container
