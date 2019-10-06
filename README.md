## Steps

- build docker image

1. `cd shadowsocks-libev && git submodule update --init --recursive`
1. `cd simple-obfs && git submodule update --init --recursive`
1. `cd ../ && docker build --network host -t shoyuf/shadowsocks-with-obfs:latest .`

- run image

1. `docker run -d --network host shoyuf/shadowsocks-with-obfs` with args