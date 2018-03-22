#!/bin/bash

mv /tmp/puma.service /etc/systemd/system/ 
systemctl enable puma.service
systemctl start puma.service

