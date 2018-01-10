#!/bin/bash
if [ "$1" == "" ]; then
  echo "Must pass container name as argument"
  exit 1
fi

echo "Starting acceptance container"
docker kill rallyjenkinsdemo_app_acceptance || true
docker run --network=rallyjenkinsdemo_default -d $TARGET_DOCKER_IMAGE --name="${1}"
echo "Waiting for Jetty to stand up"
sleep 20
