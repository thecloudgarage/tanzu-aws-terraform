output "TANZU_OPS_MANAGER_EIP_NEW_IP" {
  value       = <<-EOF

  Apply a DNS CNAME entry for tanzu-opsman.${var.rootDomain} with the following AWS Elastic IP "${aws_eip.TANZU_OPS_MANAGER_EIP_NEW.public_ip}"
 
  Furthermore, apply the below DNS CNAME entries for TAS/PAS. All traffic for TAS/PAS platform and apps will hit the GoRouter via the Load Balancer

  *.sys.${var.rootDomain}	${aws_lb.TANZU_NLB_WEB.dns_name}
  *.apps.${var.rootDomain}	${aws_lb.TANZU_NLB_WEB.dns_name}
  *.api.sys.${var.rootDomain}	${aws_lb.TANZU_NLB_WEB.dns_name}
  *.login.sys.${var.rootDomain}	${aws_lb.TANZU_NLB_WEB.dns_name}
  *.uaa.sys.${var.rootDomain}	${aws_lb.TANZU_NLB_WEB.dns_name}

  Next, apply the DNS CNAME entries for TKG-I/PKS & HARBOR

  api.pks.${var.rootDomain}	${aws_lb.TANZU_NLB_TKG_I_HARBOR.dns_name}
  harbor.${var.rootDomain}	${aws_lb.TANZU_NLB_TKG_I_HARBOR.dns_name}

  OPTIONAL: An IAM admin user is created in case of any requirements. The IAM access_key_id & access_key_secret is listed below
  USE WITH DISCRETION. IAM credentials for ${aws_iam_user.TANZU_IAM_USER_NEW.name} are:
  access_key_id: ${aws_iam_access_key.access_key_new.id}
  access_key_secret: ${aws_iam_access_key.access_key_new.secret}
  
  Once DNS entries are done, execute the below steps:
  
  * Browse to https://tanzu-opsman.${var.rootDomain} and login with the credentials admin/admin
  * You can click on Apply Changes. All products are already configured via terraform scripts. Go ahead and apply changes and it will take about 2.5 to 3 hours
  
  ALTERNATIVELY, you can do a selective install. Instead of applying changes and having the default selection for all products
  * Click on Apply Changes > Deselect all products and only select BOSH Director
  * The changes will take about 30 minutes to setup the BOSH director. You can disconnect your browser session without a hassle
  * Next, you can apply changes individually for each product, preferably starting with
    - PAS
    - PKS
    - Harbor
    - MySQL
  
  Next, SSH into the ops manager using the PEM encoded key named "tanzu" auto-generated under the parent directory
  
  The command below auto-populates the ELASTIC IP for the ops manager. So if you are in the parent directory, use the below command as-is

  ssh -i tanzu ubuntu@${aws_eip.TANZU_OPS_MANAGER_EIP_NEW.public_ip}
  
  * Once logged in "sudo su" to assume root privileges and navigate to the directory /home/ubuntu/scripts/bosh
  * Run the bosh-automate-login.sh ... This will automatically grep the required tokens and set the BOSH profile for various operations
  * In order for the profile to take effect source the below two files

  source ~/.profile
  source ~/.bashrc

  * Run the command "bosh vms" to verify login and related aspects

  Next you can navigate to cf-push or pks-k8s to conduct different setups. Verified scripts are placed in the respective directories
  
  EOF
  
}

