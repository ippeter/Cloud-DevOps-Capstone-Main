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

* First I created a VPC with two public subnets, IGW and 2 NAT gateways, one for each subnet

* Then I created an EC2 in one of the subnets and made it accessible via SSH remotely.

* While on EC2, I set up the environment:
+ apt install make
+ make general
+ make amazon
+ make docker
+ make jenkins

* When the infrastructre has been spun, set up "kubectl" for the root user:  
aws eks --region us-west-2 update-kubeconfig --name capstonecluster

* Then, complete the external service configuration:
