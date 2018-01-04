pipeline {
    agent any
    environment {
        VERSION = readFile("VERSION").trim()
        TARGET_DOCKER_IMAGE = "rally-jenkins-demo/app:${env.VERSION}"
    }
    stages {
        stage('Build') {
            steps {
                echo "Building ${env.VERSION}.."
                script {
                    sh "cp -r src/* build/"
                    sh "sed -i s/__version__/${env.VERSION}/ build/index.html"
                    sh "docker build . -t ${env.TARGET_DOCKER_IMAGE}"
                }
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
                script {
                    def test_id = sh(returnStdout: true, script: "docker run --network=rallyjenkinsdemo_default -d ${TARGET_DOCKER_IMAGE}").trim()
                    sleep 5
                    try {
                        def container_ip = sh(returnStdout: true, script: "docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${test_id}").trim()
                        sh "curl ${container_ip}:80"
                    }
                    catch (Exception e) {
                        throw e
                    }
                    finally {
                        sh "docker kill ${test_id}"
                    }
                    
                }
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

