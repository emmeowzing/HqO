FROM httpd:latest

COPY ./public-html/ /usr/local/apache2/htdocs/
COPY ./my-httpd.conf /usr/local/apache2/conf/httpd.conf
COPY ./server.crt ./server.key /usr/local/apache2/conf/

EXPOSE 443

CMD ["httpd-foreground"]