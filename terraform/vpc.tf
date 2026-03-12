# VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = "jerney-vpc"
  auto_create_subnetworks = false # This is a best practice. Instead of Google automatically creating subnets in every region world-wide, you are telling it you will explicitly define only the subnets you need
}

# Private Subnet
# Purpose: Defines a specific subnet in your chosen region (defined in variables.tf, likely asia-south1).
# Primary Range (10.0.0.0/24): This small range (256 IPs) is for the Nodes (VMs) in your cluster.
# Secondary Ranges: These are crucial for VPC-native GKE clusters:
# pod-ranges (10.1.0.0/16): A large range (65k IPs) reserved specifically for Pods (containers) running inside Kubernetes.
# services-ranges (10.2.0.0/20): A range reserved for Kubernetes Services (internal load balancers/ClusterIPs)
resource "google_compute_subnetwork" "subnet" {
  name          = "jerney-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
  
  # Secondary ranges for GKE Pods and Services
  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "10.1.0.0/16"
  }
  secondary_ip_range {
    range_name    = "services-ranges"
    ip_cidr_range = "10.2.0.0/20"
  }
}

# Cloud Router and NAT (for internet access from private nodes)
# Purpose: These two resources work together to provide outbound internet access to your private nodes.
# Why is this needed? In a secure GKE setup, your worker nodes often live in private subnets (they don't have public IP addresses). However, they still need to reach the internet to download Docker images or install updates.
# How it works: The Cloud NAT acts as a gateway. It translates the internal private IP of your node to a public IP for the request, lets it go to the internet, and routes the response back. It does not allow the outside world to initiate connections into your private nodes.
resource "google_compute_router" "router" {
  name    = "jerney-router"
  region  = var.region
  network = google_compute_network.vpc_network.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "jerney-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}