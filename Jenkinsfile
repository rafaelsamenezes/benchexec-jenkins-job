pipeline {
  agent {
    kubernetes {
      label 'jnlp-benchexec-low'
      defaultContainer 'jnlp'
    }

  }
  parameters {
        booleanParam(defaultValue: true, description: '', name: 'userFlag')
  }
  stages {
    stage('Download Files') {
      environment {
        http_proxy = 'http://10.99.101.14:3128'
        https_proxy = 'http://10.99.101.14:3128'
      }
      steps {        
	sh 'echo HELLO'
      }
    }
    stage('Execute benchexec') {
      steps {
        sh 'free -h'
      }
    }
    }
  }
