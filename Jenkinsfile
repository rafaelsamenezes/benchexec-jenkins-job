pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: "v1"
kind: "Pod"
spec:
  containers:
    - name: "jnlp"
      image: "rafaelsamenezes/esbmc-jnlp:benchexec"
      imagePullPolicy: "Always"
"""
    }

  }
  parameters {
    string(name: 'tool_url', defaultValue: 'https://gitlab.com/sosy-lab/sv-comp/archives-2020/raw/master/2020/esbmc.zip', description: 'Download link for the tool')
    string(name: 'benchmark_url', defaultValue: 'https://raw.githubusercontent.com/rafaelsamenezes/competition-definitions/master/esbmc-falsi.xml', description: 'Download link for benchmark (will be name tool-def.xml')
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
            String[] categories = [
              "ReachSafety-Arrays", "ReachSafety-BitVectors", "ReachSafety-ControlFlow", 
              "ReachSafety-Floats", "ReachSafety-Heap", "ReachSafety-Loops",  "ReachSafety-ECA",
              "ReachSafety-Recursive", "ReachSafety-Sequentialized", "SoftwareSystems-BusyBox-MemSafety", 
              "SoftwareSystems-DeviceDriversLinux64-ReachSafety", "SoftwareSystems-SQLite-MemSafety",
              "Termination-MainHeap"
            ]
            String[] high_res = [
              "ReachSafety-Sequentialized",
              "SoftwareSystems-AWS-C-Common-ReachSafety",
              "SoftwareSystems-DeviceDriversLinux64-ReachSafety",
              "MemSafety-TerminCrafted"
            ]

            def parallelJobs = [:]
            int i = 0
            for (; i < categories.size(); i++) {
              def category = categories[i]
              def job_name = high_res.contains(category) ? "Benchexec sv-benchmarks/testcov-run" : "Benchexec sv-benchmarks/testcov-run"
              println "running ${category} in ${job_name}"
              parallelJobs[category] = {
		
                  def built = build job: "${job_name}", parameters: [
                    string(name: 'tool_url', value: "${params.tool_url}"),
                    string(name: 'benchmark_url', value: "${params.benchmark_url}"),
                    string(name: 'prepare_environment_url', value: "${params.prepare_environment_url}"),
                    string(name: 'timeout', value: "${params.timeout}"),
                    string(name: 'category', value: "${category}")          
                  ]
                  copyArtifacts(projectName: "${job_name}", selector: specific("${built.number}"));
		}
              
            }

            parallel parallelJobs  
         }
      }
    }
    stage('Merge Results') {
      environment {
        http_proxy = 'http://10.99.101.14:3128'
        https_proxy = 'http://10.99.101.14:3128'
      }
       steps{
          sh "bash merge-results.sh"
          zip(zipFile: 'benchexec.zip', archive: true, dir: './results')
          publishHTML([
                    allowMissing: false,
                    alwaysLinkToLastBuild: false,
                    keepAll: true,
                    reportDir: 'results',
                    reportFiles: 'merge*.html',
                    reportName: "HTML Reports"
                  ])
      }
    }
  }
}
