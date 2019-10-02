jenkins:
	# Install Jenkins
	apt-get update
	apt-get upgrade
	apt install -y default-jdk
	wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | apt-key add -
	sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
	apt-get update
	apt-get install -y jenkins
	echo "\nalias h=history" >> ~/.bashrc

kubernetes:
	# Install Docker and Minikube
	curl -fsSL https://get.docker.com/ | sh
	systemctl enable docker
	systemctl start docker
	curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.14.4/bin/linux/amd64/kubectl
	chmod +x kubectl
	mv kubectl /usr/bin
	@kubectl version
	curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	chmod +x minikube
	install minikube /usr/local/bin
	minikube start --vm-driver=none --kubernetes-version v1.14.4
	@kubectl cluster-info
	echo "\nalias k=kubectl" >> ~/.bashrc
	echo "\nsource <(kubectl completion bash | sed s/kubectl/k/g)" >> ~/.bashrc

