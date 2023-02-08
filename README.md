# ansible-aws-ec2-dynamic-inventory
AWS-EC2 Ansible dynamic inventory implementation

### Requirements
The below requirements are needed on the local ansible controller node that executes this inventory.

python >= 3.6
boto3 >= 1.18.0
botocore >= 1.21.0
aws cli

```
pip install boto3
sudo yum install ansible -y
```

### Update python
```
sudo yum install -y amazon-linux-extras
sudo yum install python3.8
sudo amazon-linux-extras enable python3.8
sudo yum install python3.8 -y
alias python=python3.8
```

### amazon aws_ec2 inventory plugin
```
ansible-galaxy collection install amazon.aws
```
Ref: https://docs.ansible.com/ansible/latest/collections/amazon/aws/aws_ec2_inventory.html#amazon-aws-aws-ec2-inventory-ec2-inventory-source