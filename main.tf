data "aws_ami" "example" {
  most_recent = true
  executable_users = ["274055544780"]

  filter {
    name   = "name"
    values = ["myami-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["274055544780"] # GSG-playground
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.example.id
  instance_type = "t3.nano"

  tags = {
    Name = "HelloWorld"
  }
}