#!/bin/bash
read -e -p "rootDomain: " -i "aws.thecloudgarage.com" rootDomain
read -p "pksNewUserName: " pksNewUserName
read -sp "password: " password

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
          "https://tanzu-opsman.$rootDomain/api/v0/deployed/products/$pksguid/credentials/.properties.pks_uaa_management_admin_client" \
            -k -H 'Authorization: bearer '"$uaaToken"'' | jq --raw-output '.credential.value.secret' )

uaac target api.pks.$rootDomain:8443 --ca-cert /var/tempest/workspaces/default/root_ca_certificate --skip-ssl-validation
uaac token client get admin -s $uaaadminpassword
uaac user add $pksNewUserName --emails $pksNewUserName@$rootDomain -p $password
uaac member add pks.clusters.admin $pksNewUserName
