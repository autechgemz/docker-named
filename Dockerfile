FROM alpine:latest
MAINTAINER autechgemz@gmail.com
ENV TZ Asia/Tokyo
ARG TIMEZONE=${TZ}
RUN apk upgrade --update --available \
 && apk add --no-cache \
    tini \
    tzdata \
    rsyslog \
    bind \
    bind-libs \
    bind-tools \
    wget \
    ca-certificates \
 && update-ca-certificates \
 && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
 && apk del tzdata
COPY etc/bind /etc/bind
COPY etc/rsyslog.conf /etc/rsyslog.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
EXPOSE 53/udp 53/tcp
VOLUME ["/etc/bind"]
ENTRYPOINT ["tini", "--"]
CMD ["/entrypoint.sh"]
COPY Dockerfile /Dockerfile
