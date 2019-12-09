#!/bin/bash

# token for digital ocean API
do_token=`cat data/global/do-token`

# ID of current project
ID=`cat data/local/project-id`

echo "checking if image is up..."

IP=`curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $do_token" "https://api.digitalocean.com/v2/droplets/$ID" | jq '.droplet.networks.v4[0].ip_address'`

if [ -z "$IP" ]
then
    echo "site is not yet live"
else 
    # trim quotes from IP
    IP=`echo "$IP" | sed -e 's/^"//' -e 's/"$//'`

    echo "site live at $IP"
    echo $IP > data/local/IP
fi