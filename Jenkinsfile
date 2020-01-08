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
	  string(name: 'prepare_environment_url', defaultValue: 'http://script.sh', description: 'Commands to be executed before running benchexec')    
	  string(name: 'timeout', defaultValue: '60', description: 'Timeout to be used (in seconds)')
  }
  stages {
    stage('Start Jobs') {
      environment {
        http_proxy = 'http://10.99.101.14:3128'
        https_proxy = 'http://10.99.101.14:3128'
      }
      steps {   
        build job: 'benchexec-jenkins-job/low-res', parameters: [$tool_url, $benchmark_url, $prepare_environment_url, "MemSafety-Other",$timeout]
	    }
    }    
  }
}
