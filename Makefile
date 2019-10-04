general:
	# Install general requirements
	apt-get update
	apt-get upgrade -y
	apt-get install -y python3-pip
	pip3 install pylint
	apt-get install -y tidy
	apt-get install -y jq
	curl -LO https://github.com/hadolint/hadolint/releases/download/v1.17.2/hadolint-Linux-x86_64
	chmod +x hadolint-Linux-x86_64
	mv hadolint-Linux-x86_64 /usr/local/bin/hadolint
	# Install kubectl
	curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.14.4/bin/linux/amd64/kubectl
	chmod +x kubectl
	mv kubectl /usr/bin
	@echo "\nalias h=history" >> ~/.bashrc
	@echo "\nalias k=kubectl" >> ~/.bashrc
	@echo "\nsource <(kubectl completion bash | sed s/kubectl/k/g)" >> ~/.bashrc

amazon:
	# AWS specific packages
	pip3 install awscli
	# Install eksctl
	curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
	sudo mv /tmp/eksctl /usr/local/bin
	@eksctl version

docker:
	# Install Docker
	curl -fsSL https://get.docker.com/ | sh
	systemctl enable docker
	systemctl start docker
	@echo "\nDocker installation finished.\n"

jenkins:
	# Install Jenkins
	apt install -y default-jdk
	wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | apt-key add -
	sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
	apt-get update
	apt-get install -y jenkins
	usermod -a -G docker jenkins
	systemctl restart jenkins
	@echo "\nJenkins installation finished.\n"

minikube:
	# Install Minikube
	curl -LO minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	chmod +x minikube
	install minikube /usr/local/bin
	apt-get install socat -y
	minikube start --vm-driver=none --kubernetes-version v1.14.4
	@kubectl cluster-info

helm:
	# Install Helm
	curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
	chmod 700 get_helm.sh
	./get_helm.sh
	kubectl create serviceaccount -n kube-system tiller
	kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
	helm init --service-account tiller
	@kubectl --namespace kube-system get pods | grep tiller

