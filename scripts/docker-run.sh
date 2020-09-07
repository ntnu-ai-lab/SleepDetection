#!/bin/bash

# Runs a container of the image with sensible defaults

# Get current dir
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Parse arguments (can also be passed directly with env variables)
while true; do
    case "$1" in
        -i | --image ) HUNT4_SLEEP_IMAGE=$2; shift; shift; continue ;;
        -d | --dir-user ) HUNT4_SLEEP_DIR_USER=$2; shift; shift; continue ;;
        --mount-notebooks ) HUNT4_SLEEP_MOUNT_NOTEBOOKS=1; shift; continue ;;
    esac
    break
done


image=${HUNT4_SLEEP_IMAGE:-$USER/sleep}
data_labelled=${HUNT4_SLEEP_DATA_LABELLED:-'/data/hunt4/sleep-labelled-dataset'}
data_semi_supervised=${HUNT4_SLEEP_DATA_SEMI_SUPERVISED:-'/data/hunt4/sleep-semi-supervised-dataset'}
dir_user=${HUNT4_SLEEP_DIR_USER:-"$DIR/../user"}

if [ "$HUNT4_SLEEP_MOUNT_NOTEBOOKS" == "1" ]
then
  mount_notebooks="-v $DIR/../notebooks:/hunt4_sleep/notebooks"
fi

# Begin building command
docker_command="docker run --rm -it
    -v $dir_user:/hunt4_sleep/user
    $mount_notebooks
    -v $data_labelled:/hunt4_sleep/data/labelled:ro
    -v $data_semi_supervised:/hunt4_sleep/data/semi_supervised:ro
    --env USER_ID=$(id -u)
    $image"
# echo $docker_command $@
$docker_command $@
