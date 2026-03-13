variable "project_id" {
  description = "The ID of the Google Cloud project where all resources will be provisioned. This is a unique identifier for your GCP project."
  type        = string
}

variable "region" {
  description = "The primary GCP region where the infrastructure will be deployed. This affects latency and availability."
  type        = string
  default     = "asia-south1"
}

variable "cluster_name" {
  description = "The name for the Google Kubernetes Engine (GKE) cluster. This will be the identifier for your cluster in the GCP console."
  type        = string
  default     = "jerney-gke-cluster"
}