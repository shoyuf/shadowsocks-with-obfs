## Steps

- build docker image

1. `git submodule update --init --recursive && docker build --network host -t shoyuf/shadowsocks-with-obfs:latest .`

- touch configuration file to `/config/ss-config.json`

  SAMPLE:

```JSON
{
  "server": "0.0.0.0",
  "server_port": 1080,
  "password": "CCCCCCCC",
  "method": "chacha20-ietf-poly1305",
  "timeout": 60,
  "plugin": "obfs-server",
  "fast_open": true,
  "plugin_opts": "obfs=http"
}
```

- run image

1. cd shadowsocks-with-obfs folder
1. ``docker run -d --network host -v `pwd`/config:/etc/shadowsocks-libev shoyuf/shadowsocks-with-obfs``
