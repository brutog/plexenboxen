#!/bin/bash

EXISTING_KEY=$(grep ARR_API_KEY= .env | cut -d= -f2) 

# only create a new key if the field is blank
if [[ -z "${EXISTING_KEY}" ]]; then
    
    ARR_API_KEY=$(tr -dc a-z0-9 </dev/urandom | head -c 32; echo)
    echo "Writing ARR_API_KEY to .arr_api_key"
    echo $ARR_API_KEY > .arr_api_key
    sed -i "s/^ARR_API_KEY=/ARR_API_KEY=${ARR_API_KEY}/" .env
fi


EXISTING_AUTH=$(grep BASIC_AUTH= .env | cut -d= -f2)

# only create a new htpasswd auth string if the field is blank
if [[ -z "${EXISTING_AUTH}" ]]; then
    
    BASIC_AUTH=$(tr -dc a-zA-Z0-9 </dev/urandom | head -c 20; echo)
    # drop the clear text to a hidden file for pick up
    echo "Writing BASIC_AUTH to .basic_auth"
    echo $BASIC_AUTH > .basic_auth
    # also drop it to .env
    sed -i "s/^BASIC_AUTH_CLEAR=/BASIC_AUTH_CLEAR=${BASIC_AUTH}/" .env
    # hash it
    BASIC_AUTH=$(htpasswd -bn $USER $BASIC_AUTH)
    # escape $ with $ for yaml
    BASIC_AUTH=$(sed 's/\$/$$/g' <<< $BASIC_AUTH)
    sed -i "s/^BASIC_AUTH=/BASIC_AUTH=${BASIC_AUTH}/" .env

fi


# if basic auth exists here just pave sabnzbd.ini
if [ -f .basic_auth ]; then

    SAB_PASS=$(cat .basic_auth)
    DOMAIN=$(grep "DOMAIN=" .env | cut -d= -f2)
    cp sabnzbd/sabnzbd.ini.example sabnzbd/sabnzbd.ini
    sed -i "s/^username =.*/username = ${USER}/g" sabnzbd/sabnzbd.ini
    sed -i "s/^password =.*/password = ${SAB_PASS}/g" sabnzbd/sabnzbd.ini
    sed -i "s/^whitelist =.*/whitelist = sabzbd.${DOMAIN}/g" sabnzbd/sabnzbd.ini
    sed -i "s/^api_key =.*/api_key = ${ARR_API_KEY}/g" sabnzbd/sabnzbd.ini
    sed -i "s/^nzb_key =.*/nzb_key = ${ARR_API_KEY}/g" sabnzbd/sabnzbd.ini
fi
