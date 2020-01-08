pipeline {
  agent {
    kubernetes {
      label 'jnlp-benchexec-low'
      defaultContainer 'jnlp'
    }

  }
  parameters {
    string(name: 'tool_url', defaultValue: 'https://gitlab.com/sosy-lab/sv-comp/archives-2020/raw/master/2020/esbmc.zip', description: 'Download link for the tool')
    string(name: 'benchmark_url', defaultValue: 'https://raw.githubusercontent.com/rafaelsamenezes/competition-definitions/master/esbmc-def.xml', description: 'Download link for benchmark (will be name tool-def.xml')
	  string(name: 'prepare_environment_url', defaultValue: 'https://pastebin.com/raw/AidKFUx9', description: 'Commands to be executed before running benchexec')    
	  string(name: 'timeout', defaultValue: '60', description: 'Timeout to be used (in seconds)')
  }
  stages {
    stage('Start Jobs') {
      environment {
        http_proxy = 'http://10.99.101.14:3128'
        https_proxy = 'http://10.99.101.14:3128'
      }
       steps{
          script{
            String[] categories = ["MemSafety-Other", "MemSafety-MemCleanup"]
            Integer[] jobs = [1,2,3]
            def parallelJobs = [:]
            def buildResults = [:]
            for (int i = 0; i < categories.size(); i++) {
              def category = categories[i]
              println "running ${category}"
              parallelJobs[category] = {           
                def job_result = build job: 'benchexec-jenkins-job/low-res', parameters: [
                  string(name: 'tool_url', value: "${params.tool_url}"),
                  string(name: 'benchmark_url', value: "${params.benchmark_url}"),
                  string(name: 'prepare_environment_url', value: "${params.prepare_environment_url}"),
                  string(name: 'timeout', value: "${params.timeout}"),
                  string(name: 'category', value: "${category}")          
                ]
                echo "Job number ${job_result.getNumber()}"
                jobs[i] = job_result.getNumber()
              }
            }

            parallel parallelJobs  
            println parallelJobs
         }
      }
    }
  }
}
