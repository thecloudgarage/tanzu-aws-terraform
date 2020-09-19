#!/bin/bash
rm -rf singleLineSshKeys
cp tanzu singleLineSshKeys
sed -i -n '1h;2,$H;${g;s/\n//g;s/<----- \(BEGIN\|END\) ----->//g;p}' singleLineSshKeys
read keys < singleLineSshKeys
sed -i "s@AwsSshKeys@$keys@" ./installsettings/fresh/installsettings.json
