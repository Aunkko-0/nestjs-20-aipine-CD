pipeline {
    agent any

    parameters {
        string(
            name: 'IMAGE_TAG', 
            defaultValue: 'latest', 
            description: 'ใส่เฉพาะ Tag (เช่น latest, v1) *ไม่ต้องใส่ชื่อเต็ม*'
        )
    }

    environment {
        // ผมใส่ชื่อ Image ยาวๆ ของคุณไว้ตรงนี้ให้แล้วครับ
        REGISTRY = "ghcr.io"
        IMAGE_NAME = "aunkko-0/nestjs-api-20"
        
        // เอาค่ามารวมร่างกัน: ghcr.io/aunkko-0/nestjs-api-20:latest
        TARGET_IMAGE = "${REGISTRY}/${IMAGE_NAME}:${params.IMAGE_TAG}"
    }

    stages {
        stage('🚀 Deploy to Kubernetes') {
            steps {
                script {
                    echo "กำลัง Deploy Image: ${TARGET_IMAGE} ..."
                    
                    // 1. สั่งเปลี่ยน Image (อัปเดต config)
                    sh "kubectl set image deployment/nestjs-api nestjs-api=${TARGET_IMAGE}"
                    
                    // 2. สั่ง Restart (บังคับให้ดึง latest ตัวใหม่ล่าสุดเสมอ)
                    sh "kubectl rollout restart deployment/nestjs-api"
                }
            }
        }

        stage('✅ Verify Rollout') {
            steps {
                script {
                    // รอแบบไม่มีกำหนด (No Timeout) ตามที่คุณขอครับ
                    sh "kubectl rollout status deployment/nestjs-api"
                }
            }
        }
    }

    post {
        success {
            echo "🎉 Deploy ${params.IMAGE_TAG} สำเร็จเรียบร้อย!"
        }
        failure {
            echo "❌ Deploy ไม่สำเร็จ กรุณาเช็ค Logs"
        }
    }
}
