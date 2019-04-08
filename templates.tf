
data "template_file" "jenkins_conf" {
  template = "${file("${path.module}/templates/jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin.tpl")}"
  vars {
    web0_server = "${element(google_compute_instance.web.*.network_interface.0.network_ip, count.index)}"
    web1_server = "${element(google_compute_instance.web.*.network_interface.0.network_ip, count.index + 1)}"
  }
}
data "template_file" "app_conf" {
  template = "${file("${path.module}/templates/application.properties.tpl")}"
  depends_on = ["google_sql_database_instance.instance"]
  vars {
    db_server = "${google_sql_database_instance.instance.ip_address.0.ip_address}"
    db_name = "${var.db_name}"
    db_user = "${var.user_name}"
    db_pass = "${var.user_password}"
  }
}
data "template_file" "job_frontend" {
template = "${file("${path.module}/templates/job_frontend.tpl")}"
vars {
lb_backend = "${google_compute_forwarding_rule.default.ip_address}"
}
}