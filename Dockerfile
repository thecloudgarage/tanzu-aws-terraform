FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update
RUN apt-get install -y software-properties-common
RUN apt-get -y install sudo
#setup timezone
RUN apt-get install -y tzdata
RUN echo "Asia/Bangkok" > /etc/timezone \
    rm /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata
#setup git
RUN apt-get install -y git

#setup nano
RUN apt-get install -y nano
RUN apt-get install -y zip
RUN apt-get install -y curl
RUN apt-get install -y vim
RUN sudo apt install jq -y
RUN apt install wget -y
RUN apt install unzip -y
RUN apt-get update -y
#Install AWS CLI
RUN apt-get install awscli -y
#Install Terraform
RUN wget https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip
RUN unzip ./terraform_0.11.13_linux_amd64.zip -d /usr/local/bin/
#Install KOPS
RUN curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
RUN chmod +x kops
RUN sudo mv kops /usr/local/bin/
#Install CLOUDFOUNDRY CLI
RUN wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
RUN echo "deb https://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list
RUN apt-get update -y
RUN apt-get install cf-cli -y

#Install KUBECTL
RUN curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

#Install HELM version 3
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh
RUN helm repo add stable https://kubernetes-charts.storage.googleapis.com/

#Install google-cloud-sdk for gcloud cli
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk -y

COPY tanzu-aws /home/ubuntu/tanzu-aws
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

USER docker
CMD /bin/bash
