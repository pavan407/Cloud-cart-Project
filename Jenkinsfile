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
                echo 'Building Docker image'

                sh '''
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        stage('Tag Docker Image') {
            steps {
                sh '''
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${FULL_IMAGE_NAME}
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
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
                echo 'Deploying Cloud-cart to Kubernetes'

                withKubeConfig(credentialsId: 'kubernetes-credentials') {
                    sh '''
                        echo "Checking Kubernetes connection"

                        kubectl cluster-info

                        echo "Applying Kubernetes Deployment"

                        kubectl apply -f k8s/deployment.yaml

                        echo "Applying Kubernetes Service"

                        kubectl apply -f k8s/service.yaml

                        echo "Waiting for deployment"

                        kubectl rollout status deployment/cloudcart-deployment --timeout=180s

                        echo "Checking Kubernetes resources"

                        kubectl get deployments
                        kubectl get replicasets
                        kubectl get pods
                        kubectl get services
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Cloud-cart CI/CD pipeline completed successfully!'
        }

        failure {
            echo 'Cloud-cart CI/CD pipeline failed. Check console output.'
        }

        always {
            sh 'docker logout || true'
        }
    }
}
