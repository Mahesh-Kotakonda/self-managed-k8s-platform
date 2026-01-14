# 🚀 Self-Managed Production-Style Kubernetes Cluster on AWS

**Fully automated using Terraform, Ansible, and GitHub Actions**

---

## 📌 Project Overview

This repository implements a **self-managed, production-style Kubernetes cluster on AWS**, fully automated from **infrastructure provisioning** to **cluster bootstrap** and **clean teardown**.

Unlike local Kubernetes tools (Minikube, Kind) or managed services (EKS), this project exposes:

- Real Kubernetes internals
- Real cloud networking and security boundaries
- Real operational challenges

This makes it ideal for **learning, experimentation, and platform engineering practice**.

> ⚠️ **This is not a demo cluster.**  
> It is a **long-living, reusable Kubernetes environment** designed to behave like real production systems.

---

## ❓ Why This Project Exists

### The Problem

- Local Kubernetes tools **do not reflect production reality**
- Managed Kubernetes (EKS) **hides critical internals**
- Manual cluster creation is **slow, inconsistent, and error-prone**
- Private networking, NAT, and security are **hard to practice locally**
- Forgotten cloud resources lead to **unexpected costs**

### The Goal

To create a **repeatable, destroyable, cost-aware Kubernetes cluster** that:

- Runs in a **real cloud environment**
- Uses **private networking**
- Is **fully automated**
- Can be **reused safely** for deep Kubernetes learning and experimentation

---

## ✅ What This Project Solves

- Provides a **real AWS-based Kubernetes cluster**
- Uses **private subnets** with **bastion-based access**
- Automates the **entire lifecycle** *(create → use → destroy)*
- Separates **infrastructure** from **configuration**
- Enables **safe experimentation** without manual setup

---

## 🧠 Who Should Use This

- **Beginners**  
  Learn how Kubernetes is built in real-world environments

- **Engineers**  
  Learn Terraform, Ansible, and Kubernetes together

- **DevOps / Platform Engineers**  
  Practice production-style cluster design and automation

- **MLOps / SRE Learners**  
  Experiment with realistic infrastructure and failure scenarios

---
## 🏗️ Architecture Overview

GitHub Actions (Self-Hosted Runner)--->Terraform → AWS Infrastructure----> Bastion Host (Public Subnet)----> Kubernetes Nodes (Private Subnets)

---
## 🧱 Key Design Principles

- Kubernetes nodes **do not have public IPs**
- All access happens **through a bastion host**
- Infrastructure and configuration are **fully automated**
- The cluster can be **safely destroyed at any time**

---

## 🌐 Networking & Security Model

- **Custom AWS VPC**
- **Public Subnet**
  - Bastion Host (single secure entry point)
- **Private Subnets**
  - Kubernetes Control Plane
  - Worker Nodes
- **NAT Gateway**
  - Allows outbound internet access for private nodes
- **Strict Security Group rules**
  - Minimal inbound access
  - Explicit east–west traffic control

> This setup mirrors **real production security boundaries**.

---

## 🔄 How the System Works

1. **GitHub Actions** orchestrates workflows using a self-hosted runner
2. **Terraform** provisions all AWS infrastructure (VPC, EC2, networking)
3. Terraform outputs generate a **dynamic Ansible inventory**
4. **Ansible**, executed from the bastion host, configures:
   - OS prerequisites
   - `containerd` container runtime
   - Kubernetes components using `kubeadm`
5. The Kubernetes control plane is initialized
6. Worker nodes securely join the cluster
7. `kubeconfig` is retrieved for cluster access
8. The cluster can be **cleanly destroyed** using Terraform

✅ No manual SSH hopping  
✅ No hardcoded IP addresses  
✅ Fully automated lifecycle  

---

## 🧰 Tools & Technologies Used

### Infrastructure
- **AWS EC2** – Compute
- **AWS VPC** – Networking
- **NAT & Internet Gateway** – Controlled internet access
- **Security Groups** – Firewall rules

### Automation
- **Terraform** – Infrastructure provisioning
- **Ansible** – OS and Kubernetes configuration
- **GitHub Actions** – CI/CD orchestration
- **Self-Hosted Runner** – Secure execution environment

### Kubernetes Stack
- **kubeadm** – Cluster initialization
- **kubelet** – Node agent
- **kubectl** – Cluster management
- **containerd** – Container runtime
- **Calico** – CNI networking

---
## 🎯 What You Achieve With This Project

- Hands-on experience with **real Kubernetes internals**
- Practice **production-grade networking and security**
- Learn **end-to-end automation**
- Safely experiment with:
  - Persistent Volumes (PV / PVC)
  - Networking and ingress
  - Node failures and recovery
  - MLOps and SRE workflows
- Avoid cloud cost surprises through **clean teardown**

---

## 🔮 Future Enhancements

- Multi-control-plane (HA) setup
- API server load balancer
- Ingress controller
- Monitoring and logging stack
- Autoscaling
- GPU-enabled node pools
- Policy enforcement (OPA / Kyverno)

---

## ⭐ Why This Project Matters

This repository demonstrates:

- **Infrastructure-as-Code discipline**
- **Secure production-style networking**
- **Real Kubernetes bootstrapping**
- **Automation-first design**
- **Cost-aware cloud usage**

> Built to be **read, reused, extended, broken, and fixed** —  
> just like real production systems.







