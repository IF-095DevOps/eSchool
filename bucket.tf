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
  force_destroy   = "true"
    website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}
 resource "google_storage_bucket" "static1" {
   name     = "eschool-bucket1"
   location = "US"
   force_destroy   = "true"
     website {
     main_page_suffix = "index.html"
     not_found_page   = "404.html"
   }
 }
 resource "google_storage_default_object_access_control" "public_rule" {
  bucket = "${google_storage_bucket.static.name}"
  role = "READER"
  entity = "allUsers"
}
 resource "google_storage_default_object_access_control" "public_rule1" {
  bucket = "${google_storage_bucket.static1.name}"
  role = "READER"
  entity = "allUsers"
}