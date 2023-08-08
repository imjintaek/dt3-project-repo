
##### NON-DEPLOYED

# resource "aws_instance" "webserver" {

    
#     associate_public_ip_address     =   true
#     ami                             =   "ami-0c6e5afdd23291f73"
#     subnet_id                       =   module.vpc.public_subnet_ids[0]
#     instance_type                   =   "t3.micro"
#     key_name                        =   local.keypair_name
#     vpc_security_group_ids          =   [module.vpc.admin_security_group_id, module.vpc.alb_security_group_id]

#     #user_data                       =   data.template_file.webserver_init.rendered
#     user_data = <<-EOF
#     #!/bin/bash
#     apt-get update -y
#     apt-get install apache2 -y
#     IP_ADDR=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
#     sudo echo "<html>" > /var/www/html/index.html
#     sudo echo "<p>SERVER IP : $IP_ADDR</p>" > /var/www/html/index.html
#     sudo echo "<img src='http://d7fdk7608v6x2.cloudfront.net/images/iu.gif'>" >> /var/www/html/index.html
#     sudo echo "</html>" >> /var/www/html/index.html
#     systemctl restart apache2

#     useradd svtalk -c "server" -s /bin/bash -m -d /home/svtalk
#     echo 'svtalk:dlatldkagh!00' | chpasswd
#     echo "svtalk ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/90-cloud-init-users 
#     chage -m 0 -M 99999 -E -1 -I -1 svtalk
#     sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
#     systemctl restart sshd

#     #aws cli
#     sudo apt install unzip
#     curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
#     unzip awscliv2.zip
#     sudo ./aws/install

#     #  ssm-agent restart
#     sudo snap restart amazon-ssm-agent
#   EOF

#     tags = {
#         Name                        =   "${local.prefix}-webserver-10356"
#         Managed_by                  =   "terraform"
#     }
# }