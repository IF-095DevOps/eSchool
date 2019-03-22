resource "google_redis_instance" "cache" {
  name = "demo2-memory-cache"
  memory_size_gb = 1
  tier = "BASIC"

  project = "${var.project}"
  region = "${var.region}"
  location_id = "${var.zone}"


  #authorized_network = "${google_compute_network.vpc_network.self_link}"

  redis_version = "REDIS_3_2"
  display_name = "For Demo2"
  reserved_ip_range = "10.0.1.248/29"

  #port = ["8001"]

  labels = {
    my_key = "for-demo2"

  }
}