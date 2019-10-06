#
# Dockerfile for shadowsocks-libev
#

FROM alpine
LABEL maintainer="shoyuf <shoyuf@shoyuf.top>"

# shadowsocks-libev environment
ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 8388
ENV PASSWORD=
ENV METHOD      aes-256-gcm
ENV TIMEOUT     300
ENV DNS_ADDRS    8.8.8.8,8.8.4.4
ENV ARGS=

COPY ./shadowsocks-libev /tmp/shadowsocks
# e 脚本中的命令一旦运行失败就终止脚本的执行 x 用于显示出命令与其执行结果
RUN set -ex \
  # set proxy in china
  && echo -e "https://mirrors.aliyun.com/alpine/v3.10/main/\nhttps://mirrors.aliyun.com/alpine/v3.10/community/" > /etc/apk/repositories \
  # Build environment setup
  && apk update \
  && apk add --no-cache --virtual .build-deps \
  autoconf \
  automake \
  build-base \
  c-ares-dev \
  libev-dev \
  libtool \
  libsodium-dev \
  linux-headers \
  mbedtls-dev \
  pcre-dev \
  # Build & install
  && cd /tmp/shadowsocks \
  && ./autogen.sh \
  && ./configure --prefix=/usr --disable-documentation \
  && make install \
  && apk del .build-deps \
  # Runtime dependencies setup
  && apk add --no-cache \
  ca-certificates \
  rng-tools \
  $(scanelf --needed --nobanner /usr/bin/ss-* \
  | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
  | sort -u) \
  && rm -rf /tmp/shadowsocks

# Install obfs
COPY ./simple-obfs /tmp/obfs
RUN set -ex \
  # Build env
  && apk add --no-cache --virtual .build-deps \
  gcc \
  autoconf \
  make \
  libtool \
  automake \
  zlib-dev \
  openssl \
  asciidoc \
  xmlto \
  libpcre32 \
  libev-dev \
  g++ \
  linux-headers \
  ## Build & install
  && cd /tmp/obfs \
  && ./autogen.sh \
  && ./configure \
  && make \
  && make install \
  && rm -rf /tmp/obfs

USER nobody

CMD exec ss-server \
  -s $SERVER_ADDR \
  -p $SERVER_PORT \
  -k ${PASSWORD:-$(hostname)} \
  -m $METHOD \
  -t $TIMEOUT \
  -d $DNS_ADDRS \
  -u \
  --plugin obfs-server \
  --plugin-opts "obfs=http" \
  $ARGS