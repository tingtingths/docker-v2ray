ARG APP_UID=1000
ARG APP_GID=1000
ARG VERSION=v4.31.0

FROM ubuntu:18.04 AS builder
ARG VERSION
RUN mkdir -p /v2ray_install

WORKDIR /v2ray_install
RUN set -ex && \
    apt-get update && apt-get install -y curl && \
    curl -L -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh && \
    curl -L -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh && \
    chmod +x *.sh && \
    mkdir -p /sbin/init/systemd && \
    ./install-release.sh --version ${VERSION}

FROM alpine:3.11.2
ARG APP_UID
ARG APP_GID
EXPOSE 10086

COPY --from=builder /usr/local/bin/v2ray /usr/bin/v2ray/
COPY --from=builder /usr/local/bin/v2ctl /usr/bin/v2ray/
COPY --from=builder /usr/local/share/v2ray/ /usr/local/share/v2ray/

RUN set -ex && \
    addgroup -g ${APP_GID} appuser && \
    adduser --disabled-password --gecos "" -u ${APP_UID} appuser -G appuser && \
    apk --no-cache add tzdata ca-certificates && \
    mkdir -p /var/log/v2ray /etc/v2ray /usr/share/v2ray && \
    chown appuser:appuser /var/log/v2ray && \
    chmod +x /usr/bin/v2ray/v2ctl && \
    chmod +x /usr/bin/v2ray/v2ray && \
    ln -s /usr/local/share/v2ray/ /usr/share/v2ray

ADD config.json /etc/v2ray/

USER appuser

ENV PATH /usr/bin/v2ray:$PATH
ENV V2RAY_LOCATION_CONFIG /etc/v2ray
ENV V2RAY_LOCATION_ASSET /usr/share/v2ray/

CMD ["v2ray"]
