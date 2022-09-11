#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
cat <<EOF >/var/www/html/index.html
<html>
<h2>Bild by Terraform <font color="red"> v1.2.8</font></h2><br>
Owner Sergey Nomad $myip<br>
</html>
EOF
sudo service apache2 start
