data "aws_ami" "ubuntu" {
    most_recent = true
    executable_users = ["274055544780"]

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["amazon"] # GSG-playground
}

resource "aws_instance" "web" {
    ami           = data.aws_ami.ubuntu.id
    instance_type = "t3.nano"

    tags = {
        Name = "HelloWorld"
    }
}