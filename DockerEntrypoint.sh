#!/bin/bash
args="$@"

echo "Configuring..." && \
    sed -i "s/{UPSTREAM_DNS_SERVER}/${UPSTREAM_DNS_SERVER}/" /etc/unblock-proxy/configs/sniproxy.conf && \
    sed -i "s/{UPSTREAM_DNS_SERVER}/${UPSTREAM_DNS_SERVER}/" /etc/unblock-proxy/configs/dnsmasq.conf && \
    echo "${PROXY_DETAILS}" >> /etc/unblock-proxy/proxies.lst && \
    echo "Running" && \
    unblock-proxy $args