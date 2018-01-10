#!/bin/bash
if [ "$1" == "" ]; then
  echo "Must pass container name as argument"
  exit 1
fi

echo "Stopping acceptance container"
docker kill "${1}" || true
