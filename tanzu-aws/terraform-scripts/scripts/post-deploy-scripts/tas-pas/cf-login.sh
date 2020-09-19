#!/bin/bash
read -e -p "tanzuOpsmanUrl: " -i "tanzu-opsman.aws.thecloudgarage.com" tanzuOpsmanUrl
read -e -p "cfApiendpoint: " -i "api.sys.aws.thecloudgarage.com" cfApiendpoint
read -p "cfOrg: " cfOrg
read -p "cfSpace: " cfSpace

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

cf api $cfApiendPoint --skip-ssl-validation
cf auth admin $uaaadminpassword
cf target -o $cfOrg -s $cfSpace
