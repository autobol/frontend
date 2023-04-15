pipeline {
    agent any

    stages {
        stage('Build and publish') {
            steps {
                sh''' 
                    docker build `
                    `-t $DOCKER_REGISTRY/frontend:latest `
                    `-t $DOCKER_REGISTRY/frontend:jenk `
                    `--build-arg YARN_VERSION=$YARN_VERSION `
                    `--build-arg GRADLE_VERSION=$GRADLE_VERSION .
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push $DOCKER_REGISTRY/frontend --all-tags
                '''
            }
        }
    }
}
