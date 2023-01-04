// create aws instance using image spec
data "aws_ami" "amazon-linux-2" {
    most_recent = true

    filter {
        name   = "name"
        values = ["amzn2-ami-kernel-5.10-hvm-2.0.20221210.1-x86_64-gp2"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_instance" "web" {
    ami           = data.aws_ami.amazon-linux-2.id
    instance_type = "t3.micro"

    tags = {
        Name = "HelloWorld"
    }
}