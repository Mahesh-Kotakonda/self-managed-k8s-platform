#!/usr/bin/env bash
set -e

CONTROL_PLANE_IP="$1"
KEY="/home/ec2-user/k8s_key_pair.pem"

if [ -z "$CONTROL_PLANE_IP" ]; then
  echo "ERROR: Control plane IP not provided"
  exit 1
fi

echo "Fetching kubeconfig from control plane ($CONTROL_PLANE_IP)..."

ssh -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -i "$KEY" \
    ubuntu@"$CONTROL_PLANE_IP" \
    "sudo cat /etc/kubernetes/admin.conf" > kubeconfig

echo "✅ Kubeconfig saved locally as ./kubeconfig"
