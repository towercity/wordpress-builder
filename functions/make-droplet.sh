#!/bin/bash

# token for digital ocean API
do_token=`cat data/global/do-token`

# cariable for the image we use, so it can be easily changed
droplet_image="ubuntu-18-04-x64"

# check for a name argument; if none exists, prompt for one
if [ -z "$1" ]
then
    echo -e 'Please enter a project name: \c'
    read project_name
else 
    project_name="$1"
fi

#save project name to file
mkdir data
mkdir data/local
echo $project_name > data/local/project-name

# replace all spaces with dashes and make lowercase for digital ocean name compliance
project_name_dash=`echo "${project_name// /-}" | tr '[:upper:]' '[:lower:]'`

# gather local ssh key
# first tries to save local ssh fingerprint to variable
LOCAL_SSH_FINGERPRINT=`ssh-keygen -l -E md5 -f ~/.ssh/id_rsa`

if [ $? -ne 0 ] # if the last command didn't return without error
then
    # make a local ssh key
    echo 'No local ssh key found. creating...'
    ssh-keygen -t rsa

    # now rerun the command to save the ssh fingerprint to variable
    LOCAL_SSH_FINGERPRINT=`ssh-keygen -l -f ~/.ssh/id_rsa`
fi

# now set the fingerprint variable to be JUST the fingerprint
LOCAL_SSH_FINGERPRINT=${LOCAL_SSH_FINGERPRINT:9:47}

echo "creating new droplet $project_name_dash"

# call the digital ocean API to create it, then save the resulting IP to a variable
ID=`curl -s -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $do_token" -d '{"name":"'"$project_name_dash"'","region":"nyc1","size":"s-1vcpu-1gb","image":"'"$droplet_image"'","ssh_keys":["'"$LOCAL_SSH_FINGERPRINT"'"],"backups":true}' "https://api.digitalocean.com/v2/droplets" | jq '.droplet.id'`

# save ID to file
mkdir data
mkdir data/local
echo $ID > data/local/project-id

echo -e "site created\ndroplet id: $ID"

echo "please wait for droplet to finish being made on digital ocean"