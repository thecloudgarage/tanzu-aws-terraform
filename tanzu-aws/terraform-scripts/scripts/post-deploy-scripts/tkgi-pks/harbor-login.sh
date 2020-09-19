#!/bin/bash
read -e -p "harborUrl: " -i "harbor.aws.thecloudgarage.com" harborUrl
read -p "harborUsername: " harborUsername
read -p "harborPassword: " harborPassword
cat << EOF > /etc/docker/daemon.json
{ "insecure-registries": ["$harborUrl"] }
EOF
service docker restart
sudo echo "$harborPassword" | docker login $harborUrl -u $harborUsername --password-stdin
