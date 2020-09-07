#!/bin/bash

# Get current dir
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Parse arguments
while true; do
    case "$1" in
        # Allow different user tag. E.g. -u hunt4 -> hunt4/sleep
        -u | --user ) user=$2; shift; shift; continue ;;
    esac
    break
done

# Set defaults
user=${user:-$USER}

# Build with name prefixed by current user and remove intermediate containers
docker_command="docker build --rm -t $user/sleep $DIR/.."
echo $docker_command
$docker_command
