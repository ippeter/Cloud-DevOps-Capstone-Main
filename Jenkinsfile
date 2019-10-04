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

    stage('Deploy Image') {
      steps {
        script {
          withAWS(region:'us-west-2', credentials:'aws-final') {
            sh '''
              if kubectl get deployment | grep -q mysql-tester
              then
                echo "Deployment found, updating..."
                kubectl set image deployment/mysql-tester mysql-tester="$registry:$BUILD_NUMBER"
              else
                echo "Deployment not found, creating for the first time and exposing..."
                kubectl create deployment mysql-tester --image="$registry:$BUILD_NUMBER"
                kubectl scale deployment mysql-tester --replicas=2
                kubectl expose deployment mysql-tester  --type=LoadBalancer --port=8081 --target-port=5000
              fi
            '''
          }
        }
      }
    }
    
    stage('Get RDS Endpoint') {
      steps {
        withAWS(region:'us-west-2', credentials:'aws-final') {
          sh 'aws cloudformation describe-stacks --stack-name rds --query Stacks[0].Outputs[0].OutputValue > /tmp/rds-endpoint.txt'
        }
      }
    }   

  }
}
