resource "google_compute_global_forwarding_rule" "default" {
  name       = "default-rule"
  target     = "${google_compute_target_http_proxy.default.self_link}"
  port_range = "80"
}

# Create Load balancer for frontend buckets
resource "google_compute_target_http_proxy" "default" {
  name        = "http-proxy"
  description = "Load balancer for frontend buckets"
  url_map     = "${google_compute_url_map.urlmap.self_link}"
}
resource "google_compute_url_map" "urlmap" {
  name        = "lbfrontend"
  description = "URL map for frontend"

  # Set the first bucket as default
  default_service = "${google_compute_backend_bucket.static.self_link}"

  host_rule {
    hosts        = ["bucket1"]
    path_matcher = "allpaths"
  }
  host_rule {
    hosts        = ["bucket"]
    path_matcher = "allpaths1"
  }

  # Path matcher for the first bucket
  path_matcher {
    name            = "allpaths"
    default_service = "${google_compute_backend_bucket.static.self_link}"

    path_rule {
      paths   = ["/index.html"]
      service = "${google_compute_backend_bucket.static.self_link}"
    }
  }
  # Path matcher for the second bucket
  path_matcher {
    name            = "allpaths1"
    default_service = "${google_compute_backend_bucket.static1.self_link}"

    path_rule {
      paths   = ["/index.html"]
      service = "${google_compute_backend_bucket.static1.self_link}"
    }
  }
}
resource "google_compute_http_health_check" "default" {
  name               = "health-check"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}
