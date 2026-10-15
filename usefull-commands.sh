az login 
az account set --subscription cec54560-6b89-4061-8be3-036610dd4326


# Build image locally

podman build -t first-app:latest .

# Run container locally

podman run -d -p 5000:5000 --name first-app first-app:latest

# Push to Azure Container Registry (ACR)
# 1) Log in to Azure
az login
az account set --subscription "<your-subscription-name-or-id>"

# 2) Log in to ACR
az acr login --name <acr-name>

# 3) Tag image for ACR

podman tag nginx:latest azurevijayacr.azurecr.io/nginx:latest

podman tag first-app:latest testcontainerinstanceregistry.azurecr.io/first-app:latest

# 4) Push image to ACR

podman push azurevijayacr.azurecr.io/nginx:latest

# Push to podman Hub
# 1) Log in to podman Hub

podman login

az acr login --name testcontainerregistryqwerty.azurecr.io

# 2) Tag image for podman Hub

podman tag first-app:latest <podmanhub-username>/first-app:latest

# 3) Push image to podman Hub

podman push <podmanhub-username>/first-app:latest

# Optional: view running containers

podman ps

# Optional: remove old containers/images if needed
# podman rm -f first-app
# podman rmi first-app:latest

#### Image Setup If you builing in choose platform explicity MAC

podman pull --platform linux/amd64 docker.io/library/nginx:latest
podman tag docker.io/library/nginx:latest azurevijayacr.azurecr.io/nginx:latest
podman push azurevijayacr.azurecr.io/nginx:latest


# ACR login
az acr login --name azurevijayacr
# than
podman login azurevijayacr.azurecr.io
podmn push azurevijayacr.azurecr.io/nginx:latest
# if failed agian run
docker logout 
podmn push azurevijayacr.azurecr.io/nginx:latest

# If you want to authenticate with ACR credentials directly:
USERNAME=$(az acr credential show -n azurevijayacr --query username -o tsv)
PASSWORD=$(az acr credential show -n azurevijayacr --query "passwords[0].value" -o tsv)

podman login azurevijayacr.azurecr.io \
  -u "$USERNAME" \
  -p "$PASSWORD"


#### AKS TO ACR Connection TEST

az aks get-credentials --resource-group azure-vijay-rg-dev --name azure-vijay-aks --overwrite-existing
kubectl get nodes

### Deploy NGINX to AKS
kubectl create deployment nginx --image=azurevijayacr.azurecr.io/nginx:latest
kubectl expose deployment nginx --port=80 --target-port=80 --type=LoadBalancer