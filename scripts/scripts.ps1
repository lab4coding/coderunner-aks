# variables
$location="WestEurope"
$resourceGroup="cr-container-services-rg"
$aksName="cr-demo-aks"
$acrName="crdemo4aks"
$spName="https://cr-demo-aks"
$nodeCount=2
$nodeVMSize="Standard_B2s"

# Create Resource Group
az group create --name $resourceGroup --location $location

# installing kubectl
az aks install-cli

# Create Custom Service Principal
$sp=$(az ad sp create-for-rbac --skip-assignment --name $spName) | ConvertFrom-Json

# Create Aks with Service Principal
$spSecret=$sp.password
az aks create --resource-group=$resourceGroup `
    --name=$aksName `
    --dns-name-prefix=$aksName `
    --generate-ssh-keys `
    --node-count=$nodeCount `
    --node-vm-size=$nodeVMSize `
    --service-principal $sp.appId `
    --client-secret="$spSecret"
#    --attach-acr=$acrName

# Create Aks with Managed Identity
az aks create --resource-group=$resourceGroup `
    --name=$aksName `
    --dns-name-prefix=$aksName `
    --generate-ssh-keys `
    --node-count=$nodeCount `
    --node-vm-size=$nodeVMSize `
    --enable-managed-identity
    
# Create Azure Container Registry
az acr create --resource-group $resourceGroup --name $acrName --sku Basic

az acr login --name $acrName

# Attach Acr to Aks
az aks update --resource-group $resourceGroup --name $aksName --attach-acr $acrName

# Get Aks credentials
az aks get-credentials --resource-group $resourceGroup --name $aksName
# Get admin credentials for dashboard
az aks get-credentials --admin --resource-group $resourceGroup --name $aksName

# Dashboard permissions for Kubernetes version <= 1.15
kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard

# Browse Kubernetes Dashboard
az aks browse --resource-group $resourceGroup --name $aksName
