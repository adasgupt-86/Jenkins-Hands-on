**Project-1:**
1. Scripted Pipeline from Jenkinsfile using "Pipeline script from SCM" feature in Jenkins
2. Tested with Cron job (Build periodically)
3. Only for connectivity & cron job testing purposes.
**=======================================================================================**

## Project 2: Jenkins CI/CD Pipeline (Scripted) – End-to-End Implementation

## 📌 Overview

This project demonstrates a **production-style CI/CD pipeline using Jenkins (Scripted Pipeline)** integrated with **GitHub Webhooks, SonarQube, Docker, and Email Notifications**.

The pipeline automates the complete workflow from **code commit → auto trigger--->quality analysis → approval → container-image build → deployment artifact push**.

---

## ⚙️ Pipeline Architecture

```
GitHub Webhook Trigger
        ↓
Environment Setup
        ↓
Git Checkout
        ↓
SonarQube Scan & Authentication
        ↓
Quality Gate Validation
        ↓
Manual Approval (Pre-Build)
        ↓
Docker Image Build
        ↓
DockerHub Push
        ↓
Pipeline Status Output
        ↓
Email Notification
```

---

## 🔄 Workflow Explanation

### 1. 🔔 GitHub Webhook Trigger

* Configured webhook to trigger Jenkins job automatically on code push
* Used **ngrok** to expose local Jenkins server for webhook integration

---

### 2. 🌍 Environment Setup

* Defined required environment variables in Jenkins pipeline
* Managed credentials securely (DockerHub, SonarQube)

---

### 3. 📥 Git Checkout

* Pulled latest code from GitHub repository
* Ensured correct branch tracking

---

### 4. 🔍 SonarQube Analysis

* Integrated SonarQube for static code analysis
* Authenticated using secure credentials
* Performed code scan to evaluate:

  * Bugs
  * Vulnerabilities
  * Code smells

---

### 5. 🚦 Quality Gate Implementation

* Enforced **Quality Gate check**
* Pipeline proceeds only if:

  * Code meets defined quality standards
* Prevents bad code from moving forward

---

### 6. 🛑 Manual Approval Stage

* Added **human validation step before build**
* Ensures:

  * Business approval
  * Risk control before artifact creation

---

### 7. 🐳 Docker Image Build

* Built Docker image using:

  * `Dockerfile`
  * `app.sh`
* Executed inside Jenkins pipeline after approval

---

### 8. 📤 Push to DockerHub

* Authenticated securely using stored credentials
* Tagged and pushed image to DockerHub repository

---

### 9. 📊 Pipeline Status Output

* Displayed final pipeline execution status
* Helps in quick debugging and monitoring

---

### 10. 📧 Email Notification

* Configured email alerts for:

  * Success
  * Failure
  * Used AI-assisted email formatting for professional email body using Jenkins Logo.

---

## 🧰 Tools & Technologies Used

* Jenkins (Scripted Pipeline)
* GitHub (SCM)
* SonarQube (Code Quality)
* Docker (Containerization)
* DockerHub (Image Registry)
* ngrok (Webhook tunneling)
* Email Extension Plugin (Notifications)

---

## 📁 Project Setup Steps

### 1. Local Development

* Created:

  * `Dockerfile`
  * `app.sh`
* Tested application locally

### 2. Version Control

```bash
git add .
git commit -m "Initial commit"
git push origin main
```

---

### 3. Jenkins Configuration

* Created **Scripted Pipeline Job**
* Configured:

  * GitHub repository
  * Webhook trigger
  * Credentials (DockerHub, SonarQube)

---

### 4. Webhook Integration

* Used **ngrok** to expose Jenkins:

```bash
ngrok http 8080
```

* Added generated URL to GitHub webhook

---

## ❗ Key Decisions

* ❌ Did NOT use Jenkinsfile (already implemented in previous project)
* ✅ Used **Scripted Pipeline (shared bellow) directly in Jenkins UI**
* ✅ Added **Manual Approval** for controlled deployment
* ✅ Enforced **Quality Gate before build**
* ✅ Automated full CI/CD lifecycle

---

## 🧠 Learnings & Outcomes

* Hands-on experience with **end-to-end CI/CD pipeline design**
* Strong understanding of:

  * Pipeline orchestration
  * DevOps quality control (SonarQube)
  * Secure credential handling
* Implemented **real-world approval workflows**
* Integrated multiple tools into a cohesive pipeline

---

## ✅ Conclusion

This project successfully demonstrates a **robust CI/CD pipeline** with:

* Automated triggers
* Code quality enforcement
* Controlled approvals
* Containerized artifact delivery

---



-----------------------------------------------------------------------
**Groovy codes syntax in Jenkins are as following-->**
-----------------------------------------------------------------------
```groovy

pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "adasgupt86/jenkins-demo"
        TAG1 = "v1"
        TAG2 = "v2"
        DOCKER_LOGIN = credentials ('dockerhub-cred')
        SONARQUBE_LOGIN = credentials ('sonar')
    }
    
    stages {
    
        stage ('Git-checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/adasgupt-86/Jenkins-Hands-on.git',
                    credentialsId: 'git-cred'
            }
        }
        
        stage ('SonarQube Scan') {
            steps {
                script {
                    def scannerHome = tool 'sonar-scanner'
                    withSonarQubeEnv('sonarqube') {
                        sh """
                        ${scannerHome}/bin/sonar-scanner \
                        -Dsonar.projectName=Sonar-Qube-testing \
                        -Dsonar.projectKey=Sonar-Qube-testing \
                        -Dsonar.sources=. \
                        -Dsonar.nodejs.executable=/usr/bin/node \
                        -Dsonar.exclusions=**/*.js,**/*.ts,**/*.css
                        """
                    }
                }
            }
        }
        
        stage ('Quality Gate') {
            steps {
                timeout (time:5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        
        stage ('Mannual Approve for Build') {
            steps {
                input message: 'Do you want to proceed?', 
                ok: 'Approve',
                submitter: 'admin,devops-team'
            }
        }
        
        stage ('Build') {
            steps {
                sh '''
                docker build -t demo:$TAG1 .
                '''
            }
        }
        
        stage ('Image push to DockerHub') {
            steps {
                sh '''
                    echo $DOCKER_LOGIN_PSW | docker login -u $DOCKER_LOGIN_USR --password-stdin
                    '''
                sh 'docker --version'
                sh 'docker tag demo:$TAG1 $DOCKER_IMAGE:$TAG2'
                sh 'docker push $DOCKER_IMAGE:$TAG2'
            }
        }
    }
    
    
    post {
        always {
            emailext(
                to: 'abhishek.dasgupta11@gmail.com, adasgupt1986@gmail.com',
                subject: "${currentBuild.currentResult == 'SUCCESS' ? '✅ SUCCESS' : '❌ FAILURE'} | ${env.JOB_NAME} #${env.BUILD_NUMBER} [${env.GIT_BRANCH ?: 'main'}]",
                mimeType: 'text/html',
                body: """
                <html>
                <body style="font-family: Arial, sans-serif; background:#f4f6f8; padding:20px;">
                    <div style="max-width:650px; margin:auto; background:#ffffff; border-radius:10px; padding:20px;">

                        <div style="text-align:center; margin-bottom:10px;">
                            <img src="https://www.jenkins.io/images/logos/jenkins/jenkins.png"
                                 alt="Jenkins Logo"
                                 width="80" height="100"
                                 style="display:block; margin:auto;">
                        </div>

        <h2 style="text-align:center;">Jenkins Build Report</h2>

                        <p>Status:
                            <span style="color:${currentBuild.currentResult == 'SUCCESS' ? '#27ae60' : '#e74c3c'}; font-weight:bold;">
                                ${currentBuild.currentResult}
                            </span>
                        </p>

                        <table style="width:100%; border-collapse:collapse; margin-top:15px;">
                            <tr><td><b>Job</b></td><td>${env.JOB_NAME}</td></tr>
                            <tr><td><b>Build</b></td><td>#${env.BUILD_NUMBER}</td></tr>
                            <tr><td><b>Branch</b></td><td>${env.GIT_BRANCH ?: 'main'}</td></tr>
                            <tr><td><b>Duration</b></td><td>${currentBuild.durationString}</td></tr>
                            <tr><td><b>Triggered By</b></td><td>${currentBuild.getBuildCauses()[0]?.shortDescription}</td></tr>
                        </table>

                        <div style="text-align:center; margin:20px;">
                            <a href="${env.BUILD_URL}"
                                style="background:#3498db; color:#fff; padding:10px 20px; border-radius:5px; text-decoration:none;">
                                🔎 View Build Details
                            </a>
                        </div>

                        <hr>
                        <p style="font-size:11px; text-align:center; color:#888;">
                            Automated notification from Jenkins
                        </p>
                    </div>
                </body>
                </html>
                """
                )
        }
        
        success {
            echo "Docker Image Pushed Successfully"
            }
        failure {
            echo "Failed to push Image as Pipeline failed"
            }
        }
    }




