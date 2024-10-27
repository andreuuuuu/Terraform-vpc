resource "aws_subnet" "public" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.3.0/24"  # Exemplu de CIDR pentru subnetul public

  map_public_ip_on_launch = true  # Permite alocarea IP-urilor publice

  tags = {
    Name = "Ioski_Public_Subnet"
  }
}

output "subnet_id" {
  value = aws_subnet.public.id  # Asigură-te că referința este corectă
}
