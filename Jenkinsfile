pipeline {
    agent any

    triggers {
        // Poll SCM as fallback if webhook fails
        pollSCM('H/2 * * * *')
    }

    environment {
        // Build Information
        BUILD_TAG = "${env.BUILD_NUMBER}"
        GIT_COMMIT_SHORT = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
    }

    parameters {
        booleanParam(
            name: 'CLEAN_VOLUMES',
            defaultValue: true,
            description: 'Remove volumes (clears database)'
        )
        string(
            name: 'VITE_API_URL',
            defaultValue: 'http://192.168.56.1:3001',
            description: 'API host URL for frontend to connect to.'
        )
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "Checking out code..."
                    checkout scm
                    echo "Deploying to production environment"
                    echo "Build: ${BUILD_TAG}, Commit: ${GIT_COMMIT_SHORT}"
                }
            }
        }

        stage('Validate') {
            steps {
                script {
                    echo "Validating Docker Compose configuration..."
                    sh 'docker compose config'
                }
            }
        }

        stage('Prepare Environment') {
            steps {
                script {
                    echo "Preparing environment configuration..."

                    // Create .env file with predefined values
                    sh """
                        cat > .env <<EOF
MYSQL_ROOT_PASSWORD=rootpassword
MYSQL_DATABASE=drama_streaming
MYSQL_USER=drama_user
MYSQL_PASSWORD=drama_pass
MYSQL_PORT=3306
PHPMYADMIN_PORT=8888
API_PORT=3001
SESSION_SECRET=your-super-secret-session-key-change-this
CORS_ORIGIN=http://localhost:3000
FRONTEND_PORT=3000
NODE_ENV=production
VITE_API_URL=${params.VITE_API_URL}
EOF
                    """

                    echo "Environment configuration created"
                    sh 'echo ".env file created successfully"'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "Deploying to production using Docker Compose..."

                    // Stop existing containers
                    def downCommand = 'docker compose down'
                    if (params.CLEAN_VOLUMES) {
                        echo "WARNING: Removing volumes (database will be cleared)"
                        downCommand = 'docker compose down -v'
                    }
                    sh downCommand

                    // Build and start services
                    sh """
                        docker compose build --no-cache
                        docker compose up -d
                    """

                    echo "Deployment completed"
                }
            }
        }

        stage('Health Check') {
            steps {
                script {
                    echo "Waiting for services to start..."
                    sh 'sleep 20'

                    echo "Performing health check..."

                    sh """
                        # Check if containers are running
                        docker compose ps

                        # Wait for API to be ready (max 60 seconds)
                        timeout 60 bash -c 'until curl -f http://localhost:3001/api/health; do sleep 2; done' || exit 1

                        # Check dramas endpoint
                        curl -f http://localhost:3001/api/dramas || exit 1

                        echo "Health check passed!"
                    """
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    echo "Verifying all services..."

                    sh """
                        echo "=== Container Status ==="
                        docker compose ps

                        echo ""
                        echo "=== Service Logs (last 20 lines) ==="
                        docker compose logs --tail=20

                        echo ""
                        echo "=== Deployed Services ==="
                        echo "Frontend: http://localhost:3000"
                        echo "API: http://localhost:3001"
                        echo "phpMyAdmin: http://localhost:8888"
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment completed successfully!"
            echo "Build: ${BUILD_TAG}"
            echo "Commit: ${GIT_COMMIT_SHORT}"
            echo ""
            echo "Access your application:"
            echo "  - Frontend: http://localhost:3000"
            echo "  - API: http://localhost:3001"
            echo "  - phpMyAdmin: http://localhost:8888"
        }

        failure {
            echo "❌ Deployment failed!"

            script {
                echo "Printing container logs for debugging..."
                sh 'docker compose logs --tail=50 || true'
            }
        }

        always {
            echo "Cleaning up old Docker resources..."
            sh """
                # Remove dangling images
                docker image prune -f

                # Remove old containers
                docker container prune -f
            """
        }
    }
}
