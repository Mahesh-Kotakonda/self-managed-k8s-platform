🚀 Self-Managed Production-Style Kubernetes Cluster on AWS

Fully automated with Terraform, Ansible, and GitHub Actions

📌 What Is This Project?

This repository builds a real, production-style Kubernetes cluster on AWS, fully automated from infrastructure creation to cluster bootstrap — and back to clean destruction.

Unlike local tools (Minikube, Kind) or managed services (EKS), this project gives you:

Full control over Kubernetes internals

Real cloud networking and security boundaries

A cluster you can reuse, break, fix, and learn from

It’s designed for learning, experimentation, and real-world practice, not demos.

🎯 Why This Exists
The Problem

Local Kubernetes ≠ real production

Managed Kubernetes hides critical details

Manual cluster setup is slow and error-prone

Private networking and security are hard to simulate

Forgotten cloud resources = surprise bills

What This Project Solves

✅ A real cloud Kubernetes cluster
✅ Private networking with bastion access
✅ Fully automated lifecycle (create → use → destroy)
✅ Clear separation of infrastructure and configuration
✅ Safe environment for advanced experimentation

🧠 Who Is This For?

Beginners → Understand how real Kubernetes is built

Engineers → Learn Terraform + Ansible + Kubernetes together

DevOps / Platform Engineers → Extend, harden, and evolve it

MLOps / SRE learners → Practice in a realistic environment

🏗️ High-Level Architecture (Simple View)
GitHub Actions
     |
     v
Terraform (AWS Infrastructure)
     |
     v
Bastion Host (Public Subnet)
     |
     v
Kubernetes Nodes (Private Subnets)

Key Ideas

Kubernetes nodes have no public IPs

Access happens only through a bastion host

Infrastructure and configuration are fully automated

Everything can be destroyed safely to control cost

🌐 Network Design (Production-Like)

Custom VPC

Public Subnet

Bastion Host (SSH entry point)

Private Subnets

Kubernetes Control Plane

Worker Nodes

NAT Gateway

Allows outbound internet access

Strict security group rules

This mirrors real production security boundaries.

🧰 Tools Used (And Why)
Infrastructure

AWS EC2 – Compute

AWS VPC – Networking

NAT / Internet Gateway – Controlled access

Security Groups – Firewall rules

Automation

Terraform – Infrastructure provisioning

Ansible – OS & Kubernetes configuration

GitHub Actions – Orchestration

Self-Hosted Runner – Secure execution

Kubernetes

kubeadm – Cluster initialization

kubelet – Node agent

kubectl – Cluster management

containerd – Container runtime

Calico – Networking (CNI)

📂 Repository Structure (What Goes Where)
.github/workflows/
  create-cluster.yml     # Create cluster
  destroy-cluster.yml    # Destroy cluster

terraform/
  main.tf                # VPC, EC2, networking
  variables.tf
  outputs.tf
  providers.tf
  versions.tf

ansible/
  inventory/
    inventory.ini.j2     # Dynamic inventory
  playbooks/
    bastion.yml
    bootstrap.yml
    control-plane.yml
    workers.yml
    network.yml
    kubeconfig.yml
    validate.yml

scripts/
  generate-inventory.sh
  generate-kubeconfig.sh
  wait-for-ssh.sh

🔄 End-to-End Workflow (Step by Step)
1️⃣ Trigger Cluster Creation

GitHub Actions workflow is started manually

Runs on a self-hosted runner

2️⃣ Terraform Creates Infrastructure

VPC, subnets, routing

Bastion host

Kubernetes control plane

Worker nodes

NAT & Internet Gateway

👉 Terraform handles only infrastructure

3️⃣ Inventory Is Generated Automatically

Terraform outputs private IPs

Ansible inventory is created dynamically

No hardcoded values

4️⃣ Bastion Is Configured

Ansible installs and prepares:

kubectl

SSH access

Required tools

Copies Ansible project to bastion

The bastion becomes the secure control point.

5️⃣ Kubernetes Is Bootstrapped

From the bastion:

OS preparation

containerd installation

kubeadm initialization

Worker nodes join

Calico networking installed

6️⃣ kubeconfig Is Retrieved

Securely fetched

Permissions locked down

kubectl access enabled

7️⃣ Cluster Validation

Node readiness checks

Basic health verification

8️⃣ Destroy When Done

Manual destroy workflow

Optional scheduled destroy (cost control)

Terraform removes everything cleanly

🔐 Security Design

No public IPs on Kubernetes nodes

SSH access only via bastion

Strict firewall rules

Short-lived join tokens

kubeconfig permissions locked

Secrets stored in GitHub Secrets

🧪 What You Can Do With This Cluster

Deploy real workloads

Test PV / PVC behavior

Explore networking and ingress

Simulate node failures

Practice MLOps pipelines

Add monitoring and logging

Learn real SRE workflows

🚧 Intentional Limitations

Single control plane

No managed services

Focused on learning, not production SLA

These are design choices, not shortcomings.

🔮 Possible Future Improvements

Multi-control-plane HA

API server load balancer

Ingress controller

Monitoring & logging stack

Autoscaling

GPU node pools

Policy enforcement (OPA / Kyverno)

✅ Why This Project Matters

This is not a demo.

It demonstrates:

Infrastructure-as-Code discipline

Secure production networking

Kubernetes internals

End-to-end automation

Cost-aware cloud usage

It’s built to be read, reused, broken, fixed, and extended.
