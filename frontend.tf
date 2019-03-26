resource "google_storage_bucket" "frontend" {
  count         = "${var.frontend_count}"
  name          = "${var.frontend_name}-${count.index}"

  website {
    main_page_suffix = "index.html"
    not_found_page = "404.html"
  }

}


