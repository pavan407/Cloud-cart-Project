pipeline {
    agent any

    environment {
        DOCKER_USER = 'pavan404'
        IMAGE_NAME = 'cloudcart'
        IMAGE_TAG = 'MD'
        DOCKER_IMAGE = 'pavan404/cloudcart:MD'
        KUBECONFIG = '/var/lib/jenkins/.kube/config'
    }

    stages {

        stage('Code Checkout') {
            steps {
                echo 'Checking out source code from GitHub'

                checkout scm
            }
        }

        stage('Code Cloning') {
            steps {
                echo 'Source code cloned successfully'

                sh '''
                    pwd
                    ls -la
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image'

                sh '''
                    docker build -t cloudcart:MD .
                '''
            }
        }

        stage('Tag Docker Image') {
            steps {
                echo 'Tagging Docker image'

                sh '''
                    docker tag cloudcart:MD pavan404/cloudcart:MD
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                echo 'Pushing Docker image to Docker Hub'

                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKERHUB_USER',
                        passwordVariable: 'DOCKERHUB_PASS'
                    )
                ]) {
                    sh '''
                        echo "$DOCKERHUB_PASS" | docker login \
                        -u "$DOCKERHUB_USER" --password-stdin

                        docker push pavan404/cloudcart:MD
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying Cloud-cart to MicroK8s'

                sh '''
                    set -e

                    echo "Checking kubeconfig"

                    test -s "$KUBECONFIG"

                    echo "Checking Kubernetes context"

                    kubectl config current-context

                    echo "Checking Kubernetes nodes"

                    kubectl get nodes

                    echo "Deploying application"

                    kubectl apply -f deployment.yaml

                    echo "Checking deployment"

                    kubectl rollout status deployment/cloudcart \
                    --timeout=180s

                    echo "Checking pods"

                    kubectl get pods -o wide

                    echo "Checking services"

                    kubectl get svc
                '''
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
