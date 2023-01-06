// create aws instance using image spec
data "aws_ami" "amazon-linux-2" {
    most_recent = true

    filter {
        name   = "name"
        values = [var.ami_filter.name]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

# resource "aws_instance" "blog" {
#   ami                    = data.aws_ami.amazon-linux-2.id
#   instance_type          = var.instance_type
#   subnet_id              = module.blog_vpc.public_subnets[0]
#   vpc_security_group_ids = [module.blog_sg.security_group_id]

#   tags = {
#     Name = "Learning Terraform"
#   }
# }

module "blog_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.environment.name}"
  cidr = "${var.environment.network_prefix}.0.0/16"

  azs             = ["eu-west-2a","eu-west-2b"]
  public_subnets  = ["${var.environment.network_prefix}.101.0/24", "${var.environment.network_prefix}.102.0/24"]

  enable_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "${var.environment.name}"
  }
}

module "blog_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.16.2"
  name    = "${var.environment.name}-blog_new"

  vpc_id  = module.blog_vpc.vpc_id
  
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}

module "blog_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "${var.environment.name}-blog-alb"

  load_balancer_type = "application"

  vpc_id             = module.blog_vpc.vpc_id
  subnets            = module.blog_vpc.public_subnets
  security_groups    = [module.blog_sg.security_group_id]

  target_groups = [
    {
      name_prefix      = "${var.environment.name}"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "${var.environment.name}"
  }
}

module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "6.7.0"
  
  name = "${var.environment.name}-blog"

  min_size = var.min_size
  max_size = var.max_size

  vpc_zone_identifier = module.blog_vpc.public_subnets
  target_group_arns   = module.blog_alb.target_group_arns
  security_groups     = [module.blog_sg.security_group_id]

  image_id      = data.aws_ami.amazon-linux-2.id
  instance_type = var.instance_type
}