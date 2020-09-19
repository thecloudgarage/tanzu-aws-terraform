#!/bin/bash
read -e -p "rootDomain: " -i "aws.thecloudgarage.com" rootDomain

#IF REQUIRED REMOTELY, THEN UNCOMMENT THE BELOW AND COMMENT OUT THE UAA METHOD
#pks login -a api.pks.aws.thecloudgarage.com -u admin -p D6Qb_tpnm26qOGq8SWgyjjESs28F4IJr -k

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
