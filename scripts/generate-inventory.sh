#!/bin/bash
set -e

cd terraform

CONTROL_PLANE_IP=$(terraform output -raw control_plane_ip)
WORKER_IPS=$(terraform output -json worker_ips | jq -r '.[]')

cd ..

cat > ansible/inventory/inventory.ini <<EOF
[control_plane]
$CONTROL_PLANE_IP

[workers]
$WORKER_IPS

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/home/ec2-user/k8s_key_pair.pem
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
EOF

