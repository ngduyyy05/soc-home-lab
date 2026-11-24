#!/usr/bin/env bash
set -euo pipefail

if [[ ! "$KIBANA_SYSTEM_PASSWORD" =~ ^[A-Za-z0-9]{20,}$ ]]; then
    printf '%s\n' 'Use at least 20 random alphanumeric characters for KIBANA_SYSTEM_PASSWORD.' >&2
    exit 1
fi

printf '{"password":"%s"}' "$KIBANA_SYSTEM_PASSWORD" | \
    curl --silent --show-error --fail --output /dev/null --cacert /ca/ca.crt \
        --user "elastic:$ELASTIC_PASSWORD" -H 'Content-Type: application/json' \
        --data-binary @- 'https://elasticsearch:9200/_security/user/kibana_system/_password'
