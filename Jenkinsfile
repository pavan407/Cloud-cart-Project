
pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'pavan404'
        IMAGE_NAME = 'cloudcart'
        IMAGE_TAG = 'MD'
        FULL_IMAGE_NAME = "${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
    }

    stages {

        stage('Code Cloning') {
            steps {
                echo 'Cloning the code'
                git branch: 'main',
                    url: 'https://github.com/pavan407/Cloud-cart-Project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building the Docker image'
                sh '''
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        stage('Tag Docker Image') {
            steps {
                echo 'Tagging the Docker image'
                sh '''
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${FULL_IMAGE_NAME}
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                echo 'Pushing the Docker image to Docker Hub'

                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKERHUB_CREDENTIAL_USER',
                    passwordVariable: 'DOCKERHUB_PASS'
                )]) {
                    sh '''
                        echo "$DOCKERHUB_PASS" | docker login \
                            -u "$DOCKERHUB_CREDENTIAL_USER" \
                            --password-stdin

                        docker push ${FULL_IMAGE_NAME}
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Kubernetes'

                withKubeConfig(credentialsId: 'kubeconfig') {
                    sh '''
                        kubectl apply -f notesapp/deployment.yaml
                        kubectl apply -f notesapp/service.yaml

                        kubectl rollout status deployment/todo-deployment
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'CI/CD pipeline completed successfully.'
        }

        failure {
            echo 'Pipeline failed.'
        }

        always {
            sh 'docker logout || true'
        }
    }
}
