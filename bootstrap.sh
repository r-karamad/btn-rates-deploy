if ! [ -x "$(command -v kubectl)" ]; then
  echo "Installing kubectl ..."
  sudo apt-get update
  sudo apt-get install -y ca-certificates curl
  sudo apt-get install -y apt-transport-https
  sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
  echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update
  sudo apt-get install -y kubectl
else
  echo "👍 kubectl is already installed!"
fi

if ! [ -x "$(command -v docker)" ]; then
  echo "Installing docker ..."
  sudo apt update
  sudo apt install apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
  apt-cache policy docker-ce
  sudo apt install docker-ce
  sudo usermod -aG docker ${USER}
  su - ${USER}
else
  echo "👍 docker is already installed!"
fi

if ! [ -x "$(command -v minikube)" ]; then
  echo "Installing minikube ..."
  curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  sudo install minikube-linux-amd64 /usr/local/bin/minikube
else
  echo "👍 minikube is already installed!"
fi

echo "Configuring minikube ..."
minikube config set cpus 2
minikube config set memory 1g
minikube config set disk-size 2g
minikube config set driver docker
minikube config set EmbedCerts true

echo "Starting minikube ..."
minikube start --nodes=2
minikube addons enable ingress
kubectl cluster-info

echo "Setting /etc/hosts ..."
minikube ip > minikube_ip
