pipeline {
  options {
    buildDiscarder(logRotator(daysToKeepStr: '7', numToKeepStr: '200', artifactNumToKeepStr: '200'))
  }
  agent {
    kubernetes {
      yaml """
apiVersion: "v1"
kind: "Pod"
spec:
  containers:
    - name: "jnlp"
      image: "rafaelsamenezes/esbmc-jnlp:benchexec"
      securityContext:
        privileged: true
      resources:
        limits:
          memory: "140Gi"
        requests:
          memory: "140Gi"
      volumeMounts:
        - mountPath: "/sys/fs/cgroup"
          name: "volume-0"
          readOnly: false
        - mountPath: "/home/jenkins/agent"
          name: "workspace-volume"
          readOnly: false
          
  volumes:
    - hostPath:
        path: "/sys/fs/cgroup"
      name: "volume-0"
    - emptyDir:
        medium: ""
      name: "workspace-volume"
"""
    }

  }
  parameters {
    string(name: 'tool_url', defaultValue: 'https://www.dropbox.com/s/jwwmyw5q4ahpzjg/fusebmc.tar.gz', description: 'Download link for the tool')
    string(name: 'category', defaultValue: 'ReachSafety-Heap', description: 'Category to be executed')
	  string(name: 'timeout', defaultValue: '10', description: 'Timeout to be used (in seconds)')
  }
  stages {
    stage('Download Files') {
      environment {
        http_proxy = 'http://10.99.101.14:3128'
        https_proxy = 'http://10.99.101.14:3128'
      }
      steps {   
        sh 'sudo -H -E pip3 install numpy'
        sh 'wget $tool_url -O tool.zip'
        sh 'unzip tool.zip'
        sh 'wget https://raw.githubusercontent.com/rafaelsamenezes/competition-definitions/master/esbmc-falsi.xml -O tool-def.xml'
        sh 'wget https://raw.githubusercontent.com/rafaelsamenezes/competition-definitions/master/testcov.xml'
	  }
    }
    stage('Execute benchexec (Tool)') {
      steps {
        sh 'sudo benchexec  ./tool-def.xml --timelimit $timeout --tasks $category --limitCores 3 --numOfThreads 1 --no-container --full-access-dir / --hidden-dir /home --hidden-dir  ./results-verified --no-compress-results' 
      }
    }
    stage('Execute benchexec (Testcov)') {
      steps {
          sh 'sudo benchexec  ./testcov.xml --tasks $category --limitCores 1 --numOfThreads 11 --no-container --full-access-dir / --hidden-dir /home --hidden-dir  ./results-verified --no-compress-results'
      }
    }
    stage('Generate results') {
      steps {
        sh 'ls'
        sh 'sudo cp -r results-verified/ results/'
        zip(zipFile: "benchexec-${params.category}.zip", archive: true, dir: './results')
        publishHTML([
                    allowMissing: false,
                    alwaysLinkToLastBuild: false,
                    keepAll: true,
                    reportDir: 'results',
                    reportFiles: 'output*.html',
                    reportName: "HTML Reports"
                  ])
        }
      }
    
  }
}
