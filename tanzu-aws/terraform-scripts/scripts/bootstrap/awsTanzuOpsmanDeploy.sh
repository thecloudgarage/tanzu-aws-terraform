#!/bin/bash
export tanzuOpsmanDnsName=variableTanzuOpsmanDnsName
#FIND THE PUBLIC IP OF EC2 INSTANCE
  if [ -z "$1" ]; then
  echo "IP not given...trying EC2 metadata...";
  IP=$( curl http://169.254.169.254/latest/meta-data/public-ipv4 )
  else
  IP="$1"
  fi
  echo "IP to update: $IP"
  #ADD A LOCAL ENTRY FOR DNS RESOLUTION TILL ACTUAL OPS MAN DNS MAPPINGS ARE DONE
  sudo sed "\$a$IP $tanzuOpsmanDnsName" /etc/hosts > /etc/hosts.temp && mv /etc/hosts.temp /etc/hosts
  #SEND AN INSTRUCTION TO START THE OPS MANAGER UAA PROCESS
  curl -k "https://$tanzuOpsmanDnsName/api/v0/setup" \
    -X POST \
    -H "Content-Type: application/json" \
    -d '{ "setup": {
    "decryption_passphrase": "admin",
    "decryption_passphrase_confirmation":"admin",
    "eula_accepted": "true",
    "identity_provider": "internal",
    "admin_user_name": "admin",
    "admin_password": "admin",
    "admin_password_confirmation": "admin"
    } }'
sleep 2m
export pivnetToken=variablePivnetToken
#SPECIFIY REQUIRED STEMCELLS (HARDENED OS) TO RUN VARIOUS WORKLOADS AND PLATFORM COMPONENTS
export stemcell456PivnetUrl=https://network.pivotal.io/api/v2/products/stemcells-ubuntu-xenial/releases/579634/product_files/613151/download
export stemcell456PivnetProductName=light-bosh-stemcell-456.98-aws-xen-hvm-ubuntu-xenial-go_agent.tgz
export stemcell621PivnetUrl=https://network.pivotal.io/api/v2/products/stemcells-ubuntu-xenial/releases/640785/product_files/678940/download
export stemcell621PivnetProductName=light-bosh-stemcell-621.74-aws-xen-hvm-ubuntu-xenial-go_agent.tgz
export stemcell315PivnetUrl=https://network.pivotal.io/api/v2/products/stemcells-ubuntu-xenial/releases/626507/product_files/663626/download
export stemcell315PivnetProductName=light-bosh-stemcell-315.179-aws-xen-hvm-ubuntu-xenial-go_agent.tgz
export stemcell2019PivnetUrl=https://network.pivotal.io/api/v2/products/stemcells-windows-server/releases/630457/product_files/666943/download
export stemcell2019PivnetProductName=light-bosh-stemcell-2019.20-aws-xen-hvm-windows2019-go_agent.tgz
export stemcell250PivnetUrl=https://network.pivotal.io/api/v2/products/stemcells-ubuntu-xenial/releases/640793/product_files/678956/download
export stemcell250PivnetProductName=light-bosh-stemcell-250.196-aws-xen-hvm-ubuntu-xenial-go_agent.tgz
export stemcell170PivnetUrl=https://network.pivotal.io/api/v2/products/stemcells-ubuntu-xenial/releases/640795/product_files/678961/download
export stemcell170PivnetProductName=light-bosh-stemcell-170.219-aws-xen-hvm-ubuntu-xenial-go_agent.tgz
#SPECIFY REQUIRED PRODUCTS (TILES) FROM PIVOTAL NETWORK
export pasPivnetUrl=https://network.pivotal.io/api/v2/products/elastic-runtime/releases/582590/product_files/616376/download
export pasPivnetProductName=cf-2.8.4-build.16.pivotal
export pksPivnetUrl=https://network.pivotal.io/api/v2/products/pivotal-container-service/releases/551663/product_files/582811/download
export pksPivnetProductName=pivotal-container-service-1.6.1-build.6.pivotal
export harborPivnetUrl=https://network.pivotal.io/api/v2/products/harbor-container-registry/releases/579832/product_files/613396/download
export harborPivnetProductName=harbor-container-registry-1.10.1-build.7.pivotal
export mysqlPivnetUrl=https://network.pivotal.io/api/v2/products/pivotal-mysql/releases/584606/product_files/618567/download
export mysqlPivnetProductName=pivotal-mysql-2.7.6-build.21.pivotal
export rabbitmqPivnetUrl=https://network.pivotal.io/api/v2/products/p-rabbitmq/releases/601550/product_files/636892/download
export rabbitmqPivnetProductName=p-rabbitmq-1.18.4-build.83.pivotal
export paswindowsPivnetUrl=https://network.pivotal.io/api/v2/products/pas-windows/releases/625232/product_files/662163/download
export paswindowsPivnetProductName=pas-windows-2.9.1-build.2.pivotal
export redisPivnetUrl=https://network.pivotal.io/api/v2/products/p-redis/releases/626432/product_files/663536/download
export redisPivnetProductName=p-redis-2.3.3-build.2.pivotal
export awsservicebrokerPivnetUrl=https://network.pivotal.io/api/v2/products/aws-services/releases/567835/product_files/600335/download
export awsservicebrokerPivnetProductName=aws-services-1.4.16.256.pivotal
export credhubServiceBrokerPivnetUrl=https://network.pivotal.io/api/v2/products/credhub-service-broker/releases/527748/product_files/557009/download
export credhubServiceBrokerPivnetProductName=credhub-service-broker-1.4.7.pivotal
export wavefrontServiceBrokerPivnetUrl=https://network.pivotal.io/api/v2/products/wavefront-nozzle/releases/645941/product_files/684585/download
export wavefrontServiceBrokerPivnetProductName=wavefront-nozzle-2.1.0.pivotal
export azureServiceBrokerPivnetUrl=https://network.pivotal.io/api/v2/products/azure-service-broker/releases/632151/product_files/669713/download
export azureServiceBrokerPivnetProductName=azure-service-broker-1.11.5.pivotal
export gcpServiceBrokerPivnetUrl=https://network.pivotal.io/api/v2/products/gcp-service-broker/releases/553302/product_files/584574/download
export gcpServiceBrokerPivnetProductName=gcp-service-broker-5.0.1.pivotal
export scsServiceBrokerPivnetUrl=https://network.pivotal.io/api/v2/products/p-spring-cloud-services/releases/639962/product_files/678057/download
export scsServiceBrokerPivnetProductName=p_spring-cloud-services-3.1.10.pivotal
export scdfServiceBrokerPivnetUrl=https://network.pivotal.io/api/v2/products/p-dataflow/releases/603445/product_files/638972/download
export scdfServiceBrokerPivnetProductName=p-dataflow-1.7.0.pivotal
#DOWNLOAD REQUIRED STEMCELLS (HARDENED OS) TO RUN VARIOUS WORKLOADS AND PLATFORM COMPONENTS
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $stemcell456PivnetUrl -O "$stemcell456PivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $stemcell621PivnetUrl -O "$stemcell621PivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $stemcell315PivnetUrl -O "$stemcell315PivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $stemcell2019PivnetUrl -O "$stemcell2019PivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $stemcell250PivnetUrl -O "$stemcell250PivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $stemcell170PivnetUrl -O "$stemcell170PivnetProductName"
#DOWNLOAD REQUIRED PRODUCTS (TILES) FROM PIVOTAL NETWORK
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $pasPivnetUrl -O "$pasPivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $pksPivnetUrl -O "$pksPivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $harborPivnetUrl -O "$harborPivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $mysqlPivnetUrl -O "$mysqlPivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $rabbitmqPivnetUrl -O "$rabbitmqPivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $paswindowsPivnetUrl -O "$paswindowsPivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $redisPivnetUrl -O "$redisPivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $awsservicebrokerPivnetUrl -O "$awsservicebrokerPivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $credhubServiceBrokerPivnetUrl -O "$credhubServiceBrokerPivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $wavefrontServiceBrokerPivnetUrl -O "$wavefrontServiceBrokerPivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $azureServiceBrokerPivnetUrl -O "$azureServiceBrokerPivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $gcpServiceBrokerPivnetUrl -O "$gcpServiceBrokerPivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $scsServiceBrokerPivnetUrl -O "$scsServiceBrokerPivnetProductName"
sudo wget --post-data="" --header="Authorization: Token $pivnetToken" $scdfServiceBrokerPivnetUrl -O "$scdfServiceBrokerPivnetProductName"
#DERIVE THE UAA AUTHENTICATION TOKEN FOR OPS MANAGER
export uaaToken=$( sudo curl -s -k -H 'Accept: application/json;charset=utf-8' -d 'grant_type=password' -d 'username=admin' -d 'password=admin' \
  -u 'opsman:' https://localhost/uaa/oauth/token |  jq --raw-output '.access_token' )
#UPLOAD THE STEMCELLS TO OPS MANAGER
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/stemcells -F \
  'stemcell[file]=@'"$stemcell456PivnetProductName"''
sudo rm -rf $stemcell456PivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/stemcells -F \
  'stemcell[file]=@'"$stemcell621PivnetProductName"''
sudo rm -rf $stemcell621PivnetProductName  
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/stemcells -F \
  'stemcell[file]=@'"$stemcell315PivnetProductName"''
sudo rm -rf $stemcell315PivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/stemcells -F \
  'stemcell[file]=@'"$stemcell2109PivnetProductName"''
sudo rm -rf $stemcell2019PivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/stemcells -F \
  'stemcell[file]=@'"$stemcell250PivnetProductName"''  
sudo rm -rf $stemcell250PivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/stemcells -F \
	  'stemcell[file]=@'"$stemcell170PivnetProductName"''
sudo rm -rf $stemcell170PivnetProductName
#UPLOAD THE PRODUCT TILES TO OPS MANAGER
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$pasPivnetProductName"''
sudo rm -rf $pasPivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$pksPivnetProductName"''
sudo rm -rf $pksPivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$harborPivnetProductName"''
sudo rm -rf $harborPivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$mysqlPivnetProductName"''
sudo rm -rf $mysqlPivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$rabbitmqPivnetProductName"''
sudo rm -rf $rabbitmqPivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$paswindowsPivnetProductName"''  
sudo rm -rf $paswindowsPivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$redisPivnetProductName"''
sudo rm -rf $redisPivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$awsservicebrokerPivnetProductName"''
sudo rm -rf $awsservicebrokerPivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$credhubServiceBrokerPivnetProductName"''
sudo rm -rf $credhubServiceBrokerPivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$wavefrontServiceBrokerPivnetProductName"''
sudo rm -rf $wavefrontServiceBrokerPivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$azureServiceBrokerPivnetProductName"''
sudo rm -rf $azureServiceBrokerPivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$gcpServiceBrokerPivnetProductName"''
sudo rm -rf $gcpServiceBrokerPivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$scsServiceBrokerPivnetProductName"''
sudo rm -rf $scsServiceBrokerPivnetProductName
sudo curl -vv --progress-bar -H 'Authorization: bearer '"$uaaToken"'' -k -X POST https://localhost/api/v0/available_products -F \
  'product[file]=@'"$scdfServiceBrokerPivnetProductName"''
sudo rm -rf $scdfServiceBrokerPivnetProductName
#STAGE PRODUCT TILES
curl "https://localhost/api/v0/staged/products" -k \
  -X POST \
  -H 'Authorization: Bearer '"$uaaToken"'' \
  -H "Content-Type: application/json" \
  -d '{"name": "cf", "product_version": "2.8.4"}'
curl "https://localhost/api/v0/staged/products" -k \
  -X POST \
  -H 'Authorization: Bearer '"$uaaToken"'' \
  -H "Content-Type: application/json" \
  -d '{"name": "pivotal-container-service", "product_version": "1.6.1-build.6"}'
curl "https://localhost/api/v0/staged/products" -k \
  -X POST \
  -H 'Authorization: Bearer '"$uaaToken"'' \
  -H "Content-Type: application/json" \
  -d '{"name": "harbor-container-registry", "product_version": "1.10.1-build.7"}'
curl "https://localhost/api/v0/staged/products" -k \
  -X POST \
  -H 'Authorization: Bearer '"$uaaToken"'' \
  -H "Content-Type: application/json" \
  -d '{"name": "pivotal-mysql", "product_version": "2.7.6-build.21"}'
curl "https://localhost/api/v0/staged/products" -k \
  -X POST \
  -H 'Authorization: Bearer '"$uaaToken"'' \
  -H "Content-Type: application/json" \
  -d '{"name": "p-redis", "product_version": "2.3.3-build.2"}'
curl "https://localhost/api/v0/staged/products" -k \
  -X POST \
  -H 'Authorization: Bearer '"$uaaToken"'' \
  -H "Content-Type: application/json" \
  -d '{"name": "p-rabbitmq", "product_version": "1.18.4-build.83"}'
curl "https://localhost/api/v0/staged/products" -k \
  -X POST \
  -H 'Authorization: Bearer '"$uaaToken"'' \
  -H "Content-Type: application/json" \
  -d '{"name": "aws-services", "product_version": "1.4.16"}'
curl "https://localhost/api/v0/staged/products" -k \
  -X POST \
  -H 'Authorization: Bearer '"$uaaToken"'' \
  -H "Content-Type: application/json" \
  -d '{"name": "wavefront-nozzle", "product_version": "2.1.0"}'
curl "https://localhost/api/v0/staged/products" -k \
  -X POST \
  -H 'Authorization: Bearer '"$uaaToken"'' \
  -H "Content-Type: application/json" \
  -d '{"name": "credhub-service-broker", "product_version": "1.4.7"}'
curl "https://localhost/api/v0/staged/products" -k \
  -X POST \
  -H 'Authorization: Bearer '"$uaaToken"'' \
  -H "Content-Type: application/json" \
  -d '{"name": "azure-service-broker", "product_version": "1.11.5"}'
curl "https://localhost/api/v0/staged/products" -k \
  -X POST \
  -H 'Authorization: Bearer '"$uaaToken"'' \
  -H "Content-Type: application/json" \
  -d '{"name": "gcp-service-broker", "product_version": "5.0.1"}'
curl "https://localhost/api/v0/staged/products" -k \
  -X POST \
  -H 'Authorization: Bearer '"$uaaToken"'' \
  -H "Content-Type: application/json" \
  -d '{"name": "p_spring-cloud-services", "product_version": "3.1.10"}'
curl "https://localhost/api/v0/staged/products" -k \
  -X POST \
  -H 'Authorization: Bearer '"$uaaToken"'' \
  -H "Content-Type: application/json" \
  -d '{"name": "p-dataflow", "product_version": "1.7.0"}'
#DISABLE DNS WILDCARD VERIFIER FOR TAS/PAS
export pasguid=$( curl "https://localhost/api/v0/staged/products" -k \
  -X GET \
  -H 'Authorization: Bearer '"$uaaToken"'' \
  | jq --raw-output '.[] | select(.installation_name|test("cf-.")) | .guid')
echo "PAS GU-ID is: $pasguid"
curl "https://localhost/api/v0/staged/products/$pasguid/verifiers/install_time/WildcardDomainVerifier" -k \
  -X PUT \
  -H 'Authorization: Bearer '"$uaaToken"'' \
  -H "Content-Type: application/json" \
  -d '{ "enabled": false }'
sudo rm -rf /home/ubuntu/token
sudo rm -rf /home/ubuntu/dns
