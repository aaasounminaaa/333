resource "aws_security_group" "db" {
  name        = "apdev-RDS-SG"
  description = "apdev-RDS-SG"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port  = 3306
    to_port    = 3306
  }

  egress {
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "apdev-RDS-SG"
  }
}

# resource "aws_vpc_security_group_egress_rule" "bastion" {
#   security_group_id = aws_security_group.bastion.id

#   ip_protocol = "tcp"
#   cidr_ipv4   = "0.0.0.0/0"
#   from_port   = 3306
#   to_port     = 3306
# }

resource "aws_db_subnet_group" "db" {
  name = "apdev-rds-sg"
  subnet_ids = [
    aws_subnet.data_a.id,
    aws_subnet.data_b.id,
    aws_subnet.data_c.id
  ]

  tags = {
    Name = "apdev-rds-sg"
  }
}

resource "aws_db_option_group" "db" {
  name                     = "apdev-rds-og"
  option_group_description = "apdev-rds-og"
  engine_name              = "mysql"
  major_engine_version     = "8.0"

  tags = {
    Name = "apdev-rds-og"
  }
}
resource "aws_db_parameter_group" "db" {
  name                    = "apdev-rds-pg"
  description             = "apdev-rds-pg"
  family                  = "mysql8.0"

  tags = {
    Name = "apdev-rds-pg"
  }
}

resource "aws_db_instance" "db" {
  identifier             = "apdev-rds-instance"
  allocated_storage      = 20
  storage_type           = "gp3"
  engine                 = "mysql"
  db_name                = "dev"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "Skill53##"
  port                   = 3306
  skip_final_snapshot    = true
  multi_az               = true
  storage_encrypted      = false
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.db.name
  option_group_name      = aws_db_option_group.db.name
  parameter_group_name   = aws_db_parameter_group.db.name
  vpc_security_group_ids = [aws_security_group.db.id]
}

resource "aws_db_proxy" "db" {
  name                   = "apdev-rds-proxy"
  engine_family          = "MYSQL"
  role_arn               = aws_iam_role.db.arn
  vpc_security_group_ids = [aws_security_group.db.id]
  vpc_subnet_ids         = [
    aws_subnet.app_a.id,
    aws_subnet.app_b.id,
    aws_subnet.app_c.id
  ]

  auth {
    auth_scheme = "SECRETS"
    iam_auth    = "DISABLED"
    secret_arn  = aws_secretsmanager_secret.db.arn
  }

  depends_on = [
    aws_db_instance.db,
    aws_iam_role.db,
  ]

  tags = {
    Name = "apdev-rds-proxy"
  }
}

# resource aws_db_proxy_endpoint reader {
#   db_proxy_name          = aws_db_proxy.db.name
#   db_proxy_endpoint_name = "${aws_db_proxy.db.name}-reader"
#   vpc_subnet_ids         = ["${aws_subnet.app_a.id}","${aws_subnet.app_b.id}"]
#   target_role            = "READ_ONLY"

#   tags = {
#     Name = "apdev-rds-proxy"
#   }
# }

resource "aws_db_proxy_default_target_group" "db" {
  db_proxy_name = aws_db_proxy.db.name

  connection_pool_config {
    connection_borrow_timeout    = 100
    max_connections_percent      = 80
    session_pinning_filters      = []
  }
}

resource "aws_db_proxy_target" "rds_proxy" {
  db_instance_identifier = aws_db_instance.db.identifier
  db_proxy_name          = aws_db_proxy.db.name
  target_group_name      = aws_db_proxy_default_target_group.db.name
}
 
resource "aws_secretsmanager_secret" "db" {
  name = "rds-secret"
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    "username" = aws_db_instance.db.username,
    "password" = aws_db_instance.db.password,
    "engine"   = aws_db_instance.db.engine,
    "host"     = aws_db_instance.db.address,
    "port"     = aws_db_instance.db.port,
    "dbname"   = aws_db_instance.db.db_name
  })
}

resource "aws_iam_role" "db" {
  name = "rds-proxy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "db" {
  name   = "rds-proxy-policy"
  role   = aws_iam_role.db.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Effect   = "Allow",
        Resource = "${aws_secretsmanager_secret.db.arn}"
      },
      {
        Action = [
          "rds-db:connect"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "kms:Decrypt"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}