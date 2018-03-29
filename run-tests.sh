#!/bin/sh

TARGET_CONTAINER_ID=$(uuidgen)

function cleanup {
  echo "Cleanup"
  docker stop $TARGET_CONTAINER_ID
}
trap cleanup EXIT

# 1. Build runner container
echo "Building/updating runner container"
docker build --tag ansible-runner:latest runner/

# 1. Start target container
echo "Starting target container"
docker run --rm --detach --name $TARGET_CONTAINER_ID chrismeyers/centos7

# 2. Execute ansible playbook in ansible runner container
echo "Executing ansible playbook"
docker run --rm -ti -v "$(pwd)/playbook":/playbook -w /playbook ansible-runner:latest \
  ansible-playbook -i inventory site.yml --connection local

# 3. Run testinfra tests in ansible container
