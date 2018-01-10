#!/bin/bash
echo "Stopping acceptance container"
docker kill rallyjenkinsdemo_app_acceptance || true
