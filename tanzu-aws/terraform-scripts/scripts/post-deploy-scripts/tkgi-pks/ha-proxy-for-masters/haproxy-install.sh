#!/bin/bash
#In case you want to install haproxy as a service on Ubuntu 18.04
#Else you can skip this procedure and directly run docker-compose up and ha proxy will run as a docker container
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install haproxy -y
sudo rm -rf /etc/haproxy/haproxy.cfg
sudo cp haproxy.cfg /etc/haproxy/haproxy.cfg
sudo systemctl restart haproxy
#http://dockerlabs.collabnix.com/kubernetes/beginners/Install-and-configure-a-multi-master-Kubernetes-cluster-with-kubeadm.html
