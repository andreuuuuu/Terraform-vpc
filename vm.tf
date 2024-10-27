# Definirea cheii pentru acces 
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDP6fpp0a5q91RHmci5FJSdTAirs4Qk8kxiEaslkFdouckEFZvY2puPTTfeb2ePuoHHxG8fE04ZISF2HvEO4kctuOHBZ4KWyQfdHgaY7gViazvTEwm/Hh9Dtdw8OrBsNH2/J8O259LCojvqmHxceGlrXlVI7xmlEsMYzoW7LFE/IYZrIA/jvdT5vnj/KEx7E1XKNU0Fkd777iaPMwhQ/77A+aC9Y80ykyPWTnP6uXqxT46u0x8cn7AmjIKes9f2wdukWXvg4XHvQBv8Gs39n3Qd01Moytj36/UxEGTHEUrqGItA0iKhzK17gbYCLum3Om/NKcvMdPV871s7PoIn+a5SLGt052uaEE7XSRv98d62CAazr1fWIeC5r6logk4xpJkyfqDleXhsD5xE2DNgQyF7bx0bCXbuZQNirASkUZh5vN2S3I7uA1gtGnufXzrDw3EXyHH4sr01r+eUw/JznNYPx2ErnlZWIBG1UCRopGr89FQreblmIkLz6v6+Q2j0s3k= andreu1@andreu"
}

# Definirea instanței EC2 PRINCIPALA
resource "aws_instance" "this" {
  ami                           = "ami-03cc8375791cb8bcf"  # Asigură-te că acesta este un AMI valid
  instance_type                 = "t2.micro"
  subnet_id = module.private_subnet.subnet_id  # Folosește output-ul corect
  user_data = file("userdata.tpl")
  vpc_security_group_ids        = [aws_security_group.example.id]
  key_name                      = aws_key_pair.deployer.key_name
  associate_public_ip_address    = true

  tags = {
    Name = "cloud"
 
  }
 provisioner "local-exec" {
    command = templatefile("windows-ssh-config.tpl", {
      hostname     = self.public_ip,
      user         = "ubuntu",
      identityfile = "D:\\.ssh\\id_rsa"  # Calea completă către cheia ta SSH
    })
    interpreter = ["C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe", "-Command"]
  }
}


