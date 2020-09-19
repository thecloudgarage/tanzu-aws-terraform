#!/bin/bash
export IngressLoadBalancer=$( kubectl get service jboss-service -n jboss -o jsonpath="{.status.loadBalancer.ingress[].hostname}" )

echo "JBOSS SERVER MGMT URL $IngressLoadBalancer:9990"
echo "JBOSS SERVER SAMPLE APP: $IngressLoadBalancer:8080"
echo "###########################################"
echo "###########################################"
kubectl get service -n jboss
kubectl get pods -n jboss
