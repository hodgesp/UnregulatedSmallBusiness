provider "google" {
  project = var.project
  region  = var.region
  credentials = file("masterarbeit-299622-33ffe94e5ab5.json")
}

resource "google_compute_network" "vpc_network" {
name = "terraform-network"
}
resource "google_compute_subnetwork" "public-subnetwork" {
name = "terraform-subnetwork"
ip_cidr_range = "10.2.0.0/16"
region = var.region
network = google_compute_network.vpc_network.name
}

resource "google_compute_firewall" "firewall" {
  name    = "firewall-externalssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"] # Not So Secure. Limit the Source Range
  target_tags   = ["externalssh"]
}

resource "google_compute_firewall" "webserverrule" {
  name    = "webserver"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80","443"]
  }

  source_ranges = ["0.0.0.0/0"] # Not So Secure. Limit the Source Range
  target_tags   = ["webserver"]
}

# We create a public IP address for our google compute instance to utilize
resource "google_compute_address" "static" {
  name = "vm-public-address"
  project = var.project
  region = var.region
  depends_on = [ google_compute_firewall.firewall ]
}