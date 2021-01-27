# https://hub.docker.com/_/httpd/
FROM docker.io/httpd:2-alpine
COPY *.ign /usr/local/apache2/htdocs/
