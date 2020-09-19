d -p "clusterName: " clusterName
pks get-credentials $clusterName
kubectl config use-context $clusterName
kubectl apply -f ./jboss-namespace.yml
kubectl apply -f ./jboss-service.yml
kubectl apply -f ./jboss-app.yml
echo "###############################################################################"
echo "###############################################################################"
echo "###############################################################################"
echo "################  GENERATING URL'S FOR PROVISIONED JBOSS APP   ################"
sleep 5
echo "################    AWS LOAD BALANCER BEING PROVISIONED  ######################"
sleep 4
echo "#################  GENERATING URL'S FOR PROVISIONED URLS   ####################"
sleep 3
echo "############################# ALMOST THERE  ###################################"

echo "PLEASE NOTE JBOSS SERVER PROCESS TAKES A COUPLE OF MINUTES TO START"

echo "###############################################################################"
echo "###############################################################################"
echo "###############################################################################"

export IngressLoadBalancer=$( kubectl get service jboss-service -n jboss -o jsonpath="{.status.loadBalancer.ingress[].hostname}" )

RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "JBOSS SERVER MGMT URL ${RED}$IngressLoadBalancer:9990${NC}"
echo -e "JBOSS SERVER SAMPLE APP: ${RED}$IngressLoadBalancer:8080${NC}"
