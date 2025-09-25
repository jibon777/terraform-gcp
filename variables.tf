variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "dev-aji"
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "asia-southeast2"
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "asia-southeast2-a"
}

variable "machine_type" {
  description = "Machine type untuk Compute Engine"
  type        = string
  default     = "e2-small"
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = number
  default     = 5
}

variable "backup_instances" {
  description = "Number of backup instances di zone B"
  type        = number
  default     = 2
}