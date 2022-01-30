# Green-blue deploy using Terraform, Ansible, Jenkins
## Overview
This repository holds:
- Terraform code that create your infrastructure on AWS
- Servers maintaining with Ansible
- Run tasks with Jenkins
- Disaster recovery plan and terraform code for another region

## Prerequisite
1. Your AWS account
2. Domain name
2. CloudFlare account
3. Jenkins 2.319.1 or above
4. Terraform v1.1.2 or above
5. Ansible v2.9.6 or above

## Network diagram
![network diagram](https://github.com/artewka/FT/tree/FT/FT/network_diagram.png)

## Preparations
### Create service accounts on AWS
You need create two service accounts with programmatic access, by following article [AWS docs](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html#id_users_create_cliwpsapi)

For first user (for Terraform) you should give Full Administrator Access, for second user (for Ansible) you should give EC2 full access

Remember your generated AWS Access Key and AWS Secret Access Key for both of them

### Get CloudFlare credentials
Add your domain name to Cloudlfare [Cloudflare docs](https://support.cloudflare.com/hc/en-us/articles/201720164-Creating-a-Cloudflare-account-and-adding-a-website)

When it's will be done go to Overview tab for that domain. Right hand column in the API section and save your zone_id

After this you need get your API id for Cloudlfre, follow this instructions and save it [Cloudflare docs](https://support.cloudflare.com/hc/en-us/articles/201720164-Creating-a-Cloudflare-account-and-adding-a-website)

### Install Terraform
[Terraform docs](https://learn.hashicorp.com/tutorials/terraform/install-cli)

### Install Ansible
[Ansible docs](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

### Install Jenkins
[Jenkins docs](https://www.jenkins.io/doc/book/installing/linux/)
Please install additional plugins:
 - Ansible plugin

## Steps to reproduce
### Green stack

1. Copy repo to your folder

2. Generate SSH key pair and copy the public key to `FT/git/terraform/ssh_ans.pub`

3. Add AWS Access Key and AWS Secret Access Key IDs to Jenkins Credentials storage:
  - Go to the main dashboard and click on "Manage Jenkins"
  - Now, click on "Manage Credentials" under "Security" to store AWS Secret key and Access key
  - Click on "global" under "Stores scoped to Jenkins" --> "Add credentials"
  - On this page, you will be able to store the secrets. Click on the Kind drop-down and select AWS. Specify a names access_key and secret_key for the secretes, description, Access Key ID and Secret Access Key. Click on OK to store the secrets. 

4. Encrypt your AWS Access Key for Ansible with ansible-vault tool
[Ansible docs](https://docs.ansible.com/ansible/latest/user_guide/vault.html)
and put this value into FT/FT/git/ansible/inventory/aws_ec2.yaml
Don't forget vault secret for decrypt string

3. Configure MySQL credentials

Go to `FT/git/ansible/group_vars/tag_Name_db_srv` and change values for db_user and db_pass

4. Configure access point

Go to `FT/git/terraform/vpc/variables.tf` and put to variable "bastion_ip" your external ip. It's will be entry point for configure infrasctructure

4. Create Terraform job in Jenkins, follow this steps
  - Create new item => Pipeline
  - Choose option "This project is parameterized"
  - Add "Choice parametr" and in choices field type "apply destroy"
  - Add "Credential parametr" with your access_key and secret_key
  - Copy pipeline "infrastructure run"

5. Add vault secret and ssh private key to Jenkins credentials with follow names: vault and ssh_ansible

6. Create Ansible job in Jenkins, follow this steps
  - Create new item => Pipeline
  - Choose option "This project is parameterized"
  - Add "Credential parametr" with your vault and ssh_ansible
  - Copy pipeline "ansible run"

7. Create S3 bucket for remote state with parameters from path: `FT/FT/git/terraform/backend.tf`

8. Add Cloudlfare api key to Jenkins credentials with name cloudlfare_api_key

9. Create Cloudlfare job in Jenkins for green stack, follow this steps
  - Create new item => Pipeline
  - Choose option "This project is parameterized"
  - Add "Credential parametr" with your cloudflare_api_key, access_key and secret_key (from AWS)
  - Copy pipeline "Change-to-green"

10. Create Cloudlfare job in Jenkins for blue stack, follow this steps
  - Create new item => Pipeline
  - Choose option "This project is parameterized"
  - Add "Credential parametr" with your cloudflare_api_key, access_key and secret_key (from AWS)
  - Copy pipeline "Change-to-blue"

 11. Run pipelines in order:

 1. infrastructure run
 2. ansible run
 3. Change-to-green

 For change to blue stack run Change-to-blue pipeline

 ## Disaster recovery

1. Configure access point

Go to `FT/FT/DR/terraform/vpc/variables.tf` and put to variable "bastion_ip" your external ip. It's will be entry point for configure infrasctructure

2. Create S3 bucket for remote state with parameters from path: `FT/FT/DR/terraform/backend.tf`

3. Run pipelines
