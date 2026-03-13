# ☁️ Jerney Infrastructure (Terraform)

This folder contains the Terraform configuration to provision the Google Cloud Platform (GCP) infrastructure for the Jerney application.

## 🏗️ Infrastructure Overview

This Terraform setup is designed to be secure, scalable, and cost-effective.

- **Custom VPC Network (`jerney-vpc`)**: We create a custom VPC to ensure our network is isolated from other projects and to have full control over the IP address space. We disable auto-creation of subnets to avoid having unused subnets in every region.
- **Private Subnet (`jerney-subnet`)**: The GKE cluster nodes and pods will reside in a private subnet, which means they are not directly accessible from the public internet, significantly reducing the attack surface.
- **Cloud NAT & Router**: To allow the private GKE nodes to access the internet for pulling container images and other dependencies, we set up a Cloud NAT. This provides outbound internet access without exposing the nodes to inbound traffic.
- **GKE Autopilot Cluster (`jerney-gke-cluster`)**: We use GKE Autopilot to let Google manage the cluster's underlying infrastructure, including nodes and scaling. This simplifies cluster operations and improves security by reducing the operational overhead and potential for misconfiguration.
- **Workload Identity**: This is a key security feature. Instead of storing and managing service account keys, Workload Identity allows Kubernetes service accounts to impersonate GCP service accounts, providing a more secure way for your applications to access other Google Cloud services.

## 📋 Prerequisites

Ensure you have the following installed:

1.  **Terraform CLI** (v1.0+)
2.  **Google Cloud SDK** (`gcloud`)

## 🚀 Setup Instructions

### 1. Authenticate with Google Cloud

Login to your GCP account locally so Terraform can access your project:

```bash
gcloud auth application-default login
```

### 2. Configure Variables

Create a `terraform.tfvars` file in this directory to specify your Project ID and region.

```bash
# terraform.tfvars
project_id = "YOUR_PROJECT_ID"
region     = "YOUR_GCP_REGION"
```

### 3. Initialize Terraform

Download the necessary providers (Google):

```bash
terraform init
```

### 4. Review the Plan

Check what resources will be created before applying:

```bash
terraform plan
```

### 5. Apply the Configuration

Provision the infrastructure (this takes about 10-15 minutes for GKE):

```bash
terraform apply
```

Type `yes` when prompted.

## 🔗 Connecting to the Cluster

Once the `terraform apply` is complete, configure your local `kubectl` to connect to the new GKE cluster:

```bash
gcloud container clusters get-credentials YOUR_CLUSTER_NAME --region YOUR_GCP_REGION --project YOUR_PROJECT_ID
```

Replace `YOUR_CLUSTER_NAME`, `YOUR_GCP_REGION`, and `YOUR_PROJECT_ID` with the values you used in your `.tfvars` file.

Verify the connection:

```bash
kubectl get nodes
```

## 🧹 Cleanup

To delete all resources and avoid costs:

```bash
terraform destroy
```
