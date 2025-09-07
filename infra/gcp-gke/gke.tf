module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 30.0"

  project_id = var.project_id
  name       = var.cluster_name
  regional   = true
  region     = var.region

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  remove_default_node_pool = true

  node_pools = [{
    name               = "default-pool"
    machine_type       = var.machine_type
    initial_node_count = var.initial_node_count
    auto_repair        = true
    auto_upgrade       = true
  }]
}

resource "local_file" "kubeconfig" {
  filename = "kubeconfig"
  content  = module.gke.kubeconfig_raw
}

output "cluster_name" { value = module.gke.name }
output "kubeconfig_path" { value = local_file.kubeconfig.filename }
