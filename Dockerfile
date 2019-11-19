FROM ubuntu:18.04
MAINTAINER Lukas Joraschek <lukas.joraschek@gmail.com>

WORKDIR /app

RUN	apt-get update; \
	apt-get install -y libpcre3; \
	apt-get install -y libpcre3-dev; \
	apt-get install -y libpng-dev; \
	apt-get install -y git; \
	apt-get install -y wget; \
	apt-get install -y gcc; \
	apt-get install -y build-essential; \
	apt-get autoclean && apt-get autoremove;

RUN	cd /app/ && wget http://nginx.org/download/nginx-1.17.5.tar.gz; \
	cd /app/ && tar -zxvf nginx-1.17.5.tar.gz; \ 
	cd /app/ && git clone https://github.com/chobits/ngx_http_proxy_connect_module.git; \ 
	cd /app/nginx-1.17.5/ && patch -p1 < ./../ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_101504.patch; \
	cd /app/nginx-1.17.5/ && ./configure --add-module=/app/ngx_http_proxy_connect_module; \
	make && make install;

ADD proxy.conf /usr/local/nginx/conf/nginx.conf

EXPOSE 8080

CMD /usr/local/nginx/sbin/nginx
