# Deploying a Cyberark vault with Terraform 

This project should help you to install a CyberArk vault into AWS using AMIs.

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

## How to run
Just run terraform apply, if you want to adjust default parameters, please use the standard way of terraform.
Parameters can be found in vars.tf

## TO DO:
1. DR installation
