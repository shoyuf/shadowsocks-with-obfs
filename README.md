## Steps

- build docker image

1. `git submodule update --init --recursive && docker build --network host -t shoyuf/shadowsocks-with-obfs:latest .`

- run image

1. `docker run -d --network host shoyuf/shadowsocks-with-obfs`