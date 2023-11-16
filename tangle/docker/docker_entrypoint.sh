#!/usr/bin/env bash
set -euo pipefail


# load env variables from a file if ENV_FILE is set
if [[ -n "${ENV_FILE:-}" ]] && [[ -f "${ENV_FILE}" ]]; then
  set -o allexport
  source ${ENV_FILE}
  set +o allexport
fi

CHAIN=${CHAIN:?'Chain should be specified'}
NAME=${NAME:?'Name should be specified'}
BASE_PATH=${BASE_PATH:?'Base path should be specified'}
RPC_PORT=${RPC_PORT:-9944}
PORT=${PORT:-30333}


ARGS=(
  --validator
  --name "${NAME}"
  --chain "${CHAIN}"
  --node-key-file "${NODE_KEY_PATH}"
  --rpc-port "${RPC_PORT}"
  --port "${PORT}"
)


/usr/local/bin/tangle \
  --base-path "${BASE_PATH}" \
  --name "${NAME}" \
  --chain ${CHAIN} \
  --node-key-file "${NODE_KEY_PATH}" \
  --port 30334 \
  --rpc-port 9944 \
  --prometheus-port 9615 \
  --auto-insert-keys \
  --validator \
  --telemetry-url "wss://telemetry.polkadot.io/submit 0" \
  --no-mdns