data "aws_ami" "amazon_linux" {
    most_recent      = true
    owners           = ["amazon"]

    filter {
    name   = "name"
    values = ["amazn-ami-hvm-*-x86_64-gp2"]
    }

    filter {
    name   = "virtualization-type"
    values = ["hvm"]
    }
}

resource "aws_instance" "web" {
    ami           = data.aws_ami.amazon_linux.id
    instance_type = "t3.nano"

    tags = {
        Name = "HelloWorld"
    }
}