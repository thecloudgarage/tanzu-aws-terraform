#!/bin/bash
read -e -p "haborUrl: " -i "harbor.aws.thecloudgarage.com" harborUrl
read -p "harborUsername: " harborUsername
read -p "harborPassword: " harborPassword
sudo curl -u $harborPassword:$harborPassword -k -X GET "https://$harborUrl/api/systeminfo/getcert" > ca.crt
sudo rm -rf /etc/docker/certs.d/$harborUrl
sudo mkdir -p /etc/docker/certs.d/$harborUrl
sudo mv ./ca.crt /etc/docker/certs.d/$harborUrl
sudo service docker start
sudo echo "$harborPassword" | docker login $harborUrl -u $harborUsername --password-stdin
