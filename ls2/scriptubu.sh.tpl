#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
cat <<EOF >/var/www/html/index.html
<html>
<h2>Bild by Terraform <font color="red"> v1.2.8</font></h2><br>
Owner ${f_name} ${l_name} $myip<br>
%{ for x in names ~}
Hello to ${x} from ${l_name}<br>
%{ endfor ~}
</html>
EOF
sudo service apache2 restart
