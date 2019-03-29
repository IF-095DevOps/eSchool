resource "google_compute_backend_bucket" "static" {
  name        = "eschool-bucket"
  bucket_name = "${google_storage_bucket.static.name}"
  enable_cdn  = true
}
 resource "google_compute_backend_bucket" "static1" {
   name        = "eschool-bucket1"
   bucket_name = "${google_storage_bucket.static1.name}"
   enable_cdn  = true
 }

resource "google_storage_bucket" "static" {
  name     = "eschool-bucket"
  location = "US"
    website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}
 resource "google_storage_bucket" "static1" {
   name     = "eschool-bucket1"
   location = "US"
     website {
     main_page_suffix = "index.html"
     not_found_page   = "404.html"
   }
 }