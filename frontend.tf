resource "google_storage_bucket" "frontend" {
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

