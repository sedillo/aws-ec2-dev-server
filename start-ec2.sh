#!/bin/bash

# Create a key-pair
aws ec2 create-key-pair \
  --region $AWS_REGION \
  --key-name $KEY_NAME \
  --query 'KeyMaterial' \
  --output text > $KEY_NAME.pem

chmod 400 $KEY_NAME.pem

# Create a security group
SECURITY_GROUP_ID=$(aws ec2 create-security-group \
  --region $AWS_REGION \
  --group-name $SECURITY_GROUP_NAME \
  --description "Security Group for $NAME" \
  --query 'GroupId' \
  --output text)

# Add SSH ingress
aws ec2 authorize-security-group-ingress \
  --region $AWS_REGION \
  --group-id $SECURITY_GROUP_ID \
  --protocol tcp \
  --port 22 \
  --cidr 0.0.0.0/0

# Create the EC2 Instance
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

# Create an EC2 tag
aws ec2 create-tags \
  --region $AWS_REGION \
  --resources $INSTANCE_ID \
  --tags Key=Name,Value=$NAME-server
