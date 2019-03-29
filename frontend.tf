/*resource "google_storage_bucket" "frontend" {
  count         = "${var.frontend_count}"
  name          = "${var.frontend_name}-${count.index}"

  website {
    main_page_suffix = "index.html"
    not_found_page = "404.html"
  }

}

resource "google_compute_target_pool" "default" {
  project          = "${var.project}"
  name             = "lbfrontend"
  instances = ["${google_compute_instance.${var.frontend_name}.*.self_link}"]

  region           = "${var.region}"
  session_affinity = "NONE"

  health_checks = [
    "${google_compute_http_health_check.default.name}",
  ]
}
*/

resource "google_compute_global_forwarding_rule" "default" {
  name       = "default-rule"
  target     = "${google_compute_target_http_proxy.default.self_link}"
  port_range = "80"
}

resource "google_compute_target_http_proxy" "default" {
  name        = "http-proxy"
  description = "a description"
  url_map     = "${google_compute_url_map.urlmap.self_link}"
}
resource "google_compute_url_map" "urlmap" {
  name        = "lbfrontend"
  description = "a description"
  default_service = "${google_compute_backend_bucket.static.self_link}"
  host_rule {
    hosts        = ["bucket1"]
    path_matcher = "allpaths"
  }
  host_rule {
    hosts        = ["bucket"]
    path_matcher = "allpaths1"
  }
  path_matcher {
    name            = "allpaths"
    default_service = "${google_compute_backend_bucket.static.self_link}"

    path_rule {
      paths   = ["/index.html"]
      service = "${google_compute_backend_bucket.static.self_link}"
    }
  }
  path_matcher {
    name            = "allpaths1"
    default_service = "${google_compute_backend_bucket.static1.self_link}"

    path_rule {
      paths   = ["/index.html"]
      service = "${google_compute_backend_bucket.static1.self_link}"
    }
  }
}
resource "google_compute_http_health_check" "default1" {
  name               = "health-check"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}
