#!/bin/bash
read -p "clusterName: " clusterName
pks get-credentials $clusterName
kubectl config use-context $clusterName
kubectl delete -f ./jboss-app.yml
kubectl delete -f ./jboss-service.yml
kubectl delete -f ./jboss-namespace.yml
