# capstone
Repository for the final project of Udacity Cloud DevOps Nanodegree (AWS)

## Pipelines

There are two pipelines in this project:
+ ekscluster: it spins up the EKS cluster using eksctl (which uses CloudFormation behind the scenes)
+ capstone: main pipeline, which builds the image, pushes it to Docker hub and deploys the app to EKS

## Application

The application is built with Python Flask. 
It accepts the Kubernetes service name of AWS RDS instance. 
One needs to create an external service in order to reach the RDS instance from inside the Kubernetes pod.
The app is then exposed with AWS LoadBalancer, and it can be reached from outside.

## Installation notes

First I created a VPC with two public subnets, IGW and 2 NAT gateways (one for each subnet) and a security group. The security group will contain the EC2 and RDS. It has three ports open:
1. 22 - for SSH
2. 8080 - for Jenkins
3. 3306 - in order to reach RDS from inside the EKS cluster

Then I created an EC2 in one of the subnets and made it accessible via SSH remotely.  

While on EC2, I set up the environment:
1. apt install make
2. make general
3. make amazon
4. make docker
5. make jenkins

Now configure Jenkins. Install two plugins: Blue Ocean and Pipeline AWS. Create two credentials:
1. aws-final for AWS
2. dockerhub for pushing the image to Docker hub

Create pipeline "ekscluster" and connect it to "ekscluster" GitHub repo. It will take about 20 min to spin up EKS and RDS.  

When the infrastructre has been spun, set up "kubectl" for the root user:    
aws eks --region us-west-2 update-kubeconfig --name capstonecluster

Complete the external service configuration:
1. Get the RDS endpoint from /tmp/rds-endpoint.txt
2. Ping it. Ping will fail, but you will see the IP address of the RDS instance.
3. Add the IP address to the /capstone/external-endpoint.yaml and create endpoints:  
kubectl create -f /capstone/external-endpoint.yaml

Clone the "capstone" repo to the EC2 to /capstone and install requirements for the app:    
pip3 install --trusted-host pypi.python.org -r requirements.txt 

Now create the second pipeline, "capstone" and connect it to the "capstone" repo. Once the pipeline successfully finishes, get the Load Balancer DNS name:  
kubectl get svc

In the browser, go to the <LB_DNS_Name>:8081. Enter "rds" as the RDS service name and you will see the list of databases inside the RDS ;)


