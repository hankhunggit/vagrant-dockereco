echo "Provision Start"

sudo /bin/cp /vagrant/conf/master/etcd.conf /etc/etcd/etcd.conf
sudo /bin/cp /vagrant/conf/master/apiserver /etc/kubernetes/apiserver 


echo "Provision End"

echo "StartDaemon Start"

for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler; do 
	sudo systemctl restart $SERVICES
	sudo systemctl enable $SERVICES
	sudo systemctl status $SERVICES 
done

sudo etcdctl mk /coreos.com/network/config '{"Network":"172.17.0.0/16"}'

echo "StartDaemon End"
