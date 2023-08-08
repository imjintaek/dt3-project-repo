#!/bin/bash

apt-get update -y
apt-get install nginx -y
IP_ADDR=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
echo "<html>" > /var/www/html/index.html
echo "<body>" >> /var/www/html/index.html
echo "<h1 style='color:blue;'>Hello World</h1>" >> /var/www/html/index.html
#echo "<h3>Version 1.0</h3>" >> /usr/share/nginx/html/index.html
echo "<a href='https://aws.amazon.com/'><p>Connect to AWS homepage</p></a>" >> /var/www/html/index.html
echo "<img src='${image_object_uri}'>" >> /var/www/html/index.html
echo "</body>" >> /var/www/html/index.html
echo "</html>" >> /var/www/html/index.html
echo "<p>SERVER IP : $IP_ADDR</p>" >> /var/www/html/index.html

systemctl restart nginx



useradd svtalk -c "server" -s /bin/bash -m -d /home/svtalk
echo 'svtalk:dlatldkagh!00' | chpasswd
echo "svtalk ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/90-cloud-init-users 
chage -m 0 -M 99999 -E -1 -I -1 svtalk
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

#aws cli
sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

#ssm-agent restart
sudo snap restart amazon-ssm-agent

#codedeploy agent install
sudo apt install ruby-full -y
sudo apt install wget -y
wget https://aws-codedeploy-ap-northeast-2.s3.amazonaws.com/latest/install             #wget https://bucket-name.s3.region-identifier.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto > /tmp/logfile

