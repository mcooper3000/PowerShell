
az login

az account show

az configure --defaults group=aks-rg1

az aks get-credentials --name aksdemo1

#az aks install-cli
#$env:path += 'C:\Users\mcoop\.azure-kubectl' 
#$env:path += 'C:\Users\mcoop\.azure-kubelogin'

kubectl config current-context

#Node issues showing NotReady
kubectl get nodes
kubectl describe nodes
#kubectl delete node aks-agentpool-27193923-vmss000001
#Restart-AzureRmVM -ResourceGroupName "aks-rg1" -Name "aks-agentpool-27193923-vmss000001"

az aks show -g aks-rg1 -n aksdemo1 -o table

#Stop and Start AKS Cluster
az aks stop --name aksdemo1 --resource-group aks-rg1
az aks show --name aksdemo1 --resource-group aks-rg1
az aks start --name aksdemo1 --resource-group aks-rg1


#######################
# Deploy application

kubectl create deployment myapp --image=manojnair/myapp:v1 --replicas=3

kubectl get deployments #verify deployment
kubectl get pods

kubectl get svc --watch #split screen to monitor progress 
kubectl expose deployment myapp --type=LoadBalancer --port=80 --target-port=80

kubectl get svc 
start-process http://51.132.208.252

########################
# Scale deployment manually
kubectl get deployments #verify deployment

kubectl scale deployment myapp --replicas=3

kubectl get deployment --watch #split screen to monitor progress 

kubectl scale deployment myapp --replicas=150
#confirm the MazPods supported on a particular Node
az aks nodepool show --cluster-name aksdemo1 --name agentpool --query "maxPods" #110
kubectl get pods --all-namespaces 

##########################
#Add worker node to cluster
kubectl get nodes

az aks scale `
    --resource-group aks-rg1 `
    --name aksdemo1 `
    --node-count 1 `
    --no-wait 

az aks nodepool show --name agentpool --cluster-name aksdemo1 --query "[count,provisioningState]"

kubectl get deployment

kubectl scale deployment myapp --replicas=3

##########################
#Updating App
kubectl rollout history deployment/myapp

kubectl describe deployment myapp

kubectl set image `
    deployment/myapp `
    myapp=manojnair/myapp:v2 `
    --record=true `

kubectl describe deployment myapp

#alternative - opens within a Notepad to update to v3
kubectl edit deployment myapp --record=true

#####
#Rollback a deployment 

#Get the revision history 
kubectl rollout history deployment/myapp 

#rollback most recent - reverts to version 3
kubectl rollout undo deployment/myapp 

#rollback most recent - reverts to a specific revision number
kubectl rollout undo deployment/myapp --to-revision 1

######################
#Declarative deployment using myapp2.yml
kubectl.exe create -f .\myapp2.yml
kubectl.exe get svc
#apply updated file (updated to v4)
kubectl.exe apply -f .\myapp2.yml
kubectl.exe get deployment

#remove deployment & service
kubectl.exe delete -f .\myapp2.yml

######################
#Azure Container Registry - myappacr001
#loation images
docker image ls

#tag image
docker tag manojnair/myapp:v1 myappacr001.azurecr.io/myapp:v1

#Login to ACR
az acr login --name myappacr001

#Push image to ACR
docker push myappacr001.azurecr.io/myapp:v1


#create deployment using the ACR image
kubectl.exe create deployment myappacr --image=myappacr001.azurecr.io/myapp:v1
kubectl.exe get deployment myappacr
kubectl.exe expose deployment myappacr --type=LoadBalancer --target-port=80 --port=80
kubectl.exe get svc

