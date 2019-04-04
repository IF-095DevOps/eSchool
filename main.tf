resource "google_compute_instance" "web" {
  count        = "${var.count}"
  tags {
    Name = "${var.instance_name}-${count.index}"
  }
  machine_type = "${var.machine_type}"
  tags = ["ssh","web"]

  

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
sudo yum -y install httpd
sudo systemctl start httpd
sudo rpm -ivh https://d2znqt9b1bc64u.cloudfront.net/java-1.8.0-amazon-corretto-devel-1.8.0_202.b08-2.x86_64.rpm

SCRIPT

  metadata {
    sshKeys = "centos:${file("${var.public_key_path}")}"
  }

}

resource "google_compute_instance" "bastion" {
  name         = "bastion"
  machine_type = "${var.machine_type}"
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
  #  provisioner "file" {
  #   source = "f:/SSHkey/devops095_ossh.pem"
  #   destination = "/home/centos/.ssh/"
  #   }

   metadata_startup_script = <<SCRIPT
sudo yum -y update
sudo yum -y install epel-release
sudo yum -y install ansible
yum install -y mc nano wget git
#install java amazon corretto JDK and JRE
wget https://d1f2yzg3dx5xke.cloudfront.net/java-1.8.0-amazon-corretto-devel-1.8.0_202.b08-1.amzn2.x86_64.rpm
wget https://d1f2yzg3dx5xke.cloudfront.net/java-1.8.0-amazon-corretto-1.8.0_202.b08-1.amzn2.x86_64.rpm
yum localinstall -y java-1.8.0-amazon-corretto*.rpm
#enable the Jenkins repository
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
#add the repository to system
rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
#install the latest stable version of Jenkins
yum install -y jenkins
#start the Jenkins service
systemctl start jenkins
#enable the Jenkins service to start on system boot
systemctl enable jenkins
#install maven
yum install maven -y
#download maven latest version
wget https://www-us.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz -P /tmp
#Extract maven
tar xf /tmp/apache-maven-3.6.0-bin.tar.gz -C /opt
#create a symbolic link maven which will point to the Maven installation directory
ln -s /opt/apache-maven-3.6.0 /opt/maven
#setup the environment variables
cat <<EOF | tee -a /etc/profile.d/maven.sh
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto.x86_64/jre
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH=$${M2_HOME}/bin:$${PATH}
EOF
#
chmod +x /etc/profile.d/maven.sh
#load the environment variables
source /etc/profile.d/maven.sh
jusername="User"
juserpassword="userpass"
juseremail="bbb@bbb.bbb"
key=`cat /var/lib/jenkins/secrets/initialAdminPassword`
response=""
while [ `echo $$response | grep 'Authenticated' | wc -l` = 0 ]; do
  echo "Jenkins not started, wait for 2s"
  response=`java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s \
  http://localhost:8080 who-am-i --username admin --password $$key`
  echo $$response
  sleep 2
done
java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s \
http://localhost:8080/ -auth admin:$$key -noKeyAuth install-plugin \
dashboard-view cloudbees-folder antisamy-markup-formatter build-name-setter build-timeout config-file-provider \
credentials-binding embeddable-build-status rebuild ssh-agent throttle-concurrents timestamper ws-cleanup ant gradle \
msbuild nodejs checkstyle cobertura htmlpublisher junit warnings xunit workflow-aggregator github-organization-folder \
pipeline-stage-view build-pipeline-plugin conditional-buildstep jenkins-multijob-plugin parameterized-trigger \
copyartifact bitbucket clearcase cvs git git-parameter github gitlab-plugin p4 repo subversion teamconcert tfs \
matrix-project ssh-slaves windows-slaves matrix-auth pam-auth ldap role-strategy active-directory email-ext \
emailext-template mailer publish-over-ssh ssh -restart
cat <<EOF | tee -a ~/user-creation.groovy
#!groovy
import jenkins.model.*
import hudson.security.*
import jenkins.install.InstallState
import hudson.tasks.Mailer
import hudson.tasks.*
def instance = Jenkins.getInstance()
def username = args[0]
def userpassword = args[1]
def useremail = args[2]
def user = instance.getSecurityRealm().createAccount(username, userpassword)
user.addProperty(new Mailer.UserProperty(useremail))
user.save()
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)
if (!instance.installState.isSetupComplete()) {
  InstallState.INITIAL_SETUP_COMPLETED.initializeState()
}
instance.save()
def inst = Jenkins.getInstance()
def desc = inst.getDescriptor("hudson.tasks.Maven")
def minst =  new hudson.tasks.Maven.MavenInstallation("Maven_name", "/opt/maven");
desc.setInstallations(minst)
desc.save()
EOF
response=""
while [ `echo $$response | grep 'Authenticated' | wc -l` = 0 ]; do
  echo "Jenkins not started, wait for 2s"
  response=`java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s \
  http://localhost:8080 who-am-i --username admin --password $$key`
  echo $$response
  sleep 2
done
java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s \
http://localhost:8080/ -auth admin:$$key groovy = \
< ~/user-creation.groovy $$jusername $$juserpassword $$juseremail
sed -i -e 's+<home>git</home>+<home>/usr/bin/git</home>+g' /var/lib/jenkins/hudson.plugins.git.GitTool.xml

SCRIPT
}

resource "null_resource" remoteExecProvisionerWFolder {
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

  provisioner "file" {
    source = "${var.private_key_path}"
    destination = "/home/centos/.ssh/id_rsa"
   }

  provisioner "remote-exec" {
    inline = [ "sudo chmod 600 /home/centos/.ssh/id_rsa" ]
  }

}
