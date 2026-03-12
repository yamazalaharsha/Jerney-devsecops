# provider.tf

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0" 
    }
  }
}

provider "google" {
  project = "harsha-sandbox-489905" # Your GCP Project ID
  region  = "asia-south1" # Mumbai, since you're in Mumbai!
}