FROM jetty

EXPOSE 9090

RUN mkdir -p /var/lib/jetty/webapps/
COPY gameoflife-web /var/lib/jetty/webapps/

ENTRYPOINT cd /var/lib/jetty/webapps/gameoflife-web && mvn jetty:run
