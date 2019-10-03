# capstone
Repository for the final project

### Kubernetes plugin for Jenkins

* Install "Kubernetes CLI Plugin" and its dependencies from the list of available plugins
* Create a ServiceAccount named `jenkins-robot` in the default namespace:  
kubectl -n default create serviceaccount jenkins-robot
* Give `jenkins-robot` administator permissions for this namespace:  
kubectl -n default create rolebinding jenkins-robot-binding --clusterrole=cluster-admin --serviceaccount=jenkins-robot
* Get the name of the token that was automatically generated for the ServiceAccount `jenkins-robot`:  
kubectl -n default get serviceaccount jenkins-robot -o go-template --template='{{range .secrets}}{{.name}}{{"\n"}}{{end}}'

The output will be similar to 
jenkins-robot-token-d6d8

* Retrieve the token and decode it using base64:  
kubectl -n default get secrets jenkins-robot-token-d6d8z -o go-template --template '{{index .data "token"}}' | base64 -d

The output will be similar to  
eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2V[...]

* On Jenkins, navigate in the folder you want to add the token in, or go on the main page. 
Then click on the "Credentials" item in the left menu and find or create the "Domain" you want. 
Finally, paste your token into a Secret text credential. 
Set the ID and remember it. You will need to specify it the code as registryCredential.
