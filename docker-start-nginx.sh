#!/bin/bash
CONFIGURED_BY_URL_EXIT_CODE=1
if ! [[ -z "$NGINX_CONF_TARGZ_URL" ]]; then
  if ! [[ -e /root/nginx_configured ]]; then
    mkdir -p /root/uploaded/config/hadoop
    echo "Download Nginx™ Plus® configuration files from : $NGINX_CONF_TARGZ_URL  ..."
    curl -s $NGINX_CONF_TARGZ_URL | tar -xz -C /root/nginx
    export CONFIGURED_BY_URL_EXIT_CODE="$?"
    if [[ "0" != "$CONFIGURED_BY_URL_EXIT_CODE" ]]; then
      echo "Nginx™ Plus® problems downaloading and extracting files from URL : $NGINX_CONF_TARGZ_URL !!"
      exit 1
    fi
    touch /root/nginx_configured
  else
    echo "Nginx™ Plus® $NGINX_CONF_TARGZ_URL already configured!!"
  fi
fi
if ! [[ -e /root/nginx_configured ]]; then
  echo "Nginx™ Plus® configuration check from volumes ..."
  if [[ -e /root/nginx/conf ]]; then
    if ! [[ -z "$( ls /root/nginx/conf/)" ]]; then
      echo "Nginx™ Plus® apply configuration form /root/nginx/conf ..."
      cp -f /root/nginx/conf/* /etc/nginx/
    fi
  fi
  if [[ -e /root/nginx/conf.d ]]; then
    if ! [[ -z "$( ls /root/nginx/conf.d/)" ]]; then
      echo "Nginx™ Plus® applies configuration form /root/nginx/conf.d ..."
      cp -f /root/nginx/conf.d/* /etc/nginx/conf.d/
    fi
  fi
  if [[ -e /root/nginx/certs ]]; then
    if ! [[ -z "$( ls /root/nginx/certs/)" ]]; then
      echo "Nginx™ Plus® applies certificates form /root/nginx/certs ..."
    cp -f /root/nginx/certs/* /etc/ssl/
    fi
  fi
  if [[ -e /root/nginx/repo-certs ]]; then
    if ! [[ -z "$( ls /root/nginx/repo-certs/)" ]]; then
      echo "Nginx™ Plus® applies repository certificates form /root/nginx/repo-certs ..."
      cp -f /root/nginx/repo-certs/* /etc/ssl/nginx/
      echo "Nginx™ Plus® updates repository configuration for updates or new installation ..."
      wget -q -O - http://nginx.org/keys/nginx_signing.key | apt-key add -
      wget -q -O /etc/apt/apt.conf.d/90nginx https://cs.nginx.com/static/files/90nginx
      printf "deb https://plus-pkgs.nginx.com/ubuntu `lsb_release -cs` nginx-plus\n" >/etc/apt/sources.list.d/nginx-plus.list
      apt-get update
    fi
  fi
fi
if [[ -z "$( ls /usr/share/nginx/html/)" ]]; then
  tar -xzf /root/nginx-default-html.tgz -C /usr/share/nginx/html/
fi

nginx

tail -f /dev/null
