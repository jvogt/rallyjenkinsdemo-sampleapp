pipeline {
    agent any
    environment {
        pom = readMavenPom file: 'pom.xml'
        VERSION = pom.version.toString()
        TARGET_DOCKER_IMAGE = "rally-jenkins-demo/app:${env.VERSION}"
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean install -DskipTests'
                sh "docker build . -t ${env.TARGET_DOCKER_IMAGE}"
            }
        }
        stage('Test') {
            parallel {
                stage('Unit') {
                    steps {
                        sh 'mvn test'
                    }
                }
                stage('Acceptance') {
                    steps {
                        script {
                            echo "Starting acceptance container"
                            def test_id = sh(returnStdout: true, script: "docker run --network=rallyjenkinsdemo_default -d ${TARGET_DOCKER_IMAGE}").trim()
                                
                            try {
                                echo "Getting container IP"
                                def cmd = "docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${test_id}"
                                def container_ip = sh(returnStdout: true, script: cmd).trim()
                                echo "Waiting for Jetty to stand up"
                                sleep 10
                                echo "Performing simple curl test"
                                sh "curl -LsSf ${container_ip}:8080"
                                echo "Performing maven verify"
                                sh "cd gameoflife-acceptance-tests && mvn -Djetty.port=8080 -Dwebdriver.base.url='http://${container_ip}:8080' clean verify"
                            }
                            catch (Exception e) {
                                throw e
                            }
                            finally {
                                echo "Destroying acceptance container"
                                sh "docker kill ${test_id}"
                            }
                        }
                    }
                }
                stage('SonarScan') {
                    steps {
                        sh 'mvn sonar:sonar -Dsonar.host.url=http://sonar:9000 -Dsonar.login=admin -Dsonar.password=admin'
                        //sh 'cd gameoflife-acceptance-tests && mvn clean verify'
                    }                
                }
            }
        }
        stage('Deploy') {
            steps {
                sh "docker stop rallyjenkinsdemo_app_prod || true"
                sh "docker rm rallyjenkinsdemo_app_prod || true"
                sh "docker run -d --network=rallyjenkinsdemo_default --name=rallyjenkinsdemo_app_prod -p 30080:8080 ${TARGET_DOCKER_IMAGE}"
            }
        }
    }
}

