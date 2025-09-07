variable "project_id" { type = string }
variable "region" { type = string, default = "europe-west2" }
variable "network_name" { type = string, default = "gke-network" }
variable "subnet_ip_cidr_range" { type = string, default = "10.20.0.0/16" }
variable "cluster_name" { type = string, default = "demo-gke" }
variable "initial_node_count" { type = number, default = 2 }
variable "machine_type" { type = string, default = "e2-standard-2" }
