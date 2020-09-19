#!/bin/bash

export uaaToken=$( sudo curl -s -k -H 'Accept: application/json;charset=utf-8' -d 'grant_type=password' -d 'username=admin' -d 'password=admin' \
	  -u 'opsman:' https://localhost/uaa/oauth/token |  jq --raw-output '.access_token' )

#DISABLE THE WILDCARD VERFIER FOR PIVOTAL APPLICATION SERVICE AS DNS IS NOT YET SETUP

#DERIVE THE GU-ID FOR PIVOTAL APPLICATION SERVICE PRODUCT TILE
export pasguid=$( curl "https://localhost/api/v0/staged/products" -k \
	  -X GET \
	    -H 'Authorization: Bearer '"$uaaToken"'' \
	      | jq --raw-output '.[] | select(.installation_name|test("cf-.")) | .guid')

echo "PAS GU-ID is: $pasguid"

#THEN DISABLE THE DNS WILDCARD DOMAIN VERIFIER
curl "https://localhost/api/v0/staged/products/$pasguid/verifiers/install_time/WildcardDomainVerifier" -k \
	-X PUT \
	-H 'Authorization: Bearer '"$uaaToken"'' \
	-H "Content-Type: application/json" \
	-d '{ "enabled": false }'

