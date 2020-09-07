#!/bin/bash

# Startup script to set the correct user
# If the environment variabless $USER_ID is set,
# hen make a user for those and change to it
# before running the main command
#
# That way, files created inside the docker container
# will belong to that user on the host machine

if [[ -n $USER_ID ]]; then
    # echo "Creating user"
    adduser --disabled-password --gecos '' --uid $USER_ID user > /dev/null
    chown -R user /usr/local /hunt4_sleep/notebooks /hunt4_sleep/user

    # Hack to make interactive bash work
    if [[ $@ == "bash" ]]; then
        exec su user -s /bin/bash
    else
        export COMMAND="$@"
        exec su user -c '$COMMAND'
    fi
else
    # echo "Remaining as root"
    # echo "Running: $@"
    $@
fi
