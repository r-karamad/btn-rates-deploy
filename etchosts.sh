echo "Setting /etc/hosts ..."
minikube_ip=$(cat minikube_ip)
sudo sed -i '/rates.cluster.local/d' /etc/hosts
sudo echo $minikube_ip rates.cluster.local >> /etc/hosts
echo "👍 done."