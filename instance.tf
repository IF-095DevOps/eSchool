resource "google_compute_instance" "web" {
  count        = "${var.count}"
  name         = "${var.instance_name}-${count.index}"
  machine_type = "${var.machine_type}"
  tags = ["ssh","web"]
  zone = "${element(var.azs, count.index)}"
  

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.private_subnetwork.name}"
 
  }
 
  metadata_startup_script = <<SCRIPT
sudo yum -y update

SCRIPT

  metadata {
    sshKeys = "centos:${file("${var.public_key_path}")}"
  }

}

resource "google_compute_instance" "jenkins" {
  name         = "jenkins"
  machine_type = "n1-standard-1"
  tags = ["ssh","sonar"]
  

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.private_subnetwork.name}"
    access_config = {
      }
  }
   metadata {
    sshKeys = "centos:${file("${var.public_key_path}")}"
   }

   metadata_startup_script = <<SCRIPT
sudo yum -y update
sudo yum -y install epel-release
sudo yum -y install ansible
SCRIPT
}

