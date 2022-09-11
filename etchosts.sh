echo "Setting /etc/hosts ..."
minikube_ip=$(cat minikube_ip)
sudo sed -i '/app.cluster.local/d' /etc/hosts
sudo echo $minikube_ip app.cluster.local >> /etc/hosts
echo "👍 done."