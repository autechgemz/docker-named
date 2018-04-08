FROM alpine:latest

LABEL maintainer "Kenji Tsumaki <autechgemz@gmail.com>"

RUN apk upgrade --update --available \
 && apk add --no-cache \
    runit \
    tzdata \
    rsyslog \
    bind \
    bind-libs \
    bind-tools \
    wget \
    ca-certificates \
 && update-ca-certificates

COPY etc/bind /etc/bind
COPY etc/rsyslog.conf /etc/rsyslog.conf

COPY service /service
RUN chmod 755 /service/*/run

EXPOSE 53/udp 53/tcp

VOLUME ["/etc/bind"]

ENTRYPOINT ["runsvdir", "-P", "/service/"]
