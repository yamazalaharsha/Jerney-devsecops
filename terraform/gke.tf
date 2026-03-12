resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  # Enabling Autopilot mode allows Google to manage the underlying infrastructure of your cluster, including node provisioning, scaling, and maintenance. This is a great choice for a secure, production-ready cluster because it reduces the attack surface and operational overhead.
  enable_autopilot = true

  # This links the cluster to the jerney-vpc and jerney-subnet created in your vpc.tf file. This ensures the cluster is private and isolated within your defined cloud network.

  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.subnet.name

  # Security: Enabling Workload Identity allows your Kubernetes workloads to securely access Google Cloud services without needing to manage service account keys. Instead, Kubernetes service accounts can be mapped to Google service accounts, providing fine-grained access control and improved security.
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Defining the IP ranges we created in vpc.tf for Pods and Services. This is essential for VPC-native GKE clusters to ensure proper IP management and network isolation.
  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-ranges"
    services_secondary_range_name = "services-ranges"
  }

  # Best Practice: Delete the default node pool to let Autopilot manage everything and to ensure that no unintended resources are created. This also enhances security by reducing the attack surface.
  deletion_protection = false
}