#!/bin/bash
sudo apt update;
sudo apt install software-properties-common;
add-apt-repository --yes --update ppa:ansible/ansible;
sudo apt install ansible -y;
sudo apt-get install python3 -y;
sudo apt-get install python3-pip -y;
sudo pip3 install boto3;
