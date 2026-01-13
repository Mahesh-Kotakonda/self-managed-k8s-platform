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
- Automates the **entire lifecycle**  
  *(create → use → destroy)*
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

```text
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


🧱 Key Design Principles

Kubernetes nodes do not have public IPs

All access happens through a bastion host

Infrastructure and configuration are fully automated

The cluster can be safely destroyed at any time
