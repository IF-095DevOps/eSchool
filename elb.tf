resource "google_compute_forwarding_rule" "default" {
  project               = "${var.project}"
  name                  = "lbb"
  target                = "${google_compute_target_pool.default.self_link}"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "8080"
}

resource "google_compute_target_pool" "default" {
  project          = "${var.project}"
  name             = "lbbackend"
  instances = ["${google_compute_instance.web.*.self_link}"]
  
  region           = "${var.region}"
  session_affinity = "NONE"

  health_checks = [
    "${google_compute_health_check.default.name}"
  ]
}

resource "google_compute_health_check" "default" {
  name               = "health-check"
  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "8080"
  }
}