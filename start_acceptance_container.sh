#!/bin/bash
echo "Starting acceptance container"
docker kill rallyjenkinsdemo_app_acceptance || true
docker run --network=rallyjenkinsdemo_default -d $TARGET_DOCKER_IMAGE --name=rallyjenkinsdemo_app_acceptance
echo "Waiting for Jetty to stand up"
sleep 20
