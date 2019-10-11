FROM dperson/openvpn-client

RUN apk --no-cache --no-progress add stunnel openrc && \
   rm -rf /tmp/* && \
   mkdir -p /run/openrc && touch /run/openrc/softlevel

COPY ./stunnel.sh /usr/bin/

VOLUME ["/etc/stunnel"]

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/stunnel.sh"]
