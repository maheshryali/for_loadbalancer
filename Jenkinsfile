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
            steps{
            sh """
            terraform init
            terraform destroy -var-file="dev.tfvars" -auto-approve
            """
        }
        }
    }
}