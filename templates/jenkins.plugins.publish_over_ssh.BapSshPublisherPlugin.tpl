<?xml version='1.1' encoding='UTF-8'?>
<jenkins.plugins.publish__over__ssh.BapSshPublisherPlugin_-Descriptor plugin="publish-over-ssh@1.20.1">
  <hostConfigurations>
    <jenkins.plugins.publish__over__ssh.BapSshHostConfiguration>
      <name>web0_server</name>
      <hostname>${web0_server}</hostname>
      <username>centos</username>
      <secretPassword>{AQAAABAAAAAQj1WETKRVtxYhzBSC5d+foU4kbRsGRoYv0ZWjqu9caTw=}</secretPassword>
      <remoteRootDir>/home/centos</remoteRootDir>
      <port>22</port>
      <commonConfig class="jenkins.plugins.publish_over_ssh.BapSshCommonConfiguration">
        <secretPassphrase>{AQAAABAAAAAQRnBPYADpe8Zn03oNOT6vt2mW1vE+oHYLYpy+F3MFLoo=}</secretPassphrase>
        <key></key>
        <keyPath>/tmp/ansible/.ssh/devops095_ossh.pem</keyPath>
        <disableAllExec>false</disableAllExec>
      </commonConfig>
      <timeout>300000</timeout>
      <overrideKey>false</overrideKey>
      <disableExec>false</disableExec>
      <keyInfo>
        <secretPassphrase>{AQAAABAAAAAQO2f27lENFFygxns/015EidcYhMnAChvibJbsCi9Tz1g=}</secretPassphrase>
        <key></key>
        <keyPath></keyPath>
      </keyInfo>
      <jumpHost></jumpHost>
      <proxyType></proxyType>
      <proxyHost></proxyHost>
      <proxyPort>0</proxyPort>
      <proxyUser></proxyUser>
      <proxyPassword></proxyPassword>
    </jenkins.plugins.publish__over__ssh.BapSshHostConfiguration>
        <jenkins.plugins.publish__over__ssh.BapSshHostConfiguration>
      <name>web1_server</name>
      <hostname>${web1_server}</hostname>
      <username>centos</username>
      <secretPassword>{AQAAABAAAAAQj1WETKRVtxYhzBSC5d+foU4kbRsGRoYv0ZWjqu9caTw=}</secretPassword>
      <remoteRootDir>/home/centos</remoteRootDir>
      <port>22</port>
      <commonConfig class="jenkins.plugins.publish_over_ssh.BapSshCommonConfiguration">
        <secretPassphrase>{AQAAABAAAAAQRnBPYADpe8Zn03oNOT6vt2mW1vE+oHYLYpy+F3MFLoo=}</secretPassphrase>
        <key></key>
        <keyPath>/tmp/ansible/.ssh/devops095_ossh.pem</keyPath>
        <disableAllExec>false</disableAllExec>
      </commonConfig>
      <timeout>300000</timeout>
      <overrideKey>false</overrideKey>
      <disableExec>false</disableExec>
      <keyInfo>
        <secretPassphrase>{AQAAABAAAAAQO2f27lENFFygxns/015EidcYhMnAChvibJbsCi9Tz1g=}</secretPassphrase>
        <key></key>
        <keyPath></keyPath>
      </keyInfo>
      <jumpHost></jumpHost>
      <proxyType></proxyType>
      <proxyHost></proxyHost>
      <proxyPort>0</proxyPort>
      <proxyUser></proxyUser>
      <proxyPassword></proxyPassword>
    </jenkins.plugins.publish__over__ssh.BapSshHostConfiguration>
  </hostConfigurations>
  <commonConfig reference="../hostConfigurations/jenkins.plugins.publish__over__ssh.BapSshHostConfiguration/commonConfig"/>
  <defaults class="jenkins.plugins.publish_over_ssh.options.SshPluginDefaults"/>
</jenkins.plugins.publish__over__ssh.BapSshPublisherPlugin_-Descriptor>