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

### aws_ec2.yaml

```
plugin: aws_ec2
aws_profile: default
regions:
  - ap-northeast-1
```

command: `ansible-inventory -i aws_ec2.yaml --list`

###result:
```
    "all": {
        "children": [
            "aws_ec2", 
            "ungrouped"
        ]
    }, 
    "aws_ec2": {
        "hosts": [
            "ec2-13-230-17-252.ap-northeast-1.compute.amazonaws.com", 
            "ec2-18-183-254-106.ap-northeast-1.compute.amazonaws.com", 
            "ec2-18-183-59-236.ap-northeast-1.compute.amazonaws.com", 
            "ec2-43-207-100-0.ap-northeast-1.compute.amazonaws.com", 
            "ec2-54-249-82-218.ap-northeast-1.compute.amazonaws.com", 
            "ec2-54-250-163-242.ap-northeast-1.compute.amazonaws.com", 
            "ec2-54-250-197-106.ap-northeast-1.compute.amazonaws.com"
        ]
    }
}
```

### aws_ec2.yaml
```
plugin: aws_ec2
aws_profile: default
filters: 
  tag:OS: 
  - ubuntu-linux
```

command: `ansible-inventory -i aws_ec2.yaml --list`

### result
```
    }, 
    "all": {
        "children": [
            "aws_ec2", 
            "ungrouped"
        ]
    }, 
    "aws_ec2": {
        "hosts": [
            "ec2-18-183-254-106.ap-northeast-1.compute.amazonaws.com", 
            "ec2-54-250-163-242.ap-northeast-1.compute.amazonaws.com"
        ]
    }
}
```

command: `ansible-inventory -i aws_ec2.yaml --graph`

### result
```
@all:
  |--@aws_ec2:
  |  |--ec2-18-183-254-106.ap-northeast-1.compute.amazonaws.com
  |  |--ec2-54-250-163-242.ap-northeast-1.compute.amazonaws.com
  |--@ungrouped:
```


```
plugin: aws_ec2
aws_profile: default
filters: 
  tag:OS: 
  - ubuntu-linux
  - amazon-linux
  
hostnames:
  - ip-address

```

### Result
```
@all:
  |--@aws_ec2:
  |  |--13.230.17.252
  |  |--18.183.254.106
  |  |--54.249.82.218
  |  |--54.250.163.242
  |--@ungrouped:
```


```
plugin: aws_ec2
aws_profile: default

hostnames:
  - ip-address

keyed_groups:
  - prefix: distro
    key: tags.OS
```

### Result
```
@all:
  |--@aws_ec2:
  |  |--13.230.17.252
  |  |--18.183.254.106
  |  |--18.183.59.236
  |  |--43.207.100.0
  |  |--54.249.82.218
  |  |--54.250.163.242
  |  |--54.250.197.106
  |--@distro_amazon_linux:
  |  |--13.230.17.252
  |  |--54.249.82.218
  |--@distro_ubuntu_linux:
  |  |--18.183.254.106
  |  |--54.250.163.242
  |--@ungrouped:
```


```
plugin: aws_ec2
aws_profile: default

hostnames:
  - ip-address

groups:
  amazon_linux2: "'amazon-linux' in tags.OS"
  ubuntu: "'ubuntu-linux' in tags.OS"
```

### Result

```
@all:
  |--@amazon_linux2:
  |  |--13.230.17.252
  |  |--54.249.82.218
  |--@aws_ec2:
  |  |--13.230.17.252
  |  |--18.183.254.106
  |  |--18.183.59.236
  |  |--43.207.100.0
  |  |--54.249.82.218
  |  |--54.250.163.242
  |  |--54.250.197.106
  |--@ubuntu:
  |  |--18.183.254.106
  |  |--54.250.163.242
  |--@ungrouped:
```
