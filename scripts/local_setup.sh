#! /bin/sh

ABS_LOCAL_SSL_PATH="$HOME/nginx_local/letsencrypt/live/domain.com/"

echo "Start creating the dir structure for local run"

cp -r directories/local/ "$HOME/nginx_local"

echo "Finish creating the nginx_local setup"

echo "start creating the self signed ssl path for local testing"

mkdir -p "$ABS_LOCAL_SSL_PATH"

echo "finish creating the self signed ssl path for local testing"

cd "$ABS_LOCAL_SSL_PATH"

echo "start creating the self signed ssl"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout privkey.pem \
  -out fullchain.pem \
  -subj "/CN=localhost"


echo "finish creating the self signed ssl"



