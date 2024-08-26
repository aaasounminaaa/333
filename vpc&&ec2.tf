resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "apdev-vpc"
  }
}

resource"aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "apdev-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "apdev-public-rt"
  }
}

resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

resource "aws_subnet" "public_a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "apdev-public-a"
    "karpenter.sh/discovery" = "apdev-cluster" 
  }
}

resource "aws_subnet" "public_b" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-northeast-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "apdev-public-b"
    "karpenter.sh/discovery" = "apdev-cluster" 
  }
}

resource "aws_subnet" "public_c" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "apdev-public-c"
    "karpenter.sh/discovery" = "apdev-cluster"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "app_a" {
}

resource "aws_eip" "app_b" {
}

resource "aws_eip" "app_c" {
}

resource "aws_nat_gateway" "app_a" {
  depends_on = [aws_internet_gateway.main]

  allocation_id = aws_eip.app_a.id
  subnet_id = aws_subnet.public_a.id

  tags = {
    Name = "apdev-natgw-a"
  }
}

resource "aws_nat_gateway" "app_b" {
  depends_on = [aws_internet_gateway.main]

  allocation_id = aws_eip.app_b.id
  subnet_id = aws_subnet.public_b.id

  tags = {
    Name = "apdev-natgw-b"
  }
}

resource "aws_nat_gateway" "app_c" {
  depends_on = [aws_internet_gateway.main]

  allocation_id = aws_eip.app_c.id
  subnet_id = aws_subnet.public_c.id

  tags = {
    Name = "apdev-natgw-c"
  }
}

resource "aws_route_table" "app_a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "apdev-app-a-rt"
  }
}

resource "aws_route_table" "app_b" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "apdev-app-b-rt"
  }
}

resource "aws_route_table" "app_c" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "apdev-app-c-rt"
  }
}

resource "aws_route" "app_a" {
  route_table_id = aws_route_table.app_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.app_a.id
}

resource "aws_route" "app_b" {
  route_table_id = aws_route_table.app_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.app_b.id
}

resource "aws_route" "app_c" {
  route_table_id = aws_route_table.app_c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.app_c.id
}

resource "aws_subnet" "app_a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "apdev-app-a"
    "karpenter.sh/discovery" = "apdev-cluster"
  }
}

resource "aws_subnet" "app_b" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "apdev-app-b"
    "karpenter.sh/discovery" = "apdev-cluster"
  }
}

resource "aws_subnet" "app_c" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "apdev-app-c"
    "karpenter.sh/discovery" = "apdev-cluster"
  }
}

resource "aws_route_table_association" "app_a" {
  subnet_id = aws_subnet.app_a.id
  route_table_id = aws_route_table.app_a.id
}

resource "aws_route_table_association" "app_b" {
  subnet_id = aws_subnet.app_b.id
  route_table_id = aws_route_table.app_b.id
}

resource "aws_route_table_association" "app_c" {
  subnet_id = aws_subnet.app_c.id
  route_table_id = aws_route_table.app_c.id
}

resource "aws_route_table" "data" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "apdev-data-rt"
  }
}

resource "aws_subnet" "data_a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.6.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "apdev-data-a"
  }
}

resource "aws_subnet" "data_b" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.7.0/24"
  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "apdev-data-b"
  }
}

resource "aws_subnet" "data_c" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.8.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "apdev-data-c"
  }
}

resource "aws_route_table_association" "data_a" {
  subnet_id = aws_subnet.data_a.id
  route_table_id = aws_route_table.data.id
}

resource "aws_route_table_association" "data_b" {
  subnet_id = aws_subnet.data_b.id
  route_table_id = aws_route_table.data.id
}

resource "aws_route_table_association" "data_c" {
  subnet_id = aws_subnet.data_c.id
  route_table_id = aws_route_table.data.id
}

resource "aws_security_group" "day3-sg" {
  name = "day3-ep-SG"
  vpc_id = aws_vpc.main.id
  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "443"
    to_port = "443"
  }
  egress {
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
  }
    tags = {
    Name = "day3-ep-SG"
  }
}

resource "aws_vpc_endpoint" "ecr-dkr" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-2.ecr.dkr"
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.day3-sg.id
  ]
  private_dns_enabled = true
  tags = {
    Name = "ecr-dkr-endpoint"
  }
}

resource "aws_vpc_endpoint_subnet_association" "ecr_dkr_private_a" {
  vpc_endpoint_id = aws_vpc_endpoint.ecr-dkr.id
  subnet_id       = aws_subnet.app_a.id
}
resource "aws_vpc_endpoint_subnet_association" "ecr_dkr_private_b" {
  vpc_endpoint_id = aws_vpc_endpoint.ecr-dkr.id
  subnet_id       = aws_subnet.app_b.id
}

resource "aws_vpc_endpoint" "ecr-api" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-2.ecr.api"
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.day3-sg.id
  ]
  private_dns_enabled = true
  tags = {
    Name = "ecr-api-endpoint"
  }
}

resource "aws_vpc_endpoint_subnet_association" "ecr_api_private_a" {
  vpc_endpoint_id = aws_vpc_endpoint.ecr-api.id
  subnet_id       = aws_subnet.app_a.id
}
resource "aws_vpc_endpoint_subnet_association" "ecr_api_private_b" {
  vpc_endpoint_id = aws_vpc_endpoint.ecr-api.id
  subnet_id       = aws_subnet.app_b.id
}

resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-2.ec2"
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.day3-sg.id
  ]
  private_dns_enabled = true
  tags = {
    Name = "ec2-endpoint"
  }
}

resource "aws_vpc_endpoint_subnet_association" "ec2_private_a" {
  vpc_endpoint_id = aws_vpc_endpoint.ec2.id
  subnet_id       = aws_subnet.app_a.id
}
resource "aws_vpc_endpoint_subnet_association" "ec2_private_b" {
  vpc_endpoint_id = aws_vpc_endpoint.ec2.id
  subnet_id       = aws_subnet.app_b.id
}

resource "aws_vpc_endpoint" "sts" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-2.sts"
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.day3-sg.id
  ]
  private_dns_enabled = true
  tags = {
    Name = "sts-endpoint"
  }
}

resource "aws_vpc_endpoint_subnet_association" "sts_private_a" {
  vpc_endpoint_id = aws_vpc_endpoint.sts.id
  subnet_id       = aws_subnet.app_a.id
}
resource "aws_vpc_endpoint_subnet_association" "sts_private_b" {
  vpc_endpoint_id = aws_vpc_endpoint.sts.id
  subnet_id       = aws_subnet.app_b.id
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-2.logs"
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.day3-sg.id
  ]
  private_dns_enabled = true
  tags = {
    Name = "logs-endpoint"
  }
}

resource "aws_vpc_endpoint_subnet_association" "logs_private_a" {
  vpc_endpoint_id = aws_vpc_endpoint.logs.id
  subnet_id       = aws_subnet.app_a.id
}
resource "aws_vpc_endpoint_subnet_association" "logs_private_b" {
  vpc_endpoint_id = aws_vpc_endpoint.logs.id
  subnet_id       = aws_subnet.app_b.id
}

data "aws_ami" "amazonlinux2023" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*x86*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon's official account ID
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "keypair" {
  key_name = "apdev"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "keypair" {
  content = tls_private_key.rsa.private_key_pem
  filename = "./apdev.pem"
}

data "aws_region" "day3" {}
data "aws_caller_identity" "day3" {}

resource "aws_instance" "bastion" {
  ami = data.aws_ami.amazonlinux2023.id
  subnet_id = aws_subnet.public_a.id
  instance_type = "t3.small"
  key_name = aws_key_pair.keypair.key_name
  vpc_security_group_ids = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.bastion.name
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y jq curl zip
    yum install -y wget
    dnf install -y mariadb105
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    ln -s /usr/local/bin/aws /usr/bin/
    ln -s /usr/local/bin/aws_completer /usr/bin/
    sed -i "s|#PasswordAuthentication no|PasswordAuthentication yes|g" /etc/ssh/sshd_config
    systemctl restart sshd
    echo 'Skill53##' | passwd --stdin ec2-user
    echo 'Skill53##' | passwd --stdin root
    yum install -y docker
    systemctl enable --now docker
    usermod -aG docker ec2-user
    usermod -aG docker root
    chmod 666 /var/run/docker.sock
    curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.0/2024-01-04/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    mv -f ./kubectl /usr/local/bin/kubectl
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    mv /tmp/eksctl /usr/bin
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    sudo chmod 700 get_helm.sh
    ./get_helm.sh
    sudo mv ./get_helm.sh /usr/local/bin
    mkdir k9s
    cd k9s/
    wget https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_Linux_amd64.tar.gz
    tar -xf k9s_Linux_amd64.tar.gz
    chmod +x k9s
    sudo mv k9s /usr/local/bin
    HOME=/home/ec2-user
    echo "export AWS_DEFAULT_REGION=${data.aws_region.day3.name}" >> ~/.bashrc
    echo "export AWS_ACCOUNT_ID=${data.aws_caller_identity.day3.account_id}" >> ~/.bashrc
    source ~/.bashrc
    su - ec2-user -c 'aws s3 cp s3://${aws_s3_bucket.source.id}/ ~/ --recursive'
    aws ecr get-login-password --region ${data.aws_region.day3.name} | docker login --username AWS --password-stdin ${data.aws_caller_identity.day3.account_id}.dkr.ecr.${data.aws_region.day3.name}.amazonaws.com
    docker build -t ${aws_ecr_repository.token.repository_url}:latest ~/token-app
    docker build -t ${aws_ecr_repository.employees.repository_url}:latest ~/employees-app
    docker push ${aws_ecr_repository.token.repository_url}:latest
    docker push ${aws_ecr_repository.employees.repository_url}:latest
  EOF
  tags = {
    Name = "apdev-bastion"
  }
}

## Public Security Group
resource "aws_security_group" "bastion" {
  name = "apdev-bastion-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "22"
    to_port = "22"
  }

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "8080"
    to_port = "8080"
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "80"
    to_port = "80"
  }
 
  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "443"
    to_port = "443"
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "22"
    to_port = "22"
  }
  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "3306"
    to_port = "3306"
  }
    tags = {
    Name = "apdev-bastion-sg"
  }
}

resource "aws_iam_role" "bastion" {
  name = "apdev-bastion-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess","arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore","arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"]
}

resource "aws_iam_instance_profile" "bastion" {
  name = "apdev-profile-bastion"
  role = aws_iam_role.bastion.name
}

### ALB ###
resource "aws_security_group" "day3-lb-SG" {
  name = "apdev-alb-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "80"
    to_port = "80"
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "80"
    to_port = "80"
  }
 
  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "443"
    to_port = "443"
  }
  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "8080"
    to_port = "8080"
  }
    tags = {
    Name = "apdev-alb-sg"
  }
}

resource "aws_lb" "day3-lb" {
  name               = "apdev-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.day3-lb-SG.id]
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]

  tags = {
    Name = "apdev-alb"
  }
}

resource "aws_alb_listener" "day3-lb-listener" {
  load_balancer_arn = aws_lb.day3-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.employee-auto-tg.arn
        weight = 50
      }

      target_group {
        arn    = aws_lb_target_group.token-auto-tg.arn
        weight = 50
      }
    }

    fixed_response {
      content_type = "text/plain"
      message_body = "404 Page Error"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "token" {
  listener_arn = aws_alb_listener.day3-lb-listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.token-auto-tg.arn
  }

  condition {
    path_pattern {
      values = ["/v1/token*"]
    }
  }
}

resource "aws_lb_listener_rule" "employee" {
  listener_arn = aws_alb_listener.day3-lb-listener.arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.employee-auto-tg.arn
  }

  condition {
    path_pattern {
      values = ["/v1/employee*"]
    }
  }
}

resource "aws_lb_target_group" "token-lb" {
  name     = "token-tg"
  port     = 8080
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = aws_vpc.main.id
  deregistration_delay = 0

  health_check {
    path = "/healthcheck"
    port = 8080
    timeout = 2
    interval = 5
    unhealthy_threshold = 2
    healthy_threshold = 2
  }
  
  tags = {
    Name = "token-tg"
  }
}

resource "aws_lb_target_group" "employee-lb" {
  name     = "employee-tg"
  port     = 8080
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = aws_vpc.main.id
  deregistration_delay = 0

  health_check {
    path = "/healthcheck"
    port = 8080
    timeout = 2
    interval = 5
    unhealthy_threshold = 2
    healthy_threshold = 2
  }
  
  tags = {
    Name = "employee-tg"
  }
}

resource "aws_lb_target_group" "token-auto-tg" {
  name        = "apdev-auto-token-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id

  health_check {
    port                = 8080
    interval            = 10
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    path                = "/healthcheck"
  }

  tags = {
    Name = "apdev-auto-token-tg"
  }
}

resource "aws_lb_target_group" "employee-auto-tg" {
  name        = "apdev-auto-employee-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id

  health_check {
    port                = 8080
    interval            = 10
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    path                = "/healthcheck"
  }

  tags = {
    Name = "apdev-auto-employee-tg"
  }
}