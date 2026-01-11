#!/bin/bash
set -e

HOST=$1
KEY=/home/ec2-user/k8s_key_pair.pem

echo "Waiting for SSH on $HOST..."

for i in {1..30}; do
  if ssh -o StrictHostKeyChecking=no \
         -o UserKnownHostsFile=/dev/null \
         -i $KEY \
         ubuntu@$HOST "echo SSH ready" >/dev/null 2>&1; then
    echo "SSH is ready on $HOST"
    exit 0
  fi

  echo "Still waiting for SSH on $HOST..."
  sleep 10
done

echo "ERROR: SSH not available on $HOST after waiting"
exit 1
