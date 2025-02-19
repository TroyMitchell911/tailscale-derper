# Description

This is a repo like [fredliang44/derper-docker](https://github.com/fredliang44/derper-docker/).

What is different is that I modified the source code of derp to support pure IP implementation.

Where source code I modified: [link](https://github.com/TroyMitchell911/tailscale)

> I'm not sure if the DERP_VERIFY_CLIENTS works. So if it doesn't work and you want to use it please change Dockerfile from

```bash
-verify-clients=$DERP_VERIFY_CLIENTS
```
> to
```bash
-verify-clients
```

# Setup

Here is a example.
```bash
docker run -e DERP_DOMAIN=derper.your-domain.com -p 80:80 -p 443:443 -p 3478:3478/udp fredliang/derper
```

If u don't wanna use 443 port, example here and HTTP is same:
```bash
docker run -e DERP_DOMAIN=derper.your-domain.com -e DERP_ADDR=:1234 -p 80:80 -p 1234:1234 -p 3478:3478/udp fredliang/derper
```

| env                    | required | description                                                                 | default value     |
| -------------------    | -------- | ----------------------------------------------------------------------      | ----------------- |
| DERP_DOMAIN            | true     | derper server hostname                                                      | your-hostname.com |
| DERP_CERT_DIR          | false    | directory to store LetsEncrypt certs(if addr's port is :443)                | /app/certs        |
| DERP_CERT_MODE         | false    | mode for getting a cert. possible options: manual, letsencrypt              | letsencrypt       |
| DERP_ADDR              | false    | listening server address                                                    | :443              |
| DERP_STUN              | false    | also run a STUN server                                                      | true              |
| DERP_STUN_PORT         | false    | The UDP port on which to serve STUN.                                        | 3478              |
| DERP_HTTP_PORT         | false    | The port on which to serve HTTP. Set to -1 to disable                       | 80                |
| DERP_VERIFY_CLIENTS    | false    | verify clients to this DERP server through a local tailscaled instance      | false             |
| DERP_VERIFY_CLIENT_URL | false    | if non-empty, an admission controller URL for permitting client connections | ""                |

# Usage

Fully DERP setup offical documentation: https://tailscale.com/kb/1118/custom-derp-servers/

## Client verification

In order to use `DERP_VERIFY_CLIENTS`, the container needs access to Tailscale's Local API, which can usually be accessed through `/var/run/tailscale/tailscaled.sock`. If you're running Tailscale bare-metal on Linux, adding this to the `docker run` command should be enough: `-v /var/run/tailscale/tailscaled.sock:/var/run/tailscale/tailscaled.sock`
