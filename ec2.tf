resource "aws_security_group" "prodSG_iac_shoval" {
  name        = "prod_iac_shoval"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.shoval_vpc_iac.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb-shoval-sg-iac.id] 
  }
  egress {
    from_port = 0
    to_port = 0 
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 
}
resource "aws_instance" "prod1_shoval_iac" {
  ami = "ami-03c476a1ca8e3ebdc"
  instance_type = "t3a.micro"
  subnet_id = aws_subnet.sub_1_shoval_iac.id
  vpc_security_group_ids = [aws_security_group.prodSG_iac_shoval.id]
  associate_public_ip_address = true
  user_data = <<-EOF
    #!/bin/bash
    # Install docker
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
    apt-get update
    apt-get install -y docker-ce
    usermod -aG docker ubuntu

    # Install docker-compose
    curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    sudo apt-get install docker-compose-plugin
      
    docker run -d --name hostname -p 80:3000 adongy/hostname-docker
  EOF

   depends_on = [
      aws_subnet.sub_1_shoval_iac,aws_security_group.prodSG_iac_shoval
    ]
    tags = {
      "Name" = "prod1_shoval_iac",
      "bootcamp"= "17",
      "expiration_date" = "26-02-23",
      "Owner" =	"Shoval.Astamker"
    }
}
resource "aws_instance" "prod2_shoval_iac" {
  ami = "ami-03c476a1ca8e3ebdc"
  instance_type = "t3a.micro"
  subnet_id = aws_subnet.sub_2_shoval_iac.id
  vpc_security_group_ids = [aws_security_group.prodSG_iac_shoval.id]
  associate_public_ip_address = true
  user_data = <<-EOF
    #!/bin/bash
    # Install docker
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
    apt-get update
    apt-get install -y docker-ce
    usermod -aG docker ubuntu

    # Install docker-compose
    curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    sudo apt-get install docker-compose-plugin
      
    docker run -d --name hostname -p 80:3000 adongy/hostname-docker
  EOF

  depends_on = [
      aws_subnet.sub_2_shoval_iac,aws_security_group.prodSG_iac_shoval
    ]
    tags = {
      "Name" = "prod2_shoval_iac",
      "bootcamp"= "17",
      "expiration_date" = "26-02-23",
      "Owner" =	"Shoval.Astamker"
    }
}