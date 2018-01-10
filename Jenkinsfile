pipeline {
    agent any
    environment {
        pom = readMavenPom file: 'pom.xml'
        VERSION = pom.version.toString()
        TARGET_DOCKER_IMAGE = "rally-jenkins-demo/app:${env.VERSION}"
        ACCEPTANCE_CONTAINER_NAME = "rallyjenkinsdemo_app_acceptance"
        PROD_CONTAINER_NAME = "rallyjenkinsdemo_app_prod"
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean install -DskipTests'
                sh "docker build . -t ${env.TARGET_DOCKER_IMAGE}"
            }
        }
        stage('Acceptance') {
            steps {
                script {
                    sh "./start_acceptance_container.sh ${env.ACCEPTANCE_CONTAINER_NAME}"
                    def acceptance_container_ip = sh(returnStdout: true, script: "./get_acceptance_container_ip ${env.ACCEPTANCE_CONTAINER_NAME}").trim()
                    sh "curl -LsSf ${acceptance_container_ip}:8080"
                    //echo "Performing maven verify"
                    //sh "mvn -f gameoflife-acceptance-tests/pom.xml -Djetty.port=8080 -Dwebdriver.base.url='http://rallyjenkinsdemo_app_acceptance:8080' clean verify"
                    sh "./stop_acceptance_container.sh ${env.ACCEPTANCE_CONTAINER_NAME}"
                }
            }
        }
        stage('SonarScan') {
            steps {
                echo "Running SonarQube Scan"
                sh 'mvn sonar:sonar -Dsonar.host.url=http://sonar:9000 -Dsonar.login=admin -Dsonar.password=admin'
            }                
        }
        stage('Deploy') {
            steps {
                sh 'docker stop ${PROD_CONTAINER_NAME} || true'
                sh "docker rm ${PROD_CONTAINER_NAME} || true"
                sh "docker run -d --network=rallyjenkinsdemo_default --name=rallyjenkinsdemo_app_prod -p 30080:8080 ${TARGET_DOCKER_IMAGE}"
            }
        }
    }
}

