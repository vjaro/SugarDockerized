#!/bin/bash

# Enrico Simonetti
# enricosimonetti.com

# enter the repo's root directory
REPO="$( dirname ${BASH_SOURCE[0]} )/../"
cd $REPO

STACK='sugar-cron'
PROJECT_CONTAINERS_CONF=data/project/containers.conf
if [ -f "$PROJECT_CONTAINERS_CONF" ]; then
    PROJECT_STACK=$(cat "$PROJECT_CONTAINERS_CONF" | grep cron)
    if [ ! -z  "$PROJECT_STACK" ]; then
      STACK="$PROJECT_STACK"
    fi
fi

if [ $# -eq 0 ]
then
    echo Provide the command\(s\) to run as arguments
else
    # check if the stack is running
    running=`docker ps | grep "$STACK" | wc -l`

    if [ $running -gt 0 ]
    then
        # running
        # if it is our repo
        if [ -f '.gitignore' ] && [ -d 'data' ]
        then
            user_command="cd /var/www/html/sugar && $@"
            docker exec "$STACK" bash -c "$user_command"
        else
            echo The command needs to be executed from within the clone of the repository
        fi
    else
        echo The stack needs to be running before executing a cli command
    fi
fi
