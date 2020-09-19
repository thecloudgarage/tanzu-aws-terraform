provider "aws" {
        region     = "${var.region}"
  profile = "${var.profile}"
} # end provider

# create the VPC
resource "aws_vpc" "TANZU_VPC" {
  cidr_block           = "${var.vpcCIDRblock}"
  instance_tenancy     = "${var.instanceTenancy}"
  enable_dns_support   = "${var.dnsSupport}"
  enable_dns_hostnames = "${var.dnsHostNames}"
tags = {
    Name = "TANZU_VPC"
  }
} # end resource

# create the Subnet
resource "aws_subnet" "TANZU_VPC_INFRA_AZ1" {
  vpc_id                  = "${aws_vpc.TANZU_VPC.id}"
  cidr_block              = "${var.ipINFRA_AZ1}"
  map_public_ip_on_launch = "${var.mapPublicIP}"
  availability_zone       = "${var.AZ1}"
tags = {
   Name = "TANZU_VPC_INFRA_AZ1"
  }
} # end resource

# create the Subnet
resource "aws_subnet" "TANZU_VPC_INFRA_AZ2" {
  vpc_id                  = "${aws_vpc.TANZU_VPC.id}"
  cidr_block              = "${var.ipINFRA_AZ2}"
  map_public_ip_on_launch = "${var.mapPublicIP}"
  availability_zone       = "${var.AZ2}"
tags = {
   Name = "TANZU_VPC_INFRA_AZ2"
  }
} # end resource

# create the Subnet
resource "aws_subnet" "TANZU_VPC_TAS_AZ1" {
  vpc_id                  = "${aws_vpc.TANZU_VPC.id}"
  cidr_block              = "${var.ipTAS_AZ1}"
  map_public_ip_on_launch = "${var.mapPublicIP}"
  availability_zone       = "${var.AZ1}"
tags = {
   Name = "TANZU_VPC_TAS_AZ1"
  }
} # end resource

# create the Subnet
resource "aws_subnet" "TANZU_VPC_TAS_AZ2" {
  vpc_id                  = "${aws_vpc.TANZU_VPC.id}"
  cidr_block              = "${var.ipTAS_AZ2}"
  map_public_ip_on_launch = "${var.mapPublicIP}"
  availability_zone       = "${var.AZ2}"
tags = {
   Name = "TANZU_VPC_TAS_AZ2"
  }
} # end resource

# create the Subnet
resource "aws_subnet" "TANZU_VPC_TKG_I_AZ1" {
  vpc_id                  = "${aws_vpc.TANZU_VPC.id}"
  cidr_block              = "${var.ipTKG_I_AZ1}"
  map_public_ip_on_launch = "${var.mapPublicIP}"
  availability_zone       = "${var.AZ1}"
tags = {
   Name = "TANZU_VPC_TKG_I_AZ1"
  }
} # end resource

# create the Subnet
resource "aws_subnet" "TANZU_VPC_TKG_I_AZ2" {
  vpc_id                  = "${aws_vpc.TANZU_VPC.id}"
  cidr_block              = "${var.ipTKG_I_AZ2}"
  map_public_ip_on_launch = "${var.mapPublicIP}"
  availability_zone       = "${var.AZ2}"
tags = {
   Name = "TANZU_VPC_TKG_I_AZ2"
  }
} # end resource

# create the Subnet
resource "aws_subnet" "TANZU_VPC_SERVICES_AZ1" {
  vpc_id                  = "${aws_vpc.TANZU_VPC.id}"
  cidr_block              = "${var.ipSERVICES_AZ1}"
  map_public_ip_on_launch = "${var.mapPublicIP}"
  availability_zone       = "${var.AZ1}"
tags = {
   Name = "TANZU_VPC_SERVICES_AZ1"
  }
} # end resource

# create the Subnet
resource "aws_subnet" "TANZU_VPC_SERVICES_AZ2" {
  vpc_id                  = "${aws_vpc.TANZU_VPC.id}"
  cidr_block              = "${var.ipSERVICES_AZ2}"
  map_public_ip_on_launch = "${var.mapPublicIP}"
  availability_zone       = "${var.AZ2}"
tags = {
   Name = "TANZU_VPC_SERVICES_AZ2"
  }
} # end resource

# Create the Security Group
resource "aws_security_group" "TANZU_VPC_Security_Group" {
  vpc_id       = "${aws_vpc.TANZU_VPC.id}"
  name         = "PCF_VPC_Security_Group"
  description  = "PCF_VPC_Security_Group"
ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
tags = {
        Name = "TANZU_VPC_Security_Group"
  }
}
# end resource

# create VPC Network access control list
resource "aws_network_acl" "TANZU_VPC_Security_ACL" {
  vpc_id = "${aws_vpc.TANZU_VPC.id}"
  subnet_ids = [ "${aws_subnet.TANZU_VPC_INFRA_AZ1.id}","${aws_subnet.TANZU_VPC_INFRA_AZ2.id}","${aws_subnet.TANZU_VPC_TAS_AZ1.id}","${aws_subnet.TANZU_VPC_TAS_AZ2.id
}","${aws_subnet.TANZU_VPC_TKG_I_AZ1.id}","${aws_subnet.TANZU_VPC_TKG_I_AZ2.id}","${aws_subnet.TANZU_VPC_SERVICES_AZ1.id}","${aws_subnet.TANZU_VPC_SERVICES_AZ2.id}" ]
# allow port 22
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
tags = {
    Name = "TANZU_VPC_Security_ACL"
  }
} # end resource

# Create the Internet Gateway
resource "aws_internet_gateway" "TANZU_VPC_IGW" {
  vpc_id = "${aws_vpc.TANZU_VPC.id}"
tags = {
        Name = "TANZU_VPC_IGW"
    }
} # end resource
# Create the Route Table
resource "aws_route_table" "TANZU_VPC_RT" {
    vpc_id = "${aws_vpc.TANZU_VPC.id}"
tags = {
        Name = "TANZU_VPC_RT"
    }
} # end resource

# Create the Internet Access
resource "aws_route" "TANZU_VPC_internet_access" {
  route_table_id        = "${aws_route_table.TANZU_VPC_RT.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.TANZU_VPC_IGW.id}"
} # end resource
# Associate the Route Table with the Subnet
resource "aws_route_table_association" "TANZU_VPC_INFRA_AZ1_association" {
    subnet_id      = "${aws_subnet.TANZU_VPC_INFRA_AZ1.id}"
    route_table_id = "${aws_route_table.TANZU_VPC_RT.id}"
} # end resource
resource "aws_route_table_association" "TANZU_VPC_INFRA_AZ2_association" {
    subnet_id      = "${aws_subnet.TANZU_VPC_INFRA_AZ2.id}"
    route_table_id = "${aws_route_table.TANZU_VPC_RT.id}"
} # end resource
resource "aws_route_table_association" "TANZU_VPC_TAS_AZ1_association" {
    subnet_id      = "${aws_subnet.TANZU_VPC_TAS_AZ1.id}"
    route_table_id = "${aws_route_table.TANZU_VPC_RT.id}"
} # end resource
resource "aws_route_table_association" "TANZU_VPC_TAS_AZ2_association" {
    subnet_id      = "${aws_subnet.TANZU_VPC_TAS_AZ2.id}"
    route_table_id = "${aws_route_table.TANZU_VPC_RT.id}"
} # end resource
resource "aws_route_table_association" "TANZU_VPC_TKG_I_AZ1_association" {
    subnet_id      = "${aws_subnet.TANZU_VPC_TKG_I_AZ1.id}"
    route_table_id = "${aws_route_table.TANZU_VPC_RT.id}"
} # end resource
resource "aws_route_table_association" "TANZU_VPC_TKG_I_AZ2_association" {
    subnet_id      = "${aws_subnet.TANZU_VPC_TKG_I_AZ2.id}"
    route_table_id = "${aws_route_table.TANZU_VPC_RT.id}"
} # end resource
resource "aws_route_table_association" "TANZU_VPC_SERVICES_AZ1_association" {
    subnet_id      = "${aws_subnet.TANZU_VPC_SERVICES_AZ1.id}"
    route_table_id = "${aws_route_table.TANZU_VPC_RT.id}"
} # end resource
resource "aws_route_table_association" "TANZU_VPC_SERVICES_AZ2_association" {
    subnet_id      = "${aws_subnet.TANZU_VPC_SERVICES_AZ2.id}"
    route_table_id = "${aws_route_table.TANZU_VPC_RT.id}"
} # end resource

#CREATE NETWORK LOAD BALANCER FOR TAS ALONGWITH TARGET GROUPS

resource "aws_lb" "TANZU_NLB_WEB" {
  name                             = "TANZU-NLB-WEB"
  load_balancer_type               = "network"
  depends_on                       = ["aws_internet_gateway.TANZU_VPC_IGW","aws_subnet.TANZU_VPC_TAS_AZ1","aws_subnet.TANZU_VPC_TAS_AZ2"]
  enable_cross_zone_load_balancing = true
  subnets                          = ["${aws_subnet.TANZU_VPC_TAS_AZ1.id}","${aws_subnet.TANZU_VPC_TAS_AZ2.id}"]
}

resource "aws_lb_listener" "TANZU_NLB_WEB_HTTP" {
  load_balancer_arn = "${aws_lb.TANZU_NLB_WEB.arn}"
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.TANZU_NLB_WEB_HTTP.arn}"
  }
}

resource "aws_lb_listener" "TANZU_NLB_WEB_HTTPS" {
  load_balancer_arn = "${aws_lb.TANZU_NLB_WEB.arn}"
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.TANZU_NLB_WEB_HTTPS.arn}"
  }
}

resource "aws_lb_target_group" "TANZU_NLB_WEB_HTTP" {
  name     = "TANZU-NLB-WEB-HTTP"
  depends_on = ["aws_vpc.TANZU_VPC"]
  port     = 80
  protocol = "TCP"
  vpc_id   = "${aws_vpc.TANZU_VPC.id}"

  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_target_group" "TANZU_NLB_WEB_HTTPS" {
  name     = "TANZU-NLB-WEB-HTTPS"
  depends_on = ["aws_vpc.TANZU_VPC"]
  port     = 443
  protocol = "TCP"
  vpc_id   = "${aws_vpc.TANZU_VPC.id}"

  health_check {
    protocol = "TCP"
  }
}

#CREATE NETWORK-LOAD-BALANCERS FOR TKG-I AND HARBOR

resource "aws_lb" "TANZU_NLB_TKG_I_HARBOR" {
  name                             = "TANZU-NLB-TKG-I-HARBOR"
  load_balancer_type               = "network"
  depends_on                       = ["aws_internet_gateway.TANZU_VPC_IGW","aws_subnet.TANZU_VPC_TKG_I_AZ1","aws_subnet.TANZU_VPC_TKG_I_AZ2"]
  enable_cross_zone_load_balancing = true
  subnets                          = ["${aws_subnet.TANZU_VPC_TKG_I_AZ1.id}","${aws_subnet.TANZU_VPC_TKG_I_AZ2.id}"]
}

resource "aws_lb_listener" "TANZU_NLB_TKG_I_8443" {
  load_balancer_arn = "${aws_lb.TANZU_NLB_TKG_I_HARBOR.arn}"
  port              = 8443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.TANZU_NLB_TKG_I_8443.arn}"
  }
}

resource "aws_lb_listener" "TANZU_NLB_TKG_I_9021" {
  load_balancer_arn = "${aws_lb.TANZU_NLB_TKG_I_HARBOR.arn}"
  port              = 9021
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.TANZU_NLB_TKG_I_9021.arn}"
  }
}

resource "aws_lb_target_group" "TANZU_NLB_TKG_I_8443" {
  name     = "TANZU-NLB-TKG-I-8443"
  depends_on = ["aws_vpc.TANZU_VPC"]
  port     = 8443
  protocol = "TCP"
  vpc_id   = "${aws_vpc.TANZU_VPC.id}"

  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_target_group" "TANZU_NLB_TKG_I_9021" {
  name     = "TANZU-NLB-TKG-I-9021"
  depends_on = ["aws_vpc.TANZU_VPC"]
  port     = 9021
  protocol = "TCP"
  vpc_id   = "${aws_vpc.TANZU_VPC.id}"

  health_check {
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "TANZU_NLB_HARBOR_443" {
  load_balancer_arn = "${aws_lb.TANZU_NLB_TKG_I_HARBOR.arn}"
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.TANZU_NLB_HARBOR_443.arn}"
  }
}

resource "aws_lb_target_group" "TANZU_NLB_HARBOR_443" {
  name     = "TANZU-NLB-HARBOR-443"
  depends_on = ["aws_vpc.TANZU_VPC"]
  port     = 443
  protocol = "TCP"
  vpc_id   = "${aws_vpc.TANZU_VPC.id}"

  health_check {
    protocol = "TCP"
  }
}

#CREATE IAM ROLE, POLICY, PROFILE AND ADMIN USER

resource "aws_iam_role" "TANZU_IAM_ROLE_NEW" {
  name               = "TANZU_IAM_ROLE_NEW"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "TANZU_IAM_INSTANCE_PROFILE_NEW" {
  name  = "TANZU_IAM_INSTANCE_PROFILE_NEW"
  role = "${aws_iam_role.TANZU_IAM_ROLE_NEW.name}"
}

resource "aws_iam_user" "TANZU_IAM_USER_NEW" {
    name = "TANZU_IAM_USER_NEW"
    path = "/"
}

resource "aws_iam_access_key" "access_key_new" {
    user = "${aws_iam_user.TANZU_IAM_USER_NEW.name}"
}

resource "aws_iam_policy" "TANZU_IAM_POLICY_NEW" {
    name = "TANZU_IAM_POLICY_NEW"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "TANZU_IAM_ROLE_POLICY_ATTACH_NEW" {
  name       = "TANZU_IAM_ROLE_POLICY_ATTACH_NEW"
  roles      = ["${aws_iam_role.TANZU_IAM_ROLE_NEW.name}"]
  users      = ["${aws_iam_user.TANZU_IAM_USER_NEW.name}"]
  policy_arn = "${aws_iam_policy.TANZU_IAM_POLICY_NEW.arn}"
}

#CREATE SSH PRIVATE AND PUBLIC KEYS

resource "tls_private_key" "key" {
  algorithm = "RSA"
}
resource "local_file" "key_priv" {
  content  = "${tls_private_key.key.private_key_pem}"
  filename = "tanzu"
}

resource "null_resource" "key_chown" {
  provisioner "local-exec" {
    command = "chmod 400 tanzu"
  }

  depends_on = ["local_file.key_priv"]
}

resource "null_resource" "key_gen" {
  provisioner "local-exec" {
    command = "rm -f tanzu.pub && ssh-keygen -y -f tanzu > tanzu.pub"
  }

  depends_on = ["local_file.key_priv"]
}

data "local_file" "key_pub" {
  filename = "tanzu.pub"

  depends_on = ["null_resource.key_gen"]
}

resource "aws_key_pair" "key_tf" {
  public_key = "${data.local_file.key_pub.content}"
  key_name = "tanzu"
}

#CREATE THE OPS MANAGER EC2 INSTANCE

resource "aws_instance" "TANZU_OPS_MANAGER" {
  depends_on             = ["aws_iam_instance_profile.TANZU_IAM_INSTANCE_PROFILE_NEW"]
  ami                    = "${var.TANZU_OPS_MANAGER_AMI}"
  instance_type          = "${var.TANZU_OPS_MANAGER_INSTANCE_TYPE}"
  iam_instance_profile = "${aws_iam_instance_profile.TANZU_IAM_INSTANCE_PROFILE_NEW.name}"
  root_block_device {
    volume_type = "gp2"
    volume_size = "160"
    delete_on_termination = "true"
  }
  vpc_security_group_ids = ["${aws_security_group.TANZU_VPC_Security_Group.id}"]
  key_name      = "${aws_key_pair.key_tf.key_name}"
  subnet_id = "${aws_subnet.TANZU_VPC_INFRA_AZ1.id}"
  tags = {
    Name = "TANZU_OPS_MANAGER"
  }
}

#ASSIGN ELASTIC IP TO OPS MANAGER
resource "aws_eip" "TANZU_OPS_MANAGER_EIP_NEW" {
  instance = "${aws_instance.TANZU_OPS_MANAGER.id}"
  vpc      = true
}

#PREPARE AND EXECUTE DEPLOYMENT SCRIPTS

resource "null_resource" "opsman-ssh-connection" {
  depends_on = ["aws_instance.TANZU_OPS_MANAGER"]
  provisioner "local-exec" {
    command = "sleep 2m"
    }
  provisioner "local-exec" {
    command = "cp -r ../scripts/post-deploy-scripts/ ./scripts/ && cp -r ../scripts/pre-deploy-scripts/awsInstallTools.sh ./scripts/bootstrap/"
    }
  provisioner "local-exec" {
    command = "cd ./scripts/bootstrap && cp awsInstallTools.sh awsInstallToolsExecute.sh && cp awsTanzuOpsmanDeploy.sh awsTanzuOpsmanDeployExecute.sh"
    }
  provisioner "local-exec" {
    command = "sed -i 's/variablePivnetToken/${var.pivnetToken}/g' ./scripts/bootstrap/awsInstallToolsExecute.sh"
    }
  provisioner "local-exec" {
    command = "sed -i 's/variablePivnetToken/${var.pivnetToken}/g' ./scripts/bootstrap/awsTanzuOpsmanDeployExecute.sh"
    }
  provisioner "local-exec" {
    command = "sed -i 's/variableTanzuOpsmanDnsName/${var.tanzuOpsmanDnsName}/g' ./scripts/bootstrap/awsTanzuOpsmanDeployExecute.sh"
    }
  provisioner "local-exec" {
    command = "rm -rf ./scripts/installsettings/installsettings.json"
    }
  provisioner "local-exec" {
    command = "cp ./scripts/installsettings/installSettingsInput.json ./scripts/installsettings/installsettings.json"
    }
  provisioner "local-exec" {
    command = "sed -i 's/awsRegion/${var.region}/g' ./scripts/installsettings/installsettings.json"
    }
  provisioner "local-exec" {
    command = "sed -i 's/awsAz1/${var.AZ1}/g' ./scripts/installsettings/installsettings.json"
    }
  provisioner "local-exec" {
    command = "sed -i 's/awsAz2/${var.AZ2}/g' ./scripts/installsettings/installsettings.json"
    }
  provisioner "local-exec" {
    command = "sed -i 's/awsSecurityGroup/${aws_security_group.TANZU_VPC_Security_Group.id}/g' ./scripts/installsettings/installsettings.json"
    }
  provisioner "local-exec" {
    command = "sed -i 's/awsInfraAz1/${aws_subnet.TANZU_VPC_INFRA_AZ1.id}/g' ./scripts/installsettings/installsettings.json"
    }
  provisioner "local-exec" {
    command = "sed -i 's/awsInfraAz2/${aws_subnet.TANZU_VPC_INFRA_AZ2.id}/g' ./scripts/installsettings/installsettings.json"
    }
  provisioner "local-exec" {
    command = "sed -i 's/awsTasAz1/${aws_subnet.TANZU_VPC_TAS_AZ1.id}/g' ./scripts/installsettings/installsettings.json"
    }
  provisioner "local-exec" {
    command = "sed -i 's/awsTasAz2/${aws_subnet.TANZU_VPC_TAS_AZ2.id}/g' ./scripts/installsettings/installsettings.json"
    }
  provisioner "local-exec" {
    command = "sed -i 's/awsTkgIAz1/${aws_subnet.TANZU_VPC_TKG_I_AZ1.id}/g' ./scripts/installsettings/installsettings.json"
    }
  provisioner "local-exec" {
    command = "sed -i 's/awsTkgIAz2/${aws_subnet.TANZU_VPC_TKG_I_AZ2.id}/g' ./scripts/installsettings/installsettings.json"
    }
  provisioner "local-exec" {
    command = "sed -i 's/awsServicesAz1/${aws_subnet.TANZU_VPC_SERVICES_AZ1.id}/g' ./scripts/installsettings/installsettings.json"
    }
  provisioner "local-exec" {
    command = "sed -i 's/awsServicesAz2/${aws_subnet.TANZU_VPC_SERVICES_AZ2.id}/g' ./scripts/installsettings/installsettings.json"
    }
  provisioner "local-exec" {
    command = "sed -i 's/rootDomain/${var.rootDomain}/g' ./scripts/installsettings/installsettings.json"
    }
  provisioner "local-exec" {
    command = "cp ./scripts/certsKeys/genCerts.sh ./scripts/certsKeys/genCertsExecute.sh"
    }
  provisioner "local-exec" {
    command = "sed -i 's/rootDomain/${var.rootDomain}/g' ./scripts/certsKeys/genCertsExecute.sh"
    }
  provisioner "local-exec" {
    command = "cd ./scripts/certsKeys && chmod +x genCertsExecute.sh && bash genCertsExecute.sh"
    }
  provisioner "local-exec" {
    command = "cd ./scripts/certsKeys && rm -rf genCertsExecute.sh"
    }
  provisioner "local-exec" {
    command = "cd ./scripts/certsKeys && chmod +x installSettingsCertsKeys.sh && bash installSettingsCertsKeys.sh"
    }
  provisioner "file" {
    source = "./scripts"
    destination = "/home/ubuntu"
    connection {
      host        = "${aws_eip.TANZU_OPS_MANAGER_EIP_NEW.public_ip}"
      type        = "ssh"
      port        = 22
      user        = "ubuntu"
      private_key = "${tls_private_key.key.private_key_pem}"
      timeout     = "1m"
      agent       = false
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod -R +x /home/ubuntu/scripts",
      "cd /home/ubuntu/scripts/bootstrap",
      "sudo ./awsInstallToolsExecute.sh",
      "sudo ./awsTanzuOpsmanDeployExecute.sh",
      "cd /home/ubuntu/scripts/installsettings",
      "sudo ./deploy-installsettings.sh",
      "cd /home/ubuntu/scripts/bootstrap",
      "sudo ./disableWildcardVerifier.sh",
      "sudo rm -rf /home/ubuntu/scripts/installsettings",
      "sudo rm -rf /home/ubuntu/scripts/bootstrap",
      "sudo rm -rf /home/ubuntu/scripts/certsKeys"
    ]
      connection {
      host        = "${aws_eip.TANZU_OPS_MANAGER_EIP_NEW.public_ip}"
      type        = "ssh"
      port        = 22
      user        = "ubuntu"
      private_key = "${tls_private_key.key.private_key_pem}"
      timeout     = "1m"
      agent       = false
    }
  }
  provisioner "local-exec" {
    command = "rm -rf ./scripts/bootstrap/awsInstallToolsExecute.sh && rm -rf ./scripts/bootstrap/awsTanzuOpsmanDeployExecute.sh"
    }
  provisioner "local-exec" {
    command = "rm -rf ./scripts/certsKeys/singleLineSshKeys"
    }
}
