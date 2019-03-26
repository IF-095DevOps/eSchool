output "public_ip_bastion" {
   value = ["${google_compute_instance.bastion.*.network_interface.0.access_config.0.nat_ip}"]
}

output "public_ip_db" {
   value = ["${google_sql_database_instance.instance.*.ip_address}"]
}
output "public_ip_nat" {
   value = ["${google_compute_address.address.*.address}"]
}

output "frontend_buckets" {
   value = ["${google_storage_bucket.frontend.*.name}"]
}