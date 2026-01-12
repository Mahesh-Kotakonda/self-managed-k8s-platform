#!/usr/bin/env bash
set -e

echo "Generating Ansible inventory with correct SSH keys..."

cd terraform

BASTION_IP=$(terraform output -raw bastion_public_ip)
CONTROL_PLANE_IP=$(terraform output -raw control_plane_private_ip)
WORKER_IPS=$(terraform output -json worker_private_ips | jq -r '.[]')

cd ..

INVENTORY_PATH="ansible/inventory/inventory.ini"

cat > "$INVENTORY_PATH" <<EOF
# ==================================================
# Bastion (accessed from GitHub runner)
# ==================================================
[bastion]
bastion ansible_host=${BASTION_IP} ansible_ssh_private_key_file=/home/ec2-user/k8s_key_pair.pem

# ==================================================
# Control Plane (accessed from bastion)
# ==================================================
[control_plane]
control-plane ansible_host=${CONTROL_PLANE_IP}

# ==================================================
# Worker Nodes (accessed from bastion)
# ==================================================
[workers]
EOF

i=1
for ip in $WORKER_IPS; do
  echo "worker${i} ansible_host=${ip}" >> "$INVENTORY_PATH"
  i=$((i+1))
done

cat >> "$INVENTORY_PATH" <<EOF

# ==================================================
# Global settings
# ==================================================
[all:vars]
ansible_user=ubuntu
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

# ==================================================
# SSH key used WHEN Ansible runs on bastion
# ==================================================
[control_plane:vars]
ansible_ssh_private_key_file=/home/ubuntu/.ssh/k8s_key_pair.pem

[workers:vars]
ansible_ssh_private_key_file=/home/ubuntu/.ssh/k8s_key_pair.pem
EOF

echo "✅ Inventory generated at ${INVENTORY_PATH}"
