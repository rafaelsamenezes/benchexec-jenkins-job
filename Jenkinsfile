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
    string(name: 'tool_url', defaultValue: 'https://gitlab.com/sosy-lab/sv-comp/archives-2020/raw/master/2020/esbmc.zip', description: 'Download link for the tool')
    string(name: 'benchmark_url', defaultValue: 'https://raw.githubusercontent.com/rafaelsamenezes/competition-definitions/master/esbmc-def.xml', description: 'Download link for benchmark (will be name tool-def.xml')
	  string(name: 'prepare_environment_url', defaultValue: 'https://pastebin.com/raw/AidKFUx9', description: 'Commands to be executed before running benchexec')
    string(name: 'category', defaultValue: 'MemSafety-Other', description: 'Category to be executed')
	  string(name: 'timeout', defaultValue: '30', description: 'Timeout to be used (in seconds)')
  }
  stages {
    stage('Download Files') {
      environment {
        http_proxy = 'http://10.99.101.14:3128'
        https_proxy = 'http://10.99.101.14:3128'
      }
      steps {   
        sh 'wget $tool_url'
        sh 'wget $benchmark_url -O tool-def.xml'
        sh 'wget $prepare_environment_url -O prepare_environment.sh'
        sh 'bash prepare_environment.sh'     
	    }
    }
    stage('Execute benchexec') {
      steps {
        sh 'free -h'
        sh 'sudo benchexec  ./tool-def.xml --timelimit $timeout --tasks $category --numOfThreads 9  --no-container --output output-tool.log'
      }
    }
    stage('Generate results') {
      steps {
        sh 'mkdir witnesses'
        sh 'table-generator output*.xml.bz2'
        sh 'mkdir results'
        sh 'cp -r output* results'
        dir(path: 'results') {
          sh 'unzip output*.zip'
        }

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
