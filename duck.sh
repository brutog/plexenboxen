#!/bin/bash

SCRIPT_DIR=$(dirname "$0")
DUCKDNS_TOKEN=$(grep DUCKDNS_TOKEN $SCRIPT_DIR/.env | cut -d= -f2)
SUB_DOMAIN=$(grep DOMAIN= $SCRIPT_DIR/.env | cut -d= -f2 | cut -d'.' -f1)
echo url="https://www.duckdns.org/update?domains=$SUB_DOMAIN&token=$DUCKDNS_TOKEN&ip=" | curl -sss -k -o ~/repo/duck.log -K -
