echo "Provision Start"

#Install K8s,etcd
sudo yum -y install flannel kubernetes

#Config flanneld
sudo /bin/cp /vagrant/conf/minion/flanneld /etc/sysconfig/flanneld

curl -L http://192.168.50.20:2379/v2/keys/coreos.com/network/config -XPUT --data-urlencode value@/vagrant/conf/minion/flannel-config.json

#Config k8s
sudo /bin/cp /vagrant/conf/minion/config /etc/kubernetes/config
sudo /bin/cp /vagrant/conf/minion/kubelet /etc/kubernetes/kubelet

#Start flanneld
systemctl enable  flanneld
systemctl restart flanneld
systemctl status  flanneld

#Config Docker
sudo ifconfig docker0 down
sudo brctl delbr docker0

sudo /bin/cp /vagrant/conf/minion/docker.service /usr/lib/systemd/system/docker.service

systemctl daemon-reload
systemctl restart docker
systemctl enable docker
systemctl status docker

#Start kube-proxy, kublet
for SERVICES in kube-proxy kubelet ; do 
	sudo systemctl restart $SERVICES
	sudo systemctl enable $SERVICES
	sudo systemctl status $SERVICES 
done




echo "Provision End"
