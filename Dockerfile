FROM nextcloud:latest

COPY dokku-entrypoint.sh /dokku-entrypoint.sh

RUN ["chmod", "+x", "/dokku-entrypoint.sh"]

ENTRYPOINT ["/dokku-entrypoint.sh"]

ADD nginx.conf.sigil .

CMD ["apache2-foreground"]