nsbuild-jenkins-agent
=====================

Jenkins Build Agent based on Docker with all nesessary dependencies and tools which represent a complete environment for building and deploying [NetSuite](http://www.netsuite.com/) projects. 

Current Docker image supports the following NetSuite project types:
* SDF (SuiteCloud Development Framework) projects
* SCA (SuiteCommerce Adcanced) projects

and contains the following packages installed, configured and exposed globally to be used in Jenkins Build Jobs:
* Node.js v6.*
* Python 2.7.*
* npm
* Gulp
* SDF CLI (packaged to a self contained jar)

Installation
------------
1. Install [Docker Plugin](https://wiki.jenkins.io/display/JENKINS/Docker+Plugin) for Jenkins on your master Jenkins server
2. Generate private/public SSH keys to open SSH communication channel between Jenkins master and build agent service running in the container
```ssh-keygen -t rsa -b 4096 -C "jenkins"```
3. Create Jenkins SSH credentials using the private key generated on previous step
4. Configure Docker Template:
![](https://monosnap.com/file/D2CpNjMiIzfDvNoxlzMBSX6KQ6oSix.png)

NOTE:
* ```Docker Image``` - will pull the **aleksanderson/nsbuild-jenkins-agent** built images from the Docker Hub
* ```Labels``` value will be used as a marker for a particular job to be run only on a specific agent
* The following configuration is required for ```Container settings...```
  * Environment: JENKINS_SLAVE_SSH_PUBKEY=[SSH public key]

5. Configure a Jenkins build job:
* In [Build job] -> Configuration
  * Configure build to be run on a specific build agent![](https://monosnap.com/file/8Gvmfye211MZEMwqoQ0nJxNsJ2HOEx.png)
  * Reference nesessary tools from shell build steps. 
  
  For example: 
  ```echo "$NS_ENV_PASSWORD" | sdfcli validate```


TODO
----
* Use alpine based image to optimize the size