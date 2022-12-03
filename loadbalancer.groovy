pipeline {
    agent { label 'DOCKER'}
    stages {
        stage('git') {
            steps {
                git branch: 'master',
                       url: 'https://github.com/maheshryali/for_loadbalancer.git'
            }
        }
        stage('loadbalancer_terraform') {
            sh """
            cd for_loadbalancer
            terraform init
            terraform apply -var-file="dev.tfvars
            """
        }
    }
}