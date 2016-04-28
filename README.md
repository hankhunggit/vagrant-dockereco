透過 docker-machine 來控制多台 docker engine
透過 docker-swarm 來整合多台 docker engine 資源
透過 docker-compose 來配置多個 docker 之間的溝通
```
WORKAROUND

Edit $VAGRANT_HOME\embedded\gems\gems\vagrant-1.8.0\plugins\synced_folders\rsync\helper.rb

Remove the following codes (line 77~79):

"-o ControlMaster=auto " +
"-o ControlPath=#{controlpath} " +
"-o ControlPersist=10m " +
```
```bash
#Install docker-machine
curl -L https://github.com/docker/machine/releases/download/v0.6.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine && \
chmod +x /usr/local/bin/docker-machine

#
docker-machine create -d virtualbox mh-keystore

#
docker $(docker-machine config mh-keystore) run -d \
-p "8500:8500" \
-h "consul" \
progrium/consul -server -bootstrap

#swarm master
docker-machine create \
-d virtualbox \
--swarm --swarm-image="swarm" --swarm-master \
--swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
--engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
--engine-opt="cluster-advertise=eth1:2376" \
mhs-demo0


#swarn node
docker-machine create -d virtualbox \
--swarm --swarm-image="swarm:1.0.0" \
--swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
--engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
--engine-opt="cluster-advertise=eth1:2376" \
mhs-demo1

docker-machine create -d amazonec2 \
--swarm --swarm-image="swarm:1.0.0" \
--swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
--engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
--engine-opt="cluster-advertise=eth1:2376" \
mhs-demo1

```

> Written with [StackEdit](https://stackedit.io/).
