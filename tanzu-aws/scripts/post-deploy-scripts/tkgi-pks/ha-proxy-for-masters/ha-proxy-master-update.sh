#!/bin/bash

read -e -p "clusterName: " clusterName
read -e -p "masterIpOne: " masterIpOne
read -e -p "masterIpTwo: " masterIpTwo
read -e -p "masterIpThree: " masterIpThree

versionNumber=$( curl -X GET --user admin:admin "http://localhost:5555/v2/services/haproxy/configuration/frontends" | jq -r '._version' )
haProxyTxnId=$( curl -X POST --user admin:admin -H "Content-Type: application/json" http://localhost:5555/v2/services/haproxy/transactions?version=$versionNumber | jq
 -r '.id' )

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
-d '{"acl_name": "'$clusterName'", "criterion": "req.ssl_sni", "index":0, "value": "-i '$clusterName'.pks.aws.thecloudgarage.com"}' \
"http://localhost:5555/v2/services/haproxy/configuration/acls?parent_type=frontend&parent_name=masters&version=$versionNumber"

#Note: Because of the commit made in the above line., the version number changes, so we have to get the version number again
versionNumber=$( curl -X GET --user admin:admin "http://localhost:5555/v2/services/haproxy/configuration/frontends" | jq -r '._version' )

curl -X POST --user admin:admin \
-H "Content-Type: application/json" \
-d '{"cond": "if", "cond_test": "'$clusterName'", "index":0, "name": "'$clusterName'"}' \
"http://localhost:5555/v2/services/haproxy/configuration/backend_switching_rules?frontend=masters&version=$versionNumber"
