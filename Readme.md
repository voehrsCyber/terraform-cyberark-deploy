# Deploying a Cyberark vault with Terraform 

This project should help you to install a CyberArk vault and the components server into AWS using AMIs.

# Prerequisites
* Terraform (tested with 0.14.5)
* AWS CLI installed (tested with v2)
* Key pair for AWS password encryption (RSA)
* AWS CyberArk AMIs
* Cyberark EPV license file

## Features
- [x] Upload license file (license.txt needs the actual license file content)
- [x] Multi region support (eu-central-1, us-west-2 and us-east-1)
- [x] Multi version support (11.7 and 12.0)
- [x] Using KMS creating custom policy and role to access KMS
- [x] Deploying the components AMI and configuring the PVWA on it.

## How to run
1. Setup AWS CLI communication by using environemnt variables or via using "aws configure"
2. Create a RSA key-pair by using ssh-keygen or similar with a local file called mykey
3. Test the connection and all parameters by running "terraform plan"
4. If everything works, you can run "terraform apply"

(To change default parameters please use the terraform way, all paramters can be found in vars.tf)

## TO DO:
1. CPM Configuration
2. PSM Configuration
3. creating a private network between the components server and the vault
4. Security Groups review and limiting access 
5. DR installation
