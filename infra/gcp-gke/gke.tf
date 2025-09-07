module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 30.0"

  project_id = var.project_id
  name       = var.cluster_name

  regional   = false
  zones      = [var.zone]

  deletion_protection = var.deletion_protection

  create_service_account = true

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  # Secondary ranges created on the subnetwork (see network.tf)
  ip_range_pods     = google_compute_subnetwork.subnet.secondary_ip_range[0].range_name
  ip_range_services = google_compute_subnetwork.subnet.secondary_ip_range[1].range_name

  remove_default_node_pool = true

  node_pools = [{
    name               = "default-pool"
    machine_type       = var.machine_type
    initial_node_count = var.initial_node_count
    auto_repair        = true
    auto_upgrade       = true
  }]
}

# Helpful outputs for CI
output "cluster_name" {
  value = module.gke.name
}

output "cluster_location" {
  value = var.region
}
