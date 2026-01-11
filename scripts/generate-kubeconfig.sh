#!/bin/bash
set -e

CONTROL_PLANE_IP=$1
KEY=/home/ec2-user/k8s_key_pair.pem

echo "Fetching kubeconfig from control plane..."

ssh -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -i $KEY \
    ubuntu@$CONTROL_PLANE_IP \
    "sudo cat /etc/kubernetes/admin.conf" > kubeconfig

echo "Kubeconfig saved locally as ./kubeconfig"
