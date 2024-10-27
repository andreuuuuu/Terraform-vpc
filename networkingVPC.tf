# Definirea VPC-ului
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Ioski"
  }
}

 
# Crearea Internet Gateway-ului
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Gateway"
  }
}

# Crearea tabelului de rute
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "ioski.route"
  }
}

# Module pentru subrețele publice și private
# Module pentru subrețele publice și private
module "public_subnet" {
  source = "./modules/public_subnet"
  vpc_id = aws_vpc.main.id
}

module "private_subnet" {
  source = "./modules/private_subnet"
  vpc_id = aws_vpc.main.id
}

# Asocierea tabelului de rute cu subrețelele publice
resource "aws_route_table_association" "public_association" {
  subnet_id      = module.public_subnet.subnet_id  # Se referă la subrețeaua publică
  route_table_id = aws_route_table.example.id
}

# Asocierea tabelului de rute cu subrețelele private
resource "aws_route_table_association" "private_association" {
  subnet_id      = module.private_subnet.subnet_id  # Se referă la subrețeaua privată
  route_table_id = aws_route_table.example.id
}

# Crearea grupului de securitate
resource "aws_security_group" "example" {
  name        = "securitygroup"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "securitygroup"
  }
}

# Regula de egress
resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.example.id

  type         = "egress"
  from_port    = 0
  to_port      = 0
  protocol     = "-1"  # Toate protocoalele
  cidr_blocks   = ["0.0.0.0/0"]
}

# Regula de ingress
resource "aws_security_group_rule" "ingress" {
  security_group_id = aws_security_group.example.id

  type         = "ingress"
  from_port    = 22
  to_port      = 22
  protocol     = "tcp"
  cidr_blocks   = ["0.0.0.0/0"]
}
