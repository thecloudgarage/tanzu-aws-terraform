#!/bin/bash
read -e -p "pksLoginUserName: " pksLoginUserName
read -sp "pksLoginPassword: " pksLoginPassword
read -e -p "rootDomain: " -i "aws.thecloudgarage.com" rootDomain
read -p "clusterName: " clusterName
read -p "appSvcLoadBalancer: " appSvcLoadBalancer

pks login -a api.pks.$rootDomain -u $pksLoginUserName -p "$pksLoginPassword" -k

pks upgrade-clusters --clusters $clusterName

RED='\033[0;31m'
NC='\033[0m' # No Color

echo "######################################################################################"
echo "######################################################################################"
echo "############### PKS API SERVER IS USING BOSH TO UPGRADE CLUSTER       ################"
echo "############### k8s CLUSTER UPGRADE WILL TAKE ALMOST 4-5 MIN PER NODE ################"
echo "######################################################################################"
echo "######################################################################################"

#RUN A LOOP TO CHECK PKS CLUSTER STATUS AND PRINT TIME ELAPSED

unset start
export start="$(date -u +%s)";

while :
do
clusterStatus=$( pks cluster $clusterName --json | jq --raw-output '.last_action_state' )
end="$(date -u +%s)"
elapsed=$(($end-$start));
echo "$clusterName Cluster Status is $clusterStatus"
echo -e "time elapsed is $elapsed seconds"
curl --silent --output /dev/null --show-error $appSvcLoadBalancer
res=$?
if test "$res" != "0"; then
echo "$end Request failed due to: $res" >> request.log
echo -e "time elapsed is $elapsed seconds" >> request.log
else
echo "$end Request was successful" >> request.log
echo -e "time elapsed is $elapsed seconds" >> request.log
fi
echo -e "${RED}KEEP CALM AND BREATHE!!! YOU ARE IN SAFE HANDS OF TANZU${NC}"
sleep 5
if [[ "$clusterStatus" == "succeeded" ]]; then
break
fi
done
echo -e "${RED}$clusterName CLUSTER IS UPGRADED!!!!${NC}"
