pipeline {
  agent {
    kubernetes {
      label 'jnlp-benchexec-low'
      defaultContainer 'jnlp'
    }

  }
  parameters {
        string(name: 'tool_url', defaultValue: 'http://tool.zip', description: 'Download link for the tool (will be named tool.zip)')
        string(name: 'benchmark_url', defaultValue: 'http://tool.xml', description: 'Download link for benchmark (will be name tool-def.xml')
	string(name: 'prepare_environment', defaultValue: 'echo HELLO', description: 'Commands to be executed before running benchexec')
	string(name: 'timeout', defaultValue: '60s', description: 'Timeout to be used')
  }
  stages {
    stage('Download Files') {
      environment {
        http_proxy = 'http://10.99.101.14:3128'
        https_proxy = 'http://10.99.101.14:3128'
      }
      steps {        
	sh 'echo $tool_url && echo $benchmark_url && echo $timeout'
	sh '$prepare_environment'	
      }
    }
    stage('Execute benchexec') {
      steps {
        sh 'free -h'
      }
    }
    }
  }
