FROM bitnami/minideb:jessie
MAINTAINER Mario Cho "hephaex@gmail.com"

RUN echo "deb http://ftp.debian.org/debian jessie-backports main" > \
  /etc/apt/sources.list.d/backports.list && \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update -y && \
    apt-get install -y bind9 \
    bind9-host \
    dnsutils && \
  rm -rf /var/lib/apt/lists/*

ADD ./dns.sh /sbin/dns.sh
RUN chmod 755 /sbin/dns.sh

EXPOSE 53/udp 53/tcp 10000/tcp
ENTRYPOINT ["/sbin/dns.sh"]
CMD ["/usr/sbin/named"]
