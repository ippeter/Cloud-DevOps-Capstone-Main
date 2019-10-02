pipeline {
  agent any
  stages {
    stage('Lint Python') {
      steps {
        pylint --disable=R,C,W1203 mysql_tester.py
      }
    }
  }
}
