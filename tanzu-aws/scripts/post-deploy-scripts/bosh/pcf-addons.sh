#!/bin/bash
export uaaToken=$( sudo curl -s -k -H 'Accept: application/json;charset=utf-8' -d 'grant_type=password' \
  -d 'username=admin' -d 'password=admin' \
  -u 'opsman:' https://localhost/uaa/oauth/token |  jq --raw-output '.access_token' )
echo Please provide your Pivnet token
read -e -p "pivnetToken: " -i "whatisyourtoken" pivnetToken
read -p "pivnetUrl: " pivnetUrl
read -p "pivnetProductName: " pivnetProductName
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $pivnetUrl -O "$pivnetProductName"
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$pivnetProductName"''
