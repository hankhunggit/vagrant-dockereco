echo "Provision Start"

#Install Docker
sudo yum update
#sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
#[dockerrepo]
#name=Docker Repository
#baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
#enabled=1
#gpgcheck=1
#gpgkey=https://yum.dockerproject.org/gpg
#EOF

sudo yum -y install lvm2 ntp bridge-utils
sudo yum -y install docker
sudo systemctl start docker
sudo systemctl enable docker

#Install K8s,etcd
sudo yum -y install kubernetes etcd flannel

#Install misc
sudo systemctl start ntpd
sudo systemctl enable ntpd

sudo systemctl stop firewalld
sudo systemctl disable firewalld

echo "Provision End"
