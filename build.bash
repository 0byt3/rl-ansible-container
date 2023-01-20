#!/bin/bash

image_name="rl-ansible"

## get dir of this script
build_dir=` dirname $0 `

## search 
container_prog=` which podman `
[ -n "$container_prog" ] || container_prog=` which docker `

echo "container_prog = '$container_prog'"
echo "build_dir = '$build_dir'"

# fail if container engine binary wasn't found
if [ -z "$container_prog" ]; then
  echo "Neither podman nor docker are installed" >&2
  exit 1
fi

if [ -n "` echo "$container_prog" | grep podman `" ]; then
  podman build --build-arg user_home="$HOME" --rm=true --build-arg term_var=$TERM -f "$build_dir/Containerfile" -t "$image_name"
fi