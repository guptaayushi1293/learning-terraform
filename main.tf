data "aws_ami" "amazon-linux-2" {
    executable_users = ["self"]
    most_recent      = true
    owners           = ["self"]

    filter {
    name   = "name"
    values = ["amazn2-*"]
    }

    filter {
    name   = "root-device-type"
    values = ["ebs"]
    }

    filter {
    name   = "virtualization-type"
    values = ["hvm"]
    }
}

resource "aws_instance" "web" {
    ami           = data.aws_ami.amazon-linux-2.id
    instance_type = "t3.nano"

    tags = {
        Name = "HelloWorld"
    }
}