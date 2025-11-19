sleep 10
mkdir -p $HOME/.kube
if [[ -f "/etc/kubernetes/admin.conf" ]]; then 
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config 
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
else 
    echo '/etc/kubernetes/admin.conf Not found'
fi
[[ -f "$HOME/.kube/config" ]] || echo "     Kubeconfig copied $HOME/.kube/config"

echo -e "\n-------------------------- Install calico/weaveworks networking and network policy plugin --------------------------\n"
#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
#kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml 

echo -e "\n---------------------------------- Checking mater node status ---------------------------\n"
kubectl get nodes
echo -e "\n Waiting to control-plane (master node) to get Ready ...........\n"
sleep 15
kubectl get nodes
echo -e "\n\n  Wait to for 5-10 minutes, if node is still not in Ready state then try to install below calico network cni "
echo "    1. kubectl apply -f https://docs.projectcalico.org/manifests/calico-typha.yaml"
echo "    2. kubectl get nodes"
echo -e "\n-----------------------------------------------------------------------------------"

fi  

if [[ "$1" == 'worker' ]]; then 
echo "------------------------------------------------------------------------------------"
echo "    1. switch to root user: sudo su -"
echo "    2. Allow incoming traffic to port 6443 in control-plane (master node)" 
echo "    3. Run the kubeadm join <TOKEN> command which we get from master"
echo "    4. Run 'kubectl get nodes' on the control-plane to see this node joined the cluster."
echo "------------------------------------------------------------------------------------"
fi
