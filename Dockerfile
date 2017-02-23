FROM rusk85/alpine-base

ARG BUILD_TIME

LABEL author="Sven Muncic <sven@muncic.de>"
LABEL description="nginx proxy based on alpine linux mini-root-filesystem"
LABEL build-time="${BUILD_TIME}"

# build-time variables
ARG NGINX_RUN=/run/nginx/
ARG NGINX_INSTALL=/etc/nginx/
ARG NGINX_CONF=/etc/nginx/nginx.conf
ARG NUSER=nginx
ARG NGROUP=nginx

RUN	apk update && \
	apk add nginx && \
	mkdir -p ${NGINX_RUN} && \
	chown -R ${NUSER}:${NGROUP} ${NGINX_RUN} && \
	rm -f ${NGINX_CONF}

COPY nginx.conf ${NGINX_CONF}

EXPOSE 8080

USER root
WORKDIR ${NGINX_INSTALL}
CMD ["nginx"]
