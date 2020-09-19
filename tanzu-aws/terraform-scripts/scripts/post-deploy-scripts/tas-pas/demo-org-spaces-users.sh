#!/bin/bash
read -e -p "tanzuOpsmanUrl: " -i "tanzu-opsman.aws.thecloudgarage.com" tanzuOpsmanUrl
read -e -p "cfApiEndPoint: " -i "api.sys.aws.thecloudgarage.com" cfApiEndPoint
read -e -p "cfOrg: " -i "system" cfOrg
read -e -p "cfSpace: " -i "system" cfSpace

export uaaToken=$( sudo curl -s -k -H 'Accept: application/json;charset=utf-8' -d 'grant_type=password' -d 'username=admin' -d 'password=admin' \
          -u 'opsman:' https://$tanzuOpsmanUrl/uaa/oauth/token |  jq --raw-output '.access_token' )

export cfguid=$( curl "https://$tanzuOpsmanUrl/api/v0/staged/products" -k \
          -X GET \
            -H 'Authorization: Bearer '"$uaaToken"'' \
              | jq --raw-output '.[] | select(.installation_name|test("cf-.")) | .guid' )

echo "CF GU-ID is: $cfguid"

export uaaadminpassword=$( sudo curl \
           "https://$tanzuOpsmanUrl/api/v0/deployed/products/$cfguid/credentials/.uaa.admin_credentials" \
            -k -H 'Authorization: bearer '"$uaaToken"'' | jq --raw-output '.credential.value.password' )

echo "password is $uaaadminpassword"
echo "api end point is $cfApiEndPoint"
cf api $cfApiEndPoint --skip-ssl-validation
cf auth admin $uaaadminpassword
cf target -o $cfOrg -s $cfSpace
#-m org memory -i per app memory -r number of routes -s number of service instances
cf create-quota small -m 10gb -i -1 -r -1 -s -1 --allow-paid-service-plans
cf create-quota medium -m 30gb -i -1 -r -1 -s -1 --allow-paid-service-plans
cf create-quota large -m 50gb -i -1 -r -1 -s -1 --allow-paid-service-plans
cf create-quota xlarge -m 100gb -i -1 -r -1 -s -1 --allow-paid-service-plans
cf create-org OrgA -q small
cf create-org OrgB -q medium
cf create-org OrgC -q large
cf create-org OrgD -q xlarge
cf create-space spaceA -o OrgA
cf create-space spaceB -o OrgA
cf create-space spaceA -o OrgB
cf create-space spaceB -o OrgB
cf create-space spaceA -o OrgC
cf create-space spaceB -o OrgC
cf create-space spaceA -o OrgD
cf create-space spaceB -o OrgD
cf create-user orgAdmin orgAdmin
cf create-user spaceAdmin spaceAdmin
cf create-user spaceDeveloper spaceDeveloper
cf set-org-role orgAdmin orgA OrgManager
cf set-org-role orgAdmin orgB OrgManager
cf set-org-role orgAdmin orgB OrgManager
cf set-space-role spaceAdmin orgA spaceA SpaceManager
cf set-space-role spaceAdmin orgA spaceB SpaceManager
cf set-space-role spaceAdmin orgB spaceA SpaceManager
cf set-space-role spaceAdmin orgB spaceB SpaceManager
cf set-space-role spaceAdmin orgC spaceA SpaceManager
cf set-space-role spaceAdmin orgC spaceB SpaceManager
cf set-space-role spaceAdmin orgD spaceA SpaceManager
cf set-space-role spaceAdmin orgD spaceB SpaceManager
cf set-space-role spaceDeveloper orgA spaceA SpaceDeveloper
cf set-space-role spaceDeveloper orgA spaceB SpaceDeveloper
cf set-space-role spaceDeveloper orgB spaceA SpaceDeveloper
cf set-space-role spaceDeveloper orgB spaceB SpaceDeveloper
cf set-space-role spaceDeveloper orgC spaceA SpaceDeveloper
cf set-space-role spaceDeveloper orgC spaceB SpaceDeveloper
cf set-space-role spaceDeveloper orgD spaceA SpaceDeveloper
cf set-space-role spaceDeveloper orgD spaceB SpaceDeveloper
