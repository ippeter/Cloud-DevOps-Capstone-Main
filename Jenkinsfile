node {
  checkout scm
  
  stage('Lint Python') {
    sh 'pylint --disable=R,C,W1203 mysql_tester.py'
    }

  stage('Lint HTML') {
    sh 'tidy -q -e hello.html'
  }

  stage('Lint Dockerfile') {
    sh 'hadolint --ignore DL3013 Dockerfile'
  }

  stage('Build Image') {
    def dockerImage = docker.build("mysql_tester:${env.BUILD_ID}")
  }

}
