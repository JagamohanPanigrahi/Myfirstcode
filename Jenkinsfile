pipeline {
    agent any

    parameters {
            choice(
            name: 'ENVIRONMENT',
            choices: ['deltekdev','dco','flexplus','costpoint','goss'],
            description: 'AWS Account'
        )
            choice(
            name: 'REGION',
            choices: ['us-east-1', 'us-west-2', 'eu-west-1', 'eu-central-1', 'ap-southeast-1', 'ap-southeast-2'],
            description: 'Instance region'
        )
            string(name: 'AMI_ID', defaultValue: '', description: 'Enter the AMI ID'
        )

    }
    
    stages {
        stage('Checkout Source') {
            steps {
                sh 'python3 --version'
                sh 'pip3 install boto3'
                checkout([$class: 'GitSCM', branches: [[name: "*/main"]], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: "https://github.com/JagamohanPanigrahi/Myfirstcode/blob/0b48ec0b459575c483031684b7eb5be607fe87f4/mainscript.sh"]]])
            }
        }
 
    stages {
        stage('Input') {
            steps {
                script {
                    def ami_id = "${params.AMI_ID}"
                    def region ="${params.REGIONS}"
                   //def region = REGIONS.split(',')
                    def awsCredential = ""
                    def environment = "${params.ENVIRONMENT}"

                    switch (environment) {
                            case 'deltekdev':
                                awsCredential = "infra-at-dev"
                                account = "343866166964"
                                println ""
                                // Code logic for 'infra-at-dev' case
                                break
                            case 'dco':
                                awsCredential = "infra-at-dco"
                                account = "463061647317"
                                println ""
                                break
                            case 'flexplus':
                                awsCredential = "infra-at-flexplus"
                                account = "363912313913"
                                println ""
                                break
                            case 'costpoint':
                                awsCredential = "infra-at-costpoint"
                                account = "389812532864"
                                println ""
                                break
                            case 'goss':
                                awsCredential = "infra-at-oss"
                                account = "364370348307"
                                println ""
                                break
                            default:
                                // Code logic for other cases
                                break
                        }
                 withCredentials([
                            [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: awsCredential, accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                        ]) {
 
                            sh "./mainscript.sh"
                        }
                }
            }
        }
    }
}
