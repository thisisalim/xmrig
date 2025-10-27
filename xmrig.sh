#!/usr/bin/env bash

set -e

if [ ! -f /tmp/xmrig-demo ]; then
  echo "[INFO] XMRig not found, downloading XMRig to /tmp/xmrig-demo now"
  curl -L https://github.com/xmrig/xmrig/releases/download/v6.19.2/xmrig-6.19.2-linux-x64.tar.gz -o /tmp/xmrig.tar.gz --silent
  cd /tmp
  tar xvfz /tmp/xmrig.tar.gz
  mv /tmp/xmrig-6.19.2/xmrig /tmp/xmrig-demo
  rm -rf /tmp/xmrig-6.19.2
  rm -rf /tmp/xmrig.tar.gz
  chmod +x /tmp/xmrig-demo
else
  echo "[INFO] XMRig present, skipping download"
fi

if [ ! -f /tmp/config-demo.json ]; then
  echo "[INFO] XMRig configuration not found, writing dummy config to /tmp/config-demo.json"
  config='{
    "algo": "cryptonight",
    "pools": [
        {
            "url": "xmrpool.eu:5555",
            "user": "NOTAREALUSER",
            "pass": "x",
            "enabled": true,
        }
    ],
    "retries": 10,
    "retry-pause": 3,
    "watch": true
  }'
  echo $config > /tmp/config-demo.json
fi

if [ $(ps -ef | grep -v grep | grep xmrig-demo | awk '{print $2}'| wc -l) = "0" ]; then
  echo "[INFO] XMRig not running, starting now"
  /tmp/xmrig-demo -c /tmp/config-demo.json
else
  echo "[INFO] XMRig already running"
fi

echo ""
echo "Script complete. Check your Lacework console for activity in about an hour."
