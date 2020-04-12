FROM ubuntu:20.04 AS builder

RUN apt-get update
RUN apt-get install curl -y
RUN curl -L -o /tmp/go.sh https://install.direct/go.sh
RUN chmod +x /tmp/go.sh
RUN /tmp/go.sh --version 'v4.23.1'

FROM alpine:3.11.2

EXPOSE 10086

COPY --from=builder /usr/bin/v2ray/ /usr/bin/v2ray/

RUN set -ex && \
    apk --no-cache add ca-certificates && \
    mkdir -p /var/log/v2ray /etc/v2ray && \
    chmod +x /usr/bin/v2ray/v2ctl && \
    chmod +x /usr/bin/v2ray/v2ray

ADD config.json /etc/v2ray/

ENV PATH /usr/bin/v2ray:$PATH

CMD ["v2ray", "-config=/etc/v2ray/config.json"]
