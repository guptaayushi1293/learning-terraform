variable "instance_type" {
    description = "Type of instance to provision"
    default = "t3.nano"
}

variable "ami_filter" {
    description = "Name filter and owner for AMI"

    type = object({
        name = string
    })

    default = {
      name = "amzn2-ami-kernel-5.10-hvm-2.0.20221210.1-x86_64-gp2"
    }
}

variable "environment" {
    description = "Development environment"

    type = object({
        name = string
        network_prefix = string
    })

    default = {
      name = "dev"
      network_prefix = "10.0"
    }
}

variable "min_size" {
  description = "Minimum number of instances in the ASG"

  default = 1
}

variable "max_size" {
  description = "Maximum number of instances in the ASG"

  default = 2
}

