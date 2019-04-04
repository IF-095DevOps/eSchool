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

  health_checks = ["${google_compute_http_health_check.default.name}",]
}

resource "google_compute_http_health_check" "default" {
  project      = "${var.project}"
  name         = "hg-hc"
  request_path = "/"
  port         = "8080"
}