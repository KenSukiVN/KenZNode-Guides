#!/bin/bash

set -eo pipefail

# The defaults


docker build -t tangle:v1 -f docker/Dockerfile .


CHAINSPEC_FILE="tangle-standalone.json"
NAME="tangle"
BASE_PATH="/data"
HOST_BASE_PATH="${HOME}/.tangle"
source env/testnet
eval "echo \"$(cat env/testnet)\"" > env/testnet.env
ENV_FILE="env/testnet.env"

mkdir -p ${HOST_BASE_PATH}/${BASE_PATH}
mkdir -p ${HOST_BASE_PATH}/${BASE_PATH}/node-key
wget -O ${HOST_BASE_PATH}/${CHAINSPEC_FILE} "https://raw.githubusercontent.com/webb-tools/tangle/main/chainspecs/testnet/tangle-standalone.json"
chmod 744 ${HOST_BASE_PATH}/${CHAINSPEC_FILE}


docker stop tangle && docker container rm tangle

docker run --env-file ${ENV_FILE} \
                --mount type=bind,source=${HOST_BASE_PATH},target=${BASE_PATH} \
                --name "${NAME}" \
                --restart unless-stopped \
                -d tangle:v1

docker logs -f --tail 100 tangle

exit 0