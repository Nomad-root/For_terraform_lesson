#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
cat <<EOF >/var/www/html/index.html
<html>
<h2>Bild by Terraform <font color="red"> v1.2.8</font></h2><br>
Owner Sergey Nomad $myip<br>
<b>Version 3</b>
</html>
EOF
sudo service httpd start
sudo chkconfig httpd on