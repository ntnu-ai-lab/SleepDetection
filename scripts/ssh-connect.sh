#!/bin/bash

# Starts a jupyter notebook server through docker on a remote machine

# Parse arguments
while true; do
    case "$1" in
        # User to connect as
        -u | --user) HUNT4_SLEEP_USER=$2; shift; shift; continue ;;
        # Directory to mount for persistent files
        -d | --dir-user) HUNT4_SLEEP_DIR_USER=$2; shift; shift; continue ;;
        # Local machine port to run notebook on
        -p | --port) HUNT4_SLEEP_PORT_LOCAL=$2; shift; shift; continue ;;
        # Remote machine port to run notebook on
        -r | --remote-port) HUNT4_SLEEP_PORT_REMOTE=$2; shift; shift; continue ;;
        # Name of docker image to run
        -i | --image) HUNT4_SLEEP_IMAGE=$2; shift; shift; continue ;;
    esac
    break
done

# Set defaults
host=${HUNT4_SLEEP_HOST:-'samuel01.idi.ntnu.no'}
data_labelled=${HUNT4_SLEEP_DATA_LABELLED:-'/data/hunt4/sleep-labelled-dataset'}
data_semi_supervised=${HUNT4_SLEEP_DATA_SEMI_SUPERVISED:-'/data/hunt4/sleep-semi-supervised-dataset'}
dir_user=${HUNT4_SLEEP_DIR_USER:-'hunt4_sleep_user'}
port_local=${HUNT4_SLEEP_PORT_LOCAL:-'8888'}
port_remote=${HUNT4_SLEEP_PORT_REMOTE:-$((20001 + RANDOM % 8999))}
image=${HUNT4_SLEEP_IMAGE:-'hunt4/sleep'}


# If no username provided; query user
if [ -z $HUNT4_SLEEP_USER ]
then
    read -p "Username on $host: " user
else
    user=$HUNT4_SLEEP_USER
fi

# Build abs path to user dir
script="import os; print(os.path.join('/lhome/$user', '$dir_user'))"
abs_dir_user=$(python -c "$script")

# Build docker command
docker_command="docker run --rm -it
    -p $port_remote:8888
    -v $abs_dir_user:/hunt4_sleep/user
    -v $data_labelled:/hunt4_sleep/data/labelled:ro
    -v $data_semi_supervised:/hunt4_sleep/data/semi_supervised:ro
    --env USER_ID=\$(id -u)
    $image $@"

# Wrap in ssh command
ssh_command="ssh -t
  -L $port_local:localhost:$port_remote
  $user@$host
  $docker_command"

# Execute command
# echo $ssh_command
$ssh_command
