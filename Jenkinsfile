pipeline {
    agent any

    stages {
        stage('Input') {
            steps {
                script {
                    // Input step to enter AMI ID and regions
                    def userInput = input(
                        id: 'ami_input',
                        message: 'Enter AMI ID and regions',
                        parameters: [
                            string(name: 'AMI_ID', defaultValue: '', description: 'Enter the AMI ID'),
                            string(name: 'REGIONS', defaultValue: '', description: 'Enter the regions (comma-separated)')
                        ]
                    )

                    def ami_id = userInput.AMI_ID
                    def regions_input = userInput.REGIONS

                    // Split regions into an array
                    def regions = regions_input.split(',')

                    // Execute the shell script with user inputs
                    sh(script: """
                        ./mainscript.sh "$ami_id" "$regions_input"
                    """)
                }
            }
        }
    }
}
