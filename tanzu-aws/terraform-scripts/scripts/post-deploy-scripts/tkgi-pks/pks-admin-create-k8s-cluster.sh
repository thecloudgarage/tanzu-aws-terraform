#!/bin/bash
read -e -p "rootDomain: " -i "aws.thecloudgarage.com" rootDomain
read -p "clusterName: " clusterName
read -p "pksPlanName: " pksPlanName
read -p "numberOfWorkerNodes: " numberOfWorkerNodes

export uaaToken=$( sudo curl -s -k -H 'Accept: application/json;charset=utf-8' -d 'grant_type=password' -d 'username=admin' -d 'password=admin' \
          -u 'opsman:' https://tanzu-opsman.$rootDomain/uaa/oauth/token |  jq --raw-output '.access_token' )

export pksguid=$( curl "https://tanzu-opsman.$rootDomain/api/v0/staged/products" -k \
          -X GET \
            -H 'Authorization: Bearer '"$uaaToken"'' \
              | jq --raw-output '.[] | select(.installation_name|test("pivotal-container-service.")) | .guid' )

echo "PKS GU-ID is: $pksguid"

export uaaadminpassword=$( sudo curl \
          "https://tanzu-opsman.$rootDomain/api/v0/deployed/products/$pksguid/credentials/.properties.uaa_admin_password" \
            -k -H 'Authorization: bearer '"$uaaToken"'' | jq --raw-output '.credential.value.secret' )
echo "PKS admin password is $uaaadminpassword"
pks login -a api.pks.$rootDomain -u admin -p "$uaaadminpassword" -k

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

                              masterPrivateIp=$( pks cluster $clusterName --json | jq --raw-output '.kubernetes_master_ips[]' )
                              masterPublicIp=$( aws --region "$awsRegionName" ec2 describe-instances \
                                        --filters   'Name=network-interface.addresses.private-ip-address,Values='"$masterPrivateIp"'' \
                                          | jq -r '.Reservations[0].Instances[0].PublicIpAddress')


                              echo -e "$masterPublicIp $clusterName.pks.aws.$domainName" >> /etc/hosts
                              echo "YOUR k8s CLUSTER MASTER NODE IS $clusterName.pks.aws.$domainName"
