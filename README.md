## Steps

- build docker image

1. `git submodule update --init --recursive && docker build --network host -t shoyuf/shadowsocks-with-obfs:latest .`

- touch configuration file to `/config/ss-config.json`

  SAMPLES:

  for server:
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

  for client:
```JSON
{
  "server": "example.com",
  "server_port": 80,
  "local_address": "0.0.0.0",
  "local_port": 1080,
  "password": "CCCCCCCC",
  "method": "chacha20-ietf-poly1305",
  "timeout": 60,
  "plugin": "obfs-local",
  "fast_open": true,
  "plugin_opts": "obfs=http;obfs-host=example.com"
}
```

- run image

1. cd shadowsocks-with-obfs folder

for server:

2. ``docker run -d --restart always -p 80:80 -v `pwd`/config:/etc/shadowsocks-libev shoyuf/shadowsocks-with-obfs``

for client:

2. ``docker run -d --restart always -p 1080:1080 -v `pwd`/config:/etc/shadowsocks-libev -u root shoyuf/shadowsocks-with-obfs ss-local -c /etc/shadowsocks-libev/ss-config.json``