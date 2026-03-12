variable "project_id" {
  description = "The GCP Project ID"
  type        = string
}

variable "region" {
  description = "The GCP region to deploy resources"
  type        = string
  default     = "asia-south1" # Mumbai
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "jerney-gke-cluster"
}