
# DevSecOps CI/CD Pipeline Project Automation Arch

![ProjectArch](https://github.com/awanmbandi/realworld-microservice-project/blob/zdocs/images/DevSecOps-Project-Archas.png)

## Continuous Observability (Monitoring & Logging) Arch

![PromGrafEFKArch](https://github.com/awanmbandi/realworld-microservice-project/blob/zdocs/images/prom-graf-efk.avif)

### Project ToolBox 🧰

- [Git](https://git-scm.com/) Git is a distributed version control system that helps you track changes in any set of computer files, usually used for coordinating work among developers who collaboratively develops software.
- [Github](https://github.com/) Github is a free and open source distributed VCS designed to handle everything from small to very large projects with speed and efficiency
- [Jenkins](https://www.jenkins.io/) Jenkins is an open source automation CI tool which enables developers around the world to reliably build, test, and deploy their software
- [NPM](https://www.npmjs.com/) npm is the world's largest software registry. Open source developers from every continent use npm to share and borrow packages, and many organizations use npm to manage private development as well.
- [SonarQube|SAST](https://docs.sonarqube.org/) SonarQube Catches bugs and vulnerabilities in your app, with thousands of automated Static Code Analysis rules.
- [OWASP|SCA](https://owasp.org/www-project-dependency-check/) Dependency-Check is a Software Composition Analysis (SCA) tool that attempts to detect publicly disclosed vulnerabilities contained within a project’s dependencies.
- [Trivy|SAST|IAST](https://trivy.dev/) Trivy is the most popular open source security scanner, reliable, fast, and easy to use. Use Trivy to find vulnerabilities & IaC misconfigurations, SBOM discovery, Cloud scanning, Kubernetes security risks,and more.
- [ZAP](https://www.zaproxy.org/) OWASP ZAP is a penetration testing and DAST tool that helps developers and security professionals detect and find vulnerabilities in web applications at runtime.
- [GitGuardian|HoneyTokens](https://www.gitguardian.com/) GitGuardian helps developers and organizations secure their software development process by automatically detecting secrets like API keys, passwords, certificates, encryption keys and other sensitive data. It can as well remediate the risk for private or public source code repositories.
- [Docker](https://www.docker.com/) Docker helps developers build, share, run, and verify applications anywhere — without tedious environment configuration or management.
- [Docker Hub](https://hub.docker.com/) Docker Hub is a container registry built for developers and open source contributors to find, use, and share their container images.
- [Kubernetes](https://kubernetes.io/) Kubernetes, also known as K8s, is an open-source system for automating and orchestrating deployment, scaling, and management of containerized applications.
- [AWS EKS](https://aws.amazon.com/eks/) In the cloud, Amazon EKS automatically manages the availability and scalability of the Kubernetes control plane nodes responsible for scheduling containers, managing application availability, storing cluster data, and other key tasks.
- [EC2](https://aws.amazon.com/ec2/) EC2 allows users to rent virtual computers (EC2) to run their own workloads and applications.
- [Fluentd|Logstash](https://www.elastic.co/logstash/) Fluentd and Logstash are a free and open server-side data processing pipeline that ingests data from a multitude of sources, transforms it, and then sends it to your favorite "stash."
- [Elasticsearch](https://www.elastic.co/elasticsearch/) Elasticsearch is a search engine based on the Lucene library. It provides a distributed, multitenant-capable full-text search engine with an HTTP web interface and schema-free JSON documents.
- [Kibana](https://www.elastic.co/kibana/) Kibana is a source-available data visualization dashboard software for Elasticsearch.
- [Prometheus](https://prometheus.io/) Prometheus is a free software application used for event/metric monitoring and alerting for both application and infrastructure.
- [Grafana](https://grafana.com/) Grafana is a multi-platform open source analytics and interactive visualization web application. It provides charts, graphs, and alerts for the web when connected to supported data sources.
- [Slack](https://slack.com/) Slack is a communication platform designed for collaboration which can be leveraged to build and develop a very robust DevOps culture. Will be used for Continuous feedback loop.

## Jenkins Complete CI/CD Pipeline Project Runbook

### STEP 1: Create and Push the Project Repository

- Login to `Your GitHub Account`
- Create a  new Repository named `devsecops-realworld-cicd-project`
- Clone the repository to your `local machine`
- Download the source code in the `"devsecops-cicd-project-one` branch" from this repository: [https://github.com/UrsulaN1/devsecops-realworld-cicd-project.git]
- `Copy` and `Paste` its contents into your cloned respository folder.
- Run the following commands to push the code to a new branch in your GitHub repository:
        - Add the changes: `git add -A`
        - Commit changes: `git commit -m "Initial commit: Add project source code"`
        - Push the code to the default branch in your GitHub repository: `git push origin main`
        - Push the code to a new branch in your GitHub repository:
                - `git checkout -b devsecops-cicd-project-one`
                - `git push -u origin devsecops-cicd-project-one`
                - `git branch -a`
- Confirm that the code is now available on GitHub

### STEP 2: Sign Up For GitGuardian for continuous Secrete scanning

#### 2.1 Click on the following link to access GitGuardian: [https://www.gitguardian.com/]

- Click on `Start For Free`
- Select `Sign up with GitHub`

#### 2.2 OR use GitGuardian CLI ggshield on PowerShell

```bash
# 1. Install ggshield:
irm [https://raw.githubusercontent.com/GitGuardian/ggshield/main/scripts/install/install.ps1] | iex

# 2. Verify installation
ggshield --version

# 3. Authenticate
ggshield auth login

# 4. Enter your project repository
cd C:\path\to\devsecops-realworld-cicd-project

# 5. Verify Git repository
git status

# 6. Install the pre-commit secret scanner
ggshield install --mode local

# 7. Scan the entire repository
ggshield secret scan repo .
```

### STEP 3: Create An IAM Profile/Role For The `Jenkins-CI` Server

- Create an EC2 Service Role in IAM with AdministratorAccess Privilege
- Navigate to IAM
        - Click on `Roles`
        - Click on `Create Role`
        - Select `Service Role`
        - Use Case: Select `EC2`
        - Click on `Next`
        - Attach Policies: `AmazonSSMManagedInstanceCore`, `AmazonEC2ContainerRegistryPowerUser`, `CloudWatchAgentServicePolicy`
        - Click `Next`
        - Role Name: `Jenkins-EC2-DevSecOps-Role`
        - Click `Create`

### STEP 4: Jenkins CI

- Create a Jenkins VM instance
- Name: `Jenkins-CI`
- AMI: `Ubuntu 22.04`
- Instance type: `t3.large`
- Key pair: `Select` or `create a new keypair`
- Security Group (Edit/Open): `All Traffic` to `YOUR_IP`
        - Name & Description: `DevSecOps-Jenkins-CI-SG`
        - What we actually need: `8080`, `9000` and `22` to `YOUR_IP`
- Storage: Increase to `50 GB`
- IAM instance profile: Select the `Jenkins-EC2-DevSecOps-Role`
- Copy the User Data from the `user_data.sh` script in your local project folder.
- Launch Instance

#### ⚠️ NOTE:ALERT ⚠️

- **ONLY VISIT THIS SECTION IF YOU STOPPED AND RESTARTED YOUR JENKINS SERVER**
- The above `Jenkins Userdata` includes a `SonarQube` container deployment task
  - As a result, we know containers are `Ephemeral` by natuure, so if you `Stop` your `Jenkins CI Server` at any point in time... You'll have to `Deploy the Container` again when you `Start` it back or bring the instance up again.
  - If you don't do this, you will not be able able to proceed with the project.

```bash
# Volume inspection, confirm the docker volume exist
docker volume inspect volume sonarqube-volume

# Create a new conainter, provide your container name and deploy in the `Jenkins-CI` server
docker run -d --name PROVIDE_NAME_HERE -v sonarqube-volume:/opt/sonarqube/data -p 9000:9000 sonarqube:lts-community
```

### STEP 5: Slack

- Create a Private Slack Channel and name it `yourfirstname-jenkins-cicd-pipeline-alerts`
      - Visibility: Select `Private`
- Click on the `Channel Name` at the top and select `Agents and Apps`
      - Click on `Add Agent or app`
      - Search for `Jenkins CI` and click on `Install`
      - This will open up on the browser.
      - Click `Add to Slack`
      - Leave this page open [ or copy Token to use in Jenkins Tool configuration]

### STEP 6: Verify the Following Services are Running in the Jenkins Instance

- SSH into the `Jenkins-CI` server
- Run the following commands and confirm that the `services` are all `Running`

```bash
# Confirm Java version
sudo java --version

# Confirm that Jenkins is running
sudo systemctl status jenkins

# Confirm that docker is running
sudo systemctl status docker

# Confirm that Trivy is running
trivy --version

# Confirm that Terraform is running
terraform version

# Confirm that the Kubectl utility is running 
kubectl version --client

# Confirm that AWS CLI is running
aws --version

# Confirm that the SonarQube container is running
docker ps | grep sonarqube:lts-community

# Lastly confirm that the `sonarqube volumes` - logs, data, and extensions  were created
docker volume ls
```

### STEP 7: Deploy Your EKS Cluster Environment

1. `UPDATE` Your Terraform Provider Region to `Your Choice REGION`*
        - **⚠️`NOTE:ALERT!`⚠️:** *Do Not Use `North Virginia`, that's `us-east-1`*
        - **⚠️`NOTE:ALERT!`⚠️:** *Also Confirm that The Selected Region Has A `Default VPC` You're Confident Has Internet Connection*
2. Confirm you're still logged into the `Jenkins-CI` Server via `SSH`
3. Run the following commands to deploy the `EKS Cluster` in the `Jenkins-CI`
        ```bash
        git clone https://github.com/UrsulaN1/devsecops-realworld-cicd-project.git
        cd devsecops-realworld-cicd-project && git checkout devsecops-cicd-project-one
        cd eks-terraform
        terraform init
        terraform validate
        terraform plan
        terraform apply --auto-approve
        ```
4. Navigate to `EKS` and confirm your Cluster was created successfully
5. Also confirmthere's no issue regarding your Terraform execution

---

### NOTE

**Pushing code to GitHub from your Ubuntu server:**

1. Generate an SSH key on the Ubuntu server
**Run:** `ssh-keygen -t ed25519 -C "your.email@example.com"`. Press Enter to accept the default file location, and set a passphrase if you want extra security (or leave blank for none).
2. Start the SSH agent and add your key
**Run:** `eval "$(ssh-agent -s)" then ssh-add ~/.ssh/id_ed25519`. This loads your private key into memory so Git can use it automatically.
3. Copy the public key
**Run:** `cat ~/.ssh/id_ed25519.pub` and copy the entire output (starts with ssh-ed25519 ...).
4. Add the key to GitHub
On GitHub: **Settings** → **SSH and GPG keys** → **New SSH key**. Paste the copied key, give it a name like 'ubuntu-server', and save.
5. Switch your repo's remote URL to SSH
**Run:** `git remote set-url origin git@github.com:<YOUR_GITHUB_REPO_URL>.` This replaces the https:// URL that was triggering the password prompt.
6. Test the connection
**Run:** `ssh -T git@github.com`. You should see 'Hi `<username>!` You've successfully authenticated...' If you see that, you're set.
7. Push your code
**Run:** `git push` (or `git push -u origin <branch-name>` if pushing a branch for the first time). No username/password prompt should appear from now on.

---

### STEP 8: Jenkins setup

#### 8.1: Access Jenkins

8.1.1. Copy your Jenkins public IP address and open it in a browser: `http://<EXTERNAL_IP>:8080`.
8.1.2. From your shell (Git Bash or macOS Terminal), SSH into the Jenkins instance.
8.1.3. Retrieve the administrator password:
        - Run: `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
        - Copy the password and login to Jenkins
8.1.4. Navigate to `Settings` --> `Plugins` --> `Available Plugins`
    - Search and Install the following Plugings:
        - **SonarQube Scanner**
        - **NodeJS**
        - **Eclipse Temurin installer**
        - **Docker**
        - **Docker Commons**
        - **Docker Pipeline**
        - **docker-build-step**
        - **Docker API**
        - **OWASP Dependency-Check**
        - **Terraform**
        - **Kubernetes**
        - **Kubernetes CLI**
        - **Kubernetes Credentials**
        - **Kubernetes Client API**
        - **Kubernetes Credentials Provider**
        - **Kubernetes :: Pipeline :: DevOps Steps**
        - **Slack Notification**
        - **ssh-agent**
        - **BlueOcean**
        - **Build Timestamp (Needed for Artifact versioning)**
        - **Pipeline: Stage View**
    - Click on `Install`
    - Once all plugins are installed
    - Select/Check the Box **Restart Jenkins when installation is complete and no jobs are running**
    - Refresh your Browser and Log back into Jenkins

#### 8.2: Jenkins Global tools configuration

##### 8.2.1. Click on **Manage Jenkins** -->> **Tools**

1. **JDK**
    - Click on `Add JDK`
    - **Name:** `JDK21`
    - Select `Install automatically`
    - Click on `Add installer`
    - Select `Install from adoptium.net`
    - **Version:** `jdk-21.0.12.8`

2. **SonarQube Scanner**
    - Click on `Add SonarQube Scanner`
    - Name: `SonarScanner`
    - Enable: `Install automatically`
  
3. **NodeJS installations**
      - Click on `Add NodeJS`
      - Name: `NodeJS16`
      - Enable: `Install automatically`
      - Version: Select `16.2.0`

4. **Dependency-Check installations**
      - Click on `Add Dependency-Check`
      - Name: `OWASP-Dependency-Check`
      - Enable: `Install automatically`
      - Click on `Add installer`
      - Select `Install from github.com`

      - Version: Select `6.5.1`

5. **Docker installations**
      - Click on `Add Docker`
      - Name: `Docker`
      - Enable: `Install automatically`
      - Click on `Add installer`
      - Select `Download from docker.com`
      - Docker version: `latest`

6. **Terraform Installation**
      - Click on `Add Terraform`
      - Name: `Terraform`
      - Disable: `Install automatically`
        - NOTE: *Please Do Not Check The ``Install automatically`*
      - Install directory: provide `/usr/bin/`

7. **SonarQube-Server**
      - Navigatae to `SonarQube servers` in **Manage Jenkins** --> **System**
      - Click on `Add SonarQube installations`
      - Name: `Sonar-Server`
      - Server URL: `[http://YOUR_JENKINS_PRIVATE_IP:9000]`
      - Authentication token: Select your server authentication token from the drop down `SonarQube-Credential`

`Apply` and `Save`

#### 8.3:  Credentials Setup (SonarQube, Slack, DockerHub, Kubernetes and ZAP)

Navigate to **Manage Jenkins** > **Credentials** > **System** > **Global Credentials** (Unrestricted), then click **Add Credentials** for each item below.

##### 8.3.1: Generate the SonarQube Token

- Log in to your SonarQube Application at [(http://SonarServer-Public-IP:9000)]
        - Default username: **`admin`**
        - Default password: **`admin`**
- Click on `Login` and update your login information with a strong password
- Click on `Manually`
        - Project display name: `NodeJS-WebApp-Project`
        - Display key: `NodeJS-WebApp-Project`
        - Main branch name: `devsecops-cicd-project-one`
        - Click on `Set Up`
- Click on `Locally`
        - Token Name ``NodeJS-WebApp-SonarQube-Token``
        - Click on `Generate`
            - **NOTE:** *Copy the TOKEN and SAVE somwhere on your Notepad*
        - Click on `Continue`
- Run analysis on your project: Select `Other (for JS, TS, Go, Python, PHP, ...)`
- What is your OS?: Select `Linux`
        - `COPY` the `Execute the Scanner` and save on your Notepad as well
- Generate a `Global Analysis Token`
        - Click on the `User Profile` icon at top right of SonarQube
        - Click on `My Account`
        - Under the `Security` tab, generate the token: *This is the Token you need for Authorization*
            - Token Name: `Sonar-Token`
            - Type: `Global Analysis token`
        - Generate Token
        - Click `Generate`
        - Copy token to your Notepad

##### 8.3.2:  Store SonarQube Secret Token in Jenkins

- In your Jenkins UI `http://JENKINS_PUBLIC_IP:8080`
      - Navigate to `Manage Jenkins` --> `Credentials`
        - Click on ``Add Credentials``
              - Kind: `Secret text`
              - Secret: `Paste the SonarQube TOKEN` value that we have created on the SonarQube server
              - ID: ``SonarQube-Credential``
              - Description: `SonarQube-Credential`
              - Click on `Create`

##### 8.3.3: Generate the Slack Secret token (Slack-Credntial)

- Navigate to your Slack account and create a `Private Channel`: `YOUR_INITIAL-devsecops-cicd-alerts`
- Click on the `Channel Name` at the top and select `Agents and Apps`
      - Click on `Add Agent or app`
      - Search for `Jenkins CI` and click on `Install`
      - This will open up on the browser.
      - Click `Add to Slack`

###### 8.3.4: Create The Slack Credential in Jenkins

- Click on ``Add Credentials``
      - Kind: `Secret text`
      - Secret: Place the Integration Token Credential ID (Note: Generated for slack setup)
      - ID: ``Slack-Credential``
      - Description: `Slack-Credential`
- Click on `Create`  

- Still on `Manage Jenkins` and `Configure System`
        - Scroll down to the `Slack` Section (at the very bottom)
        - Go to section `Slack`
            - `NOTE:` *Make sure you still have the Slack Page that has the `team subdomain` & `integration token` open*
            - Workspace: **Provide the `Team Subdomain` value** (created above)
            - Credentials: select the `Slack-Credential` credentials (created above)
            - Default channel / member id: `#PROVIDE_YOUR_CHANNEL_NAME_HERE`
            - Click on `Test Connection`
            - Click on `Apply` and `Save`

##### 8.3.4: Generate the DockerHub Token

- Log in at `[hub.docker.com]` and go to `Account Settings` under your profile.
- Click `Personal Access Token` in the left menu.
- Click `Generate New Token`.
- Description `jenkins-cicd-pipeline`
- Access permissions:  `Read & Write`
- Click Generate.
- Copy the token immediately — Docker Hub only shows it once; if you lose it you'll have to generate a new one.

##### 8.3.5: Add the DockerHub Token in Jenkins

- In Jenkins, go to **Manage Jenkins > **Credentials** >
- Click on ``Add Credentials``**
        - Kind: `Username with password`
        - Username: ``YOUR USERNAME``
        - Password: ``YOUR DOCKERHUB PAT``
        - ID: ``DockerHub-Credential``
        - Description: `DockerHub-Credential`
        - Click on `Create`

##### 8.3.6: Kubernetes Cluster Credential (kubeconfig)

- Start By Increasing The `EBS Volume Size` of Your Kubernetes Cluster Worker Nodes
      - Navigate to `EC2`
      - Click on `Volumes`
      - Select each volume and click on `Actions`, then `Modify` *Both Nodes Volumes*
      - Size: `130 GB`
      - Click `Modify`

- Get Cluster Credential From Kube Config
      - `SSH` back into your `Jenkins-CI` server
      - List the clusters in your region: `aws eks list-clusters --region <YOUR_REGION>`
      - RUN the command: `aws eks update-kubeconfig --name <clustername> --region <region>`
      - COPY the Cluster KubeConfig: `cat ~/.kube/config`
      - `COPY` the KubeConfig file content
      - Save it to a local file:
         - `vi ~/Downloads/kubeconfig-secret.txt`
                - `PASTE` and `SAVE` the KubeConfig content in the file

###### 8.3.7: Create The Kubernetes Credential In Jenkins

- Navigate back to Jenkins UI
- Click on ``Add Credentials``
      - Kind: `Secret File`
      - File: Click ``Choose File``
        - **NOTE:** *Seletct the KubeConfig file you saved locally*
      - ID: ``Kubernetes-Credential``
      - Description: `Kubernetes-Credential`
      - Click on `Create`

##### 8.3.8: Create the ZAP Dynamic Application Security Testing Server Credential

- Start by copying the `EC2 SSH Private Key File Content` of your `Jenkins-CI` Server
      - Open your `GitBash Terminal` or `MacOS Terminal`
      - Navigate to the Location where your `Jenkins-CI` Server SSH Key is Stored *(Usually in **Downloads**)*
      - Run the Command `cat YOUR_SSH_KEY_FILE_NAME.pem`
      - COPY the KEY content and Navigate back to Jenkins to save it

###### 8.3.9: Save The ZAP Server SSH Key Credential in Jenkins

- Navigate to the `Jenkins Credential Dashboard`
- Click on `Add Credentials`
      - Kind: `SSH Username with private key`
      - ID and Description: `OWASP-Zap-Credential`
      - Username: `ubuntu`
      - Private key: `Enter directly`
          - Key: Click on `Add`
          - Key: `Paste The Private Key Content You Copied`
      - Click on `Create`

### STEP 9:  SonarQube Configuration

#### 9.1: Setup SonarQube GateKeeper

- Open the SonarQube UI `[http:Sonarqube_Server_IP:9000]`
- Click on `Quality Gates`
- Click on `Create`
      - Name: `NodeJS-Webapp-QualityGate`
- Click on `Save` to Create
- Click on `Unlock Editing`
- Click `Add Condition` to Add a Quality Gate Condition to Validate the Code Against (Code Smells or Bugs)
- Add Quality to SonarQube Project
        -  ``NOTE:`` Make sure to update the `SonarQube` stage in your `Jenkinsfile` and Test the Pipeline so your project will be visible on the SonarQube Project Dashboard.
- Click on `Projects`
- Click on your project name `NodeJS-Webapp-Project`
- Click on `Project Settings`
- Click on `Quality Gate`
- Select `Always use a speciic Quality Gate` and select your QG `NodeJS-Webapp-QualityGate`
- Save

### 9.2: Setup SonarQube Webhook to Integrate Jenkins (To pass the results to Jenkins)

- Click on `Administration`
- Click on `Configuration` and Select `Webhook`
- Click on `Create Webhook`
        - Name: `jenkinswebhook`
        - URL: `http://Jenkins-Server-Private-IP:8080/sonarqube-webhook/`
- Confirm in the Jenkinsfile you have the “Quality Gate Stage”. The stage code should look like the below;

    ```bash
    stage('SonarQube GateKeeper') {
        steps {
          timeout(time : 1, unit : 'HOURS'){
          waitForQualityGate abortPipeline: true, credentialsId: 'SonarQube-Credential'
          }
        }
    ```

### 9.3: Build Project in Jenkins UI

- Create a project/job
        - Name: `NodeJS-WebApp-Project`
- Copy the contents of the `Jenkinsfile` in your root project and paste in the `Pipeline script` field
- Run Your Pipeline To Test Your Quality Gate (It should PASS QG)
- **(OPTIONAL)** FAIL Your Quality Gate: Go back to SonarQube -->> Open your Project -->> Click on Quality Gates at the top -->> Select your Project Quality Gate -->> Click EDIT -->> Change the Value to “0” -->> Update Condition
- **(OPTIONAL)** Run/Test Your Pipeline Again and This Time Your Quality Gate Should Fail
- **(OPTIONAL)** Go back and Update the Quality Gate value to 10. The Exercise was just to see how Quality Gate Works

### 9.4: Update the EKS Cluster Security Group (Add A NodePort)

- Navigate to `EC2`
  - Select any of the `Cluster Worker Nodes`
  - Click on `Security`
  - Click on the `EKS Cluster Security Group ID`
  - Click on `Edit Inbound Rules`
  - Click on `Add Rule`
  - Port Number: `30000`, Source: `0.0.0.0/0`
  - Click on `SAVE`

### 9.5:  Deploy Monitoring and Logging Solution Using EFK Stack, Prometheus & Grafana

#### 9.5.1: Deploy and Configure EFK Stack

- SSH Back into your `Jenkins-CI` instance
- Run the following commands to deploy the `EFK Stack including Prometheus and Grafana k8s manifest`

```bash
# Get cluster nodes
kubectl get nodes

# Get cluster pods
kubectl get pods

# Get all kubernets Objects
kubectl get all

# Deploy EFK Stack and give it about 10 Minutes before deploying the Prom & Graf..
find ~ -maxdepth 2 -type d -name "efk-stack"
cd ../efk-stack #(copy the efk stack 'PATH' from the command above and insert here)
ls -al
kubectl apply -f .

# Confirm EFK Resources
kubectl get ns
kubectl get all -n efklog
kubectl get pods -n efklog -w   # To ensure all pods are running
```

#### 9.5.2: Access the `Kibana Dashboard`

1. Run `kubectl get svc -n efklog`
2. On the browser, paste `*KIBANA_LOADBALANCER_URL:5601*`
3. Click on `Explore on my own`
4. Click on `Discover` on the left menu and click on `Index Pattern`
5. Toggle on `Include system indices`
6. Index Pattern: `.kibana_1*`
        - Click `Next step`
7. Time Filter field name: Select `updated_at`
8. Click `Create Index Pattern`
    - Confirm that you atleast have some `Logs` displayed on the `Kibana Discovery Page`

#### 9.5.3: Deploy and Configure Prometheus and Grafana

1. Navigate back to your `Jenkins-CI SSH Shell` where you're logged in
2. Run the following commands

```bash
# Navigate to the monitoring directory
cd ../monitoring/

# Start by Deploying the Kubernetes CRDs Configuration/Manifest
kubectl apply -f crds.yaml

# The Deploy the `eks-monitoring.yaml` config
kubectl apply -f eks-monitoring.yaml

# Resources created Pods, Deployments, ReplicaSets and Services deployed in the `Monitoring` Namespace
kubectl get ns
kubectl get pods -n monitoring
kubectl get svc -n monitoring
```

#### 9.5.4: Access the PROMETHEUS Dashboard

1. RUN: `kubectl get svc -n monitoring`
2. COPY the DNS of the LoadBalancer of the Service: `monitoring-kube-prometheus-prometheus`
    - **NOTE:** *You can as well get this from the EC2 --> LoadBalancer service*
3. Open a new tab: http://YOUR_PROMETHEUS_LOADBALANCER_DNS:9090

#### 9.5.5: Access the GRAFANA Dashboard

1. RUN: `kubectl get svc -n monitoring`
2. COPY the DNS of the LoadBalancer of the Service: `monitoring-grafana`
    - **NOTE:** *You can as well get this from the EC2 --> LoadBalancer service*
3. Open a new tab: http://YOUR_GRAFANA_LOADBALANCER_DNS:80
    - Username: `admin`
    - Password: `prom-operator`

4. Access Your Project Pre-Build Dashboards
    - Click on `HOME`
    - These are the three most `Important Dashboards` which you can click and open any
        - `Node Exporter / USE Method / Node`
        - `Node Exporter / USE Method / Cluster`
        - `Kubernetes / Networking / Pod`

    - Click on the `Node Exporter / USE Method / Node`

## Pipeline creation (Make Sure To Make The Following Updates First)

- UPDATE YOUR ``Jenkinsfile``
- Update your `OWASP Zap Server IP (Which is Jenkins IP)` in the `Jenkinsfile` on `Line 87`
- Update the `EKS Worker Node IP` with yours in the `Jenkinsfile` on `Line 87`
- Update your `Slack Channel Name` in the `Jenkinsfile` on `Line 104`
- Update `SonarQube projectName` in your `Jenkinsfile` On `Line 34`
- Update the `SonarQube projectKey` in your `Jenkinsfile` On `Line 35`
- Update the `DockerHub username` in the `Jenkinsfile` on `Line 62`, `Line 63` and `Line 70` provide Yours

1. Log into Jenkins: `[http://Jenkins-Public-IP:8080/]`
    - Click on `New Item`
    - Enter an item name: `DevSecOps-CICD-Pipeline-Automation`
    - Select the category as **`Pipeline`**
    - Click `OK`
    - GitHub hook trigger for GITScm polling: `Check the box`
    - **NOTE:** Make sure to also configure it on *GitHub's side*
    - Pipeline Definition: Select `Pipeline script from SCM`
    - SCM: `Git`
    - Repositories
            - Repository URL: `Provide Your Project Repo Git URL` (the one you created in the initial phase)
            - Credentials: `none` *since the repository is public*
            - Branch Specifier (blank for 'any'): ``*/dev-sec-ops-cicd-pipeline-project-one``
            - Script Path: ``Jenkinsfile``
    - Click on `SAVE`
    - Click on `Build Now` to *TEST Pipeline*

2. Test Application Access From the `Test-Environment` Using `NodePort` of one of your Workers
    - SSH Back into your `Jenkins-CI` Server
        - RUN: `kubectl get svc -n test-env`
        - **NOTE:** COPY the Exposed `NodePort Pod Number`
    - Access The Application Running in the `Test Environment` within the Cluster
    - `Update` the EKS Cluster Security Group ***(If you've not already)***
      - To do this, navigate to `EC2`
      - Select one of the `Worker Nodes` --> Click on `Security` --> Click on `The Security Group ID`
      - Click on `Edit Inbound Rules`: Port = `30000` and Source `0.0.0.0/0`
    - Open your Browser
    - Go to: `[http://YOUR_KUBERNETES_WORKER_NODE_IP]`
    - Stage Deployment Succeeded
    - Production Deployment Succeeded
        - To access the application running in the `Prod-Env`
        - Navigate back to the `Jenkins-CI` shell
        - RUN: `kubectl get svc`
        - Copy the LoadBalancer DNS and Open on a TAB on your choice Browser http://PROD_LOADBALANCER_DNS
    - You can as well get this from the LoadBalancer Service in EC2:

## Troubleshooting (Possible Issues You May Encounter and Suggested Solutions)

1) If you experience a long wait time at the level of `GateKeeper`, please check if your `Sonar Webhook` is associated with your `SonarQube Project` with `SonarQube Results`
    - If you check your jenkins Pipeline you'll most likely find the below message at the `SonarQube GateKeper` stage

    ```test
    JENKINS CONSOLE OUTPUT

    Checking status of SonarQube task 'AYfEB4IQ3rP3Y6VQ_yIa' on server 'SonarQube'
    SonarQube task 'AYfEB4IQ3rP3Y6VQ_yIa' status is 'PENDING'
    ```

2) Only Meant For Those That Are Facing Issues With SonarQube Analysis Because They Stopped and Restarted Jenkins

    - The above `Jenkins Userdata` includes a `SonarQube` container deployment task
      - As a result, we know containers are `Ephemeral` by natuure, so if you `Stop` your `Jenkins CI Server` at any point in time... You'll have to `Deploy the Container` again when you `Start` it back or bring the instance up again.
      - If you don't do this, you will not be able able to proceed with the project.
      - I have also Included a `Docker Volume` setup task as well for `SonarQube`, where the Container Data will be persisted to avoid data loss

```bash
# Volume inspection, confirm the docker volume exist
docker volume inspect volume sonarqube-volume

# Create a new conainter, provide your container name and deploy in the `Jenkins-CI` server
docker run -d --name PROVIDE_NEW_NAME_HERE -v sonarqube-volume:/opt/sonarqube/data -p 9000:9000 sonarqube:lts-community
```
