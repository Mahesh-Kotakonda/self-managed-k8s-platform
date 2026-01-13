🚀 Self-Managed Production-Style Kubernetes Cluster on AWS

Fully automated using Terraform, Ansible, and GitHub Actions

📌 Project Overview

This repository implements a self-managed, production-style Kubernetes cluster on AWS, fully automated from infrastructure provisioning to cluster bootstrap and clean teardown.

Unlike local Kubernetes tools or managed services, this project exposes real Kubernetes internals, real cloud networking, and real operational challenges — making it ideal for learning, experimentation, and platform engineering practice.

This is not a demo cluster.
It is a long-living, reusable Kubernetes environment designed to behave like production.

❓ Why This Project Exists
The Problem

Local tools (Minikube, Kind) do not reflect production reality

Managed Kubernetes (EKS) hides critical internals

Manual cluster creation is slow and inconsistent

Private networking, NAT, and security are hard to practice locally

Forgotten cloud resources lead to unexpected costs

The Goal

To create a repeatable, destroyable, cost-aware Kubernetes cluster that:

Runs in a real cloud

Uses private networking

Is fully automated

Can be reused for deep Kubernetes learning and experimentation

✅ What This Project Solves

Provides a real AWS-based Kubernetes cluster

Uses private subnets with bastion-based access

Automates the entire lifecycle (create → use → destroy)

Separates infrastructure and configuration

Enables safe experimentation without manual setup

🧠 Who Should Use This

Beginners — understand how Kubernetes is built in real environments

Engineers — learn Terraform, Ansible, and Kubernetes together

DevOps / Platform Engineers — practice production-style cluster design

MLOps / SRE learners — experiment with realistic infrastructure

🏗️ Architecture Overview
GitHub Actions (Self-Hosted Runner)
        |
        v
Terraform → AWS Infrastructure
        |
        v
Bastion Host (Public Subnet)
        |
        v
Kubernetes Nodes (Private Subnets)

Key Design Principles

Kubernetes nodes have no public IPs

All access happens via a bastion host

Infrastructure and configuration are fully automated

The cluster can be safely destroyed anytime

🌐 Networking & Security Model

Custom AWS VPC

Public Subnet

Bastion Host (single entry point)

Private Subnets

Kubernetes Control Plane

Worker Nodes

NAT Gateway for outbound access

Strict Security Group rules

This setup mirrors real production security boundaries.

🔄 How the System Works (Flow)

GitHub Actions orchestrates the workflow using a self-hosted runner

Terraform provisions all AWS infrastructure (VPC, EC2, networking)

Terraform outputs are used to generate a dynamic Ansible inventory

Ansible, executed via the bastion, configures:

OS prerequisites

containerd runtime

Kubernetes components via kubeadm

The Kubernetes cluster is initialized and validated

kubeconfig is securely retrieved for cluster access

The cluster can be destroyed cleanly using Terraform

Everything is automated — no manual SSH hopping, no hardcoded values.

🧰 Tools & Technologies Used
Infrastructure

AWS EC2 – Compute

AWS VPC – Networking

NAT & Internet Gateway – Controlled internet access

Security Groups – Firewall rules

Automation

Terraform – Infrastructure provisioning

Ansible – OS & Kubernetes configuration

GitHub Actions – CI/CD orchestration

Self-Hosted Runner – Secure execution environment

Kubernetes Stack

kubeadm – Cluster initialization

kubelet – Node agent

kubectl – Cluster management

containerd – Container runtime

Calico – CNI networking

📂 Repository Structure
.github/workflows/
  create-cluster.yml
  destroy-cluster.yml

terraform/
  main.tf
  variables.tf
  outputs.tf
  providers.tf
  versions.tf

ansible/
  inventory/
    inventory.ini.j2
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

🎯 What You Achieve With This Project

Hands-on experience with real Kubernetes internals

Practice production-grade networking and security

Learn end-to-end automation

Experiment safely with:

Storage (PV / PVC)

Networking & ingress

Node failures and recovery

MLOps and SRE workflows

Avoid cloud cost surprises through clean teardown

🔮 Future Enhancements

Multi-control-plane (HA) setup

API server load balancer

Ingress controller

Monitoring & logging stack

Autoscaling

GPU-enabled node pools

Policy enforcement (OPA / Kyverno)

⭐ Why This Project Matters

This repository demonstrates:

Infrastructure-as-Code discipline

Secure production-style networking

Real Kubernetes bootstrapping

Automation-first design

Cost-aware cloud usage

It is built to be read, reused, extended, broken, and fixed — just like real production systems.
