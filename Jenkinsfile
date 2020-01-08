pipeline {
  agent {
    kubernetes {
      label 'jnlp-benchexec-low'
      defaultContainer 'jnlp'
    }

  }
  parameters {
    string(name: 'tool_url', defaultValue: 'http://tool.zip', description: 'Download link for the tool')
    string(name: 'benchmark_url', defaultValue: 'http://tool.xml', description: 'Download link for benchmark (will be name tool-def.xml')
	  string(name: 'prepare_environment', defaultValue: 'echo HELLO', description: 'Commands to be executed before running benchexec')
    string(name: 'category', defaultValue: 'Memsafety-Other', description: 'Category to be executed')
	  string(name: 'timeout', defaultValue: '60', description: 'Timeout to be used (in seconds)')
  }
  stages {
    stage('Download Files') {
      environment {
        http_proxy = 'http://10.99.101.14:3128'
        https_proxy = 'http://10.99.101.14:3128'
      }
      steps {   
        sh 'wget $tool_url'
        sh 'wget $benchmark_url -o tool-def.xml'
        sh '$prepare_environment'     
	    }
    }
    stage('Execute benchexec') {
      steps {
        sh 'free -h'
        sh 'sudo benchexec  ./tool-def.xml --timelimit $timeout --tasks $category --limitCores 2 --numOfThreads 4  --no-container --output output-tool.log'
      }
    }
    }
  }
