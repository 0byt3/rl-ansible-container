image_name="rl-ansible"
container_name="ansible"

## if container doesn't exist then create it
if [ -z "`podman ps -f name=$container_name | awk 'NR > 1'`" ]; then

  ## if image doesn't exist then build it
  if [ -z "`podman images -f "reference=$image_name:latest" | awk 'NR > 1'`" ]; then
    current_dir=`pwd`
    cd `dirname $0`
    buildah build -t "$image_name"
    cd $current_dir
  fi

  podman create -t --name "$container_name" -v "$HOME":"$HOME" "$image_name"
fi

podman start "$container_name"

if [ ! `podman exec "$container_name" test -L '/root/.ssh'` ]; then
  [ `podman exec "$container_name" test -d '/root/.ssh'` ] && podman exec "$container_name" rm -Rf '/root/.ssh'
  podman exec "$container_name" ln -s "$HOME/.ssh" '/root/.ssh'
fi

podman exec -ti "$container_name" bash