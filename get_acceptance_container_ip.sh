#!/bin/bash
if [ "$1" == "" ]; then
  echo "Must pass container name as argument"
  exit 1
fi
echo $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "${1}")
