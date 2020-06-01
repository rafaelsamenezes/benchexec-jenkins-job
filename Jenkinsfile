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
    string(name: 'benchmark_url', defaultValue: 'https://raw.githubusercontent.com/rafaelsamenezes/competition-definitions/master/esbmc-falsi.xml', description: 'Download link for benchmark (will be name tool-def.xml')
	  string(name: 'prepare_environment_url', defaultValue: 'https://pastebin.com/raw/zLA7KR3m', description: 'Commands to be executed before running benchexec')
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
        sh "sudo mkdir /tool && sudo mkdir /results-verified && sudo mkdir /result-verified"
        sh 'sudo -H -E pip3 install numpy'
        sh 'cd /tool ; sudo -E wget $tool_url'
        sh 'cd /tool ; sudo -E wget $benchmark_url -O tool-def.xml'
        sh 'cd /tool ; sudo -E wget $prepare_environment_url -O prepare_environment.sh'
        sh 'cd /tool ; sudo -E bash prepare_environment.sh'
        
        sh 'sudo mkdir /verified'
        sh 'cd /verified ; sudo -E wget https://www.dropbox.com/s/8p1re7tgoe15ksm/val_testcov.zip'
        sh 'cd /verified ; sudo unzip val_testcov.zip'
        sh 'cd /verified/testcov ; sudo -E wget https://raw.githubusercontent.com/rafaelsamenezes/competition-definitions/master/testcov.xml'
	  }
    }
    stage('Execute benchexec (Tool)') {
      steps {
        sh 'cd /tool ; sudo benchexec  ./tool-def.xml --timelimit $timeout --tasks $category --limitCores 3 --numOfThreads 8 --full-access-dir / --hidden-dir /home --hidden-dir /result-verified'
        sh 'cd /tool; sudo cp -r results/*.files/* /results-verified'
      }
    }
    stage('Execute benchexec (Testcov)') {
      steps {
          sh 'cd /verified/testcov ; sudo benchexec  ./testcov.xml --tasks $category --limitCores 1 --numOfThreads 10 --read-only-dir / --full-access-dir $PWD --hidden-dir /home --full-access-dir /sys/fs/cgroup'
          sh 'cd /verified/testcov ; ls results'
      }
    }
    stage('Generate results') {
      steps {
        sh 'ls'
        sh 'sudo table-generator /verified/testcov/results/*.xml.bz2'
        sh 'mkdir results'
        sh 'sudo cp -r /verified/testcov/results/* results'
        sh 'sudo cp -r /tool/results/*.files/* results'
        

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
