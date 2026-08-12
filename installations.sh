
#!/bin/bash
set -e
exec > >(tee /var/log/user-data.log) 2>&1

apt update -y

# Install Git
apt install git -y
git --version

# Install Temurin JDK 17
mkdir -p /etc/apt/keyrings
wget -O /etc/apt/keyrings/adoptium.asc https://packages.adoptium.net/artifactory/api/gpg/key/public
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
apt update -y
apt install temurin-17-jdk -y
/usr/bin/java --version

# Install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list > /dev/null
apt-get update -y
apt-get install jenkins -y
systemctl enable jenkins
systemctl start jenkins

# Install Docker
apt install docker.io -y
systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu
usermod -aG docker jenkins
systemctl restart jenkins
docker version

# Install Node.js (LTS)
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt install nodejs -y
node --version
npm --version

# Install Trivy
apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/trivy.list
apt-get update -y
apt-get install trivy -y

# Install Terraform
apt install wget gnupg software-properties-common -y
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt update -y
apt install terraform -y

# Install kubectl
apt update -y
apt install curl -y
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

# Install eksctl
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
install -m 0755 /tmp/eksctl /usr/local/bin/eksctl
eksctl version

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt-get install unzip -y
unzip -o awscliv2.zip
./aws/install
aws --version

# Deploy a SonarQube container
docker volume create sonarqube-volume
docker volume inspect sonarqube-volume
docker run -d --name sonarqube -v sonarqube-volume:/opt/sonarqube/data -p 9000:9000 sonarqube:lts-community

# Install Maven
apt install maven -y
mvn --version

# Print Jenkins initial admin password
cat /var/lib/jenkins/secrets/initialAdminPassword