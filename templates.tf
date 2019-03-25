
data "template_file" "inv" {
  template = "${file("${path.module}/templates/inventory.tpl")}"
  vars {
    bastion_public_ip = "${element(google_compute_instance.bastion.*.network_interface.0.access_config.0.nat_ip, count.index)}"
    web1_private_ip = "${element(google_compute_instance.web.*.network_interface.0.network_ip, count.index)}"
    web2_private_ip = "${element(google_compute_instance.web.*.network_interface.0.network_ip, count.index+1)}"
  }
}