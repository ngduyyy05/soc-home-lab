#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f /certs/elasticsearch/elasticsearch.crt || ! -f /certs/elasticsearch/elasticsearch.key || ! -f /certs/ca.crt ]]; then
    work="$(mktemp -d)"
    bin/elasticsearch-certutil ca --silent --pem --out "$work/ca.zip"
    unzip -q "$work/ca.zip" -d "$work"
    bin/elasticsearch-certutil cert --silent --pem --name elasticsearch \
        --dns "elasticsearch,localhost,${ES_LAB_DNS}" --ip 127.0.0.1 \
        --ca-cert "$work/ca/ca.crt" --ca-key "$work/ca/ca.key" --out "$work/node.zip"
    unzip -q -o "$work/node.zip" -d /certs
    cp "$work/ca/ca.crt" /certs/ca.crt
fi

chgrp -R 0 /certs
chmod 750 /certs /certs/elasticsearch
chmod 640 /certs/elasticsearch/elasticsearch.key
chmod 644 /certs/elasticsearch/elasticsearch.crt /certs/ca.crt
cp /certs/ca.crt /ca-public/ca.crt
chmod 644 /ca-public/ca.crt
