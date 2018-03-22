#!/bin/bash

gcloud compute instances create reddit-app2 \
  --boot-disk-size=10GB \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --image reddit-full-1521661388

