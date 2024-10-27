data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # ID-ul proprietarului pentru Ubuntu AMIs

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]  # Caută AMI-urile pentru Ubuntu 22.04
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ubuntu_server" {
  ami           = data.aws_ami.ubuntu.id  # Folosește AMI-ul obținut din data source
  instance_type = "t2.micro"               # Free tier eligible

  tags = {
    Name = "UbuntuServer22.04"
  }
}
