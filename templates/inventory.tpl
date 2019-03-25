[bastion]
bastionhost ansible_ssh_host=${bastion_public_ip} ansible_user=centos ansible_ssh_private_key_file=/home/centos/.ssh/id_rsa
[web_servers]
webserver1  ansible_ssh_host=${web1_private_ip} ansible_user=centos ansible_ssh_private_key_file=/home/centos/.ssh/id_rsa
webserver2  ansible_ssh_host=${web2_private_ip} ansible_user=centos ansible_ssh_private_key_file=/home/centos/.ssh/id_rsa


