FROM ubuntu:16.10

MAINTAINER Fabrizio Torelli <hellgate75@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive \
    PATH=$PATH:/usr/local/bin \
    NGINX_CONF_TARGZ_URL=""

USER root

# Set the debconf frontend to Noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update && apt-get install -y -q wget apt-transport-https lsb-release ca-certificates net-tools tar sudo gcc make libpcre3-dev zlib1g-dev apt-utils && \
    mkdir -p /etc/ssl/nginx

# Download certificate and key from the customer portal (https://cs.nginx.com)
# and copy to the build context
ADD nginx-repo.crt /etc/ssl/nginx/
ADD nginx-repo.key /etc/ssl/nginx/

# Get other files required for installation
RUN wget -q -O - http://nginx.org/keys/nginx_signing.key | apt-key add -
RUN wget -q -O /etc/apt/apt.conf.d/90nginx https://cs.nginx.com/static/files/90nginx
RUN printf "deb https://plus-pkgs.nginx.com/ubuntu `lsb_release -cs` nginx-plus\n" >/etc/apt/sources.list.d/nginx-plus.list
    # Install NGINX Plus
RUN apt-get update && apt-get install -y nginx-plus  nginx-plus-module-geoip nginx-plus-module-image-filter \
    nginx-plus-module-perl nginx-plus-module-xslt nginx-plus-module-njs nginx-plus-module-headers-more \
    nginx-plus-module-lua nginx-plus-module-passenger nginx-plus-module-rtmp nginx-plus-module-set-misc && \
    apt-get clean && \
    apt-get -y autoclean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /root/nginx/certs && \
    mkdir -p /root/nginx/conf && \
    mkdir -p /root/nginx/conf.d && \
    rm -f /etc/apt/sources.list.d/nginx-plus.list && \
    rm -f /etc/ssl/nginx/*


# forward request logs to Docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    cd /usr/share/nginx/html &&  tar -czf /root/nginx-default-html.tgz *

COPY docker-start-nginx.sh /usr/local/bin/docker-start-nginx

VOLUME ["/root/nginx/certs", "/root/nginx/conf", "/root/nginx/conf.d", "/usr/share/nginx/html"]

RUN chmod 777 /usr/local/bin/docker-start-nginx

CMD docker-start-nginx

EXPOSE 80 443
