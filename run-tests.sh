#!/bin/sh

set -e

PROJECT_ROOT=$(cd `dirname $0` && pwd)
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
docker run --rm --detach --name ${TARGET_CONTAINER_ID} \
  --hostname targethost \
  --privileged \
  --network ${NETWORK_ID} \
  --network-alias=targethost \
  --volume ${PROJECT_ROOT}/keys/target/authorized_keys:/root/.ssh/authorized_keys \
  chrismeyers/centos7

# 2. Execute ansible playbook and testinfra tests in runner container
echo "Executing ansible lint, playbook and testinfra tests"
docker run --rm --tty \
  --volume "${PROJECT_ROOT}/playbook":/playbook \
  --volume "${PROJECT_ROOT}/test":/test \
  --workdir /playbook \
  --network ${NETWORK_ID} \
  ansible-runner:latest \
  sh -c 'ansible-lint site.yml && ansible-playbook --inventory-file=inventory site.yml && py.test --verbose --connection=ansible --ansible-inventory=inventory /test'
