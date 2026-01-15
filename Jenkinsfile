pipeline {
    agent any

    environment {
        // ข้อมูล Registry และ Image
        REGISTRY = "ghcr.io"
        IMAGE_NAME = "aunkko-0/nestjs-api-20"
        CREDENTIALS_ID = 'nestjs' 
    }

    stages {
        stage('1. Checkout Source') {
            steps {
                checkout scm
            }
        }

        stage('2. Docker Login') {
            steps {
                // ต้องใช้ ID ให้ตรงกับใน Jenkins Credentials
                withCredentials([usernamePassword(credentialsId: "${env.CREDENTIALS_ID}", passwordVariable: 'GHCR_PAT', usernameVariable: 'GHCR_USER')]) {
                    sh 'echo $GHCR_PAT | docker login $REGISTRY -u $GHCR_USER --password-stdin'
                }
            }
        }

        stage('3. Build Image') {
            steps {
                sh 'docker build -t $REGISTRY/$IMAGE_NAME:latest .'
            }
        }

        stage('4. Push to Registry') {
            steps {
                sh 'docker push $REGISTRY/$IMAGE_NAME:latest'
            }
        }
    }

    post {
        always {
            // ลบ Image หลังทำงานเสร็จเพื่อประหยัดพื้นที่
            sh 'docker rmi $REGISTRY/$IMAGE_NAME:latest || true'
            cleanWs()
        }
        success {
            echo "Successfully built and pushed: $IMAGE_NAME"
        }
    }
}
