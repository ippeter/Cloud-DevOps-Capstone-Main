pipeline {
  environment {
    registry = "ippeter/mssql_tester"
    registryCredential = 'dockerhub'
  }
  
  agent ( dockerfile true }
  
  stages {
    stage('Lint Python') {
      steps {
        sh 'pylint --disable=R,C,W1203 mysql_tester.py'
      }
    }

    stage('Lint HTML') {
      steps {
        sh 'tidy -q -e hello.html'
      }
    }

    stage('Lint Dockerfile') {
      steps {
        sh 'hadolint --ignore DL3013 Dockerfile'
      }
    }

    stage('Build Image') {
      steps {
        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
  }
}
