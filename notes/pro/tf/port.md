# Source: https://gist.github.com/vfarcic/704d30f46f4c05a75f09a463e95d1fa4

###################################################################
# How To Build A UI For An Internal Developer Platform With Port? #
# https://youtu.be/ro-h7tsp0qI                                    #
###################################################################

# Additional Info:
# - Port: https://getport.io
# - DevOps Is Dead! Long Live Platform Engineering! Did We Get Confused?: https://youtu.be/9_v77YiSGEY
# - DevOps MUST Build Internal Developer Platform (IDP): https://youtu.be/j5i00z3QXyU

#########
# Setup #
#########

# Install `yq` CLI from https://github.com/mikefarah/yq/#install

# Create a Kuberentes cluster

# Open https://app.getport.io in a browser, register (if not
#   already), and add Git and Kubernetes templates.

git clone https://github.com/vfarcic/port-demo

cd port-demo

###########################################
# Port Predefined Blueprints And Entities #
###########################################

cat config-k8s.yaml

helm repo add port-labs https://port-labs.github.io/helm-charts

# Click the "Help" item from the left-hand menu and select
#   "Credentials".

# Replace `[...]` with the "Client ID"
export CLIENT_ID=[...]

# Replace `[...]` with the "Client Secret"
export CLIENT_SECRET=[...]

helm upgrade --install \
    port-k8s-exporter port-labs/port-k8s-exporter \
    --namespace port-k8s-exporter --create-namespace \
    --set secret.secrets.portClientId=$CLIENT_ID \
    --set secret.secrets.portClientSecret=$CLIENT_SECRET \
    --set-file configMap.config=config-k8s.yaml --wait

#######################################
# Port Custom Blueprints And Entities #
#######################################

cat blueprints/environment.json

cat blueprints/backend-app.json

cat config.yaml

helm upgrade --install \
    port-k8s-exporter port-labs/port-k8s-exporter \
    --namespace port-k8s-exporter --create-namespace \
    --set secret.secrets.portClientId=$CLIENT_ID \
    --set secret.secrets.portClientSecret=$CLIENT_SECRET \
    --set-file configMap.config=config.yaml --wait

cat namespaces.yaml

kubectl apply --filename namespaces.yaml

cat kustomize/base/deployment.yaml

kubectl --namespace environment-production apply \
    --kustomize kustomize/base

cat kustomize/base/hpa.yaml

kubectl --namespace environment-production apply \
    --kustomize kustomize/base

kubectl --namespace environment-production get pods