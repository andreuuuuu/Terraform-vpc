resource "aws_subnet" "private" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Ioski_Private_Subnet"
  }
}

output "subnet_id" {
  value = aws_subnet.private.id
}
