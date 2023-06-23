# Create an EC2 development server

## Create dev server EC2 instance using AWS cloudshell

Log into AWS cloudshell

Next configure the following variables in the start-ec2.sh script
```bash
NAME="aws-dev"
AWS_REGION="us-west-1"
KEY_NAME=${NAME}-key
SECURITY_GROUP_NAME=${NAME}-sg
INSTANCE_TYPE="t2.micro"
AMI_ID="ami-0f8e81a3da6e2510a"
CONFIG_FILE="install-ansible.txt"
```

Run the script, wait for script to finish
```bash
./start-ec2.sh
```

## Navigate to AWS EC2 Dev Server Configuration

At this point you can navigate to AWS Console
- Go to EC2 instances, and click on the instance just created
- Click Connect
- Click EC2 Instance Connect
- Execute commands

```bash
sudo apt update -y
sudo apt install -y software-properties-common
sudo add-apt-repository -y --update ppa:ansible/ansible
sudo apt install git ansible -y
```

## Install Terraform
```bash
git clone https://github.com/sedillo/aws-ec2-dev-server.git config
cd config/ansible
ansible-playbook -i hosts.ini install_terraform.yml
```
