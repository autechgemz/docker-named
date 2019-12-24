FROM alpine:latest
MAINTAINER autechgemz@gmail.com
RUN apk upgrade --update --available \
 && apk add --no-cache \
    tini \
    tzdata \
    rsyslog \
    bind \
    bind-libs \
    bind-tools \
 && rm -f /var/cache/apk/*
COPY etc/bind /etc/bind
COPY var/bind /var/bind
COPY etc/rsyslog.conf /etc/rsyslog.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
EXPOSE 53/udp 53/tcp
ENTRYPOINT ["tini", "--"]
CMD ["/entrypoint.sh"]
COPY Dockerfile /Dockerfile
