#################################################
# Terraform vs. Pulumi vs. Crossplane           #
# Infrastructure as Code (IaC) Tools Comparison #
# https://youtu.be/RaoKcJGchKM                  #
#################################################

#########
# Setup #
#########

# Install Terraform CLI, Pulumi CLI, and Crossplane `kubectl` plugin

git clone git clone https://github.com/vfarcic/terraform-vs-pulumi-vs-crossplane.git

cd terraform-vs-pulumi-vs-crossplane

# The examples are designed for Google Cloud.
# Using a different provider requires changes to the manifests and code.

gcloud auth application-default login

export PROJECT_ID=dt-$(date +%Y%m%d%H%M%S)

gcloud projects create $PROJECT_ID

echo "https://console.cloud.google.com/marketplace/product/google/container.googleapis.com?project=$PROJECT_ID"

# Open the link
# Enable the API

export SA_NAME=devops-toolkit

export SA="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

gcloud iam service-accounts \
    create $SA_NAME \
    --project $PROJECT_ID

export ROLE=roles/admin

gcloud projects add-iam-policy-binding \
    --role $ROLE $PROJECT_ID \
    --member serviceAccount:$SA

gcloud iam service-accounts keys \
    create creds.json \
    --project $PROJECT_ID \
    --iam-account $SA

echo $PROJECT_ID

# Open 3 terminal sessions

# Terminal 1 (Terraform)
cd terraform

# Terminal 2 (Pulumi)
cd pulumi

# Terminal 3 (Crossplane)
cd crossplane

# In all 3 terminals
# Replace `[...]` with the project ID (output from `echo echo $PROJECT_ID`)
export PROJECT_ID=[...]

# Terminal 2 (Pulumi)
pulumi config set gcp:project $PROJECT_ID

# Terminal 3 (Crossplane)
minikube start

# Terminal 3 (Crossplane)
helm repo add crossplane-stable \
    https://charts.crossplane.io/stable

# Terminal 3 (Crossplane)
helm repo update

# Terminal 3 (Crossplane)
helm upgrade --install \
    crossplane crossplane-stable/crossplane \
    --namespace crossplane-system \
    --create-namespace \
    --wait

# Terminal 3 (Crossplane)
kubectl --namespace crossplane-system \
    create secret generic gcp-creds \
    --from-file key=../creds.json

# Terminal 3 (Crossplane)
kubectl crossplane install provider \
    crossplane/provider-gcp:v0.15.0

# Terminal 3 (Crossplane)
kubectl get providers

# Repeat the previous command until `HEALTHY` column is set to `True`

# Terminal 3 (Crossplane)
echo "apiVersion: gcp.crossplane.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
spec:
  projectID: $PROJECT_ID
  credentials:
    source: Secret
    secretRef:
      namespace: crossplane-system
      name: gcp-creds
      key: key" \
    | kubectl apply --filename -

################
# Requirements #
################

# Terraform: 
# - `terraform`
# - storage or Terraform Cloud account
# Pulumi:
# - `pulumi`
# - Pulumi account
# Crossplane:
# - `kubectl`
# - Crossplane `kubectl` plugin
# - Kubernetes cluster

##########
# Syntax #
##########

# Terminal 1 (Terraform)
cat main.tf

# Terminal 2 (Pulumi)
cat main.go

# Terminal 3 (Crossplane)
cat k8s.yaml

# Terraform
# - HCL
# - Declarative with optional imperative logic or templating

# Pulumi
# - General purpose languages
# - Depends on how we use it

# Crossplane
# - Pure YAML
# - Declarative only
# - Can be combined with other Kubernetes CLI tools like Helm, Kustomize, JSONNet.

####################
# Plan and preview #
####################

# Terminal 1 (Terraform)
terraform init

# Terminal 1 (Terraform)
terraform plan

# Terminal 2 (Pulumi)
pulumi preview --diff

# Terminal 3 (Crossplane)
# NONE

###############################
# Create, update, and destroy #
###############################

# Terminal 1 (Terraform)
terraform apply \
    --var project_id=$PROJECT_ID

# Terminal 2 (Pulumi)
pulumi up --diff

# Terminal 3 (Crossplane)
kubectl apply --filename k8s.yaml

# Terminal 3 (Crossplane)
kubectl describe gkecluster dt-crossplane

# Terminal 3 (Crossplane)
kubectl describe nodepool dt-crossplane

# Terminal 3 (Crossplane)
watch kubectl get gkeclusters,nodepools

# All terminals
export KUBECONFIG=$PWD/kubeconfig.yaml

# Terminal 2 (Pulumi)
gcloud container clusters \
    get-credentials dt-pulumi \
    --region us-east1 \
    --project $PROJECT_ID

# Terminal 3 (Crossplane)
gcloud container clusters \
    get-credentials dt-crossplane \
    --region us-east1 \
    --project $PROJECT_ID

# All terminals
kubectl get nodes

############################
# Drift detection and sync #
############################

# Delete the node pools

# All terminals
watch kubectl get nodes

# Terminal 1 (Terraform)
terraform apply \
    --var project_id=$PROJECT_ID

# Terminal 2 (Pulumi)
pulumi refresh

# Terminal 2 (Pulumi)
pulumi up --diff

###########
# Destroy #
###########

# Terminal 1 (Terraform)
terraform destroy \
    --var project_id=$PROJECT_ID

# Terminal 2 (Pulumi)
pulumi destroy --diff

# Terminal 3 (Crossplane)
unset KUBECONFIG

# Terminal 3 (Crossplane)
kubectl delete nodepools dt-crossplane

# Terminal 3 (Crossplane)
kubectl delete gkecluster dt-crossplane

gcloud projects delete $PROJECT_ID

minikube delete