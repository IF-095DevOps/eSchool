#Creatu a new firewall rule
resource "google_compute_firewall" "tcp-firewall-rule-9000" {
  name = "tcp-firewall-rule-9000-5432"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["9000", "5432", "80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
}
   
   # Create a new instance
resource "google_compute_instance" "vm_instance" {
   name = "${var.name}"
   machine_type = "${var.machine_type}"
   zone = "${var.zone}"

   boot_disk {
      initialize_params {
      image = "${var.image_project}/${var.image_family}"
      }
   }

   network_interface {
      network = "default"
      access_config {}
   }

   metadata_startup_script = <<SCRIPT
   #Pre-install
   sudo yum -y update
   sudo yum -y install epel-release
   sudo yum -y install ansible
   SCRIPT

   service_account {
      scopes = ["userinfo-email", "compute-ro", "storage-ro"]
      }
}

