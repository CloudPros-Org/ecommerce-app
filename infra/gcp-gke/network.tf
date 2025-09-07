resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.network_name}-subnet"
  ip_cidr_range = var.subnet_ip_cidr_range
  region        = var.region
  network       = google_compute_network.vpc.id

  # Secondary ranges required for VPC-native (alias IPs)
  secondary_ip_range {
    range_name    = "${var.network_name}-pods"
    ip_cidr_range = var.pods_secondary_cidr
  }

  secondary_ip_range {
    range_name    = "${var.network_name}-services"
    ip_cidr_range = var.services_secondary_cidr
  }
}
