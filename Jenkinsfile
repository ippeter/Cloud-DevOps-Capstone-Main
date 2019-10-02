pipeline {
  agent any
  stages {
    stage('Lint Python') {
      steps {
        pylint --disable=R,C,W1203 mysql_tester.py
      }
    }
    stage('Lint HTML') {
      steps {
        sh 'tidy -q -e hello.html'
      }
    }
  }
}
