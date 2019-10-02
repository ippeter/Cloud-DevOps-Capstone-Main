jenkins:
	# Install Jenkins
	apt-get update
	apt-get upgrade -y
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
	@echo -e "\nalias h=history" >> ~/.bashrc
	@echo -e "\nJenkins installation finished.\n"

docker:
	# Install Docker
	curl -fsSL https://get.docker.com/ | sh
	systemctl enable docker
	systemctl start docker
	@echo -e "\nDicker installation finished.\n"

minikube:
	# Install Minikube
	curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.14.4/bin/linux/amd64/kubectl
	chmod +x kubectl
	mv kubectl /usr/bin
	curl -LO minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	chmod +x minikube
	install minikube /usr/local/bin
	minikube start --vm-driver=none --kubernetes-version v1.14.4
	@kubectl cluster-info
	@echo -e "\nalias k=kubectl" >> ~/.bashrc
	@echo -e "\nsource <(kubectl completion bash | sed s/kubectl/k/g)" >> ~/.bashrc

