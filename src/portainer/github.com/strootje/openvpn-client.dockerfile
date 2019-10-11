FROM dperson/openvpn-client

RUN apk --no-cache --no-progress add stunnel openrc && \
    rm -rf /tmp/*

VOLUME ["/etc/stunnel"]
