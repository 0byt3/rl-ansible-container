#!/bin/bash

## the USER_HOME environment variable is required
if [ -z "$USER_HOME" ]; then

  ## if the .ssh directory exists in the volume dir then assume volume is mounted
  if [ -d /mnt/home/.ssh ]; then
    ## if /root/.ssh is not a symbolic link then remove the existing .ssh dir (if exists) then link it
    if [ ! -L /root/.ssh ]; then
      # if the /root/.ssh dir exists then remove it
      [ -d /root/.ssh ] && rm -Rf /root/.ssh
      # create a symbolic link
      ln -s /mnt/home/.ssh /root/.ssh
    fi
    
    ## create a symbolic link from /mnt/home to $USER_HOME
    [ -L "$USER_HOME" ] || ln -s /mnt/home "$USER_HOME"

    cd "$HOME"

    ## enable ssh-agent for private key storing
    [ -n "` ps -a -C ssh-agent | awk '$4=="ssh-agent"' `" ] || eval `ssh-agent`

    ## change HOME var to linked volume if volume exists
    export HOME="$USER_HOME"

  else
    echo "Did not find a .ssh folder in volume mount. A home directory must be mounted to /mnt/home. If a home directory is mounted to /mnt/home then create a .ssh folder and keys." >&2
  fi

else

  echo "Missing environment variable USER_HOME" >&2
  
fi
