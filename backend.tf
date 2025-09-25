terraform {
  backend "gcs" {
    bucket = "dev-aji-terraform-state"  # Ganti dengan nama bucket mu
    prefix = "terraform/state"
  }
}