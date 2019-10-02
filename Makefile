docker:
	# Install Docker
	apt-get update
	apt-get upgrade -y
	curl -fsSL https://get.docker.com/ | sh
	systemctl enable docker
	systemctl start docker
	@echo -e "\nDicker installation finished.\n"

jenkins:
	# Install Jenkins
	apt install -y default-jdk
	wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | apt-key add -
	sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
	apt-get update
	apt-get install -y jenkins
	pip install --upgrade pip
	pip install pylint
	apt-get install -y tidy
	curl -LO https://github.com/hadolint/hadolint/releases/download/v1.17.2/hadolint-Linux-x86_64
	chmod +x hadolint-Linux-x86_64
	mv hadolint-Linux-x86_64 /usr/local/bin/hadolint
	usermod -a -G docker jenkins
	systemctl restart jenkins
	@echo -e "\nalias h=history" >> ~/.bashrc
	@echo -e "\nJenkins installation finished.\n"

minikube:
	# Install Minikube
	curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.14.4/bin/linux/amd64/kubectl
	chmod +x kubectl
	mv kubectl /usr/bin
	curl -LO minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	chmod +x minikube
	install minikube /usr/local/bin
	apt-get install socat -y
	minikube start --vm-driver=none --kubernetes-version v1.14.4
	@kubectl cluster-info
	@echo -e "\nalias k=kubectl" >> ~/.bashrc
	@echo -e "\nsource <(kubectl completion bash | sed s/kubectl/k/g)" >> ~/.bashrc

helm:
	# Install Helm
	curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
	chmod 700 get_helm.sh
	./get_helm.sh
	kubectl create serviceaccount -n kube-system tiller
	kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
	helm init --service-account tiller
	@kubectl --namespace kube-system get pods | grep tiller

