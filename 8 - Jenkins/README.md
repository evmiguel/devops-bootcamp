Starting with repo: `https://gitlab.com/evmiguel/jenkins-exercises`
In it, there is a Dockerfile for the application.

## Jenkins Multibranch Pipline
- Created Jenkins Multibranch Pipeline called `jenkins-exercises-pipeline`
- Set git project repository to the repo above
- Added build strategy for Ignore Committer Strategy for `jenkins@example.com`
- Installed `Pipeline Utility Steps` plugin to use `readJSON` utility in Jenkinsfile

## Manually deploy new Docker Image on server
```
ssh root@134.209.64.193
docker login
docker run -d -p 3000:3000 evmiguel/demo-app:1.0.1-10
```

App ran on http://134.209.64.193:3000/

## Jenkins Shared Library
In this repo: https://gitlab.com/evmiguel/jenkins-exercises-shared-library
The Jenkinsfile is in the `shared-library` branch of https://gitlab.com/evmiguel/jenkins-exercises

- Configure Global Pipeline Library called `jenkins-exercises-shared-library` with default version `main`
- Note: make sure to add an underscore after `@Library("jenkins-exercises-shared-library")_`. See [Stack Overflow](https://stackoverflow.com/questions/47875357/why-is-there-a-sometimes-a-trailing-underscore-in-the-pipeline-library-syntax)
- The following were implemented:
  - incrementVersion
  - runTests
  - buildImage
  - dockerLogin
  - dockerPush
  - commitNewVersion

