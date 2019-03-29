
data "template_file" "jenkins_conf" {
  template = "${file("${path.module}/templates/jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin.tpl")}"
  vars {
    web1_private_ip = "${element(google_compute_instance.web.*.network_interface.0.network_ip, count.index)}"
    web2_private_ip = "${element(google_compute_instance.web.*.network_interface.0.network_ip, count.index+1)}"
  }
}