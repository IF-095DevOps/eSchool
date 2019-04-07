resource "null_resource" remoteExecProvisionerWFolder {
   depends_on = ["google_sql_database_instance.instance"]
  count = 1
  connection {
    host = "${google_compute_instance.jenkins.*.network_interface.0.access_config.0.nat_ip}"
    type = "ssh"
    user = "centos"
    private_key = "${file("${var.private_key_path}")}"
    agent = "false"
  }
  provisioner "file" {
     source = "${var.private_key_path}"
     destination = "/home/centos/.ssh/id_rsa"
     }
  provisioner "remote-exec" {
    inline = [ "sudo chmod 600 /home/centos/.ssh/id_rsa" ]
  }
  provisioner "remote-exec" {
    inline = [ "rm -rf /tmp/ansible" ]
  }
  provisioner "file" {
    source = "ansible"
    destination = "/tmp/ansible"
  }

  provisioner "file" {
    content = "${data.template_file.jenkins_conf.rendered}"
    destination = "/tmp/ansible/files/jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin.xml"
  }
   provisioner "file" {
    content = "${data.template_file.app_conf.rendered}"
    destination = "/tmp/ansible/files/application.properties"
  }
   provisioner "file" {
    content = "${data.template_file.job_frontend.rendered}"
    destination = "/tmp/ansible/files/job_frontend.xml"
  }

}


resource "null_resource" inventoryFileWeb {
  depends_on = ["null_resource.remoteExecProvisionerWFolder"]
  count = 2
  connection {
    host = "${google_compute_instance.jenkins.*.network_interface.0.access_config.0.nat_ip}"
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
  count = 1
  connection {
    host = "${google_compute_instance.jenkins.*.network_interface.0.access_config.0.nat_ip}"
    type = "ssh"
    user = "centos"
    private_key = "${file("${var.private_key_path}")}"
    agent = "false"
  }
  provisioner "remote-exec" {
    inline = ["sudo sed -i -e 's+#host_key_checking+host_key_checking+g' /etc/ansible/ansible.cfg"]
  }

  provisioner "remote-exec" {
    inline = ["ansible-playbook -i /tmp/ansible/hosts.txt /tmp/ansible/main.yml"]
  }
}