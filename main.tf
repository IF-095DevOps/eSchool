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
  tags = ["ssh"]
  

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

resource "null_resource" remoteExecProvisionerWFolder {
  count = 1
  connection {
    host = "${google_compute_instance.bastion.*.network_interface.0.access_config.0.nat_ip}"
    type = "ssh"
    user = "centos"
    private_key = "${file("${var.private_key_path}")}"
    agent = "false"
  }
  provisioner "remote-exec" {
    inline = [ "rm -rf /tmp/ansible" ]
  }
  provisioner "file" {
    source = "ansible"
    destination = "/tmp/ansible"
  }
/* ADD var of backend LB IP */
  provisioner "remote-exec" {
    inline = [ "sudo sed -i -e 's/backend_host_ip:/backend_host_ip: ${google_compute_address.address.*.address}' tmp/ansible/playbooks/vars.yml" ]
  }
  provisioner "file" {
    source = "${var.private_key_path}"
    destination = "/home/centos/.ssh/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [ "sudo chmod 600 /home/centos/.ssh/id_rsa" ]
  }

  provisioner "file" {
    content = "${data.template_file.jenkins_conf.rendered}"
    destination = "/tmp/ansible/files/jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin.xml"
  }
}


resource "null_resource" inventoryFileWeb {
  depends_on = ["null_resource.remoteExecProvisionerWFolder"]
  count = "${var.count}"
  connection {
    host = "${google_compute_instance.bastion.*.network_interface.0.access_config.0.nat_ip}"
    type = "ssh"
    user = "centos"
    private_key = "${file("${var.private_key_path}")}"
    agent = "false"
  }

  provisioner "remote-exec" {
    inline = ["echo ${var.instance_name}-${count.index}\tansible_ssh_host=${element(google_compute_instance.web.*.network_interface.0.network_ip, count.index)}\tansible_user=centos\tansible_ssh_private_key_file=/home/centos/.ssh/id_rsa>>/tmp/ansible/hosts.txt"]
  }
}

resource "null_resource" "ansibleProvision" {
  depends_on = ["null_resource.remoteExecProvisionerWFolder", "null_resource.inventoryFileWeb"]
  count = 0
  connection {
    host = "${google_compute_instance.bastion.*.network_interface.0.access_config.0.nat_ip}"
    type = "ssh"
    user = "centos"
    private_key = "${file("${var.private_key_path}")}"
    agent = "false"
  }

  provisioner "remote-exec" {
    inline = ["ansible-playbook /tmp/ansible/main.yml"]
  }
}