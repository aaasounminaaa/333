# locals {
#     eks_version = "1.29"
#     path = "./config"
# }

# data "aws_ssm_parameter" "bottlerocket_image_id" {
#   name = "/aws/service/bottlerocket/aws-k8s-${local.eks_version}/x86_64/latest/image_id"
# }

# data "aws_ssm_parameter" "bottlerocket_image_id_arn" {
#   name = "/aws/service/bottlerocket/aws-k8s-${local.eks_version}/arm64/latest/image_id"
# }

# data "aws_ami" "bottlerocket_image" {
#   owners = ["amazon"]
#   filter {
#     name   = "image-id"
#     values = [data.aws_ssm_parameter.bottlerocket_image_id.value]
#   }
# }

# data "aws_ami" "bottlerocket_image-arn" {
#   owners = ["amazon"]
#   filter {
#     name   = "image-id"
#     values = [data.aws_ssm_parameter.bottlerocket_image_id_arn.value]
#   }
# }
# resource "aws_iam_role" "nodes" {
#   name = "AmazonEKSNodeRole"

#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#     Version = "2012-10-17"
#   })
# }

# resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.nodes.name
# }

# resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.nodes.name
# }

# resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.nodes.name
# }

# # Create the IAM instance profile
# resource "aws_iam_instance_profile" "eks_node" {
#   name = "eks-node-instance-profile"
#   role = aws_iam_role.nodes.name
# }

# # resource "aws_eks_node_group" "app" {
# #   cluster_name    = aws_eks_cluster.skills.name
# #   node_group_name = "apdev-app-nodegroup"
# #   node_role_arn   = aws_iam_role.nodes.arn

# #   subnet_ids = [
# #     aws_subnet.private_a.id, aws_subnet.private_a.id
# #   ]
# # #   ami_type       = "BOTTLEROCKET_x86_64"
# # #   capacity_type  = "ON_DEMAND"
# #   instance_types = ["t3.micro"]

# #   scaling_config {
# #     desired_size = 4
# #     min_size     = 3
# #     max_size     = 10
# #   }

# #   update_config {
# #     max_unavailable = 1
# #   }
# #   labels = {
# #     "apdev" = "app"
# #   }


# #   launch_template {
# #     name    = aws_launch_template.app.name
# #     version = aws_launch_template.app.latest_version
# #   }

# #   depends_on = [
# #     aws_eks_access_policy_association.console-allow
# #   ]
# # }

# resource "aws_launch_template" "app" {
#   name = "apdev-app-node-lt"
#   image_id               = data.aws_ami.bottlerocket_image.id
#   update_default_version = true
#   iam_instance_profile {
#     name = aws_iam_instance_profile.eks_node.name
#   }
#   block_device_mappings {
#     device_name = "/dev/xvda"

#     ebs {
#       volume_size           = 30
#       volume_type           = "gp2"
#       delete_on_termination = true
#     }
#   }
#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       "Name"                                                          = "apdev-app-node"
#       "kubernetes.io/cluster/${aws_eks_cluster.skills.name}"     = "owned"
#       "k8s.io/cluster-autoscaler/${aws_eks_cluster.skills.name}" = "owned"
#       "k8s.io/cluster-autoscaler/enabled"                             = "true"
#     }
#   }
#   network_interfaces {
#     associate_public_ip_address = false
#   }

#   metadata_options {
#     http_tokens                 = "required"
#     http_put_response_hop_limit = 2
#   }
#   # BottleRocket Configuration File. See Below This Code Block.
#   user_data = base64encode(templatefile("${local.path}/config.toml",
#     {
#       "cluster_name"             = aws_eks_cluster.skills.name
#       "endpoint"                 = aws_eks_cluster.skills.endpoint
#       "cluster_auth_base64"      = aws_eks_cluster.skills.certificate_authority[0].data
#       "aws_region"               = "ap-northeast-2"
#       "enable_admin_container"   = false
#       "enable_control_container" = true
#       "max_pods_per_node"        = 110
#     }
#   ))
# }

# resource "aws_autoscaling_group" "app-nodes-asg" {
#   name                      = "apdebv-app-nodegroup-asg"
#   desired_capacity          = 4
#   max_size                  = 8
#   min_size                  = 3
#   health_check_grace_period = 15
#   health_check_type         = "EC2"
#   force_delete              = true

#   launch_template {
#     id      = aws_launch_template.app.id
#     version = "$Latest"
#   }
#   vpc_zone_identifier = [aws_subnet.app_a.id, aws_subnet.app_b.id]
#   warm_pool {
#     pool_state                  = "Stopped"
#     min_size                    = "2"
#     max_group_prepared_capacity = "4"
#   }
#   timeouts {
#     delete = "15m"
#   }
#   tag {
#     key                 = "kubernetes.io/cluster/${local.cluster_name}"
#     propagate_at_launch = true
#     value               = "owned"
#   }
#   tag {
#     key                 = "k8s.io/cluster-autoscaler/enable"
#     propagate_at_launch = true
#     value               = "true"
#   }
#   tag {
#     key                 = "k8s.io/cluster-autoscaler/${local.cluster_name}"
#     propagate_at_launch = true
#     value               = "owned"
#   }
# }