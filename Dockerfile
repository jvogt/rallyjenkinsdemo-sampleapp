FROM jetty

EXPOSE 8080

RUN mkdir -p /var/lib/jetty/webapps/
COPY /var/jenkins_home/workspace/SampleApp/gameoflife-web/target/gameoflife/gameoflife.war /var/lib/jetty/webapps/ROOT.war
