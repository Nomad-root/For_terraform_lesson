#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
sudo service httpd start
sudo chkconfig httpd on
