# terraform-gcp

📌 Repository ini berisi **Infrastructure as Code (IaC)** menggunakan **Terraform** untuk provisioning resource di **Google Cloud Platform (GCP)**.  
Struktur repo dibuat modular agar mudah digunakan untuk berbagai jenis resource (VPC, Compute Engine, Database, Monitoring, dll).

## 📂 Struktur Direktori
terraform-gcp/
├── main.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── versions.tf
├── modules/
│ ├── network/
│ ├── compute/
│ ├── database/
│ └── monitoring/

markdown
Salin kode

## 🔑 Prasyarat
- ⬆️ Terraform >= 1.3.0  
- 💻 Google Cloud SDK terinstal  
- ☁️ Project GCP aktif dengan billing  
- 👤 Service Account dengan akses ke GCP (misalnya `roles/editor`, `roles/storage.admin`, `roles/compute.admin`)

## 🗄️ Remote State
Gunakan **Google Cloud Storage (GCS)** sebagai remote state backend untuk menyimpan state file Terraform.

## 🚀 Cara Penggunaan

⚙️ Inisialisasi Terraform  
```bash
terraform init
🧪 Validasi konfigurasi

bash
Salin kode
terraform validate
🔍 Lihat rencana deployment

bash
Salin kode
terraform plan
🚀 Terapkan perubahan

bash
Salin kode
terraform apply
🗑️ Hapus resource jika diperlukan

bash
Salin kode
terraform destroy