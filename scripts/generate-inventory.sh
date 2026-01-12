#!/usr/bin/env bash
set -e

echo "Generating Ansible inventory from Terraform outputs..."

cd terraform

BASTION_IP=$(terraform output -raw bastion_public_ip)
CONTROL_PLANE_IP=$(terraform output -raw control_plane_private_ip)
WORKER_IPS=$(terraform output -json worker_private_ips | jq -r '.[]')

cd ..

INVENTORY_PATH="ansible/inventory/inventory.ini"

cat > "$INVENTORY_PATH" <<EOF
[bastion]
bastion ansible_host=${BASTION_IP}

[control_plane]
control-plane ansible_host=${CONTROL_PLANE_IP}

[workers]
EOF

for ip in $WORKER_IPS; do
  echo "worker ansible_host=${ip}" >> "$INVENTORY_PATH"
done

cat >> "$INVENTORY_PATH" <<EOF

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/home/ec2-user/k8s_key_pair.pem
ansible_ssh_common_args='-o ProxyJump=ubuntu@${BASTION_IP} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
EOF

echo "✅ Inventory generated at ${INVENTORY_PATH}"
