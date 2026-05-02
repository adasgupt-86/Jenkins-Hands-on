pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/adasgupt-86/jenkins-practice.git'
            }
        }

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
