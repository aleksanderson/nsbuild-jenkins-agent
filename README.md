nsbuild-jenkins-agent
=====================

Jenkins Build Agent based on Docker container with all nesessary dependencies and tools which represents complete environment for building and deploying [NetSuite](http://www.netsuite.com/) projects. 

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
![](https://d1ro8r1rbfn3jf.cloudfront.net/ms_107835/klJBuxrcnriYFiPWu25Ignunc9W3ge/Configure%2BSystem%2B%255BJenkins%255D%2B2017-10-15%2B22-30-19.png?Expires=1508182235&Signature=Nm0uuQxWY75IGK1MrX692V0eNEg8RdgLuVNk7660hAeZ2TKQGdV2h0Rk~cpivHfeSKks91RLz9saEU7kuYM0jpXXF5jFnmdKx5HlxxV~C7Gn7SgePe2z~1v0imyxRrkp32eJZGUsGU4f-U4SrKLxDe5OMSXR09O8-ZV3Xg1hr~Y~Vs2vxr3UCC9brDiS1Ne2b6R1WuWW4AlSqJW6H0QLwGM73vfMfnh49OcptYGDTWdcXsXKtBDsroZR4H29lak6x5hkdWKVynPuGFIO~mwEyTIfzaebLHBVXxB~LoUTjD2GSgdqXOSFtaCodh2dil3nxwCrKgCm8zUGBo7UhI6sAA__&Key-Pair-Id=APKAJHEJJBIZWFB73RSA)

NOTE:
* ```Labels``` value will be used as a marker for a particular job to be run only on a specific agent
* The following configuration is required for ```Container settings...```
  * JENKINS_SLAVE_SSH_PUBKEY=<SSH public key>  

5. Configure a Jenkins build job:
* In [Build job] -> Configuration
  * Configure build to be run on a specific build agent![](https://d1ro8r1rbfn3jf.cloudfront.net/ms_107835/kLIlALItOgEYmHAGd3PizpzDsCIfJg/NS%2BBuild%2B-%2BDocker%2BAgent%2BConfig%2B%255BJenkins%255D%2B2017-10-15%2B22-41-16.png?Expires=1508182889&Signature=WW-ps8HrDu3znJ0o9NY5tSdvV29W77lhuj~kKxNV6x5yNXGo5LbH6jzcUaT6ZN3~cnYnN4lSgIkwlXtfrc8BNpD-ayRk5m9z1sULaAM0NY94pq7YhFJOjXoJHrBffQ-2hTYGMwEtETCoO~wklhcP--sWRWoXmQcEMZ8o2TEhhTYUvNxtEOMAFtYi1NAIBLZmxCcccbk6mBqnrwXQQk0phz3bpvS~EoiBtUNdwfG0oOMSGVDRNaGz~gDBLLa3EfuVm~~5SH~4UifjXuzLWF4mI65yL2cYdlo8nVXuW1H1NQDKIEI7rDeEC237qB4vUyaSi8Y~1mCteQI9BBjwT6Jgeg__&Key-Pair-Id=APKAJHEJJBIZWFB73RSA)
  * Reference nesessary tools from shell build steps. For example: 
  ```echo "$NS_ENV_PASSWORD" | sdfcli validate```


TODO
----
* Use alpine based image to optimize the size