# ☁️ Jerney Infrastructure (Terraform)

This folder contains the Terraform configuration to provision the Google Cloud Platform (GCP) infrastructure for the Jerney application.

## 🏗️ Resources Created

- **VPC Network**: Custom VPC (`jerney-vpc`) with a private subnet (`jerney-subnet`).
- **Networking**: Cloud NAT and Router to allow private nodes outbound internet access.
- **Kubernetes**: GKE Autopilot Cluster (`jerney-gke-cluster`) with Workload Identity enabled.

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

Create a `terraform.tfvars` file in this directory to specify your Project ID.

```bash
# terraform.tfvars
project_id = "harsha-sandbox-489905"
region     = "asia-south1"
```

> **Note:** Although `provider.tf` has a default project set, `gke.tf` requires the `project_id` variable for Workload Identity configuration.

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
gcloud container clusters get-credentials jerney-gke-cluster --region asia-south1 --project harsha-sandbox-489905
```

Verify the connection:

```bash
kubectl get nodes
```

## 🧹 Cleanup

To delete all resources and avoid costs:

```bash
terraform destroy
```