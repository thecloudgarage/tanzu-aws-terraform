#!/bin/bash
read -e -p "tanzuOpsmanUrl: " -i "https://tanzu-opsman.aws.thecloudgarage.com" tanzuOpsmanUrl

perl -i -ne '/^export BOSH_CLIENT=ops_manager/ || print' ~/.profile
perl -i -ne '/^export BOSH_CLIENT=ops_manager/ || print' ~/.bashrc

export uaaToken=$( sudo curl -s -k -H 'Accept: application/json;charset=utf-8' -d 'grant_type=password' -d 'username=admin' -d 'password=admin' \
                          -u 'opsman:' $tanzuOpsmanUrl/uaa/oauth/token |  jq --raw-output '.access_token' )

export credential=$( sudo curl \
                          "$tanzuOpsmanUrl/api/v0/deployed/director/credentials/bosh_commandline_credentials" \
                                                        -k -H 'Authorization: bearer '"$uaaToken"'' | jq --raw-output '.credential' )
echo "bosh credentials are $credential"

#FOR REMOTE LOGINS
#rm -rf /var/tempest/workspaces/default
#mkdir -p /var/tempest/workspaces/default
#sudo curl \
#  "$tanzuOpsmanUrl/api/v0/certificate_authorities" \
#   -k -H 'Authorization: bearer '"$uaaToken"'' | jq -r '.certificate_authorities[0].cert_pem' > /var/tempest/workspaces/default/root_ca_certificate

echo -e 'export '"$credential"'' >> ~/.profile
echo -e 'export '"$credential"'' >> ~/.bashrc
