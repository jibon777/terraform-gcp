terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Network
resource "google_compute_network" "vpc_network" {
  name                    = "dev-aji-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_jakarta_a" {
  name          = "subnet-jakarta-a"
  ip_cidr_range = "10.0.1.0/24"
  region        = "asia-southeast2"  # Jakarta
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "subnet_jakarta_b" {
  name          = "subnet-jakarta-b"
  ip_cidr_range = "10.0.2.0/24"
  region        = "asia-southeast2"  # Jakarta
  network       = google_compute_network.vpc_network.id
}

# Firewall
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-allowed"]
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

# Instance Template untuk Auto Scaling
resource "google_compute_instance_template" "dev_template" {
  name_prefix  = "dev-aji-template-"
  description  = "Template untuk Compute Engine dev-aji"
  machine_type = var.machine_type
  
  tags = ["ssh-allowed", "http-server"]

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
    disk_size_gb = 20
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnet_jakarta_a.name
    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Health Check
resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10

  http_health_check {
    request_path = "/"
    port         = "80"
  }
}

# Managed Instance Group Jakarta A (Primary)
resource "google_compute_region_instance_group_manager" "mig_jakarta_a" {
  name               = "mig-jakarta-a"
  region             = "asia-southeast2"
  base_instance_name = "dev-aji-instance"

  version {
    instance_template = google_compute_instance_template.dev_template.id
  }

  target_size = var.max_instances

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 300
  }

  update_policy {
    type                         = "PROACTIVE"
    instance_redistribution_type = "PROACTIVE"
    minimal_action               = "REPLACE"
    max_surge_fixed              = 3
    max_unavailable_fixed        = 0
    replacement_method           = "SUBSTITUTE"
  }
}

# Backup Instance Group Jakarta B
resource "google_compute_instance_template" "backup_template" {
  name_prefix  = "dev-aji-backup-template-"
  description  = "Backup template untuk Jakarta B"
  machine_type = var.machine_type
  
  tags = ["ssh-allowed", "http-server"]

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
    disk_size_gb = 20
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnet_jakarta_b.name
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_region_instance_group_manager" "mig_jakarta_b" {
  name               = "mig-jakarta-b"
  region             = "asia-southeast2"
  base_instance_name = "dev-aji-backup-instance"

  version {
    instance_template = google_compute_instance_template.backup_template.id
  }

  target_size = var.backup_instances

  depends_on = [google_compute_region_instance_group_manager.mig_jakarta_a]
}

