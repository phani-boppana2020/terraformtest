#vpc
resource "google_compute_network" "vpc_network" {
    name = var.vpc_name
    auto_create_subnetworks = false
}
#subnet
resource "google_compute_subnetwork" "public-subnetwork" {
    count = var.instance_count
    name = "terraform-subnetwork-${count.index}"
    ip_cidr_range = var.subnet_cidr[count.index]
    region = var.gcp_region
    network = google_compute_network.vpc_network.name #implicit dependency
    depends_on = [google_compute_network.vpc_network] #explicit dependency
}
#firewall
resource "google_compute_firewall" "default" {
  name    = var.firewall_name
  network = google_compute_network.vpc_network.name #implicit dependency

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["web"]
  depends_on = [google_compute_network.vpc_network] #explicit dependency
}
#service account
resource "google_service_account" "service_account" {
  #project = var.project_id
  account_id   = var.account_id
  display_name = var.serviceaccount_name


}
#iam
resource "google_project_iam_member" "project" {
  for_each = toset([
    "roles/storage.admin",
    "roles/iam.serviceAccountTokenCreator",
  ])
  role = each.key
  member = "serviceAccount:terraform-sa@sb-tf-task.iam.gserviceaccount.com"
  project = var.project_id
  depends_on = [google_service_account.service_account] #explicit dependency
}
#key
resource "google_service_account_key" "mykey" {
  service_account_id = google_service_account.service_account.account_id
  public_key_type    = "TYPE_X509_PEM_FILE"
  depends_on = [google_service_account.service_account] #explicit dependency
}
resource "local_file" "myaccountjson" {
    content     = base64decode(google_service_account_key.mykey.private_key)
    filename = "test345.json"    
}

#storage
resource "google_storage_bucket" "bucket1" {
  name     = var.bucket_name
  location = "US"
  #count=var.target_group_addition_for_bucket+1
}
/*
#gcs bucket for storing tfstate file
terraform {
backend "gcs" {
  #count = var.target_group_addition_for_bucket? 1 : 0
  bucket = var.bucket_name  
  credentials = "test345.json"
  prefix = "firsttfstate" 
  depends_on = [google_storage_bucket.bucket1]          
  }

}
*/


