output "vpc_network" {
  description = "VPC Network details"
  value       = google_compute_network.vpc_network
}

output "instance_group_a" {
  description = "Managed Instance Group Jakarta A"
  value       = google_compute_region_instance_group_manager.mig_jakarta_a
}

output "instance_group_b" {
  description = "Managed Instance Group Jakarta B"
  value       = google_compute_region_instance_group_manager.mig_jakarta_b
}

output "instance_templates" {
  description = "Instance templates yang dibuat"
  value = {
    primary = google_compute_instance_template.dev_template
    backup  = google_compute_instance_template.backup_template
  }
}