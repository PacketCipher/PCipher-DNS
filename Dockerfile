### Build Stage
FROM golang:1.18-alpine AS build-env

WORKDIR /
RUN apk --no-cache add git && \
    git clone https://github.com/cybozu-go/transocks.git src && \
    cd /src && go get github.com/cybozu-go/transocks/cmd/transocks && \
    go build -o transocks ./cmd/transocks

### Final Stage
FROM ubuntu:20.04

# Packages
COPY --from=build-env /src/transocks /usr/bin/
RUN apt-get update && apt-get install --yes curl iputils-ping net-tools iproute2 iptables git sniproxy dnsmasq
ADD . /etc/unblock-proxy
RUN ln -s /etc/unblock-proxy/unblock-proxy.sh /usr/bin/unblock-proxy 

# Configurations
EXPOSE 53/udp
EXPOSE 80
EXPOSE 443

## User ENV
ENV UPSTREAM_DNS_SERVER 8.8.8.8
ENV PROXY_DETAILS "http 127.0.0.1 8080 user pass"

COPY ./DockerEntrypoint.sh /
RUN chmod +x /DockerEntrypoint.sh

ENTRYPOINT ["/DockerEntrypoint.sh"]

CMD ["--debug"]