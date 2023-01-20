#!/bin/bash

image_name="rl-ansible"
# container_name="ansible"

if [ -z "$1" ]; then
  read -p "Container name: " container_name
else
  container_name="$1"
fi

## get dir of this script
build_dir=` dirname $0 `

## search 
container_prog=` which podman `
[ -n "$container_prog" ] || container_prog=` which docker `

# fail if container engine binary wasn't found
if [ -z "$container_prog" ]; then
  echo "Neither podman nor docker are installed" >&2
  exit 1
fi

if [ -n "` echo "$container_prog" | grep podman `" ]; then
  ## if the image has not been built yet, build it
  test -n "` podman images --all | awk "\$1~\"/$image_name\" {print \$3}" `" || bash "$build_dir/build.bash"
  podman create -t --name "$container_name" -v "$HOME":"/mnt/home" "$image_name"
# else
fi