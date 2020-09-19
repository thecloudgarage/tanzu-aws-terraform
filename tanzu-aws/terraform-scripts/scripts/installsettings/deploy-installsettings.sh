#!/bin/bash
export uaaToken=$( sudo curl -s -k -H 'Accept: application/json;charset=utf-8' -d 'grant_type=password' -d 'username=admin' -d 'password=admin' \
	  -u 'opsman:' https://localhost/uaa/oauth/token |  jq --raw-output '.access_token' )
curl -s -k -H 'Accept: application/json;charset=utf-8' \
	  -H "Content-Type: multipart/form-data" \
	    -H 'Authorization: bearer '"$uaaToken"'' \
	      https://localhost/api/installation_settings -X POST -F  "installation[file]=@installsettings.json"
