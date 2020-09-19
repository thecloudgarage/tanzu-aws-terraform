#!/bin/bash

export pivnetToken=variablePivnetToken

#INSTALL COMMON UTILITIES
sudo apt update -y
sudo apt install openjdk-8-jdk -y
sudo apt install jq -y
sudo apt install wget -y
sudo apt install unzip -y

#INSTALL DOCKER-CE

sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update -y
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo service docker start
sudo usermod -aG docker ubuntu

#INSTALL DOCKER-COMPOSE
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#INSTALL KUBECTL

curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

#INSTALL AWS CLI

sudo apt-get update -y
sudo apt-get install awscli -y

#INSTALL KOPS

curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops
sudo mv kops /usr/local/bin/

#INSTALL PKS CLI
wget --post-data="" --header="Authorization: Token $pivnetToken" https://network.pivotal.io/api/v2/products/pivotal-container-service/releases/501833/product_files/528557/download -O "pks-linux-amd64-1.6.0-build.225"
sudo mv pks-linux-amd64-1.6.0-build.225 pks
chmod +x ./pks
sudo mv ./pks /usr/local/bin

#INSTALL CF CLI

wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
echo "deb https://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list
sudo apt-get update -y
sudo apt-get install cf-cli -y

#INSTALL TERRAFORM

wget https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip
sudo unzip ./terraform_0.11.13_linux_amd64.zip -d /usr/local/bin/
echo "done"
