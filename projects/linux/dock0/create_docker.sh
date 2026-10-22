docker volume create dock0-state

docker run --rm -it --privileged \
  -v /Users/Shared/ccc:/ccc \
  -v dock0-state:/state -e DOCK0_DIR=/state \
  $(docker inspect -f '{{.Config.Image}}' my-dev-vm) bash
