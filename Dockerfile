FROM jetty

EXPOSE 8080

RUN mkdir -p /var/lib/jetty/webapps/
COPY gameoflife-web/target/gameoflife.war /var/lib/jetty/webapps/ROOT.war
