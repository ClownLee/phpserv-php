FROM php:7.4.7-fpm-alpine
COPY exts /exts
RUN  sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
  && apk update \
  && apk add --update --no-cache build-base autoconf \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libmcrypt-dev \
    libzip-dev \
    libxml2 libxml2-dev \
    libxslt libxslt-dev zlib-dev zlib \
    #git \
    #nodejs \
  # 编译安装 redis
  && mkdir -p /usr/src/php/ext/redis \
  && tar zxvf /exts/redis-5.3.1.tgz -C /exts \
  && mv /exts/redis-5.3.1/* /usr/src/php/ext/redis \
  && chmod -R 0777 /usr/src/php/ext/redis \
  && echo 'redis' >> /usr/src/php-available-exts \
  && docker-php-ext-install -j$(nproc) redis \
  # 编译安装 mcrypt
  && mkdir -p /usr/src/php/ext/mcrypt \
  && tar zxvf /exts/mcrypt-1.0.3.tgz -C /exts \
  && mv /exts/mcrypt-1.0.3/* /usr/src/php/ext/mcrypt \
  && chmod -R 0777 /usr/src/php/ext/mcrypt \
  && echo 'mcrypt' >> /usr/src/php-available-exts \
  && docker-php-ext-install -j$(nproc) mcrypt \
  # 编译安装 mongodb
  && mkdir -p /usr/src/php/ext/mongodb \
  && tar zxvf /exts/mongodb-1.7.5.tgz -C /exts \
  && mv /exts/mongodb-1.7.5/* /usr/src/php/ext/mongodb \
  && chmod -R 0777 /usr/src/php/ext/mongodb \
  && echo 'mongodb' >> /usr/src/php-available-exts \
  && docker-php-ext-install -j$(nproc) mongodb \
  # 编译安装 swoole
  && mkdir -p /usr/src/php/ext/swoole \
  && tar zxvf /exts/swoole-4.5.2.tgz -C /exts \
  && mv /exts/swoole-4.5.2/* /usr/src/php/ext/swoole \
  && chmod -R 0777 /usr/src/php/ext/swoole \
  && echo 'swoole' >> /usr/src/php-available-exts \
  && docker-php-ext-install -j$(nproc) swoole \
  && rm -rf /exts \
  # pecl 安装 mcrypt mongodb swoole redis 【很慢】
  #&& pecl install mcrypt mongodb swoole redis \
  #&& docker-php-ext-enable mcrypt mongodb swoole redis \
  # 安装 gd 扩展
  && docker-php-ext-configure gd \
  && docker-php-ext-install -j$(nproc) gd \
  # 安装 sockets 扩展
  && docker-php-ext-configure sockets \
  && docker-php-ext-install -j$(nproc) sockets \
  # 安装 bcmath 扩展
  && docker-php-ext-configure bcmath \
  && docker-php-ext-install -j$(nproc) bcmath \
  # 安装 soap 扩展
  && docker-php-ext-configure soap \
  && docker-php-ext-install -j$(nproc) soap \
  # 安装 pdo_mysql 扩展
  && docker-php-ext-configure pdo_mysql \
  && docker-php-ext-install -j$(nproc) pdo_mysql \
  # 安装 xsl 扩展
  && docker-php-ext-configure xsl \
  && docker-php-ext-install -j$(nproc) xsl \
  # 安装 zip 扩展
  && docker-php-ext-configure zip \
  && docker-php-ext-install -j$(nproc) zip \
  && cp -r /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
  && sed -i 's/;date.timezone =/date.timezone=Asia\/Shanghai/g' /usr/local/etc/php/php.ini
EXPOSE 9000
CMD ["php-fpm"]
