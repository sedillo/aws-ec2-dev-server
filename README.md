# New Dev Server

## Github Keys

Create SSH Github keys
```bash
ssh-keygen -t ed25519 -C "EMAIL"
cat ~/.ssh/id_ed25519.pub
```
[Add SSH key](https://github.com/settings/ssh/new)

## Install Ansible

```bash
sudo apt update -y
sudo apt install -y software-properties-common
sudo add-apt-repository -y --update ppa:ansible/ansible
sudo apt install git ansible curl nmap lsof wget -y
```

## Source Code

```bash
git clone https://github.com/sedillo/aws-ec2-dev-server.git config
cd config/ansible/
```

## Install AWS
In the AWS console create a user, add programmatic access, and fill in the values below.
```bash
ansible-playbook -i hosts.ini install-awscli.yml
aws configure
ansible-playbook -i hosts.ini install-terraform.yml
```

# Specific setup for EC2
Log into AWS cloudshell

Next configure the following variables in the start-ec2.sh script
```bash
export NAME="aws-dev"
export AWS_REGION="us-west-1"
export KEY_NAME=${NAME}-key
export SECURITY_GROUP_NAME=${NAME}-sg
export INSTANCE_TYPE="t2.micro"
export AMI_ID="ami-0f8e81a3da6e2510a" # AMI Ubuntu 22.04
export CONFIG_FILE="install-ansible.txt"
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
