#!/bin/bash
while :
do
	echo $(curl http://a16b42b91f2c34b418c837e41f56e472-45fe8de2f82981f2.elb.us-east-2.amazonaws.com:8080/jboss-healthcheck/HelloWorld)
	sleep 5
done
