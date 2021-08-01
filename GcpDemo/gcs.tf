resource "google_storage_bucket" "storage" {
  name          = var.bucket_name
  location      = var.bucket_location
  force_destroy = true
}
