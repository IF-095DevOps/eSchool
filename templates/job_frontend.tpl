<?xml version='1.1' encoding='UTF-8'?>
<project>
  <actions/>
  <description>Frontend</description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <com.dabsquared.gitlabjenkins.connection.GitLabConnectionProperty plugin="gitlab-plugin@1.5.11">
      <gitLabConnection></gitLabConnection>
    </com.dabsquared.gitlabjenkins.connection.GitLabConnectionProperty>
    <com.sonyericsson.rebuild.RebuildSettings plugin="rebuild@1.30">
      <autoRebuild>false</autoRebuild>
      <rebuildDisabled>false</rebuildDisabled>
    </com.sonyericsson.rebuild.RebuildSettings>
    <hudson.plugins.throttleconcurrents.ThrottleJobProperty plugin="throttle-concurrents@2.0.1">
      <maxConcurrentPerNode>0</maxConcurrentPerNode>
      <maxConcurrentTotal>0</maxConcurrentTotal>
      <categories class="java.util.concurrent.CopyOnWriteArrayList"/>
      <throttleEnabled>false</throttleEnabled>
      <throttleOption>project</throttleOption>
      <limitOneJobWithMatchingParams>false</limitOneJobWithMatchingParams>
      <paramsToUseForLimit></paramsToUseForLimit>
    </hudson.plugins.throttleconcurrents.ThrottleJobProperty>
  </properties>
  <scm class="hudson.plugins.git.GitSCM" plugin="git@3.9.3">
    <configVersion>2</configVersion>
    <userRemoteConfigs>
      <hudson.plugins.git.UserRemoteConfig>
        <url>https://github.com/IF-092-UI/final_project.git</url>
      </hudson.plugins.git.UserRemoteConfig>
    </userRemoteConfigs>
    <branches>
      <hudson.plugins.git.BranchSpec>
        <name>*/master</name>
      </hudson.plugins.git.BranchSpec>
    </branches>
    <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
    <submoduleCfg class="list"/>
    <extensions/>
  </scm>
  <canRoam>true</canRoam>
  <disabled>false</disabled>
  <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
  <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
  <triggers/>
  <concurrentBuild>false</concurrentBuild>
  <builders>
    <hudson.tasks.Shell>
      <command>sed -i -e s+https://fierce-shore-32592.herokuapp.com+http://${lb_backend}:8080+g /var/lib/jenkins/workspace/job_frontend/src/app/services/token-interceptor.service.ts
yarn install
ng build --prod
</command>
    </hudson.tasks.Shell>
    <hudson.tasks.Shell>
      <command>gcloud auth activate-service-account --key-file /tmp/ansible/.ssh/devops-eb6d149e8256.json
gsutil -m cp -R dist/eSchool/* gs://eschool-bucket
gsutil -m cp -R dist/eSchool/* gs://eschool-bucket1</command>
    </hudson.tasks.Shell>
  </builders>
  <publishers/>
  <buildWrappers/>
</project>