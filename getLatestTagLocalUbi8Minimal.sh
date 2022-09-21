#!/bin/bash

rm -rf ./latest.txt
curl -sL 'https://registry.access.redhat.com/v2/ubi8-minimal/tags/list' > data2.json
DATA=$(cat data2.json)
LATEST=$(echo $DATA | jq -r '.tags' | sed 's/\"//g' | sed 's/\[//g' | sed 's/\]//g' | sed 's/,//g' | sed '/^[[:space:]]*$/d' | sed 's/^ *//' | tail -r | tail -n +2 | sed -n '1p' )
LATEST=${LATEST:0:7}
echo $LATEST > local.txt
rm -rf ./data2.json
