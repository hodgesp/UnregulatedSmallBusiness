resource "google_redis_instance" "cache" {
  name           = var.redis_display_name
  tier           = "STANDARD_HA"
  memory_size_gb = 1

  location_id             = var.redis_location_id
  #alternative_location_id = "us-central1-f"

  authorized_network = google_compute_network.vpc_network.name

  redis_version     = "REDIS_4_0"
  display_name      = var.redis_display_name
  reserved_ip_range = "192.168.0.0/29"

}

// This example assumes this network already exists.
// The API creates a tenant network per network authorized for a
// Redis instance and that network is not deleted when the user-created
// network (authorized_network) is deleted, so this prevents issues
// with tenant network quota.
// If this network hasn't been created and you are using this example in your
// config, add an additional network resource or change
// this from "data"to "resource"
//data "google_compute_network" "redis-network" {
//  name = [module.vpc.network_name]
//}