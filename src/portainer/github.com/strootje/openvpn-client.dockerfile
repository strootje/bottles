FROM dperson/openvpn-client

RUN apk --no-cache --no-progress add stunnel openrc && \
   rm -rf /tmp/* && \
   mkdir -p /run/openrc && touch /run/openrc/softlevel

COPY ./stunnel.conf /etc/default/stunnel3

VOLUME ["/etc/stunnel"]
