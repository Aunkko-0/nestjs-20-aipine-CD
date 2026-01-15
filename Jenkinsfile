pipeline {
    agent any

    environment {
        // --- ส่วนที่ต้องตรวจสอบให้ตรงกับ GitHub ของคุณ ---
        GITHUB_USERNAME     = 'aunkko-0'
        GITHUB_REPO         = 'nestjs-20-aipine-' // ชื่อ Repo ตามที่คุณส่งมาก่อนหน้า
        GHCR_CREDENTIALS_ID = 'Nestjs-jenkins'      // ID ที่ตั้งไว้ใน Jenkins
        
        // --- ตัวแปรระบบ ---
        GHCR_REGISTRY       = 'ghcr.io'
        IMAGE_BASE_NAME     = "${GHCR_REGISTRY}/${GITHUB_USERNAME}/${GITHUB_REPO}"
    }

    stages {
        stage('1. Install Dependencies') {
            steps {
                echo "Installing NestJS dependencies..."
                // ใช้ npm ci จะเร็วกว่าและแม่นยำกว่าสำหรับ CI/CD
                sh 'npm ci' 
            }
        }

        stage('2. Build Docker Image') {
            steps {
                echo "Building Image: ${IMAGE_BASE_NAME}:${env.BUILD_NUMBER}"
                // Build และติด Tag ทั้งเลข Build และ Latest
                sh "docker build -t ${IMAGE_BASE_NAME}:${env.BUILD_NUMBER} ."
                sh "docker tag ${IMAGE_BASE_NAME}:${env.BUILD_NUMBER} ${IMAGE_BASE_NAME}:latest"
            }
        }
        
        stage('3. Publish to GitHub Registry') {
            steps {
                // ใช้ withCredentials เพื่อความปลอดภัย
                withCredentials([usernamePassword(
                    credentialsId: "${env.GHCR_CREDENTIALS_ID}", 
                    passwordVariable: 'GHCR_TOKEN', 
                    usernameVariable: 'GHCR_USER'
                )]) {
                    // ใช้ Single Quote (') ครอบคำสั่ง sh เพื่อแก้ Security Warning
                    // และใช้ตัวแปรสภาพแวดล้อมโดยตรง ($GHCR_TOKEN)
                    sh 'echo $GHCR_TOKEN | docker login $GHCR_REGISTRY -u $GHCR_USER --password-stdin'
                    
                    echo "Pushing Package to GHCR..."
                    sh "docker push ${IMAGE_BASE_NAME}:${env.BUILD_NUMBER}"
                    sh "docker push ${IMAGE_BASE_NAME}:latest"
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up..."
            // ลบ Image ออกจากเครื่องหลังรันเสร็จ ป้องกันความจุเต็ม
            sh "docker rmi ${IMAGE_BASE_NAME}:${env.BUILD_NUMBER} ${IMAGE_BASE_NAME}:latest || true"
            // ล้าง Workspace
            cleanWs()
        }
        success {
            echo "✅ NestJS Image Published Successfully!"
        }
        failure {
            echo "❌ Build Failed! Please check logs."
        }
    }
}
