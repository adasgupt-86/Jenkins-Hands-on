pipeline {
    agent any

        stage('Build') {
            steps {
                sh 'echo "Build started..."'
                sh 'chmod +x app.sh'
                sh './app.sh'
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
