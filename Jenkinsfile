pipeline
	agent any
	
	environment {
        // ข้อมูล Registry และ Image (แก้ให้ตรงกับของคุณ)
        REGISTRY = "ghcr.io"
        IMAGE_NAME = "aunkko-0/nestjs-api-20"
        CREDENTIALS_ID = 'Nestjs-jenkins' // ชื่อ ID ที่คุณตั้งใน Jenkins

        }
	
	stages {
        stage('1. Checkout Source') {
            steps {
                // ดึงโค้ดจาก Github
                checkout scm
            }
        }

	stage('2. Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${CREDENTIALS_ID}", usernameVariable: 'GHCR_USER', passwordVariable: 'GHCR_PAT')]) {
                    // ใช้ Single Quotes ('...') เพื่อความปลอดภัย และแก้ปัญหาการส่งค่า Password
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
