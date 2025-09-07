module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 30.0"

  project_id = var.project_id
  name       = var.cluster_name
  regional   = true
  region     = var.region

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  # Use the secondary range names from the subnetwork
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

# Write kubeconfig so CI can publish it as an artifact
resource "local_file" "kubeconfig" {
  filename = "kubeconfig"
  content  = module.gke.kubeconfig_raw
}

output "cluster_name"     { value = module.gke.name }
output "kubeconfig_path"  { value = local_file.kubeconfig.filename }
