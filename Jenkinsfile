def resultDir = 'results'

pipeline {
    agent any

    stages {
        stage('Prepare results dir') {
            steps {
                sh "mkdir -p ${resultDir}"
            }
        }
        stage('Verify Iac-sec') {
            parallel {
                stage("TFsec") {
                    agent{
                        docker{
                            image 'aquasec/tfsec-ci:latest'
                            reuseNode true
                        }
                    }
                    steps {
                        sh "tfsec . --no-colour  --format junit > ${resultDir}/tfsec_report.xml"
                    }
                }
                stage("Regula") {
                    agent{
                        docker{
                            args '--entrypoint=""'
                            image 'fugue/regula:v2.9.1'
                            reuseNode true
                        }
                    }
                    steps {
                        sh "regula run . --input-type tf --include config/waiver.rego --format junit > ${resultDir}/regula_report.xml"
                    }
                }
                stage("Terrascan") {
                    agent{
                        docker{
                            args '--user=root --entrypoint=""'
                            image 'tenable/terrascan'
                            reuseNode true
                        }
                    }
                    steps {
                        sh "terrascan scan --iac-type terraform --verbose --output junit-xml > ${resultDir}/terrascan_report.xml"
                    }
                }
            }
        }
        stage('Build') {
            steps {
                echo "Building..."
                withCredentials([usernamePassword(credentialsId: 'aws-terraform-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'terraform init -no-color'
                    sh 'terraform plan -out plan -no-color'
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
                //sh 'terraform apply "plan" -no-color'
            }
        }
    }
    post { 
        always { 
                junit "${resultDir}/*.xml"
        }
    }
}