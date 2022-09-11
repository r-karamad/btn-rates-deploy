# Bitcoin to Currency Exchange Rates Deployment
This repo contains a solution for deploying btn-rates application into minikube.

## Tools
- Terraform
- Helm
- Shell
- Minikube

# How to package charts
- Pushes your changes into 'main' branch.
- Pipelines packages and builds a new chart which will be available in order to install or upgrade.

# Usage 
1. Clone the repository
```
git clone https://github.com/r-karamad/btn-rates-deploy.git && cd btn-rates-deploy
```
2. Initial Setup and update /etc/hosts
```
./prepare.sh
sudo ./etchosts.sh
```
3. Apply terraform
```
cd terraform/dev/
terraform init
terraform plan
terraform apply --auto-approve
```
4. URL
K8s ingress resource is deployed to forwarding requests. The below hostname selected and the port number needs to be placed due to the ingress controller inside K8s.
- rates.cluster.local
