pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'echo "Build started..."'
                sh 'chmod +x app.sh'
                sh './app.sh'
            }
        }
        stage ('Error exeception') {
            steps {
                script {
                    try {
                        sh 'exit 1'
                    } catch (Exception e) {
                        echo "Error occurred but continuing..."
                }
            }
        }
        }            
        stage ('Test (fail but continue)') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    sh 'exit 1'
                }
            }
        }
    }
    post {
        success {
            echo 'Build SUCCESS'
        }
        failure {
            echo 'Build FAILED'
            }
        }
    }
