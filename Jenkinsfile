pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'pavan404'
        IMAGE_NAME = 'cloudcart'
        IMAGE_TAG = 'MD'
        FULL_IMAGE_NAME = "${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
    }

    stages {

        // Stage 1: Code Cloning
        stage('Code Cloning') {
            steps {
                echo 'Cloning the code'

                git branch: 'main',
                    url: 'https://github.com/pavan407/Cloud-cart-Project.git'
            }
        }

        // Stage 2: Build Docker Image
        stage('Build Docker Image') {
            steps {
                echo 'Building the Docker image'

                sh '''
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        // Stage 3: Tag Docker Image
        stage('Tag Docker Image') {
            steps {
                echo 'Tagging the Docker image'

                sh '''
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${FULL_IMAGE_NAME}
                '''
            }
        }

        // Stage 4: Push Docker Image
        stage('Push Docker Image') {
            steps {
                echo 'Pushing Docker image to Docker Hub'

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

        // Stage 5: Deploy Kubernetes Deployment
        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying application using Kubernetes Deployment'

                withKubeConfig(credentialsId: 'kubeconfig') {
                    sh '''
                        kubectl apply -f k8s/deployment.yaml

                        kubectl rollout status deployment/cloudcart-deployment
                    '''
                }
            }
        }

        // Stage 6: Create ReplicaSet
        stage('Create ReplicaSet') {
            steps {
                echo 'Applying Kubernetes ReplicaSet'

                withKubeConfig(credentialsId: 'kubeconfig') {
                    sh '''
                        kubectl apply -f k8s/replicaset.yaml
                    '''
                }
            }
        }

        // Stage 7: Create Kubernetes Service
        stage('Create Kubernetes Service') {
            steps {
                echo 'Creating Kubernetes Service'

                withKubeConfig(credentialsId: 'kubeconfig') {
                    sh '''
                        kubectl apply -f k8s/service.yaml
                    '''
                }
            }
        }

        // Stage 8: Verify Kubernetes Resources
        stage('Verify Deployment') {
            steps {
                echo 'Checking Kubernetes resources'

                withKubeConfig(credentialsId: 'kubeconfig') {
                    sh '''
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
