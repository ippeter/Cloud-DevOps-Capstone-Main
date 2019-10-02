pipeline {
  environment {
    registry = "ippeter/mysql-tester"
    registryCredential = 'dockerhub'
  }
  
  agent any
  
  stages {
    stage('Lint Python') {
      steps {
        sh 'pylint --disable=R,C,W1203 mysql-tester.py'
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
    
    stage('Push Image') {
      steps {
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }

    stage('Check Minikube Connection') {
      steps {
        script {
          withKubeConfig([credentialsId: 'JenkinsToken', serverUrl: 'https://192.168.0.215:8443']) {
            sh 'kubectl get deployment'
          }
        }
      }
    }

    stage('Deploy Image') {
      steps {
        script {
          withKubeConfig([credentialsId: 'JenkinsToken', serverUrl: 'https://192.168.0.215:8443']) {
            sh '''
              if kubectl get deployment | grep -q mysql-tester
              then
                echo "Deployment found, updating..."
                kubectl set image deployment/mysql-tester mysql-tester="$registry:$BUILD_NUMBER"
              else
                echo "Deployment not found, creating for the first time..."
                kubectl create deployment mysql-tester --image="$registry:$BUILD_NUMBER"
                kubectl scale deployment mysql-tester --replicas=2
              fi
            '''
          }
        }
      }
    }

  }
}
