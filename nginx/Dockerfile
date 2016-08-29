FROM vipconsult/base:jessie
MAINTAINER Krasimir Georgiev <support@vip-consult.co.uk>

# Version
ENV NGINX_VERSION 1.11.3
ENV NPS_VERSION 1.11.33.3
ENV OPENSSL_VERSION 1.0.2h
# Install Build Tools & Dependence

RUN apt-get install autotools-dev zlib1g-dev libpcre3 libpcre3-dev && \
    apt-get build-dep nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ===========
# Build Nginx
# ===========

# Setting Up ENV
ENV MODULE_DIR /usr/src/nginx-modules

# Create Module Directory
RUN mkdir ${MODULE_DIR}

# Download Source
RUN cd /usr/src && \
    wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar xzf nginx-${NGINX_VERSION}.tar.gz && \
    rm -rf nginx-${NGINX_VERSION}.tar.gz && \

    cd /usr/src && \
    wget ftp://ftp.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz && \
    tar xzf openssl-${OPENSSL_VERSION}.tar.gz && \
    rm -rf openssl-${OPENSSL_VERSION}.tar.gz && \

    # Install Addational Module
    cd ${MODULE_DIR} && \
    wget --no-check-certificate https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.tar.gz && \
    tar zxf release-${NPS_VERSION}-beta.tar.gz && \
    rm -rf release-${NPS_VERSION}-beta.tar.gz && \
    cd ngx_pagespeed-release-${NPS_VERSION}-beta/ && \
    wget --no-check-certificate https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz && \
    tar zxf ${NPS_VERSION}.tar.gz && \
    rm -rf ${NPS_VERSION}.tar.gz && \

    # Compile Nginx
    cd /usr/src/nginx-${NGINX_VERSION} && \
    ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --user=nobody --group=nogroup \
    --with-http_dav_module \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_realip_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_secure_link_module \
    --with-http_auth_request_module \
    --with-file-aio \
    --with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2' --with-ld-opt='-Wl,-z,relro -Wl,--as-needed' \
    --with-ipv6 \
    --with-sha1=/usr/include/openssl \
    --with-md5=/usr/include/openssl \
    --with-openssl="../openssl-${OPENSSL_VERSION}" \
    --add-module=${MODULE_DIR}/ngx_pagespeed-release-${NPS_VERSION}-beta && \

    # Install Nginx
    cd /usr/src/nginx-${NGINX_VERSION} && \
    make && make install && \

    # Clear source code to reduce container size
    rm -rf /usr/src/*


# Forward requests and errors to docker logs
RUN mkdir -p /var/log/nginx && ln -sf /dev/stdout /var/log/nginx/access.log && \
    mkdir -p /var/log/nginx && ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx", "/var/cache/ngx_pagespeed"]

EXPOSE 80 443
ADD entrypoint.sh /
RUN chmod 777 /entrypoint.sh \
    && sed -i -e 's/\r$//' /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx","-c","/home/http/default/main.conf","-g", "daemon off;"]