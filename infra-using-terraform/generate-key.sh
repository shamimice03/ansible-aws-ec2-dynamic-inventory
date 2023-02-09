#! /bin/bash

# ` -N "" ` Specifying an empty passphrase
# ` -f ~/.ssh/aws-ec2-access` Specifying the File Name

ssh-keygen -f ~/.ssh/aws-ec2-access -t rsa  -N ""

