FROM dperson/openvpn-client

RUN echo "http://dl-3.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories &&\
   apk --no-cache --no-progress add stunnel openrc && \
   mkdir -p /run/openrc && touch /run/openrc/softlevel && \
   rm -rf /tmp/*

COPY ./stunnel.sh /usr/bin/

VOLUME ["/etc/stunnel"]

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/stunnel.sh"]
