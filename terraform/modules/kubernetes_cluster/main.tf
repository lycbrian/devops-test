resource "google_container_cluster" "app_cluster" {
  name     = "app-cluster"
  location = var.region
  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_ipv4_cidr_block = var.pods_ipv4_cidr_block
    services_ipv4_cidr_block = var.services_ipv4_cidr_block
  }
  network = var.network_name
  subnetwork = var.subnet_name

  logging_service = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  maintenance_policy {
    daily_maintenance_window {
      start_time = "00:00"
    }
  }


  dynamic "master_authorized_networks_config" {
    for_each = var.authorized_ipv4_cidr_block != null ? [var.authorized_ipv4_cidr_block] : []
    content {
      cidr_blocks {
        cidr_block   = master_authorized_networks_config.value
        display_name = "External Control Plane access"
      }
    }
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  release_channel {
	  channel = "STABLE"
  }

  addons_config {
    network_policy_config {
        disabled = false
      }
  }
  network_policy {
    enabled = "true"
  }

  workload_identity_config {
    identity_namespace = format("%s.svc.id.goog", var.project_id)
  }
}

resource "google_container_node_pool" "app_cluster_linux_node_pool" {
  name           = "${google_container_cluster.app_cluster.name}--linux-node-pool"
  location       = google_container_cluster.app_cluster.location
  node_locations = var.node_zones
  cluster        = google_container_cluster.app_cluster.name
  node_count     = 1

  autoscaling {
    max_node_count = 1
    min_node_count = 1
  }
  max_pods_per_node = 100

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = true
    disk_size_gb = 10

    service_account = var.service_account
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
    ]

    labels = {
      cluster = google_container_cluster.app_cluster.name
    }

    shielded_instance_config {
      enable_secure_boot = true
    }

    // Enable workload identity on this node pool.
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }

    metadata = {
      // Set metadata on the VM to supply more entropy.
      google-compute-enable-virtio-rng = "true"
      // Explicitly remove GCE legacy metadata API endpoint.
      disable-legacy-endpoints = "true"
    }
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 1
  }
}
