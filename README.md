# Create an EC2 development server

## Start the server using AWS cloudshell

Log into AWS cloudshell

Next configure the following variables and execute:
```bash
NAME="aws-dev"
AWS_REGION="us-west-1"
KEY_NAME=${NAME}-key
SECURITY_GROUP_NAME=${NAME}-sg
INSTANCE_TYPE="t2.micro"
AMI_ID="ami-0f8e81a3da6e2510a"
CONFIG_FILE="install-ansible.txt"
```

Add git clone
```bash
```

Create an SSH key. Download the Pem file after creation.
```bash
aws ec2 create-key-pair \
  --region $AWS_REGION \
  --key-name $KEY_NAME \
  --query 'KeyMaterial' \
  --output text > $KEY_NAME.pem
chmod 400 $KEY_NAME.pem
```

AWS CLI command to create a security group
Open up SSH port
```bash
SECURITY_GROUP_ID=$(aws ec2 create-security-group \
  --region $AWS_REGION \
  --group-name $SECURITY_GROUP_NAME \
  --description "Security Group for $NAME" \
  --query 'GroupId' \
  --output text)

aws ec2 authorize-security-group-ingress \
  --region $AWS_REGION \
  --group-id $SECURITY_GROUP_ID \
  --protocol tcp \
  --port 22 \
  --cidr 0.0.0.0/0
```

Create an EC2 Instance
```bash
INSTANCE_ID=$(aws ec2 run-instances \
  --region $AWS_REGION \
  --image-id $AMI_ID \
  --count 1 \
  --instance-type $INSTANCE_TYPE \
  --key-name $KEY_NAME \
  --security-group-ids $SECURITY_GROUP_NAME \
  --query 'Instances[0].InstanceId' \
  --user-data file://$CONFIG_FILE \
  --output text)

aws ec2 create-tags \
  --region $AWS_REGION \
  --resources $INSTANCE_ID \
  --tags Key=Name,Value=$NAME-server
```

At this point you can navigate to AWS Console
- Go to EC2 instances, and click on the instance just created
- Click Connect
- Click EC2 Instance Connect

## AWS EC2 Dev Server Configuration
```bash
sudo apt update -y
sudo apt install -y software-properties-common
sudo add-apt-repository -y --update ppa:ansible/ansible
sudo apt install git ansible -y
```

## Install Terraform
```bash
git clone https://github.com/sedillo/aws-ec2-dev-server.git
cd ansible
ansible-playbook -i hosts.ini terraform_install.yml
```
