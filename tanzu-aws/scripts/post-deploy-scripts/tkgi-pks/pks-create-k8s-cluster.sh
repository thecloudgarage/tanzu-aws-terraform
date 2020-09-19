#!/bin/bash
read -e -p "pksLoginUserName: " pksLoginUserName
read -sp "pksLoginPassword: " pksLoginPassword
read -e -p "rootDomain: " -i "aws.thecloudgarage.com" rootDomain
read -p "clusterName: " clusterName
read -p "pksPlanName: " pksPlanName
read -p "numberOfWorkerNodes: " numberOfWorkerNodes
read -e -p "awsRegion: " -i "us-east-1" awsRegion

pks login -a api.pks.$rootDomain -u $pksLoginUserName -p "$pksLoginPassword" -k

pks create-cluster $clusterName --external-hostname $clusterName.pks.$rootDomain --plan $pksPlanName --num-nodes $numberOfWorkerNodes

RED='\033[0;31m'
NC='\033[0m' # No Color

echo "######################################################################################"
echo "######################################################################################"
echo "############### PKS API SERVER IS TALKING TO BOSH TO CREATE CLUSTER   ################"
echo "############### k8s CLUSTER CREATION WILL TAKE ALMOST 5 to 7 MINUTES  ################"
echo "############### ONCE CLUSTER IS SUCCEEDED WE WILL DEPLOY OUR APPS     ################"
echo "############### LETS PATIENTLY WAIT AS BOSH WILL ENSURE ACCURACY      ################"
echo "###############        AND CREATE A STATE MANAGEMENT PROFILE          ################"
echo "############### TILL THEN WE WILL LOOP THE CLUSTER STATUS EVERY 10 SEC   #############"
echo "#############  Press <CTRL+C> to exit anytime or once cluster succeeds.    ###########"

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
                    echo -e "${RED}k8s CLUSTERS DO TAKE TIME TO CREATE DUE TO UNDERLYING IaaS CONDITIONS AND k8s FULL CONVERGENCE${NC}"
                      sleep 10
                        if [[ "$clusterStatus" == "succeeded" ]]; then
                                    break
                                      fi
                              done
                              echo -e "${RED}$clusterName CLUSTER IS CREATED!!!!${NC}"

#TAG THE TKG_I SUBNETS TO ENSURE ADDITION OF K8S SERVICES EXPOSED VIA LOAD_BALANCER"
clusterDetails=$( pks cluster $clusterName --json )
clusterUuid=$( pks cluster $clusterName --json | jq --raw-output '.uuid' )
TKG_I_AZ1_SubnetId=$( aws ec2 describe-subnets --region $awsRegion --filters 'Name=tag:Name,Values=TANZU_VPC_TKG_I_AZ1' | jq -r '.Subnets[0].SubnetId' )
TKG_I_AZ2_SubnetId=$( aws ec2 describe-subnets --region $awsRegion --filters 'Name=tag:Name,Values=TANZU_VPC_TKG_I_AZ2' | jq -r '.Subnets[0].SubnetId' )
aws ec2 create-tags --region $awsRegion --resources $TKG_I_AZ1_SubnetId --tags Key=kubernetes.io/cluster/service-instance_$clusterUuid,Value=
aws ec2 create-tags --region $awsRegion --resources $TKG_I_AZ2_SubnetId --tags Key=kubernetes.io/cluster/service-instance_$clusterUuid,Value=

#GET CLUSTER CREDENTIALS AND SWITCH KUBECTL CONTEXT
pks get-credentials $clusterName
kubectl config use-context $clusterName

if [[ $(pks cluster $clusterName --json | jq --raw-output '.kubernetes_master_ips[0]') != *null* ]]; then
    masterIpOne=$( pks cluster $clusterName --json | jq --raw-output '.kubernetes_master_ips[0]' )
else
    echo "master 1 is not present"
fi

if [[ $(pks cluster $clusterName --json | jq --raw-output '.kubernetes_master_ips[1]') != *null* ]]; then
    masterIpTwo=$( pks cluster $clusterName --json | jq --raw-output '.kubernetes_master_ips[1]' )
else
    echo "master 2 is not present"
fi

if [[ $(pks cluster $clusterName --json | jq --raw-output '.kubernetes_master_ips[2]') != *null* ]]; then
    masterIpThree=$( pks cluster $clusterName --json | jq --raw-output '.kubernetes_master_ips[2]' )
else
    echo "master 3 is not present"
fi

versionNumber=$( curl -X GET --user admin:admin "http://localhost:5555/v2/services/haproxy/configuration/frontends" | jq -r '._version' )
haProxyTxnId=$( curl -X POST --user admin:admin -H "Content-Type: application/json" http://localhost:5555/v2/services/haproxy/transactions?version=$versionNumber | jq -r '.id' )

curl -X POST --user admin:admin \
-H "Content-Type: application/json" \
-d '{"name": "'$clusterName'", "mode":"tcp", "adv_check":"tcp-check"}' \
"http://localhost:5555/v2/services/haproxy/configuration/backends?transaction_id=$haProxyTxnId"

curl -X POST --user admin:admin \
-H "Content-Type: application/json" \
-d '{"name": "k8s-master-0", "address": "'$masterIpOne'", "port": 8443, "check": "enabled"}' \
"http://localhost:5555/v2/services/haproxy/configuration/servers?backend=$clusterName&transaction_id=$haProxyTxnId"

curl -X POST --user admin:admin \
-H "Content-Type: application/json" \
-d '{"name": "k8s-master-1", "address": "'$masterIpTwo'", "port": 8443, "check": "enabled"}' \
"http://localhost:5555/v2/services/haproxy/configuration/servers?backend=$clusterName&transaction_id=$haProxyTxnId"

curl -X POST --user admin:admin \
-H "Content-Type: application/json" \
-d '{"name": "k8s-master-2", "address": "'$masterIpThree'", "port": 8443, "check": "enabled"}' \
"http://localhost:5555/v2/services/haproxy/configuration/servers?backend=$clusterName&transaction_id=$haProxyTxnId"

curl -X PUT --user admin:admin \
-H "Content-Type: application/json" \
"http://localhost:5555/v2/services/haproxy/transactions/$haProxyTxnId"

versionNumber=$( curl -X GET --user admin:admin "http://localhost:5555/v2/services/haproxy/configuration/frontends" | jq -r '._version' )

haProxyTxnId=$( curl -X POST --user admin:admin -H "Content-Type: application/json" http://localhost:5555/v2/services/haproxy/transactions?version=$versionNumber | jq
 -r '.id' )

curl -X POST --user admin:admin \
-H "Content-Type: application/json" \
-d '{"acl_name": "'$clusterName'", "criterion": "req.ssl_sni", "index":1, "value": "-i '$clusterName'.pks.aws.thecloudgarage.com"}' \
"http://localhost:5555/v2/services/haproxy/configuration/acls?parent_type=frontend&parent_name=masters&version=$versionNumber"

#Note: Because of the commit made in the above line., the version number changes, so we have to get the version number again
versionNumber=$( curl -X GET --user admin:admin "http://localhost:5555/v2/services/haproxy/configuration/frontends" | jq -r '._version' )

curl -X POST --user admin:admin \
-H "Content-Type: application/json" \
-d '{"cond": "if", "cond_test": "'$clusterName'", "index":0, "name": "'$clusterName'"}' \
"http://localhost:5555/v2/services/haproxy/configuration/backend_switching_rules?frontend=masters&version=$versionNumber"

docker restart ha-proxy-for-masters_master_1
sleep 5

#OUTPUT THE CLUSTER DETAILS
echo "YOUR k8s CLUSTER MASTER NODE IS $clusterName.pks.$rootDomain and the cluster details are provided below"
echo "$clusterDetails"
workerPrivateIp=$( kubectl get no -o json | jq -r '.items[].status.addresses[] | select(.type=="InternalIP") | .address' )
workerPublicIp=$( kubectl get no -o json | jq -r '.items[].status.addresses[] | select(.type=="ExternalIP") | .address' )
echo "YOUR k8s CLUSTER MASTER NODE IS $clusterName.pks.$rootDomain"
echo "CLUSTER WORKER/S PRIVATE IP IS/ARE $workerPrivateIp"
echo "CLUSTER WORKER/S PUBLIC IP IS/ARE $workerPublicIp"
