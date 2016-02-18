FROM ubuntu:15.10
MAINTAINER Jake Pelletier <ghjnut@gmail.com>

ENV DATA_DIR=/data
ENV BIND_USER=bind
ENV WEBMIN_VERSION=1.770

RUN rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes \
	&& apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
		bind9 \
		perl \
		libnet-ssleay-perl \
		openssl \
		libauthen-pam-perl \
		libpam-runtime \
		libio-pty-perl \
		dnsutils \
		apt-show-versions \
		python \
		wget \
	&& wget "http://prdownloads.sourceforge.net/webadmin/webmin_${WEBMIN_VERSION}_all.deb" -P /tmp/ \
	&& dpkg -i /tmp/webmin_${WEBMIN_VERSION}_all.deb \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 10000/tcp

VOLUME ["${DATA_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/sbin/named"]
