#!/bin/bash
#prepare and deploy the SSH keys for BOSH director configuration
cp ../../tanzu singleLineSshKeys
mv *.crt awsPlatformCerts
mv *.key awsPlatformKeys
perl -i -pe "chomp if eof" singleLineSshKeys
perl -i -pe "chomp if eof" awsPlatformCerts
perl -i -pe "chomp if eof" awsPlatformKeys
sed -i ':a;N;$!ba;s/\n/\\r\\n/g' singleLineSshKeys
sed -i ':a;N;$!ba;s/\n/\\n/g' awsPlatformCerts
sed -i ':a;N;$!ba;s/\n/\\n/g' awsPlatformKeys
perl -pe 's/awsSshKeys/`cat singleLineSshKeys`/ge' -i ../installsettings/installsettings.json
perl -pe 's/awsPlatformCerts/`cat awsPlatformCerts`/ge' -i ../installsettings/installsettings.json
perl -pe 's/awsPlatformKeys/`cat awsPlatformKeys`/ge' -i ../installsettings/installsettings.json
