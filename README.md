# Nginx Plus

Docker Image for Nginx plus


### Introduction ###

Nginx™ Plus® is the all‑in‑one application delivery platform for the modern web.

Here some more info on Nginx™ Plus® :
https://www.nginx.com/products/


### Goals ###

This docker images has been designed to be a test, development, integration, production environment for Nginx™ Plus® features.
*No warranties for production use.*

NOTE: Will be released soon a production docker image.


### Docker Image features ###

Here some information :

Volumes : /root/nginx/certs, /root/nginx/repo-certs, /root/nginx/conf.d, /root/nginx/certs, /usr/share/nginx/html

`/root/nginx/certs` :

Volume used to install Nginx™ Plus® system certificates and keys.

`/root/nginx/repo-certs` :

Volume used to install Nginx™ Plus® repository certificates and keys.

`/root/nginx/conf` :

Volume used to install Nginx™ Plus® configuration files.


`/root/nginx/conf.d` :

Volume used to install Nginx™ Plus® module configuration files (/etc/nginx/conf.d/...).


`/usr/share/nginx/html` :

Default Nginx™ Plus® html folder, if no file will be added default file will be uploded (see [sample](/samples) folder for defualt folder html files).

Ports: 80, 443


### Docker Environment Variable ###

Here Nginx™ Plus® container environment variable :

* `NGINX_CONF_TARGZ_URL` : URL provided to download a tar gz file containing a few folders : `conf`, `conf.d`, `repo-certs`, `html` and `certs` to be decompressed in folder `/root/nginx`. (default: "") see *Docker-Image-features* paragraph for more details



### Sample command ###

Here a sample command to run Nginx™ Plus® container:

```bash
docker run -d -p 8080:80 -p 8043:443 -v /path/to/nginx/conf:/root/nginx/conf -v /path/to/nginx/certs:/root/nginx/certs --name my-nginx-plus hellgate75/nginx-plus:latest
```

### Test Container ###

On your browser open URL: http://{ container ip or localhost}:{8080 or any port you have bootstrapped}/.


### License ###

[LGPL 3](/LICENSE)
