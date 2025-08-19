FROM nginx:alpine

WORKDIR /var/www

RUN set -x ; \
#    addgroup -g 1000 -S www-data ; \
    adduser -u 1000 -D -S -G www-data www-data && exit 0 ; exit 1
# Let usermod, groupmod available in alpine and change the ids
RUN apk add --no-cache shadow && usermod -u 1000 -o www-data && groupmod -g 1000 -o www-data

CMD ["nginx"]

EXPOSE 443
