variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west2"
}

variable "network_name" {
  type    = string
  default = "gke-network"
}

variable "subnet_ip_cidr_range" {
  type    = string
  default = "10.20.0.0/16"
}

# NEW: secondary ranges for VPC-native GKE
variable "pods_secondary_cidr" {
  type    = string
  default = "10.21.0.0/16"
}

variable "services_secondary_cidr" {
  type    = string
  default = "10.22.0.0/20"
}

variable "cluster_name" {
  type    = string
  default = "ecommerce-app-cluster"
}

variable "initial_node_count" {
  type    = number
  default = 1
}

variable "machine_type" {
  type    = string
  default = "e2-standard-2"
}

variable "zone" {
  type    = string
  default = "europe-west2-b"
}
