#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <CONTROL_PLANE_IP>"
  exit 1
fi

HOST="$1"
USER="ubuntu"
KEY="/home/ec2-user/k8s_key_pair.pem"
MAX_RETRIES=30
SLEEP_SECONDS=10

echo "Waiting for SSH on ${HOST}..."

for ((i=1; i<=MAX_RETRIES; i++)); do
  if ssh \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -o ConnectTimeout=5 \
    -i "${KEY}" \
    "${USER}@${HOST}" \
    "echo SSH ready" >/dev/null 2>&1; then

    echo "SSH is ready on ${HOST}"
    exit 0
  fi

  echo "Attempt ${i}/${MAX_RETRIES}: SSH not ready yet, retrying in ${SLEEP_SECONDS}s..."
  sleep "${SLEEP_SECONDS}"
done

echo "ERROR: SSH not available on ${HOST} after $((MAX_RETRIES * SLEEP_SECONDS)) seconds"
exit 1
