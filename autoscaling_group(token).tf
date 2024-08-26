# resource "aws_security_group" "day3-scaling" {
#   name = "day3-scaling-sg"
#   vpc_id = aws_vpc.main.id
#   ingress {
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     from_port = "8080"
#     to_port = "8080"
#   }
#   ingress {
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     from_port = "22"
#     to_port = "22"
#   }
#   egress {
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#     from_port = "0"
#     to_port = "0"
#   }
#     tags = {
#     Name = "day3-scaling-sg"
#   }

#   lifecycle {
#     ignore_changes = [ingress, egress]
#   }
# }
# resource "aws_launch_configuration" "token-scaling-lt" {
#   image_id             = data.aws_ami.amazonlinux2023.id
#   iam_instance_profile = aws_iam_instance_profile.bastion.name
#   security_groups      = [aws_security_group.day3-scaling.id]
#   instance_type        = "t3.micro"
#   key_name = aws_key_pair.keypair.key_name
#   user_data            = <<-EOF
#     #!/bin/bash
#     yum update -y
#     yum install -y jq curl wget
#     yum install -y net-tools dnsutils
#     curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
#     unzip awscliv2.zip
#     sudo ./aws/install
#     ln -s /usr/local/bin/aws /usr/bin/
#     ln -s /usr/local/bin/aws_completer /usr/bin/
#     sed -i "s|#PasswordAuthentication no|PasswordAuthentication yes|g" /etc/ssh/sshd_config
#     systemctl restart sshd
#     echo 'Skill53##' | passwd --stdin ec2-user
#     echo 'Skill53##' | passwd --stdin root
#     HOME=/home/ec2-user
#     echo "export AWS_DEFAULT_REGION=${data.aws_region.day3.name}" >> ~/.bashrc
#     source ~/.bashrc
#     mkdir ~/token-app
#     yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
#     systemctl enable --now amazon-ssm-agent
#     sudo yum install -y amazon-cloudwatch-agent
#     systemctl enable --now amazon-cloudwatch-agent
#     su - ec2-user -c 'aws s3 cp s3://${aws_s3_bucket.source.id}/token-app ~/ --recursive'
#     /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/home/ec2-user/cwagent.json -s
#     chmod +x ~/token
#     chown ec2-user:ec2-user ~/token
#     ~/token >> ~/token.log 2>&1 &
#   EOF
# }

# resource "aws_autoscaling_group" "day3-token" {
#   name                      = "token-app"
#   vpc_zone_identifier       = [
#     aws_subnet.app_a.id,
#     aws_subnet.app_b.id,
#   ]
#   desired_capacity          = 2
#   min_size                  = 2
#   max_size                  = 10
#   health_check_grace_period = 0
#   health_check_type         = "EC2"
#   launch_configuration = aws_launch_configuration.token-scaling-lt.name

#   warm_pool {
#     pool_state                  = "Stopped"
#     min_size                    = "3"
#     max_group_prepared_capacity = "4"
#   }

#   protect_from_scale_in = true

#   tag {
#     key                 = "Name"
#     value               = "token-app"
#     propagate_at_launch = true
#   }
#   tag {
#     key                 = "ec2"
#     value               = "count"
#     propagate_at_launch = true
#   }
#   lifecycle {
#     ignore_changes = [desired_capacity]
#   }
# }

# resource "aws_autoscaling_attachment" "token" {
#   autoscaling_group_name = aws_autoscaling_group.day3-token.id
#   lb_target_group_arn    = aws_lb_target_group.token-auto-tg.arn
# }