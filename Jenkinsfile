pipeline {
    agent any
    environment {
        pom = readMavenPom file: 'pom.xml'
        VERSION = pom.version
        TARGET_DOCKER_IMAGE = "rally-jenkins-demo/app:${env.VERSION}"
    }
    stages {
        stage('Build') {
            echo "Building ${env.VERSION}.."
            steps {
                sh 'mvn clean install'
                sh "docker build . -t ${env.TARGET_DOCKER_IMAGE}"
            }
        }
        stage('Test') {
            echo 'Testing..'
            parallel(
                Acceptance: {
                    def test_id = sh(returnStdout: true, script: "docker run --network=rallyjenkinsdemo_default -d ${TARGET_DOCKER_IMAGE}").trim()
                    sleep 5
                    try {
                        def container_ip = sh(returnStdout: true, script: "docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${test_id}").trim()
                        sh "curl ${container_ip}:9090"
                    }
                    catch (Exception e) {
                        throw e
                    }
                    finally {
                        sh "docker kill ${test_id}"
                    }
                },
                SonarScan: {
                    sh 'mvn sonar:sonar -Dsonar.host.url=http://localhost:9000 -Dsonar.login=48428c97f3d54d35c974dea22d2cc285bc11f8a6'
                    //sh 'cd gameoflife-acceptance-tests && mvn clean verify'
                }
            )
        }
        }
        stage('Deploy') {
            steps {
                script {
                    sh "docker stop rallyjenkinsdemo_app_prod || true"
                    sh "docker rm rallyjenkinsdemo_app_prod || true"
                    sh "docker run -d --network=rallyjenkinsdemo_default --name=rallyjenkinsdemo_app_prod -p 30080:80 ${TARGET_DOCKER_IMAGE}"
                }
            }
        }
    }
}

