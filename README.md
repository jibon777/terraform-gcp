# terraform-gcp

📌 Repository ini berisi **Infrastructure as Code (IaC)** menggunakan **Terraform** untuk provisioning resource di **Google Cloud Platform (GCP)**.  
Struktur repo modular agar mudah digunakan untuk resource seperti VPC, Compute Engine, Database, Monitoring, dll.

## 📂 Struktur Direktori
terraform-gcp/
├── main.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── versions.tf
└── modules/
├── network/
├── compute/
├── database/
└── monitoring/

text

## 🔑 Prasyarat
- Terraform >= 1.3.0  
- Google Cloud SDK terinstal  
- Project GCP aktif dengan billing  
- Service Account dengan akses ke GCP (misalnya `roles/editor`, `roles/storage.admin`, `roles/compute.admin`)

## 🗄️ Remote State
Gunakan **Google Cloud Storage (GCS)** sebagai remote state backend untuk menyimpan state Terraform.

Contoh buat bucket:
```bash
gsutil mb -p <PROJECT_ID> -c STANDARD -l asia-southeast2 gs://<BUCKET_NAME>
Contoh backend di main.tf:

hcl
terraform {
  backend "gcs" {
    bucket = "<BUCKET_NAME>"
    prefix = "terraform/state"
  }
}
🚀 Cara Penggunaan
⚙️ Inisialisasi:
bash
terraform init
🧪 Validasi:
bash
terraform validate
🔍 Lihat rencana:
bash
terraform plan
🚀 Terapkan perubahan:
bash
terraform apply
🗑️ Hapus resource (jika perlu):
bash
terraform destroy