output "public_ip_bastion" {
   value = ["${google_compute_instance.jenkins.*.network_interface.0.access_config.0.nat_ip}"]
}

output "public_ip_db" {
   value = ["${google_sql_database_instance.instance.*.ip_address}"]
}
output "public_ip_nat" {
   value = ["${google_compute_address.address.*.address}"]
}
output "public_ip_sql" {
   value = ["${google_sql_database_instance.instance.ip_address.0.ip_address}"]
}
output "internal_load_balancer_ip" {
value = "${google_compute_forwarding_rule.default.ip_address}"
}