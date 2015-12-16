
#consul base image
FROM alpine:3.2

ENV CONSUL_VERSION 0.6.0
ENV CONSUL_SHA256 307fa26ae32cb8732aed2b3320ed8daf02c28b50d952cbaae8faf67c79f78847

# add certificates to that consul doesn't return an error when checking for an update
RUN apk --update add curl ca-certificates
#     curl -Ls https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk > /tmp/glibc-2.21-r2.apk && \
#     apk add --allow-untrusted /tmp/glibc-2.21-r2.apk && \
#     rm -rf /tmp/glibc-2.21-r2.apk /var/cache/apk/*

RUN curl -o /tmp/consul.zip https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
RUN echo "${CONSUL_SHA256}  /tmp/consul.zip" > /tmp/consul.sha256 \
  && sha256sum -c /tmp/consul.sha256 \
  && cd /bin \
  && unzip /tmp/consul.zip \
  && chmod +x /bin/consul \
  && rm /tmp/consul.zip


# consul agent image
EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 8600 8600/udp
ENV DNS_RESOLVES consul
ENV DNS_PORT 8600

# consul server image
RUN curl -o /tmp/webui.zip https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_web_ui.zip
RUN cd /tmp && mkdir /ui && unzip webui.zip -d /ui && rm webui.zip
ADD entrypoint.sh entrypoint.sh
ENTRYPOINT ["/entrypoint.sh","/bin/consul", "agent", "-server", "-config-dir=/config"]
