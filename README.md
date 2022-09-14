# Bitcoin to Currency Exchange Rates Deployment
This repo contains a solution for deploying btn-rates application into minikube.

## Solutions
- Terraform
- Helm
- Shell
- Minikube for development
- AWS EKS for production 

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
3. Apply terraform: it will use helm chart to apply the config.
```
cd terraform/dev/
terraform init
terraform plan
terraform apply --auto-approve
```
4. URL
K8s ingress resource is deployed to forwarding requests. The below hostname selected and the port number needs to be placed due to the ingress controller inside K8s. As an example:
- https://rates.cluster.local:31982/
5. Helming manually: add the helm repo
```
helm repo add btn https://r-karamad.github.io/btn-rates-deploy/
```
Verify helm repo
```
helm repo ls
```
Update helm repo
```
helm repo update
```
Upgrade helm release
```
helm upgrade <release_name> <helm_repo> --namespace <release_namespace>
```
# How to setup AWS EKS
```
cd terraform/prod
```
Run terraform: 
```
terraform init
terraform plan
terraform apply
```

## How to update kubectl config file
```
aws eks --region <region> update-kubeconfig --name <cluster_name>
```
## TODO
- Write terraform codes and helm chart for for setting up the service in AWS EKS cluster like we did for set up in Minikube
- Put EKS terraform state file into S3 buckets as best practice
- Pushing helm charts to artifiact repostories like ChartMuseum or ArtifactHub
