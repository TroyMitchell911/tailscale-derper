FROM golang:latest AS builder

WORKDIR /app

ENV MODIFIED_DERPER_GIT=https://ghfast.top/https://github.com/TroyMitchell911/tailscale.git
ENV http_proxy=http://127.0.0.1:7890
ENV https_proxy=http://127.0.0.1:7890

RUN git clone $MODIFIED_DERPER_GIT tailscale --depth 1 && \
cd /app/tailscale/cmd/derper && \
/usr/local/go/bin/go build -ldflags "-s -w" -o /app/derper && \
cd /app && \
rm -rf /app/tailscale

FROM ubuntu:22.04
WORKDIR /app

COPY --from=builder /app/derper /app/derper

ENV DERP_DOMAIN your-hostname.com
ENV DERP_CERT_MODE letsencrypt
ENV DERP_CERT_DIR /app/certs
ENV DERP_ADDR :443
ENV DERP_HTTP_PORT 80
ENV DERP_VERIFY_CLIENTS false
ENV DERP_VERIFY_CLIENT_URL ""
ENV DERP_STUN true
ENV DERP_STUN_PORT 3478

CMD /app/derper \
-c=/app/derper.conf \
-hostname=$DERP_DOMAIN \
-a=$DERP_ADDR \
-http-port=$DERP_HTTP_PORT \
-certmode=$DERP_CERT_MODE \
-certdir=$DERP_CERT_DIR \
-stun-port=$DERP_STUN_PORT \
-stun=$DERP_STUN \
-verify-client-url=$DERP_VERIFY_CLIENTS \
-verify-clients=$DERP_VERIFY_CLIENTS
